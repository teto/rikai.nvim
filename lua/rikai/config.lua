
---@class RikaiConfig jap.nvim plugin configuration.
---
---@field kanjidb? string path towards a https://github.com/odrevet/edict_database's compatible db
---@field jmdictdb? string
---@field log_level? vim.log.levels logging level
---@field popup_options vim.lsp.util.open_floating_preview.Opts
---@field _state table internal dont use
local JapDefaultConfig = {
    width = 100,
    height = 30,
    kanjidb = vim.fn.stdpath("data").."/rikai/kanji.db",
    jmdictdb = vim.fn.stdpath("data").."/rikai/expression.db",
    log_level = vim.log.levels.WARN,
    tokenizer = 'sudachi',
    -- separator = " ------ ",

    popup_options = {
        max_height = 20
    },

    -- internal usage
    _state = {
    }
}

---@type RikaiConfig
RikaiConfig = vim.tbl_deep_extend('keep', vim.g.rikai or {}, JapDefaultConfig)

-- vim.g.rikai._internal / _state is used internally to save some state
vim.g.rikai = RikaiConfig

return RikaiConfig
