local JapDefaultConfig = require("rikai.config.default")

---@type RikaiConfig
local overrides = vim and vim.g.rikai or {}
RikaiConfig = vim and vim.tbl_deep_extend("force", JapDefaultConfig, overrides) or JapDefaultConfig

-- vim.g.rikai._internal / _state is used internally to save some state
if vim then
	vim.g.rikai = RikaiConfig
end

return RikaiConfig
