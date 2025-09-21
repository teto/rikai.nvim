local M = {}
local types = require'rikai.types'
local tokenizer = require'rikai.tokenizers.sudachi'
local logger = require'rikai.log'

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
---@param pos any a neovim pos
---@param highlight_names boolean
M.toggle_highlights = function(pos, highlight_names)
    -- for now just enable
    -- tokenize the current line, searching for names and adding highlights for them
    logger.info("Toggling highlights ")
    local line = pos[2] -1 -- nvim_buf_get_lines is 0-indexed

    lines = vim.api.nvim_buf_get_lines(
        pos[1],
        line,
        pos[2], -- last line index
        true)
    assert(#lines)
    local res = tokenizer.tokenize(lines[1], true)

    logger.info("Setting vim.g.rikai._state")
    vim.g.rikai._state = res
    -- vim.print("Looping over tokens ...")
    for _i, j in ipairs(res) do
        -- vim.print(j[2])
        local lexicon_type = j[2]
        if lexicon_type == types.LexiconType.PROPER_NOUN and highlight_names then
            vim.fn.matchadd('RikaiProperNoun', j[1])
            -- TODO we could print in furigana as virtual text
            -- res["keb_reb_group"]
        end
    end

end

--- Clear the names registered by toggle_names
function M.clear_names()
end

return M
