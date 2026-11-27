describe("download command #mock", function()
	local download
	local original_fetch
	local requested_urls

	setup(function()
		require("rikai.config")
		require("rikai.commands").create_command()
	end)

	before_each(function()
		download = require("rikai.download")
		original_fetch = download.fetch
		requested_urls = {}
		download.fetch = function(url, _outpath)
			requested_urls[#requested_urls + 1] = url
			return "mock download failure"
		end
	end)

	after_each(function()
		download.fetch = original_fetch
	end)

	teardown(function()
		vim.api.nvim_del_user_command("Rikai")
	end)

	it("downloads only the requested dictionary", function()
		local dictionaries = {
			kanjidb = "https://github.com/odrevet/edict_database/releases/download/v0.0.7/sqlite_kanji_en.zip",
			jmdictdb = "https://github.com/odrevet/edict_database/releases/download/v0.0.7/sqlite_expression_eng.zip",
			kanjivg = "https://github.com/KanjiVG/kanjivg/releases/download/r20250816/kanjivg-20250816-all.zip",
		}

		for name, url in pairs(dictionaries) do
			requested_urls = {}
			vim.cmd("Rikai download " .. name)
			assert.are.same({ url }, requested_urls)
		end
	end)

	it("downloads all dictionaries when none is specified", function()
		vim.cmd("Rikai download")

		assert.are.equal(3, #requested_urls)
	end)
end)

describe("download command #online", function()
	setup(function()
		require("rikai.config")
		require("rikai.commands").create_command()
	end)

	teardown(function()
		vim.api.nvim_del_user_command("Rikai")
	end)

	it("runs :Rikai download", function()
		vim.cmd("Rikai download")
	end)
end)
