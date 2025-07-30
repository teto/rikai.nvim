
local M = {}

---@enum rikai.types.CharacterType
M.CharacterType = {
    OTHER    = 1;
    -- ASCII    = 2;
    KATAKANA = 3;
    HIRAGANA = 4;
    KANJI    = 5;

    -- TODO add __tostring ?
}

---@param e rikai.types.CharacterType
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


-- rename into lexicon type ?
-- maps to sudachi's 'LexiconEntry' ?
---@enum rikai.types.LexiconType part of speech tag
M.LexiconType = {
    -- names
    NAME = 1,
    PROPER_NOUN = 2,


    PARTICLE = 10,
    AUXILIARY = 11,
}



return M
