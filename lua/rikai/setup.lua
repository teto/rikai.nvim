-- setup functions for rikai
-- Autocommand to highlight the word under the cursor when the cursor moves

local M = {}

-- local highlighter = require("rikai.highlighter")

-- disabled temporarily, should be replaced by live_hl module eventually
---@return nil
function M.enable_on_cursor()
	-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	-- 	group = highlighter.highlight_group,
	--        -- TODO replace by buffer
	-- 	pattern = "*",
	-- 	callback = highlighter.highlight_current_token,
	-- })
end

return M
