local cmdparser = require'rikai.commands'


-- Create a new highlight group linked to 'Comment'
vim.api.nvim_set_hl(0, 'RikaiVirtualText', { link = 'Comment' })
vim.api.nvim_set_hl(0, 'RikaiProperNoun', { link = 'Search' })
-- Const / Character
vim.api.nvim_set_hl(0, 'RikaiName', { link = 'Const' })



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
    -- print("Exiting Neovim...")
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


