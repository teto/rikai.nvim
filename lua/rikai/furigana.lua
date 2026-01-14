local provider = require("rikai.providers.sqlite")
local types = require("rikai.types")
-- local classifier = require'rikai.classifier'
local tokenizer = require("rikai.tokenizers.sudachi")
local logger = require("rikai.log")

local M = {}

local furigana_ns = "rikai-furigana"

-- TODO in case virtual lines at line 0 are added, we should do https://github.com/neovim/neovim/issues/16166
-- -- vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--     group = my_augroup,
--     buffer = buf,
--     callback = function()
--        local win = vim.fn.bufwinid(buf)
--        -- execute winrestview in context of win:
--        vim.fn.win_execute(win, 'lua vim.fn.winrestview({ topfill = ' .. topfill .. ' })')
--     end,
--   })

-- TODO add callback such that one can filter out kanjis
-- for instance if it's jlpt5 or not
---@param _args any
function M.add_furigana(_args)
	-- Get the buffer number (0 refers to the current buffer)
	-- get buf from getpos
	local pos = vim.fn.getpos(".")
	local line = pos[2] -- nvim_buf_get_lines is 0-indexed
	local bufnr = pos[1]

	-- Create a namespace for virtual text
	local namespace_id = vim.api.nvim_create_namespace(furigana_ns)

	-- exclusive
	local lines = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, true)

	local virt_line = {}
	-- tokenizing only the first one
	-- TODO we should do all of them/in the range
	local line2 = lines[1]
	if line2 == nil then
		logger.warn("Nothing to tokenize")
		return
	end
	local res = tokenizer.tokenize(line2, true)
	local column = 1
	for _i, j in ipairs(res) do
		local token = j[1]

		local lexicon_type = j[2]
		local highlight = "Comment"
		if lexicon_type == types.LexiconType.PROPER_NOUN then
			highlight = "RikaiProperNoun"
		elseif lexicon_type == types.LexiconType.NOUN then
			highlight = "RikaiName"
		end

		if lexicon_type == types.LexiconType.PROPER_NOUN then
			-- for now let's assume it's an expression
			local results = provider.lookup_expr(token)

			local virtual_text = token
			if not vim.tbl_isempty(results) then
				-- table.insert(virt_line, { token, highlight })
				virtual_text = results[1]["keb_reb_group"]
			end
			table.insert(virt_line, { virtual_text, highlight })
		else
			-- column = column + token_len
			-- virtual_text = "toto"
			-- add an empty

			local display_len = vim.fn.strdisplaywidth(token)
			-- print(string.format("token %s of display width %d of type %s", token, display_len, tokenizer.lexicon_to_str(lexicon_type)))
			local placeholder = string.rep(" ", display_len)
			table.insert(virt_line, { placeholder, "Normal" })
		end
	end

	--
	vim.api.nvim_buf_set_extmark(
		bufnr,
		namespace_id,
		line - 1,
		column - 1, -- column
		{
			-- TODO provide desc
			virt_lines = { virt_line },
			virt_lines_above = true,
		}
	)

	-- Set the virtual text on a specific line and column
	-- TODO be careful what happens on first line ?
	-- vim.api.nvim_buf_set_extmark(bufnr, namespace_id, line-1, 0, {
	--     virt_text = virtual_text,
	--     -- virt_lines_above =
	--     virt_text_pos = 'overlay',
	--     virt_text_hide = true,
	-- })
end

function M.clear() end

---@return nil
function M.setup_autocommands()
	vim.api.nvim_create_autocmd("CursorMoved", {
		callback = function()
			-- delete
		end,
	})
end

return M
