local image = require("rikai.image")

---@class RikaiConfigDictionaries
---@field kanjidb string path towards a https://github.com/odrevet/edict_database's compatible db
---@field jmdictdb string
---@field kanjivg string

---@class RikaiConfigPopupOptions
---@field generate_image_cmd fun(string): string
---@field render_images boolean convert kanjis into images to make them easier to read/bigger
---@field max_height integer
---@field max_width integer

---@class RikaiConfig
---@field log_level vim.log.levels logging level
---@field popup_options RikaiConfigPopupOptions
---@field dictionaries RikaiConfigDictionaries
---@field tokenizer string
---@field _state table internal dont use

---@type RikaiConfig
local JapDefaultConfig = {

	dictionaries = {
		kanjidb = vim.fn.stdpath("data") .. "/rikai/kanji.db",
		jmdictdb = vim.fn.stdpath("data") .. "/rikai/expression.db",
		kanjivg = vim.fn.stdpath("data") .. "/rikai/kanjivg",
	},
	log_level = vim.log.levels.WARN,
	tokenizer = "sudachi",

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
