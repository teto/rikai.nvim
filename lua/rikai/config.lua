local image = require("rikai.image")

---@class RikaiConfig jap.nvim plugin configuration.
---@field kanjidb string path towards a https://github.com/odrevet/edict_database's compatible db
---@field jmdictdb string
---@field log_level vim.log.levels logging level
---@field popup_options RikaiConfigPopupOptions
---@field _state table internal dont use
local JapDefaultConfig = {
	---@class RikaiConfigDictionaries
	---@field kanjidb string
	dictionaries = {
		kanjidb = vim.fn.stdpath("data") .. "/rikai/kanji.db",
		jmdictdb = vim.fn.stdpath("data") .. "/rikai/expression.db",
		kanjivg = vim.fn.stdpath("data") .. "/rikai/kanjivg",
	},
	width = 100,
	height = 30,
	log_level = vim.log.levels.WARN,
	tokenizer = "sudachi",

	-- separator = " ------ ",

	---@class RikaiConfigPopupOptions
	---@field generate_image_cmd fun(string): string
	---@field use_images boolean convert kanjis into images to make them easier to read/bigger
	--- TODO vim.lsp.util.open_floating_preview.Opts
	popup_options = {
		---
		use_images = true,

		generate_image_cmd = image.from_kanjivg,
		max_height = 20,
	},

	-- internal usage, todo remove let to
	_state = {},
}

---@type RikaiConfig
RikaiConfig = vim.tbl_deep_extend("keep", vim.g.rikai or {}, JapDefaultConfig)

-- vim.g.rikai._internal / _state is used internally to save some state
vim.g.rikai = RikaiConfig

return RikaiConfig
