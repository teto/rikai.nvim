describe("configuration defaults", function()
	local previous_config, previous_global

	before_each(function()
		previous_config = package.loaded["rikai.config"]
		previous_global = vim.g.rikai
		package.loaded["rikai.config"] = nil
	end)

	after_each(function()
		package.loaded["rikai.config"] = previous_config
		vim.g.rikai = previous_global
	end)

	it("populates dictionary paths without user configuration", function()
		vim.g.rikai = nil
		local config = require("rikai.config")
		local defaults = require("rikai.config.default")
		assert.same(defaults.dictionaries, config.dictionaries)
		assert.same(defaults.dictionaries, vim.g.rikai.dictionaries)
	end)

	it("preserves a dictionary override and fills in missing paths", function()
		vim.g.rikai = { dictionaries = { kanjidb = "/tmp/custom-kanji.db" } }
		local config = require("rikai.config")
		local defaults = require("rikai.config.default")
		assert.equals("/tmp/custom-kanji.db", config.dictionaries.kanjidb)
		assert.equals(defaults.dictionaries.jmdictdb, vim.g.rikai.dictionaries.jmdictdb)
		assert.equals(defaults.dictionaries.kanjivg, vim.g.rikai.dictionaries.kanjivg)
	end)
end)
