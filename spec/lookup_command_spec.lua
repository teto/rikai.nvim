describe("single-character lookup command", function()
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

	teardown(function()
		lookup.popup_lookup = popup_lookup
		vim.api.nvim_del_user_command("Rikai")
	end)

	it("passes 起 to the popup without tokenization", function()
		vim.cmd("Rikai lookup 起")
		assert.are.same({ surface = "起", normal_form = "起" }, captured_token)
	end)
end)
