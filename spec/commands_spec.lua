-- local utils = require('rikai.classifier')
-- local kanji = require('rikai.kanji')
-- local utf8 = require'utf8'
describe("is_japanese function", function()
	-- copy the dicts to xdg
	setup(function()
		-- error('failing a setup method')
		-- TODO download symlink

		-- we need to prepare the environment without
		-- https://github.com/lumen-oss/lux/discussions/1484#discussioncomment-16807929
		local dictFolder = os.getenv("RIKAI_DICTIONARIES_FOLDER")
		-- todo adjust folder
		vim.fn.system([[
        	
            mkdir -p .lux/5.1/test_dependencies/5.1/home/xdg/local/share/nvim/rikai
            ]])

		vim.fn.system([[
        ln -s ]] .. dictFolder .. [[/* .lux/5.1/test_dependencies/5.1/home/xdg/local/share/nvim/rikai ]])

		vim.g.rikai = vim.tbl_deep_extend("force", vim.g.rikai or {}, {
			popup_options = {
				render_images = false,
			},
		})

		local config = require("rikai.config")
		config.popup_options.render_images = false

		if vim.fn.exists(":Rikai") == 0 then
			vim.cmd.source(vim.fn.fnameescape(vim.fn.getcwd() .. "/plugin/rikai.lua"))
		end

		-- print(vim.g.rikai.dictionaries.kanjidb)
	end)

	it("lookup specified word", function()
		-- check files were created
		-- assert.is_true(utils.is_hiragana(vim.fn.char2nr("あ")))
		-- assert.is_true(utils.is_japanese("あ"))
		vim.cmd("Rikai lookup 消")
	end)

	it("lookup current word", function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "最初" })
		vim.api.nvim_win_set_cursor(0, { 1, 1 })
		vim.cmd("Rikai lookup ")
	end)

	it("lookup specified word", function()
		vim.cmd("Rikai lookup 最初")
	end)

	-- lookup visual mode
	it("lookup specified word", function()
		vim.cmd("Rikai lookup 最初")
	end)
end)
