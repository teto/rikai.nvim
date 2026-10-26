describe("lookup command", function()
	local lookup
	local popup_lookup
	local captured_token

	setup(function()
		require("rikai.config")
		lookup = require("rikai.commands.lookup")
		popup_lookup = lookup.popup_lookup
		lookup.popup_lookup = function(token)
			captured_token = token
		end
		require("rikai.commands").create_command()
	end)

	before_each(function()
		captured_token = nil
		vim.cmd("enew!")
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "起見" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })
	end)

	after_each(function()
		vim.cmd.normal({ args = { "\027" }, bang = true })
	end)

	teardown(function()
		lookup.popup_lookup = popup_lookup
		vim.api.nvim_del_user_command("Rikai")
	end)

	it("passes 起 to the popup without tokenization", function()
		vim.cmd("Rikai lookup 起")
		assert.are.same({ surface = "起", normal_form = "起" }, captured_token)
	end)

	it("looks up the active visual selection without an Ex range", function()
		vim.api.nvim_win_set_cursor(0, { 1, 3 })
		vim.cmd.normal({ args = { "v" }, bang = true })
		vim.cmd("Rikai lookup ")
		assert.are.same({ surface = "見", normal_form = "見" }, captured_token)
	end)

	it("looks up a visual selection passed as an Ex range", function()
		vim.api.nvim_win_set_cursor(0, { 1, 3 })
		vim.cmd.normal({ args = { "v\027" }, bang = true })
		vim.cmd("'<,'>Rikai lookup ")
		assert.are.same({ surface = "見", normal_form = "見" }, captured_token)
	end)

	it("prefers explicit text over the active selection", function()
		vim.cmd.normal({ args = { "v" }, bang = true })
		vim.cmd("Rikai lookup 見")
		assert.are.same({ surface = "見", normal_form = "見" }, captured_token)
	end)
end)
