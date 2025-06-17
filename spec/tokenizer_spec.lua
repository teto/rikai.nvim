-- This is a placeholder for tokenizer_spec tests.
-- You can add your tests here to validate the functionality of your tokenizer module.

-- Import the module containing the is_katakana function
local utils = require('jap-nvim.utils')

-- A simple test suite for the is_katakana function

describe("is_katakana function", function()
    it("should return true for a Katakana character", function()
        assert.is_true(utils.is_katakana(vim.fn.char2nr("カ")))
    end)

    it("should return false for a non-Katakana character", function()
        assert.is_false(utils.is_katakana(vim.fn.char2nr("あ")))  -- Hiragana
        assert.is_false(utils.is_katakana(vim.fn.char2nr("あ")))  -- Hiragana
        assert.is_false(utils.is_katakana(vim.fn.char2nr("漢")))  -- Kanji
        assert.is_false(utils.is_katakana(vim.fn.char2nr("A")))  -- Latin
    end)
end)

