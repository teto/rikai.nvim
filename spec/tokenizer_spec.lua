-- Import the module containing the is_japanese function
local utils = require('jap-nvim.classifier')

describe("is_japanese function", function()
    it("should return true for a Hiragana character", function()
        assert.is_true(utils.is_japanese("あ"))
    end)

    it("should return true for a Katakana character", function()
        assert.is_true(utils.is_japanese("カ"))
    end)

    it("should return true for a Common Kanji character", function()
        assert.is_true(utils.is_japanese("漢"))
    end)

    it("should return true for a Half-width Katakana character", function()
        assert.is_true(utils.is_japanese("ｶ"))
    end)

    it("should return false for a non-Japanese character", function()
        assert.is_false(utils.is_japanese("A"))  -- Latin
        assert.is_false(utils.is_japanese("3"))  -- Digit
        assert.is_false(utils.is_japanese("@"))  -- Special character
    end)
end)

