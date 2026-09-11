local M = {}
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
---@field gloss_group string

---@diagnostic disable-next-line: unused
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
	}

	return lines
end

---@param exps ExpressionDesc[]
---@param separator string
---@return string[]
function M.format_expression_list(exps, separator)
	local groups = {}
	local group_order = {}

	for _, res in ipairs(exps) do
		local heading = res["keb_reb_group"]
		if not groups[heading] then
			groups[heading] = {}
			table.insert(group_order, heading)
		end
		table.insert(groups[heading], res)
	end

	local lines = {}
	for group_index, heading in ipairs(group_order) do
		if group_index > 1 then
			table.insert(lines, separator)
		end

		table.insert(lines, heading)
		table.insert(lines, "")
		for _, res in ipairs(groups[heading]) do
			table.insert(lines, res["gloss_group"])
		end
		table.insert(lines, "")
	end

	return lines
end

return M
