local M = {}
local utils = require("rikai.utils")
-- {
-- ||   entry_id = 1169250,
-- ||   gloss_group = "to lead (e.g. a horse),to pull,to tug",
-- ||   k_ele_id = 4211,
-- ||   keb_reb_group = "引く:ひく,曳く:ひく,牽く:ひく",
-- ||   pos_group = "v5k,vt",
-- ||   sense_id = 18822
-- || }

---@class ExpressionDesc
---@field k_ele_id number
---@field entry_id number
---@field pos_group string
---@field sense_id number
---@field keb_reb_group string

---@param original_token string The original search
---@param res ExpressionDesc
---@return table (as expected by 'open_floating_preview')
function M.format_expression(original_token, res)
	local lines = {
		-- annoyingly it contains the prefix / request
		res["keb_reb_group"], -- .. " (k_ele_id) ",
		-- "kun reading: ".. res["kun_reading"],
		-- "on reading: ".. res["on_reading"],
		-- "pos_group ?"..res["pos_group"],
		"",
		res["gloss_group"],
		"",
		utils.jisho_link(original_token, false),
	}

	return lines
end

return M
