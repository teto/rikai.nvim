---@mod rikai.platform Platform abstraction
---@brief [[
---Thin compatibility layer so that the core of rikai can run either inside
---Neovim (using the `vim` API) or as a standalone Lua program (`rikai`
---executable) with only the Lua standard library and a POSIX shell.
---
---Modules other than the Neovim UI ones (popup, live highlighting, ...) must
---go through this module instead of calling `vim.*` directly.
---@brief ]]

local M = {}

--- true when running inside Neovim (including `nvim -l`)
M.has_vim = type(_G.vim) == "table" and type(_G.vim.api) == "table"

--- mirrors vim.log.levels
M.levels = {
	TRACE = 0,
	DEBUG = 1,
	INFO = 2,
	WARN = 3,
	ERROR = 4,
	OFF = 5,
}

local level_names = {}
for k, v in pairs(M.levels) do
	level_names[v] = k
end

---@param path string
---@return string
local function strip_trailing_slash(path)
	if #path > 1 then
		path = path:gsub("/+$", "")
	end
	return path
end

---@param ... string path components
---@return string
function M.joinpath(...)
	return (table.concat({ ... }, "/"):gsub("//+", "/"))
end

---@param path string
---@return string
function M.dirname(path)
	path = strip_trailing_slash(path)
	local dir = path:match("^(.*)/[^/]*$")
	if dir == nil then
		return "."
	elseif dir == "" then
		return "/"
	end
	return dir
end

--- Emulates `vim.fn.stdpath` outside of neovim so that both the plugin and the
--- standalone executable share the same dictionaries.
---@param what "data"|"cache"|"config"|"log"|"state"
---@return string
function M.stdpath(what)
	if M.has_vim then
		return vim.fn.stdpath(what) --[[@as string]]
	end

	local home = os.getenv("HOME") or "."
	local appname = os.getenv("NVIM_APPNAME") or "nvim"
	local function xdg(var, default)
		local v = os.getenv(var)
		if v == nil or v == "" then
			v = home .. "/" .. default
		end
		return v .. "/" .. appname
	end

	if what == "data" then
		return xdg("XDG_DATA_HOME", ".local/share")
	elseif what == "cache" then
		return xdg("XDG_CACHE_HOME", ".cache")
	elseif what == "config" then
		return xdg("XDG_CONFIG_HOME", ".config")
	elseif what == "log" or what == "state" then
		return xdg("XDG_STATE_HOME", ".local/state")
	end
	error("stdpath: unsupported value " .. tostring(what))
end

---@param s string
---@param sep string plain (non-pattern) separator
---@return string[]
function M.split(s, sep)
	local res = {}
	local init = 1
	while true do
		local i, j = s:find(sep, init, true)
		if not i then
			table.insert(res, s:sub(init))
			break
		end
		table.insert(res, s:sub(init, i - 1))
		init = j + 1
	end
	return res
end

---@param t table
---@return boolean
function M.tbl_isempty(t)
	return next(t) == nil
end

---@param t table
---@return any[]
function M.tbl_keys(t)
	local keys = {}
	for k, _ in pairs(t) do
		table.insert(keys, k)
	end
	table.sort(keys, function(a, b)
		return tostring(a) < tostring(b)
	end)
	return keys
end

---@param t table
---@return boolean
local function is_dict(t)
	return type(t) == "table" and (next(t) == nil or t[1] == nil)
end

--- Like vim.tbl_deep_extend("force", ...)
---@param ... table
---@return table
function M.deep_extend(...)
	local ret = {}
	for i = 1, select("#", ...) do
		local tbl = select(i, ...)
		if tbl then
			for k, v in pairs(tbl) do
				if is_dict(v) and is_dict(ret[k]) then
					ret[k] = M.deep_extend(ret[k], v)
				elseif is_dict(v) then
					ret[k] = M.deep_extend(v)
				else
					ret[k] = v
				end
			end
		end
	end
	return ret
end

--- Current time in milliseconds (only meaningful for durations)
---@return number
function M.now()
	if M.has_vim then
		vim.uv.update_time()
		return vim.uv.now()
	end
	return os.clock() * 1000
