local JapDefaultConfig = require("rikai.config.default")
local platform = require("rikai.platform")

--- Load the user configuration
--- - in neovim, from `vim.g.rikai`
--- - standalone, from the lua file pointed at by $RIKAI_CONFIG or
---   `$XDG_CONFIG_HOME/rikai/config.lua` which must return a table
---@return table
local function load_user_config()
	if platform.has_vim then
		return vim.g.rikai or {}
	end

	local path = os.getenv("RIKAI_CONFIG")
	if not path then
		local config_home = os.getenv("XDG_CONFIG_HOME")
		if config_home == nil or config_home == "" then
			config_home = (os.getenv("HOME") or ".") .. "/.config"
		end
		path = config_home .. "/rikai/config.lua"
	end

	if not platform.file_exists(path) then
		return {}
	end

	local chunk, err = loadfile(path)
	if not chunk then
		platform.notify("Could not load config " .. path .. ": " .. tostring(err), platform.levels.ERROR)
		return {}
	end
	local ok, res = pcall(chunk)
	if not ok or type(res) ~= "table" then
		platform.notify("Config " .. path .. " must return a table", platform.levels.ERROR)
		return {}
	end
	return res
end

---@type RikaiConfig
RikaiConfig = platform.deep_extend(JapDefaultConfig, load_user_config())

if platform.has_vim then
	-- vim.g.rikai._internal / _state is used internally to save some state
	vim.g.rikai = RikaiConfig
end

return RikaiConfig
