-- 
local M = {}
local kanji = require 'rikai.kanji'

M.katakana_range = {0x30A0, 0x30FF}

function M.is_hiragana(code)
    -- 12352 - 12447
    return code >= 0x3040 and code <= 0x309F
end

function M.is_katakana(code)
    return code >= 0x30A0 and code <= 0x30FF
end

function M.is_halfwidth_katakana(code)
    return code >= 0xFF66 and code <= 0xFF9F
end

---@return boolean
function M.is_japanese(text)
    -- Check if the input is valid
    if type(text) ~= 'string' or #text == 0 then
        print("first false")
        return false
    end

    -- Get the first character
    -- local character = text:sub(1, 1)
    -- false/ check iconv
    local mb_char = M.get_first_multibyte_char(text)
    local code = vim.fn.char2nr(mb_char)

    -- Check if the character is within the Japanese Unicode ranges
    if M.is_hiragana(code) or
       M.is_katakana(code) or
       kanji.is_common_kanji(code) or
       M.is_halfwidth_katakana(code) then
        return true
    end

    return false
end

-- hacky function to be replaced by utf8.lua 
-- https://github.com/uga-rosa/utf8.nvim?tab=readme-ov-file
function M.get_first_multibyte_char(input_str)
    -- Pattern to match UTF-8 multibyte characters
    local multibyte_pattern = "[%z\1-\127\194-\244][\128-\191]*"
    -- Find and return the first multibyte character
    for char in input_str:gmatch(multibyte_pattern) do
        if #char > 1 then
            return char
        end
    end
    return nil -- Return nil if no multibyte character is found
end

return M
