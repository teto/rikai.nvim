-- local utils = require('rikai.providers.sqlite')
local db = require("rikai.providers.sqlite")

describe("edict sqlite queries", function()
	it("kanji simple request", function()
		local kanji = "降"
		-- db.lookup_kanji()
		local results = db.lookup_kanji(kanji)
		print(results)
		-- assert.is_equal(utils.jisho_link(kanji, true), "https://jisho.org/search/降"..kanji)
	end)
end)
