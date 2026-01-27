--- interface that can work with several tokenizers.
--- Available:
--- - sudachi
local config = require("rikai.config")
local utils = require("rikai.utils")
-- local utf8 = require("utf8")
local logger = require("rikai.log")

local M = {}

---@class TokenizationResult
---@field token string
---@field POS string part of speech tag
---@field normal string normal form ?

---@class Tokenizer
---@field tokenize function


--- Returns a table of TokenizationResult
---@param content string
--@param enable_pos_processing boolean enable part of speech processing
--@param force boolean ignore cache
---@return table of TokenizationResult
M.tokenize = function(content, ...)
    -- TODO we should add a cache depending on content
	local exists, tokenizer = pcall(require, "rikai.tokenizers." .. config.tokenizer)
	if not exists then
		vim.notify("Could not load the " .. config.tokenizer)
	end
	local tokens = utils.timeit("tokenize", tokenizer.tokenize, content, ...)
	return tokens
end

--- we might want to return its lenght for matchaddpos ?
---@return string token value
--@return any value returned by getcurpos, i.e: [0, lnum, col, off, curswant]
---@return number line
---@return number current token start offset
---@return number token width
function M.get_current_token()
	-- Get the content of the current line in the buffer
    -- Getting the line can be wasteful in terms of tokenization but it allows us to compare the offsets between the tokens
    -- it is a temporary measure until we can retreive the current sentence ?
	-- local content = vim.fn.expand("<cword>")
	local content = vim.api.nvim_get_current_line()

    -- we use getpos (byte) and not getcursorcharpos (index) because
    -- we later want to use matchaddpos that accepts column offset
	local cursorpos = vim.fn.getpos('.') -- getpos returns [0, line, coloff, ...]
	local cursorcoloffset = cursorpos[3]
	local tokens = M.tokenize(content)
	-- find the matching token under current pos
	local curcoloffset = 1 -- current starts at 1
	local current_token = ""
    local nextoffset = 1

    -- Find which token cursor is highlighting by comparing offsets ?
    -- compute the size of the token
	for i, tok in pairs(tokens) do
		nextoffset = curcoloffset + vim.fn.strlen(tok[1])
        logger.info(string.format("Round %d, inspecting token %s. Comparing cursor offset %d with nextoffset %d", i, tok[1], cursorcoloffset, nextoffset))
		if cursorcoloffset < nextoffset then
            current_token = tok[1]
			break
        else
            curcoloffset = nextoffset
            current_token = tok[1]
		end
	end

	return current_token, cursorpos[2], curcoloffset, vim.fn.strlen(current_token)
end

return M
