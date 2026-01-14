--- interface that can work with several tokenizers.
--- Available:
--- - sudachi
local config = require("rikai.config")
local utils = require("rikai.utils")

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
	local exists, tokenizer = pcall(require, "rikai.tokenizers." .. config.tokenizer)
	if not exists then
		vim.notify("Could not load the " .. config.tokenizer)
	end
	local tokens = utils.timeit("tokenize", tokenizer.tokenize, content, ...)
	return tokens
end

---@return string
function M.get_current_token()
	-- vim.fn.getcurpos (byte) vs getcursorcharpos (index)
	-- Get the content of the current line in the buffer
	local word = vim.fn.expand("<cword>")

	-- TODO use matchaddpos({group},
	-- [{lnum}, {col}, {off}, {curswant}]
	local cursorpos = vim.fn.getcursorcharpos()
	local curcharindex = cursorpos[3]
	local tokens = M.tokenize(word)
	-- find the matching token under current pos
	local charindex = 0
	local current_token = ""
	for _i, tok in pairs(tokens) do
		current_token = tok[1]
		charindex = vim.fn.strwidth(current_token) + charindex
		if curcharindex < charindex then
			break
		end
	end

	return current_token
end

return M
