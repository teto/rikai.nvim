---@mod rikai.health rikai.nvim health checks

-- must return a Lua table containing a `check()`

local M = {}

local external_dependencies = {
	"sudachi",
}

local h = vim.health

-- ideally we would return the version
---@param dep string dependency name to check
---@return boolean is_installed
---@return string|nil version
local check_installed = function(dep)
	if vim.fn.executable(dep) == 1 then
		return true
	end
	return false
end

---@param name string
---@param value any
---@param validator vim.validate.Validator
---@param optional? boolean
---@param message? string
---@return boolean
---@return string
local function validate(name, value, validator, optional, message)
	local ok, err = pcall(vim.validate, name, value, validator, optional, message)
	return ok or false, "Rocks: Invalid config" .. (err and ": " .. err or "")
end

-- expose bits of it to test validation
---@return boolean|nil
---@return string|nil
local function check_config()
	local cfg = vim.g.rikai
	local ok, err = validate("kanjidb", cfg.dictionaries.kanjidb, "string")
	-- TODO check the file exists ! and if it's outdated ?
	if not ok then
		h.error(err or "" .. vim.g.rikai and "" or " This looks like a plugin bug!")
		return false, err
	else
		h.ok("config structure ok")
	end

	if cfg.popup_options.render_images then
		if vim.fn.isdirectory(cfg.dictionaries.kanjivg) == false then
			h.error("Could not find the kanjivg directory")
		else
			h.ok(string.format("Found the kanjivg directory [%s]", cfg.dictionaries.kanjivg))
		end
	else
		h.ok("Rendering kanji stroke order as images disabled")
	end
end

function M.check()
	local cfg = vim.g.rikai
	h.start("Checking external dependencies")
	for _, dep in ipairs(external_dependencies) do
		if check_installed(dep) then
			h.ok("Program '" .. dep .. "' is executable")
		else
			h.error("Program '" .. dep .. "' is not executable")
		end
	end

	-- { "kanjivg", "kanjidb",
	-- local default_config = require'rikai.config.default'
	for _k, key in ipairs({ "kanjidb", "jmdictdb" }) do
		-- kanjivg is a folder though
		local dep = cfg.dictionaries[key]
		-- print(key)
		-- print(dep)
		if vim.fn.filereadable(dep) == 1 then
			h.ok("Dictionary file '" .. dep .. "' exists")
		else
			h.error("Missing dictionary file '" .. dep .. "'")
		end
	end

	check_config()
end

return M
