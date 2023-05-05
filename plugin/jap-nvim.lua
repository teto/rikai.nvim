-- unused-local
local util = vim.lsp.util


-- todo add a preview function
local commandOpts = {bang= true, range = true}
vim.api.nvim_create_user_command('JapRo2Ka', require'jap-nvim'.ro2ka, commandOpts)
vim.api.nvim_create_user_command('JapRo2Hi', require'jap-nvim'.ro2hi, commandOpts)


-- get current word translations
vim.api.nvim_create_user_command('JapLookup', require'jap-nvim'.lookup, commandOpts)


-- should depend on filetype and underlying character ?
--vim.api.nvim_create_autocmd("CursorHold", {
--	desc = "Display translations on hover",
--    -- inspired by "hover"
--	callback = function(args)
--        -- :xa
--        --
--        local params = vim.lsp.util.make_position_params()
--        print(params)
--        local width = 100
--        local height = 30
--        local opts = {}
--        util.make_floating_popup_options(width, height, opts)
--        local floating_bufnr, floating_winnr = util.open_floating_preview("THIS IS THE CONTENT", "text", opts)

--		-- if not (args.data and args.data.client_id) then
--		-- 	return
--		-- end
--		-- local client = vim.lsp.get_client_by_id(args.data.client_id)
--		-- local bufnr = args.buf
--		-- local on_attach = require 'on_attach'
--		-- on_attach.on_attach(client, bufnr)
--		-- require'lsp_signature'.on_attach(client, bufnr)
--	end
--})

