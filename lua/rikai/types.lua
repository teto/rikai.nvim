local M = {}

---@class TokenizationResult
---@field surface string the string appearing in text
---@field pos string part of speech tag
---@field normal_form string normal form

---Create a named tuple
---@return TokenizationResult
M.TokenResult = function(surface, pos, normal_form)
	return {
		surface = surface,
		pos = pos,
		normal_form = normal_form,
	}
end

---@enum rikai.types.CharacterType
M.CharacterType = {
	OTHER = 1,
	-- ASCII    = 2;
	KATAKANA = 3,
	HIRAGANA = 4,
	KANJI = 5,
	EXPRESSION = 6,

	-- TODO add __tostring ?
}

---@param e rikai.types.CharacterType
---@return string The name of CharacterType
function M.as_str(e)
	local map = {
		[M.CharacterType.OTHER] = "other",
		[M.CharacterType.KATAKANA] = "katakana",
		[M.CharacterType.HIRAGANA] = "hiragana",
		[M.CharacterType.KANJI] = "kanji",
		[M.CharacterType.EXPRESSION] = "expression",
	}
	return map[e]
end

-- add a tostring ?
-- maps to sudachi's 'LexiconEntry' ?
---@enum rikai.types.LexiconType part of speech tag
M.LexiconType = {
	-- names
	NAME = 1,
	PROPER_NOUN = 2,
	NOUN = 3,
	-- "adjectival noun" ?
	NA_ADJECTIVE = 4,
	PARTICLE = 10,
	AUXILIARY = 11,
	PUNCTUATION = 20,
	UNKNOWN = 99,
}

return M
