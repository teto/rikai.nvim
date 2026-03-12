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
		"rsvg-convert",
		"-w",
		"1024",
		"-h",
		"768",
		input_filename,
		"-o",
		output_filename,
	}

	-- join(' ')
	logger.debug("Running ", cmd_generate_image)
	local obj = vim.system(cmd_generate_image, {
		timeout = 3000,
	}):wait()
	if obj.code ~= 0 then
		vim.notify("Could not generate image for kanji:\n" .. obj.stderr, vim.log.levels.ERROR)
	end

	return output_filename
end

return M
