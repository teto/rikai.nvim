local utils = require 'rikai.utils'
local query = require 'rikai.providers.sqlite'
local config = require 'rikai.config'
local logger = require'rikai.log'

local M = {}


---@class KanjiDesc
---@field id string
---@field jlpt number
---@field freq number frequency
---@field kun_reading string
---@field on_reading string
---@field meanings string


--- Get radicals associated with kanji
---@param kanji string 
function M.format_radicals(kanji)
    logger.debug("Looking up radicals for kanji : ".. tostring(kanji))
    local res = {}

    local req = query.query_kanji_get_radicals(kanji)
    local con = query.get_db_handle(config.kanjidb)

    assert (con)
    for a in con:nrows(req) do
        res [#res + 1] = a
    end
    return res
end



---@param res KanjiDesc 
---@param radicals table 
---@return table (as expected by 'open_floating_preview')
function M.format_kanji(res, radicals)
-- {
--   freq = 139,
--   id = "多",
--   jlpt = 4,
--   kun_reading = "おお.い,まさ.に,まさ.る",
--   meanings = "frequent,many,much",
--   on_reading = "タ",
--   radicals = "夕",
--   stroke_count = 6
-- }

    local lines = {
        res["id"] .. " (jlpt "..(res["jlpt"] or "unknown") .. ")",
        "freq: ".. (res["freq"] or "None"),
        "kun reading: ".. (res["kun_reading"] or "None"),
        "on reading: ".. res["on_reading"],
        "Stroke count: ".. (res["stroke_count"] or "unknown"),
        "",
        res["meanings"],
        "",
        "Radicals:",
    }
    for _i, radical in pairs(radicals) do
        results = query.lookup_kanji(radical["id"])
        -- results[1]["meanings"])
        if #results > 0 then
            local radical_line = radical["id"] .. ": " .. (results[1]["meanings"] or "none")
            table.insert(lines, radical_line)
        end
    end

    table.insert(lines, "")
    table.insert(lines, utils.jisho_link(res["id"], true))
    return lines
end

return M
