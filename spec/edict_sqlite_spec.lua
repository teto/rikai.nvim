-- local utils = require('rikai.providers.sqlite')

describe("edict sqlite queries", function()
	local db
	local dict_folder = os.getenv("RIKAI_DICTIONARIES_FOLDER")

	if not dict_folder then
		pending("kanji simple request (set RIKAI_DICTIONARIES_FOLDER to run this integration test)", function() end)
		return
	end

	local kanjidb = vim.fs.joinpath(dict_folder, "kanji.db")
	local jmdictdb = vim.fs.joinpath(dict_folder, "expression.db")

	if vim.fn.filereadable(kanjidb) ~= 1 then
		pending(
			"kanji simple request (RIKAI_DICTIONARIES_FOLDER does not contain kanji.db: " .. kanjidb .. ")",
			function() end
		)
		return
	end

	if vim.fn.filereadable(jmdictdb) ~= 1 then
		pending(
			"kanji simple request (RIKAI_DICTIONARIES_FOLDER does not contain expression.db: " .. jmdictdb .. ")",
			function() end
		)
		return
	end

	setup(function()
		vim.g.rikai = vim.tbl_deep_extend("force", vim.g.rikai or {}, {
			dictionaries = {
				kanjidb = kanjidb,
				jmdictdb = jmdictdb,
			},
		})

		db = require("rikai.providers.sqlite")
	end)

	it("kanji simple request", function()
		local kanji = "降"
		-- db.lookup_kanji()
		local results = db.lookup_kanji(kanji)
		assert.is_equal(#results, 1)
	end)
end)
