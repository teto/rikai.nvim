local logger = require("rikai.log")
local config = require("rikai.config")

local dict_version = "v0.0.7"
local kanjivg_version = "20250816"

local kanji_url = "https://github.com/odrevet/edict_database/releases/download/"
	.. dict_version
	.. "/sqlite_kanji_en.zip"
local expression_url = "https://github.com/odrevet/edict_database/releases/download/"
	.. dict_version
	.. "/sqlite_expression_eng.zip"
-- optional, to plot stroke order
---@type string
local kanjivg_url = "https://github.com/KanjiVG/kanjivg/releases/download/r"
	.. kanjivg_version
	.. "/kanjivg-"
	.. kanjivg_version
	.. "-all.zip"

local function unzip_file(zip_path, output_dir)
	local cmd = string.format("unzip -u %s -d %s", vim.fn.shellescape(zip_path), vim.fn.shellescape(output_dir))
	logger:info("Running: ", cmd)
	local result = vim.fn.system(cmd)
	return result
end

-- runs in fast context
---@param name string dict name, used to notify user
---@param url string where to install from
---@param dest string where to install file
local function download(name, url, dest)
	local tmp = os.tmpname() .. ".zip"

	local done, err, res = false, nil, nil
	vim.notify("Downloading rikai dictionary [" .. name .. "], please wait...")

	---@param e string|nil
	---@param r any
	local on_reponse = function(e, r)
		err, res, done = e, r, true
	end

	local _job = vim.net.request(url, {
		outpath = tmp,
		verbose = true,
	}, on_reponse)

	local timeout_ms = 360 * 1000
	vim.wait(timeout_ms, function()
		logger:debug("Checking if download is finished")
		return done
	end, 200, true)

	local status = res and res.status or 0
	-- local ok = (not err) and ((status >= 200 and status < 300) or (status == 0 and file_ok(outpath)))
	-- return not not ok, (status ~= 0 and status or nil), err

	local successful = not err and status == 0
	if err or status ~= 0 then
		local msg = "Downloading rikai DB failed:\n" .. (err or ("HTTP status " .. status))
		logger:error(msg)
		vim.notify(msg)
	else
		logger:info("Finished downloading rikai dictionary.")
		vim.notify("Finished downloading [" .. name .. "] dictionary.")
	end

	if not successful then
		vim.notify("Failed to download " .. url)
		return
	end

	-- expect output dir rather
	unzip_file(tmp, dest)
end

local dictionaries = {
	{
		key = "kanjidb",
		name = "edict-kanji",
		url = kanji_url,
		destination = function()
			return vim.fs.dirname(config.dictionaries.kanjidb)
		end,
	},
	{
		key = "jmdictdb",
		name = "edict-expr",
		url = expression_url,
		destination = function()
			return vim.fs.dirname(config.dictionaries.jmdictdb)
		end,
	},
	{
		key = "kanjivg",
		name = "kanjivg",
		url = kanjivg_url,
		destination = function()
			return vim.fn.stdpath("data") .. "/rikai"
		end,
	},
}

---@param requested_name string|nil
local function cmd_download(requested_name)
	for _, dict in ipairs(dictionaries) do
		if requested_name == nil or requested_name == dict.key then
			download(dict.name, dict.url, dict.destination())
		end
	end
end

return cmd_download
