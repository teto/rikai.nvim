---@mod rikai.lookup Dictionary lookups
---@brief [[
---Editor-agnostic lookup logic, shared by the neovim plugin and the `rikai`
---executable.
---@brief ]]
local config = require("rikai.config")
local types = require("rikai.types")
local logger = require("rikai.log")
local utils = require("rikai.utils")
local platform = require("rikai.platform")

local M = {}

M.separator = " ---------- "

--- Turn arbitrary text into the token to look up.
--- Text longer than one character gets tokenized and the first token is kept.
---@param text string
---@return TokenizationResult|nil token nil if no token was found
function M.resolve_token(text)
	local utf8 = require("lua-utf8")
	if utf8.len(text) > 1 then
		local tokenizer = require("rikai.tokenizer")
		-- TODO match against cursor position, for instance 'によると'
		local tokens = utils.timeit("tokenize", tokenizer.tokenize, text, true)
		if platform.tbl_isempty(tokens) then
			return nil
		end
		return tokens[1]
	end

	logger:debug("Word " .. text .. " is one character: skipping tokenization...")
	-- create a pseudo TokenizationResult
	return types.TokenResult(text, nil, text)
end

---@class rikai.lookup.FormatOpts
---@field render_images? boolean include the path to a stroke-order image (markdown)

---@class rikai.lookup.Result
---@field lines string[] markdown lines
---@field restype rikai.types.CharacterType
---@field count integer number of results

--- Lookup `normal_form` in the dictionaries and format the results as markdown
---@param normal_form string
---@param opts? rikai.lookup.FormatOpts
---@return rikai.lookup.Result|nil nil when nothing was found
---@return rikai.types.CharacterType restype
function M.lookup(normal_form, opts)
	opts = opts or {}
	local query = require("rikai.providers.sqlite")

	local restype, results = utils.timeit("lookup_expr", query.lookup, normal_form)
	assert(results, "There must be a result")
	if platform.tbl_isempty(results) then
		return nil, restype
	end

	local lines = {}
	logger:debug("Found " .. tostring(#results) .. " results")

	if restype == types.CharacterType.KANJI then
		local radicals = query.lookup_kanji_radicals(normal_form)

		if opts.render_images then
			-- TODO we should implement some caching
			local output_filename = config.popup_options.generate_image_cmd(config.dictionaries.kanjivg, normal_form)
			table.insert(lines, "![kanji](" .. output_filename .. ")")
		end

		local kanji = require("rikai.kanji")
		for _, line in ipairs(kanji.format_kanji(results[1], radicals)) do
			table.insert(lines, line)
		end
	else
		local expr = require("rikai.expression")
		-- TODO find a way to sort / limit results ?
		for _, line in ipairs(expr.format_expression_list(results, M.separator)) do
			table.insert(lines, line)
		end
		table.insert(lines, utils.jisho_link(normal_form, false))
	end

	return { lines = lines, restype = restype, count = #results }, restype
end

return M
