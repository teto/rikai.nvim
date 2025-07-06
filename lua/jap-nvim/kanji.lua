local M = {}

---@class KanjiDesc
---@field id string
---@field jlpt number
---@field freq number frequency
---@field kun_reading string
---@field on_reading string
---@field meanings string

---@param res KanjiDesc 
---@return table (as expected by 'open_floating_preview')
function M.format_kanji(res)
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
        res["id"] .. " (jlpt "..res["jlpt"] .. ")",
        "kun reading: ".. res["kun_reading"],
        "on reading: ".. res["on_reading"],
        "",
        res["meanings"],
        M.jisho_link(res["id"])
    }

    return lines
end

---@return string (link towards jisho.org)
function M.jisho_link(expr)
    local url = "https://jisho.org/search/"..expr
    return url
end

return M
