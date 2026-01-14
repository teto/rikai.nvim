-- Import the module containing the is_japanese function
local utils = require("rikai.classifier")
-- local kanji = require('rikai.kanji')
-- local utf8 = require'utf8'

describe("is_japanese function", function()
	it("should return true for a Hiragana character", function()
		assert.is_true(utils.is_hiragana(vim.fn.char2nr("あ")))
		assert.is_true(utils.is_japanese("あ"))
	end)

	it("should return true for a Katakana character", function()
		assert.is_true(utils.is_katakana(vim.fn.char2nr("カ")))
		-- assert.is_true(utils.is_japanese("カ"))
	end)
	--
	-- it("should return true for a Common Kanji character", function()
	--     assert.is_true(utils.is_common_kanji("漢"))
	--     assert.is_true(utils.is_common_kanji("理"))
	--     assert.is_true(utils.is_japanese("漢"))
	--
	-- end)

	-- it("should return true for a Half-width Katakana character", function()
	--     assert.is_true(utils.is_japanese("日高"))
	--     assert.is_true(utils.is_japanese("ｶ"))
	-- end)
	--
	-- it("should return false for a non-Japanese character", function()
	--     assert.is_false(utils.is_japanese("A"))  -- Latin
	--     assert.is_false(utils.is_japanese("3"))  -- Digit
	--     assert.is_false(utils.is_japanese("@"))  -- Special character
	-- end)
end)

-- describe("lengths", function()
--     it("should return true for a Half-width Katakana character", function()
--         assert.is_true(utf8.codes("たたｶ"))
--     end)
-- end)
