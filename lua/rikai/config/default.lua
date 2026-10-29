local image = require("rikai.image")

local function data_dir()
	if vim then
		return vim.fn.stdpath("data")
	end
	local xdg_data_home = os.getenv("XDG_DATA_HOME")
	if xdg_data_home and xdg_data_home ~= "" then
		return xdg_data_home .. "/nvim"
	end
	return (os.getenv("HOME") or ".") .. "/.local/share/nvim"
end

local rikai_data_dir = os.getenv("RIKAI_DATA_DIR") or (data_dir() .. "/rikai")

---@class RikaiConfigDictionaries
---@field kanjidb string path towards a https://github.com/odrevet/edict_database's compatible db
---@field jmdictdb string
---@field kanjivg string

---@alias RikaiImageGeneratorFn fun(kanjivg_folder: string, kanji: string): string
---returns path to image

---@class RikaiConfigPopupOptions
---@field generate_image_cmd RikaiImageGeneratorFn string you can import one from 'rikai.image'
---@field render_images boolean convert kanjis into images to make them easier to read/bigger
---@field max_height integer
---@field max_width integer

---@class RikaiConfig
---@field log_level vim.log.levels logging level
---@field popup_options RikaiConfigPopupOptions
---@field dictionaries RikaiConfigDictionaries
---@field tokenizer "sudachi" for now only "sudachi" is supported
---@field live_popup_delay integer idle delay in milliseconds before showing a live popup
---@field _state table internal state shared with the database provider

---@type RikaiConfig
local JapDefaultConfig = {

	dictionaries = {
		kanjidb = os.getenv("RIKAI_KANJI_DB") or (rikai_data_dir .. "/kanji.db"),
		jmdictdb = os.getenv("RIKAI_EXPRESSION_DB") or (rikai_data_dir .. "/expression.db"),
		kanjivg = rikai_data_dir .. "/kanji",
	},
	log_level = vim and vim.log.levels.WARN or "warning",
	tokenizer = "sudachi",
	live_popup_delay = 500,

	--- TODO vim.lsp.util.open_floating_preview.Opts
	popup_options = {
		render_images = true,
		max_width = 100,
		max_height = 30,
		generate_image_cmd = image.from_kanjivg,
	},

	-- internal usage, todo remove let to
	_state = {},
}

return JapDefaultConfig
