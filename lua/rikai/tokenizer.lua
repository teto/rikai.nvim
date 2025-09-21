--- interface that can work with several tokenizers.
--- Available:
--- - sudachi
--
-- todo we should load tokenizer from config
local config = require 'rikai.config'
local utils = require 'rikai.utils'


local M = {}

---@class TokenizationResult
---@field token string
---@field POS string part of speech tag
---@field normal string normal form ?

--- Returns a table of TokenizationResult
---@param content string
---@param enable_pos_processing boolean enable part of speech processing
---@param force boolean ignore cache
---@return table of TokenizationResult
M.tokenize = function (content, ...)
    local exists, tokenizer = pcall(require, 'rikai.tokenizers.'..config.tokenizer)
    if not exists then
        vim.notify("Could not load the "..config.tokenizer)
    end
    tokens = utils.timeit("tokenize", tokenizer.tokenize, content, ...)
    return tokens
end

function M.get_current_token()
    -- vim.fn.getcurpos (byte) vs getcursorcharpos (index)
    -- Get the content of the current line in the buffer
    -- local current_line_content = vim.api.nvim_get_current_line()
    -- print(current_line_content)  -- Print the current line content for verification
    word = vim.fn.expand("<cword>")

    -- TODO use matchaddpos({group},
    -- [{lnum}, {col}, {off}, {curswant}]
    local cursorpos = vim.fn.getcursorcharpos()
    local curcharindex = cursorpos[3]
    local tokens = M.tokenize(word)
    -- find the language
    -- find the matching token under current pos
    -- vim.fn.strwidth("toto")
    local charindex = 0
    local current_token = ""
    for _i, tok in pairs(tokens) do
        current_token = tok[1]
        charindex = vim.fn.strwidth(current_token) + charindex
        -- vim.print("charindex:", charindex)
        if curcharindex < charindex then
            break
        end
    end
    -- vim.print("Identified token and pos ", current_token)

    return current_token
    -- vim.print(tokens)

end

return M
