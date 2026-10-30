---Lookup and format the dictionary content shared by the editor and CLI.
local config = require("rikai.config")
local types = require("rikai.types")
local utils = require("rikai.utils")
local query = require("rikai.providers.sqlite")

local M = {}
local separator = " ---------- "

---@param token TokenizationResult
---@param opts? { render_images: boolean }
---@return string[]|nil lines
---@return string|table? details
function M.format(token, opts)
	local normal_form = token.normal_form
	local restype, results = utils.timeit("lookup_expr", query.lookup, normal_form)
	assert(results, "There must be a result")
	if #results == 0 then
		return nil, "No results matching " .. types.as_str(restype) .. " " .. normal_form
	end

	local formatted_results = {}
	if restype == types.CharacterType.KANJI then
		local popup_options = config.popup_options
		if (opts and opts.render_images) or (opts == nil and popup_options.render_images) then
			local has_snacks = pcall(require, "snacks.image")
			if not has_snacks and vim then
				vim.notify("Can't preview kanji: Snacks is not available")
			end
			local output_filename = popup_options.generate_image_cmd(config.dictionaries.kanjivg, normal_form)
			table.insert(formatted_results, "![kanji](" .. output_filename .. ")")
		end

		local radicals = query.lookup_kanji_radicals(normal_form)
		local kanji = require("rikai.kanji")
		for _, line in ipairs(kanji.format_kanji(results[1], radicals)) do
			table.insert(formatted_results, line)
		end
	else
		local expr = require("rikai.expression")
		for _, line in ipairs(expr.format_expression_list(results, separator)) do
			table.insert(formatted_results, line)
		end
		table.insert(formatted_results, utils.jisho_link(normal_form, false))
	end

	return formatted_results, { count = #results, normal_form = normal_form }
end

return M