end

---@param msg string
---@param level? integer one of platform.levels
function M.notify(msg, level)
	-- without UI (headless, `nvim -l`), vim.notify at ERROR level raises an error
	if M.has_vim and #vim.api.nvim_list_uis() > 0 then
		vim.notify(msg, level)
		return
	end
	level = level or M.levels.INFO
	if level >= M.levels.WARN then
		io.stderr:write(string.format("rikai [%s]: %s\n", level_names[level] or "?", msg))
	else
		io.stderr:write(msg .. "\n")
	end
end

---@param s string
---@return string
function M.shellescape(s)
	return "'" .. s:gsub("'", [['\'']]) .. "'"
end

---@param path string
---@return string|nil
local function read_file(path)
	local f = io.open(path, "rb")
	if not f then
		return nil
	end
	local content = f:read("*a")
	f:close()
	return content
end

---@param path string
---@return boolean
function M.file_exists(path)
	local f = io.open(path, "rb")
	if f then
		f:close()
		return true
	end
	return false
end

---@param path string
---@return boolean
function M.is_dir(path)
	if M.has_vim then
		return vim.fn.isdirectory(path) == 1
	end
	return M.run({ "test", "-d", path }).code == 0
end

---@param path string
function M.mkdir_p(path)
	if M.has_vim then
		vim.fn.mkdir(path, "p")
		return
	end
	M.run({ "mkdir", "-p", path })
end

---@param name string
---@return boolean
function M.executable(name)
	if M.has_vim then
		return vim.fn.executable(name) == 1
	end
	local r = os.execute("command -v " .. M.shellescape(name) .. " >/dev/null 2>&1")
	return r == 0 or r == true
end

---@class rikai.platform.RunResult
---@field code integer exit code
---@field stdout string
---@field stderr string

---@class rikai.platform.RunOpts
---@field stdin? string
---@field timeout? integer in milliseconds (only honored inside neovim)

--- Run a command synchronously
---@param cmd string[]
---@param opts? rikai.platform.RunOpts
---@return rikai.platform.RunResult
function M.run(cmd, opts)
	opts = opts or {}
	if M.has_vim then
		local ok, obj = pcall(vim.system, cmd, { text = true, stdin = opts.stdin })
		if not ok then
			return { code = -1, stdout = "", stderr = tostring(obj) }
		end
		local res = obj:wait(opts.timeout)
		return { code = res.code, stdout = res.stdout or "", stderr = res.stderr or "" }
	end

	local escaped = {}
	for _, c in ipairs(cmd) do
		table.insert(escaped, M.shellescape(c))
	end
	local shell_cmd = table.concat(escaped, " ")

	local tmp_in
	if opts.stdin then
		tmp_in = os.tmpname()
		local f = assert(io.open(tmp_in, "wb"))
		f:write(opts.stdin)
		f:close()
		shell_cmd = shell_cmd .. " < " .. M.shellescape(tmp_in)
	else
		shell_cmd = shell_cmd .. " < /dev/null"
	end
	local tmp_out, tmp_err = os.tmpname(), os.tmpname()
	shell_cmd = shell_cmd .. " > " .. M.shellescape(tmp_out) .. " 2> " .. M.shellescape(tmp_err)

	-- lua 5.1 returns the status code, lua >= 5.2 returns ok, "exit", code
	local r1, _, r3 = os.execute(shell_cmd)
	local code
	if type(r1) == "number" then
		code = r1 >= 256 and math.floor(r1 / 256) or r1
	else
		code = r3 or (r1 and 0 or 1)
	end

	local result = {
		code = code,
		stdout = read_file(tmp_out) or "",
		stderr = read_file(tmp_err) or "",
	}
	os.remove(tmp_out)
	os.remove(tmp_err)
	if tmp_in then
		os.remove(tmp_in)
	end
	return result
end

--- Unicode codepoint of the first character, like vim.fn.char2nr
---@param s string
---@return integer
function M.char2nr(s)
	if s == nil or s == "" then
		return 0
	end
	local utf8 = require("lua-utf8")
	return utf8.codepoint(s, 1)
end

return M
