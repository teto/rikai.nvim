local lookup = require("rikai.commands.lookup")
local tokenizer = require("rikai.tokenizer")
local utils = require("rikai.utils")
local logger = require("rikai.log")

local M = {}


-- _state.current_token

---@class LiveHlState
---@field current_token table
-- cache some state
local _state = {}

M.highlight_current_token = function()
	local token, line, coloffset, width_in_bytes = tokenizer.get_current_token()

	if not token then
		utils.notify("Could not find current token")
        return
    end
    -- highlight token for current line
    -- RikaiCurrentToken
    -- M.highlight_group = vim.api.nvim_create_augroup("RikaiHighlightWordGroup", { clear = true })

    -- [23, 11, 3]
    -- if it exists, remove it
    -- local line, coloffset = curpos[2], curpos[3]
    local msg = string.format("hl current token '%s' at line %d, coloffset= %d width=%d }", token, line, coloffset, width_in_bytes)
    utils.notify(msg)
    -- higlighting current token at pos {0, 14, 2 }
    -- TODO clear up previous highlight
    if _state.current_token then
        -- todo 
        -- remove the saved
        logger.debug(string.format("Removing previous hl %d", _state.current_token))
        vim.fn.matchdelete(_state.current_token)
    end
    local res = vim.fn.matchaddpos("RikaiCurrentToken", 
        -- list of per line positions ?
        {
          { line,
            coloffset, -- expects an offset starting with one
            width_in_bytes
          }
        }
        )
    if res < 0 then
        logger.error("Could not create position")
    else 
        vim.print(res)
        _state.current_token = res
    end

end

-- This function highlights the current token under cursor to help with comprehension
M.live_lookup = function()
	-- tokenize
	local token, _ = tokenizer.get_current_token()
	if not token then
		utils.notify("Could not find current token")
	else
		-- print("TODO live lookup of token: " .. token)
        -- lookup() / open window
        lookup.popup_lookup(token)
	end
end


function M.setup_hl_autocmds (_args)
    -- local update_tokenizer_cache = function ()
    -- vim.ringbuf()
    local curbuf = vim.api.nvim_get_current_buf()

    vim.api.nvim_create_autocmd("CursorMoved", {
        -- all 			-- pattern = { "*.md", "*.txt", "*.org" },
        -- pattern = "*",
        buffer = curbuf,
        desc = "Highlights current token with RikaiCurrentToken",
        callback = function ()
            -- TODO 
            -- 1. check if line changed tokenization exists in cache
            -- if it didn't tokenize current line and save it in cache
            -- use vim.ringbuf ?
            M.highlight_current_token()
        end,
    })


    -- disabled during testing, this works fine
    -- vim.api.nvim_create_autocmd({ "CursorHold" }, {
    --     -- group = "rikai",
    --     buffer = curbuf,
    --     desc = "Display translations on hover",
    --     -- inspired by "hover"
    --     callback = function () 
    --         M.live_lookup()
    --         -- todo update highlight
    --     end,
    -- })

    -- if megaargs.hl_command == "clear" then
    --     logger.info("clearing hl")
    --     -- renvoye -1 ptet
    --     vim.fn.matchdelete('RikaiProperNoun')
    -- end
    -- require'rikai.highlighter'.toggle_highlights(pos, true)
end

return M
