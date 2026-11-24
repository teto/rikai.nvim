describe("download command #mock", function()
	local original_request
	local request_count

	setup(function()
		require("rikai.config")
		require("rikai.commands").create_command()
	end)

	before_each(function()
		original_request = vim.net.request
		request_count = 0
		vim.net.request = function(_url, _options, callback)
			request_count = request_count + 1
			callback("mock download failure", nil)
			return 0
		end
	end)

	after_each(function()
		vim.net.request = original_request
	end)

	teardown(function()
		vim.api.nvim_del_user_command("Rikai")
	end)

	it("runs :Rikai download", function()
		vim.cmd("Rikai download kanjidb")

		assert.are.equal(2, request_count)
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
