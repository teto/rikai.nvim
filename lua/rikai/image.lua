--- Collection of functions to generate kanji images
local M = {}

local logger = require("rikai.log")

---
function M.from_magick(token)
	-- TODO get 'Normal' instead as background color
	local output_filename = "output.png"
	local cmd_generate_image

	cmd_generate_image = {
		"magick",
		"-background",
		"transparent",
		"-fill",
		"white",
		"-pointsize",
		"24",
		"label:" .. token,
		output_filename,
	}
	local obj = vim.system(cmd_generate_image, {
		timeout = 3000,
	}):wait()

	if obj.code ~= 0 then
		vim.notify("Could not generate image for kanji:\n" .. obj.stderr, vim.log.levels.ERROR)
	end

	return output_filename
end

function M.from_kanjivg(token)
	-- TODO get 'Normal' instead as background color
	local kanjivg_dir = vim.fn.stdpath("data") .. "/rikai/kanjivg"

	local cmd_generate_image
	local unicode_value = vim.fn.char2nr(token)
	-- respect kanjivg format
	local hex_value = string.format("%05x", unicode_value)
	local output_filename = vim.fn.stdpath("cache") .. "/rikai/" .. hex_value .. ".png"

	local input_filename = vim.fs.joinpath(kanjivg_dir, hex_value .. ".svg")

	cmd_generate_image = {
		"rsvg-convert", -- available in "librsvg"
		"-w",
		"512",
		"-h",
		"512",
		input_filename,
		"-o",
		output_filename,
	}

	logger.debug("Running ", cmd_generate_image)
	local has_job, obj_or_err = pcall(vim.system, cmd_generate_image, {
		-- timeout = 3000,
	})
	print(has_job)
	if not has_job then
		logger.error("Could not generate image for kanji:\n" .. obj_or_err, vim.log.levels.ERROR)
	else
		---@diagnostic disable-next-line: need-check-nil
		local hdl = obj_or_err
		---@diagnostic disable-next-line: need-check-nil
		-- in milliseconds
		local res = hdl:wait(3000)
		if res.code ~= 0 then
			logger.error("Could not generate image for kanji:\n" .. res.stderr, vim.log.levels.ERROR)
		end
	end

	return output_filename
end

return M
