---@mod rikai.health rikai.nvim health checks

-- must return a Lua table containing a `check()`

local M = {}

local external_dependencies = {
	"sudachi",
	"rsvg-convert",
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

---Validates the config.
---@param cfg RikaiConfig
---@return boolean is_valid
---@return string|nil error_message
function validateCfg(cfg)
    local ok, err = validate("tokenizer", cfg.tokenizer, "string")
    if not ok then
        return false, err
    end
    ok, err = validate("dictionaries", cfg.dictionaries, "table")
    if not ok then
        return false, err
    end
    ok, err = validate("popup_options", cfg.popup_options, "table")
    if not ok then
        return false, err
    end
end


-- expose bits of it to test validation
---@@param table
---@return boolean|nil
---@return string|nil
local function check_config(cfg)
	-- local cfg = vim.g.rikai
	local ok, err = validateCfg(cfg)
	-- TODO check the file exists ! and if it's outdated ?
	if not ok then
        -- TODO error
		h.error(err or "" .. vim.g.rikai and "" or " This looks like a plugin bug!")
		return false, err
	else
		h.ok("config structure valid")
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
	local merged_cfg = require'rikai.config'

	check_config(merged_cfg)

	h.start("Checking external dependencies")
    if check_installed("sudachi") then
        h.ok("Tokenizer  'sudachi' is executable")
    else
        h.error("The tokenizer 'sudachi' must be available")
    end

    if check_installed("rsvg-convert") then
        h.ok("svg to image kanji converter 'rsvg-converter' is executable")
    else
        h.warn("Make available the program 'rsvg-convert' to display kanji as images")
    end

	-- { "kanjivg", "kanjidb",
	-- local default_config = require'rikai.config.default'
	for _k, key in ipairs({ "kanjidb", "jmdictdb" }) do
		-- kanjivg is a folder though
		local dep = merged_cfg.dictionaries[key]
		if vim.fn.filereadable(dep) == 1 then
			h.ok("Dictionary file '" .. dep .. "' exists")
		else
			h.error("Missing dictionary file '" .. dep .. "'")
		end
	end
end

return M
