-- unused-local
local util = vim.lsp.util

local JapConfig = require('jap-nvim.config')

-- todo add a preview function
local commandOpts = {bang= true, range = true}
vim.api.nvim_create_user_command('JapRo2Ka', require'jap-nvim'.ro2ka, commandOpts)
vim.api.nvim_create_user_command('JapRo2Hi', require'jap-nvim'.ro2hi, commandOpts)


-- get current word translations
vim.api.nvim_create_user_command('JapLookup', require'jap-nvim'.lookup, commandOpts)


-- should depend on filetype and underlying character ?
vim.api.nvim_create_autocmd({"CursorHold"}, {
    pattern = { "*.md", "*.txt", "*.org" },
	desc = "Display translations on hover",
   -- inspired by "hover"
	callback = function(args)
       -- :xa
       local params = vim.lsp.util.make_position_params()
       print(params)
        require'jap-nvim.popup'.create_popup()
	end
})

