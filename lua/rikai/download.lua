---@mod rikai-download-dict Download dictionaries
---@brief [[
--- Download:
--- - edict as SQL database https://github.com/odrevet/edict_database, for kanji and expression
--- - https://github.com/KanjiVG/kanjivg for kanji image generation
---
--- Requires the `curl` and `unzip` executables.
---@brief ]]
local logger = require("rikai.log")
local config = require("rikai.config")
local platform = require("rikai.platform")

local M = {}

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

---@param zip_path string
---@param output_dir string
---@return rikai.platform.RunResult
function M.unzip_file(zip_path, output_dir)
	local cmd = { "unzip", "-o", "-u", zip_path, "-d", output_dir }
	logger:info("Running: ", cmd)
	return platform.run(cmd)
end

--- Fetch `url` into `outpath`. Overridable (for tests).
---@param url string
---@param outpath string
---@return string|nil error message, nil on success
function M.fetch(url, outpath)
	local res = platform.run({ "curl", "--fail", "--location", "--silent", "--show-error", "-o", outpath, url })
	if res.code ~= 0 then
		return res.stderr ~= "" and res.stderr or ("curl exited with code " .. tostring(res.code))
	end
	return nil
end

---@param name string dict name, used to notify user
---@param url string where to install from
---@param dest string where to install file
---@return boolean success
function M.download(name, url, dest)
	local tmp = os.tmpname() .. ".zip"

	platform.notify("Downloading rikai dictionary [" .. name .. "], please wait...")

	local err = M.fetch(url, tmp)
	if err then
		local msg = "Downloading rikai dictionary [" .. name .. "] from " .. url .. " failed:\n" .. err
		logger:error(msg)
		platform.notify(msg, platform.levels.ERROR)
		os.remove(tmp)
		return false
	end
	logger:info("Finished downloading rikai dictionary.")

	platform.mkdir_p(dest)
	local res = M.unzip_file(tmp, dest)
	os.remove(tmp)
	if res.code ~= 0 then
		local msg = "Could not unzip [" .. name .. "] into " .. dest .. ":\n" .. res.stderr
		logger:error(msg)
		platform.notify(msg, platform.levels.ERROR)
		return false
	end

	platform.notify("Finished downloading [" .. name .. "] dictionary.")
	return true
end

M.dictionaries = {
	{
		key = "kanjidb",
		name = "edict-kanji",
		url = kanji_url,
		destination = function()
			return platform.dirname(config.dictionaries.kanjidb)
		end,
	},
	{
		key = "jmdictdb",
		name = "edict-expr",
		url = expression_url,
		destination = function()
			return platform.dirname(config.dictionaries.jmdictdb)
		end,
	},
	{
		key = "kanjivg",
		name = "kanjivg",
		url = kanjivg_url,
		destination = function()
			return platform.dirname(config.dictionaries.kanjivg)
		end,
	},
}

--- Download the requested dictionary, or all of them
---@param requested_name string|nil
---@return boolean success
function M.run(requested_name)
	local ok = true
	for _, dict in ipairs(M.dictionaries) do
		if requested_name == nil or requested_name == dict.key then
			ok = M.download(dict.name, dict.url, dict.destination()) and ok
		end
	end
	return ok
end

return M
