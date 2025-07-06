
---@class JapConfig jap.nvim plugin configuration.
local JapDefaultConfig = {
    width = 120,
    height = 30,
    kanjidb = vim.fn.stdpath("data").."/rikai/kanji.db",
    jmdictdb = vim.fn.stdpath("data").."/rikai/expression.db",
}

---@type JapConfig
JapConfig = vim.tbl_deep_extend('keep', vim.g.rikai or {}, JapDefaultConfig)

vim.g.rikai = JapConfig

return JapConfig
