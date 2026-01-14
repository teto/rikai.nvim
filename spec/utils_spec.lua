local utils = require("rikai.utils")

describe("Utils tests", function()
	it("check kanji link", function()
		local kanji = "降"
		assert.is_equal(utils.jisho_link(kanji, true), "https://jisho.org/search/降" .. kanji)
	end)

	it("check expression link", function()
		local kanji = "降"
		assert.is_equal(utils.jisho_link(kanji, false), "https://jisho.org/search/" .. kanji)
	end)
end)
