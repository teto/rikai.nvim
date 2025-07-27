-- Function to highlight the current word using <cword>
-- funnily enough, it highlights different kanjis
local function highlight_current_word()
    local word = vim.fn.expand("<cword>")
    if word then
        vim.cmd('match Search /\\<' .. word .. '\\>/')
    end
end

-- Create an autocommand group for highlighting
local highlight_group = vim.api.nvim_create_augroup("HighlightWordGroup", { clear = true })

-- Autocommand to highlight the word under the cursor when the cursor moves
vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
    group = highlight_group,
    pattern = "*",
    callback = highlight_current_word,
})

