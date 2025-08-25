local main = require'rikai'
local log = require'rikai.log'
local cmdparser = require'rikai.commands'



-- Create a new highlight group linked to 'Comment'
vim.api.nvim_set_hl(0, 'RikaiVirtualText', { link = 'Comment' })
vim.api.nvim_set_hl(0, 'RikaiNames', { link = 'Search' })



-- todo add a preview function
local commandOpts = {bang= true, range = true}
vim.api.nvim_create_user_command('RikaiNames', require'rikai.highlighter'.toggle_names, {
        bang= true, range = true, nargs= "?"
    })
vim.api.nvim_create_user_command('RikaiLog',
        function ()
            print(tostring(log.get_outfile()))
        end,
        commandOpts)

cmdparser.create_command()

-- should depend on filetype and underlying character ?
-- TODO make delay configurable
-- vim.api.nvim_create_autocmd({"CursorHold"}, {
--     pattern = { "*.md", "*.txt", "*.org" },
-- 	desc = "Display translations on hover",
--    -- inspired by "hover"
-- 	callback = popup_lookup
-- })

-- Function to execute on VimLeave
local function on_vim_leave()
    print("Exiting Neovim...")
    -- TODO close db when opened
end

-- Create an autocommand group for exiting
local exit_group = vim.api.nvim_create_augroup("ExitGroup", { clear = true })

-- Autocommand to trigger on VimLeave
vim.api.nvim_create_autocmd("VimLeave", {
    group = exit_group,
    pattern = "*",
    callback = on_vim_leave,
})


