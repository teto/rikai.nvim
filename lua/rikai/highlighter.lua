local M = {}
local types = require'rikai.types'
local tokenizer = require'rikai.tokenizers.sudachi'

-- Function to highlight the current word using <cword>
-- funnily enough, it highlights different kanjis
local function highlight_current_word()
    local word = vim.fn.expand("<cword>")
    if word then
        vim.cmd('match Search /\\<' .. word .. '\\>/')
    end
end

-- Create an autocommand group for highlighting
M.highlight_group = vim.api.nvim_create_augroup("RikaiHighlightWordGroup", { clear = true })


--- Add highlights for names present in current line
--- ideally we would display furiganas as a virtual line see furigana.lua
---@param args vim.api.keyset.create_user_command.command_args
M.toggle_names = function(args)
    -- for now just enable
    -- tokenize the current line, searching for names and adding highlights for them
    local pos = vim.fn.getpos(".")
    vim.print(pos)
    local line = pos[2] -1 -- nvim_buf_get_lines is 0-indexed
    -- print("line:", line)
    lines = vim.api.nvim_buf_get_lines(pos[1], line, pos[2], true)
    assert(#lines)
    local res = tokenizer.tokenize(lines[1], true)
    -- vim.print(res)
    vim.print("Looping over tokens ...")
    for _i, j in ipairs(res) do
        vim.print(j[2])
        local lexicon_type = j[2]
        if lexicon_type == types.LexiconType.PROPER_NOUN then
            vim.fn.matchadd('RikaiNames', j[1])
            -- TODO we could print in furigana as virtual text
            -- res["keb_reb_group"]
        end
    end

end

--- Clear the names registered by toggle_names
function M.clear_names()
end

return M
