local JapDefaultConfig =  require'rikai.config.default'

---@type RikaiConfig
RikaiConfig = vim.tbl_deep_extend("keep", vim.g.rikai or {}, JapDefaultConfig)
---@cast config RikaiConfig

-- vim.g.rikai._internal / _state is used internally to save some state
vim.g.rikai = RikaiConfig

return RikaiConfig
