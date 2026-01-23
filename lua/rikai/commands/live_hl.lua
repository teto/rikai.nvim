local lookup = require("rikai.commands.lookup")
local tokenizer = require("rikai.tokenizer")

local M = {}

-- This function highlights the current token under cursor to help with comprehension
M.live_lookup = function()
	-- tokenize
	local token = tokenizer.get_current_token()
	if not token then
		vim.notify("Could not find current token")
	else
		-- print("TODO live lookup of token: " .. token)
        -- lookup() / open window
        lookup.popup_lookup(token)
	end
end


function M.setup_hl_autocmds (_args)
    -- local update_tokenizer_cache = function ()
    -- vim.ringbuf()

    vim.api.nvim_create_autocmd("CursorMoved", {
        -- all 			-- pattern = { "*.md", "*.txt", "*.org" },
        pattern = "*",
        callback = function ()
            -- TODO 
            -- 1. check if line changed tokenization exists in cache
            -- if it didn't tokenize current line and save it in cache
            -- use vim.ringbuf ?
        end,
    })


    vim.api.nvim_create_autocmd({ "CursorHold" }, {
        -- group = "rikai",
        buffer = vim.api.nvim_get_current_buf(),
        -- configurable ?
        -- pattern = { "*.md", "*.txt", "*.org" },
        desc = "Display translations on hover",
        -- inspired by "hover"
        callback = function () 
            M.live_lookup()
            -- todo update highlight
        end,
    })

    -- if megaargs.hl_command == "clear" then
    --     logger.info("clearing hl")
    --     -- renvoye -1 ptet
    --     vim.fn.matchdelete('RikaiProperNoun')
    -- end
    -- require'rikai.highlighter'.toggle_highlights(pos, true)
end

return M
