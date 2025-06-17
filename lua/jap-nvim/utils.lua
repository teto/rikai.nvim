
local M = {}


function M.is_hiragana(code)
    return code >= 0x3040 and code <= 0x309F
end

function M.is_katakana(code)
    return code >= 0x30A0 and code <= 0x30FF
end

function M.is_common_kanji(code)
    return code >= 0x4E00 and code <= 0x9FFF
end

function M.is_halfwidth_katakana(code)
    return code >= 0xFF66 and code <= 0xFF9F
end

function M.is_japanese(text)
    -- Check if the input is valid
    if type(text) ~= 'string' or #text == 0 then
        return false
    end

    -- Get the first character
    local character = text:sub(1, 1)
    local code = vim.fn.char2nr(character)

    -- Check if the character is within the Japanese Unicode ranges
    if M.is_hiragana(code) or
       M.is_katakana(code) or
       M.is_common_kanji(code) or
       M.is_halfwidth_katakana(code) then
        return true
    end

    return false
end

return M
