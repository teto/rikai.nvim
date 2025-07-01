local M = {}

-- 多

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
    local str =
        res["id"] .. [[ (jlpt ]]..res["jlpt"] ..[[
        kun reading: ]].. res["kun_reading"] .. [[
        on reading: ]].. res["on_reading"] .. [[
        meanings: ]] .. res["meanings"]..[[
        ]]
    return str
end

return M
