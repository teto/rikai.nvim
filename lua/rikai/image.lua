--- Collection of functions to generate kanji images
local M = {}

local logger = require("rikai.log")
local platform = require("rikai.platform")

---@param token string
---@return string path towards the generated image
function M.from_magick(token)
	-- TODO get 'Normal' instead as background color
	local output_filename = "output.png"
	local cmd_generate_image = {
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
	local res = platform.run(cmd_generate_image, { timeout = 3000 })

	if res.code ~= 0 then
		platform.notify("Could not generate image for kanji:\n" .. res.stderr, platform.levels.ERROR)
	end

	return output_filename
end

---Generates an image for the token
---@param kanjivg_dir string
---@param token string
---@return string path towards the generated image
function M.from_kanjivg(kanjivg_dir, token)
	local unicode_value = platform.char2nr(token)
	-- respect kanjivg format
	local hex_value = string.format("%05x", unicode_value)
	local output_dir = platform.stdpath("cache") .. "/rikai"
	local output_filename = output_dir .. "/" .. hex_value .. ".png"

	local input_filename = platform.joinpath(kanjivg_dir, hex_value .. ".svg")

	if platform.file_exists(output_filename) then
		return output_filename
	end
	platform.mkdir_p(output_dir)

	local cmd_generate_image = {
		"rsvg-convert", -- available in "librsvg"
		"-w",
		"512",
		"-h",
		"512",
		input_filename,
		"-o",
		output_filename,
	}

	logger:debug("Running ", cmd_generate_image)
	local res = platform.run(cmd_generate_image, { timeout = 3000 })
	if res.code ~= 0 then
		logger:error("Could not generate image for kanji:\n" .. res.stderr)
	end

	return output_filename
end

return M
