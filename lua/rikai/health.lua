---@mod rikai.health rikai.nvim health checks

-- must return a Lua table containing a `check()`

local platform = require("rikai.platform")

local M = {}

---@class rikai.health.Reporter
---@field start fun(msg: string)
---@field ok fun(msg: string)
---@field warn fun(msg: string)
---@field error fun(msg: string)

---@param name string
---@param value any
---@param expected_type string
---@return boolean
---@return string|nil
local function validate(name, value, expected_type)
	if type(value) ~= expected_type then
		return false,
			string.format("Rikai: Invalid config: %s: expected %s, got %s", name, expected_type, type(value))
	end
	return true, nil
end

---Validates the config.
---@param cfg RikaiConfig
---@return boolean is_valid
---@return string|nil error_message
function M.validate_config(cfg)
	for _, check in ipairs({
		{ "tokenizer", "string" },
		{ "dictionaries", "table" },
		{ "popup_options", "table" },
	}) do
		local ok, err = validate(check[1], cfg[check[1]], check[2])
		if not ok then
			return false, err
		end
	end
	return true, nil
end

-- kept for backwards compatibility
validateCfg = M.validate_config

---@param h rikai.health.Reporter
---@param cfg RikaiConfig
---@return boolean
local function check_config(h, cfg)
	local ok, err = M.validate_config(cfg)
	-- TODO check the file exists ! and if it's outdated ?
	if not ok then
		h.error(err or "This looks like a plugin bug!")
		return false
	end
	h.ok("config structure valid")

	if cfg.popup_options.render_images then
		if not platform.is_dir(cfg.dictionaries.kanjivg) then
			h.error("Could not find the kanjivg directory")
		else
			h.ok(string.format("Found the kanjivg directory [%s]", cfg.dictionaries.kanjivg))
		end
	else
		h.ok("Rendering kanji stroke order as images disabled")
	end
	return true
end

--- Run every check, reporting through `h`
---@param h rikai.health.Reporter
---@param cfg? RikaiConfig
function M.run_checks(h, cfg)
	local merged_cfg = cfg or require("rikai.config")

	h.start("Checking configuration")
	check_config(h, merged_cfg)

	h.start("Checking external dependencies")
	if platform.executable("sudachi") then
		h.ok("Tokenizer  'sudachi' is executable")
	else
		h.error("The tokenizer 'sudachi' must be available")
	end

	if platform.executable("rsvg-convert") then
		h.ok("svg to image kanji converter 'rsvg-converter' is executable")
	else
		h.warn("Make available the program 'rsvg-convert' to display kanji as images")
	end

	for _, exe in ipairs({ "curl", "unzip" }) do
		if platform.executable(exe) then
			h.ok("'" .. exe .. "' (needed to download dictionaries) is executable")
		else
			h.warn("Make available the program '" .. exe .. "' to download dictionaries")
		end
	end

	h.start("Checking dictionaries")
	for _k, key in ipairs({ "kanjidb", "jmdictdb" }) do
		-- kanjivg is a folder though
		local dep = merged_cfg.dictionaries[key]
		if platform.file_exists(dep) then
			h.ok("Dictionary file '" .. dep .. "' exists")
		else
			h.error("Missing dictionary file '" .. dep .. "'")
		end
	end
end

--- Entrypoint for `:checkhealth rikai`
function M.check()
	local h = vim.health
	M.run_checks({
		start = h.start,
		ok = h.ok,
		warn = h.warn,
		error = h.error,
	})
end

return M
