local image = require("rikai.image")
local platform = require("rikai.platform")
local data_dir = platform.stdpath("data") .. "/rikai"

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
---@field log_level integer logging level (see vim.log.levels)
---@field popup_options RikaiConfigPopupOptions
---@field dictionaries RikaiConfigDictionaries
---@field tokenizer "sudachi" for now only "sudachi" is supported
---@field live_popup_delay integer idle delay in milliseconds before showing a live popup
---@field _state table internal state shared with the database provider

---@type RikaiConfig
local JapDefaultConfig = {

	dictionaries = {
		kanjidb = data_dir .. "/kanji.db",
		jmdictdb = data_dir .. "/expression.db",
		kanjivg = data_dir .. "/kanji",
	},
	log_level = platform.levels.WARN,
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
