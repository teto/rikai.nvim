---@mod rikai-live
---@brief [[
---Creates a yomitan-like experience where current word gets highlighted as you move the cursor along
---@brief ]]
local lookup = require("rikai.commands.lookup")
local tokenizer = require("rikai.tokenizer")
local utils = require("rikai.utils")
local logger = require("rikai.log")
local config = require("rikai.config")

local M = {}

-- _state.current_token

---@class LiveHlState
---@field current_token? integer match ID returned by vim.fn.matchaddpos
-- cache some state
local _state = {}
local pending_lookups = {}

M.highlight_current_token = function()
	local token, line, coloffset, width_in_bytes = tokenizer.get_current_token()

	if not token then
		utils.notify("Could not find current token.")
		return
	end
	-- highlight token for current line
	-- RikaiCurrentToken
	-- M.highlight_group = vim.api.nvim_create_augroup("RikaiHighlightWordGroup", { clear = true })

	-- [23, 11, 3]
	-- if it exists, remove it
	-- local line, coloffset = curpos[2], curpos[3]
	local msg = string.format(
		"hl current token '%s' at line %d, coloffset= %d width=%d }",
		token,
		line,
		coloffset,
		width_in_bytes
	)
	logger:debug(msg)
	-- higlighting current token at pos {0, 14, 2 }
	-- TODO clear up previous highlight
	if _state.current_token then
		-- todo
		-- remove the saved
		logger:debug(string.format("Removing previous hl %d", _state.current_token))
		vim.fn.matchdelete(_state.current_token)
	end
	local res = vim.fn.matchaddpos(
		"RikaiCurrentToken",
		-- list of per line positions ?
		{
			{
				line,
				coloffset, -- expects an offset starting with one
				width_in_bytes,
			},
		}
	)
	-- matchaddpos returns a match ID; Neovim's annotation also includes table.
	---@cast res integer
	if res < 0 then
		logger:error("Could not create position")
	else
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
		-- lookup() / open window
		lookup.popup_lookup(token)
	end
end

---Setups autocommands that
---1. highlight current word
---2. Creates popup on current word
---TODO shall we limit it to special filetypes ?
---@param autocmd_args table merged into nvim_create_autocmd args
---   for instance to limit the autocmd to certain filetypes do
---   'pattern = { "*.md", "*.txt", "*.org" }'
function M.setup_hl_autocmds(autocomd_args)
	local curbuf = vim.api.nvim_get_current_buf()
	local delay = config.live_popup_delay
	assert(type(delay) == "number" and delay >= 0 and delay % 1 == 0, "live_popup_delay must be a non-negative integer")
	local group = vim.api.nvim_create_augroup("RikaiLive_" .. curbuf, { clear = true })
	pending_lookups[curbuf] = nil

	local function cancel_lookup()
		pending_lookups[curbuf] = nil
	end

	local function schedule_lookup()
		local request = {}
		pending_lookups[curbuf] = request
		local win = vim.api.nvim_get_current_win()
		local cursor = vim.api.nvim_win_get_cursor(win)
		local changedtick = vim.api.nvim_buf_get_changedtick(curbuf)
		vim.defer_fn(function()
			if pending_lookups[curbuf] ~= request then
				return
			end
			cancel_lookup()
			if
				vim.api.nvim_get_current_buf() == curbuf
				and vim.api.nvim_get_current_win() == win
				and vim.api.nvim_get_mode().mode == "n"
				and vim.api.nvim_buf_get_changedtick(curbuf) == changedtick
				and vim.deep_equal(vim.api.nvim_win_get_cursor(win), cursor)
			then
				M.live_lookup()
			end
		end, delay)
	end

	vim.api.nvim_create_autocmd(
		"CursorMoved",
		vim.tbl_deep_extend("keep", {
			buffer = curbuf,
			group = group,
			desc = "Highlights current token with RikaiCurrentToken",
			callback = function()
				-- TODO
				-- 1. check if line changed tokenization exists in cache
				-- if it didn't tokenize current line and save it in cache
				-- use vim.ringbuf ?
				M.highlight_current_token()
				schedule_lookup()
			end,
		}, autocomd_args or {})
	)

	vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave", "InsertEnter", "BufWipeout", "TextChanged" }, {
		buffer = curbuf,
		group = group,
		desc = "Cancel pending Rikai hover lookup",
		callback = cancel_lookup,
	})

	-- Also translate when live mode is enabled without moving the cursor.
	schedule_lookup()

	-- if megaargs.hl_command == "clear" then
	--     logger:info("clearing hl")
	--     -- renvoye -1 ptet
	--     vim.fn.matchdelete('RikaiProperNoun')
	-- end
	-- require'rikai.highlighter'.toggle_highlights(pos, true)
end

return M
