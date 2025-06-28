
---@class JapConfig jap.nvim plugin configuration.
local JapDefaultConfig = {

    width = 120,
    height = 30
}
---@type JapConfig
JapConfig = vim.tbl_deep_extend('force', vim.g.jap_nvim or {}, JapDefaultConfig)


return JapConfig
