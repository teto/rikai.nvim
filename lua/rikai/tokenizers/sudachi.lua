---@brief [[
---Using  sudachi-rs tokenizer https://github.com/WorksApplications/sudachi.rs
---
---@brief ]]
---
--  echo 日高屋 | sudachi
-- 日高	名詞,固有名詞,人名,姓,*,*	日高
-- 屋	接尾辞,名詞的,一般,*,*,*	屋
-- EOS
local logger = require("rikai.log")
local types = require("rikai.types")

local M = {}

local function split(text, delimiter)
	local parts = {}
	for part in (text .. delimiter):gmatch("(.-)" .. delimiter) do
		parts[#parts + 1] = part
	end
	return parts
end

local function shell_quote(text)
	return "'" .. text:gsub("'", "'\\''") .. "'"
end

-- local NUMERAL = "数詞"
local PROPER_NOUN = "固有名詞"
local PUNCTUATION = "補助記号"

---Parses the part of speech (POS) of sudachi
---"固有名詞" lastname might appear as a subtype
---so we mix both together
---@param pos_full string The full pos returned by sudachi
---@return rikai.types.LexiconType
function M.lexicon_type(pos_full)
	local pos = split(tostring(pos_full) or "", ",")
	local pos1 = pos[1]
	-- TODO 地名 = > nom de lieu, utiliser un bitfield ?

	if pos[2] == PROPER_NOUN then -- last name
		return types.LexiconType.PROPER_NOUN
	elseif pos1 == "名詞" then
		return types.LexiconType.NAME
	elseif pos1 == "形状詞" then
		return types.LexiconType.NA_ADJECTIVE
	elseif pos1 == "助詞" then
		return types.LexiconType.PARTICLE
	elseif pos1 == "補助記号" then
		return types.LexiconType.AUXILIARY
	elseif pos1 == PUNCTUATION then
		return types.LexiconType.PUNCTUATION
	end

	return types.LexiconType.UNKNOWN
end

---@param  lex_type rikai.types.LexiconType
---@return string
function M.lexicon_to_str(lex_type)
	local map = {
		[types.LexiconType.PUNCTUATION] = "punctuation",
		[types.LexiconType.PROPER_NOUN] = "proper_noun",
		[types.LexiconType.PARTICLE] = "particle",
		[types.LexiconType.NAME] = "name",
	}

	return map[lex_type] or "unknown"
end

---Calls sudachi and returns result in structured format
---Sudachi output format described at:
--- https://github.com/WorksApplications/sudachi.rs?tab=readme-ov-file#output
---
--- Tab separated are:
--- - Surface
--- - Part-of-Speech Tags (comma separated)
--- - Normalized Form
---@param content string
---@param enable_pos_processing boolean enable part of speech processing
---@return TokenizationResult[]
M.tokenize = function(content)
	local tokens = {}

	logger:info(string.format("Tokenizer called with content '%s'", content))
	local command = "printf '%s\\n' " .. shell_quote(content) .. " | sudachi"
	local pipe = io.popen(command, "r")
	if not pipe then
		error("could not start sudachi")
	end
	local output = pipe:read("*a")
	local ok, reason, code = pipe:close()
	if not ok then
		error(string.format("sudachi failed (%s: %s)", tostring(reason), tostring(code)))
	end
	for line in output:gmatch("[^\r\n]+") do
		if line ~= "EOS" then
			local surface, part_of_speech, normal_form = line:match("^([^\t]*)\t([^\t]*)\t(.*)$")
			if surface then
				table.insert(tokens, types.TokenResult(surface, M.lexicon_type(part_of_speech), normal_form))
			end
		end
	end

	logger:debug("Found " .. tostring(#tokens) .. " different tokens")
	return tokens
end

return M
