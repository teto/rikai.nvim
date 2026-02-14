--- Collection of functions to generate kanji images
local M = {}

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
            local output_filename = 'output.png'
            local kanjivg = vim.fn.stdpath("data") .. "/rikai/kanjivg"

            local cmd_generate_image
            local input_filename = vim.fs.joinpath(kanjivg, "0f9af.svg")

            cmd_generate_image = {  
                "rsvg-convert",  "-w", "1024", "-h", "768", input_filename,
                "-o", output_filename }

            local obj = vim.system(cmd_generate_image, {
                timeout = 3000,
            }):wait()
            if obj.code ~= 0 then
                vim.notify("Could not generate image for kanji:\n"..obj.stderr , vim.log.levels.ERROR)
            end
            
			return output_filename
		end

return M
