local JapDefaultConfig = require("rikai.config.default")

---@type RikaiConfig
RikaiConfig = vim.tbl_deep_extend("force", JapDefaultConfig, vim.g.rikai or {})

-- vim.g.rikai._internal / _state is used internally to save some state
vim.g.rikai = RikaiConfig

return RikaiConfig
