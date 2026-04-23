local logger = require("rikai.log")
-- local config = require'rikai.config'

local dict_version = "v0.0.5"

local kanji_url = "https://github.com/odrevet/edict_database/releases/download/" .. dict_version .. "/kanji.zip"
local expression_url = "https://github.com/odrevet/edict_database/releases/download/"
	.. dict_version
	.. "/expression.zip"
-- optional, to plot stroke order
local kanjivg_url = "https://github.com/KanjiVG/kanjivg/releases/download/r20250816/kanjivg-20250816-all.zip"

successful = false

local function unzip_file(zip_path, output_dir)
	local cmd = string.format("unzip -u %s -d %s", vim.fn.shellescape(zip_path), vim.fn.shellescape(output_dir))
	logger.info("Running: ", cmd)
	local result = vim.fn.system(cmd)
	return result
end

-- runs in fast context
---@param url string where to install from
---@param dest string where to install file
local function download(url, dest)
	local tmp = os.tmpname() .. ".zip"

	local done, err, res = false, nil, nil

	---@param e string|nil
	---@param r any
	local on_reponse = function(e, r)
		err, res, done = e, r, true
	end

	local _job = vim.net.request(url, {
		outpath = tmp,
		verbose = true,
		-- retry = 3
	}, on_reponse)

	local timeout_ms = 360 * 1000
	vim.wait(timeout_ms, function()
		logger.debug("Checking if download is finished")
		return done
	end, 200, true)

	local status = res and res.status or 0
	-- local ok = (not err) and ((status >= 200 and status < 300) or (status == 0 and file_ok(outpath)))
	-- return not not ok, (status ~= 0 and status or nil), err

	local msg = "placeholder message"
	if err or status ~= 0 then
		-- set ERROR level
		msg = "Downloading rikai DB failed:\n" .. err
		logger.error(msg)
		print("Downloading rikai DB failed:\n" .. err)
	else
		msg = "Finished downloading rikai dictionary."
		logger.info(msg)

		successful = true
		-- vim.notify("Finished downloading rikai dictionary.")
	end

	if not successful then
		vim.notify("Failed to download " .. url)
		return
	end

	-- expect output dir rather
	local out_dir = vim.fn.stdpath("data") .. "/rikai"
	unzip_file(tmp, out_dir)
end

-- todo one should be able to download only one of the dicts
---@param _args any
function cmd_download(_args)
	download(kanji_url, vim.g.rikai.dictionaries.kanjidb)
	download(expression_url, vim.g.rikai.dictionaries.jmdictdb)

	local cfg = vim.g.rikai
	if cfg.popup_options.render_images then
		download(kanjivg_url, vim.g.rikai.dictionaries.kanjivg)
	end
end

return cmd_download
