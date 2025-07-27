-- Function to execute on VimLeave
local function on_vim_leave()
    print("Exiting Neovim...")
end

-- Create an autocommand group for exiting
local exit_group = vim.api.nvim_create_augroup("ExitGroup", { clear = true })

-- Autocommand to trigger on VimLeave
vim.api.nvim_create_autocmd("VimLeave", {
    group = exit_group,
    pattern = "*",
    callback = on_vim_leave,
})

