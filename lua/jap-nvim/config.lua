
---@class JapConfig jap.nvim plugin configuration.
local JapDefaultConfig = {
}
---@type JapConfig
JapConfig = vim.tbl_deep_extend('force', vim.g.jap_nvim or {}, JapDefaultConfig)


vim.g.jap_nvim = 

