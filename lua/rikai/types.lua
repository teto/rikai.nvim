
local M = {}

---@enum rikai.CharacterType
M.CharacterType = {
    OTHER    = 1;
    -- ASCII    = 2;
    KATAKANA = 3;
    HIRAGANA = 4;
    KANJI    = 5;

    -- TODO add __tostring ?
}

---@param e rikai.CharacterType
---@return string The name of CharacterType
function M.as_str(e)
    local map = {
        [M.CharacterType.OTHER] = "other";
        [M.CharacterType.KATAKANA] = "katakana";
        [M.CharacterType.HIRAGANA] = "hiragana";
        [M.CharacterType.KANJI] = "kanji";
    }
    return map[e]
end



return M
