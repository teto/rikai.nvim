-- 
local M = {}
-- local kanji = require 'rikai.kanji'
local utf8 = require'utf8'

local types = require'rikai.types'
local logger = require'rikai.log'

M.katakana_range = {0x30A0, 0x30FF}
M.hiragana_range = {0x3040, 0x309F}

---@param code number
---@return rikai.types.CharacterType
function M.chartype(code)
    local ctype = types.CharacterType;
    if M.is_hiragana(code) then
        return ctype.HIRAGANA
    elseif M.is_katakana(code) then
        return ctype.KATAKANA
    elseif M.is_common_kanji(code) then
        return ctype.KANJI
    end

    -- todo distinguish between greek/numeral
    return types.CharacterType.OTHER
end





function M.is_common_kanji(code)
    return code >= 0x4E00 and code <= 0x9FFF
end


function M.is_hiragana(code)
    -- 12352 - 12447
    return code >= M.hiragana_range[1] and code <= M.hiragana_range[2]
end

function M.is_katakana(code)
    return code >= M.katakana_range[1] and code <= M.katakana_range[2]

end

function M.is_halfwidth_katakana(code)
    return code >= 0xFF66 and code <= 0xFF9F
end

---@param text string
---@return boolean
function M.is_japanese(text)
    -- Check if the input is valid
    -- logger.debug("Checking if code "..text)
    assert(text, "Accept sonly string")

    if  #text == 0 then
        logger.debug("Empty string")
        return false
    end

    -- Get the first character
    -- local character = text:sub(1, 1)
    -- false/ check iconv
    -- todo could use utf8 there ?
    -- local mb_char = M.get_first_multibyte_char(text)
    -- local code = vim.fn.char2nr(mb_char)
    -- local code = 0
    -- stop at first one not of the same type ?
    local first_type
    for _pos, code in utf8.codes(text) do
        local chartype = M.chartype(code)
        first_type = chartype
        -- print("chartype", chartype)
        break
    end

    -- logger.debug("Checking if mb_char ["..mb_char.."] is japanese")
    -- logger.debug("Checking if code "..tostring(code).." is japanese")

    -- -- Check if the character is within the Japanese Unicode ranges
    if first_type == types.CharacterType.HIRAGANA or
        first_type == types.CharacterType.KATAKANA or
        first_type == types.CharacterType.KANJI then
        return true
    end

    return false
end


return M
