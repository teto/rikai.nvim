
local utils = require('rikai.classifier')
-- local kanji = require('rikai.kanji')
local utf8 = require'utf8'

describe("is_japanese function", function()

    it("", function()
        -- check files were created
        -- assert.is_true(utils.is_hiragana(vim.fn.char2nr("あ")))
        -- assert.is_true(utils.is_japanese("あ"))
        vim.cmd("Rikai lookup 消")
    end)

    it("lookup current word", function()
            vim.cmd("Rikai lookup ")
    end)

end)
