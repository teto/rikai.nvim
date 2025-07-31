-- setup functions for rikai
-- Autocommand to highlight the word under the cursor when the cursor moves

local M = {}

local highlighter = require'rikai.highlighter'

function M.enable_on_cursor()
    vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
        group = highlighter.highlight_group,
        pattern = "*",
        callback = highlighter.highlight_current_word,
    })
end

