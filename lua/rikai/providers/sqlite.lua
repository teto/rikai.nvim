--[[
Returns values based on an sqlite db generated by https://github.com/odrevet/edict_database
The db itself is generated via edict
--]]

-- (or sqlite3 = require('lsqlite3complete')) 
local sqlite3 = require('lsqlite3')
local config = require('rikai.config')
local logger = require'rikai.log'

local jmdictdb = config.jmdictdb
local M = {}

function M.kanji_sql(kanji)
    return [[
SELECT character.*, 
GROUP_CONCAT(DISTINCT character_radical.id_radical) as radicals, 
GROUP_CONCAT(DISTINCT on_yomi.reading) AS on_reading, 
GROUP_CONCAT(DISTINCT kun_yomi.reading) AS kun_reading, 
GROUP_CONCAT(DISTINCT meaning.content) AS meanings 
FROM character 
LEFT JOIN character_radical ON character.id = character_radical.id_character
LEFT JOIN on_yomi ON character.id = on_yomi.id_character
LEFT JOIN kun_yomi ON kun_yomi.id_character = character.id 
LEFT JOIN meaning ON meaning.id_character = character.id 
WHERE character.id="]]..kanji..[[";
]]
end


function M.query_kanji_get_radicals(kanji)
    return [[
    SELECT radical.* 
    FROM radical 
    JOIN character_radical ON character_radical.id_radical = radical.id 
    WHERE character_radical.id_character="]]..kanji..[[";
    ]]
end

-- リョクトウ
-- look at the jmdict DTD  to understand the different value
-- basically if we are dealing with a kanji somewhere in expression, we should match against keb, and reb otherwise ?
function M.query_expr(expr)
    return [[SELECT
  k_ele.id k_ele_id,
  entry.id AS entry_id,
  sense.id AS sense_id,
  (
    SELECT
      GROUP_CONCAT(IFNULL(keb || ':', '') || reb)
    FROM
      r_ele r_ele_sub
      LEFT JOIN r_ele_k_ele ON r_ele_k_ele.id_r_ele = r_ele_sub.id
      LEFT JOIN k_ele k_ele_sub ON r_ele_k_ele.id_k_ele = k_ele_sub.id
    WHERE
      r_ele_sub.id_entry = entry.id
  ) keb_reb_group,
  GROUP_CONCAT(DISTINCT gloss.content) gloss_group,
  GROUP_CONCAT(DISTINCT pos.name) pos_group,
  GROUP_CONCAT(DISTINCT dial.name) dial_group,
  GROUP_CONCAT(DISTINCT misc.name) misc_group,
  GROUP_CONCAT(DISTINCT field.name) field_group
FROM
  entry
  JOIN sense ON sense.id_entry = entry.id
  JOIN gloss ON gloss.id_sense = sense.id
  LEFT JOIN sense_pos ON sense.id = sense_pos.id_sense
  LEFT JOIN pos ON sense_pos.id_pos = pos.id
  LEFT JOIN sense_dial ON sense.id = sense_dial.id_sense
  LEFT JOIN dial ON sense_dial.id_dial = dial.id
  LEFT JOIN sense_misc ON sense.id = sense_misc.id_sense
  LEFT JOIN misc ON sense_misc.id_misc = misc.id
  LEFT JOIN sense_field ON sense.id = sense_field.id_sense
  LEFT JOIN field ON sense_field.id_field = field.id
  JOIN r_ele ON entry.id = r_ele.id_entry
  LEFT JOIN k_ele ON entry.id = k_ele.id_entry
WHERE
  keb = ']]..expr..[['
GROUP BY
  sense.id;
  ]];
end

--- how to j
---@return table
function M.lookup_kanji(kanji)

    logger.info("Opening " .. config.kanjidb)
    local con, errmsg, _errcode = sqlite3.open(config.kanjidb, sqlite3.OPEN_READWRITE)
    local res = {}

    local req = M.kanji_sql(kanji)

    if not con then
        vim.notify(string.format("rikai: could not open %s:\n%s", config.kanjidb, errmsg))
    else
        logger.info("Looking up kanji: ".. tostring(kanji))
        for a in con:nrows(req) do
            res [#res + 1] = a
        end
    end

    con:close()
    return res
end

-- lookup several kanjis
-- 押す works for the "simple" db if you need to test
-- function M.lookup_expression(word)
--     print("Opening " .. config.jmdictdb)
--     local con = sqlite3.open(config.jmdictdb)
--     local res = {}
--     -- TODO look wiki for expression
--
-- end


function M.lookup_expr(word)

    logger.info("Opening " .. jmdictdb)
    local db, errmsg, _errcode = sqlite3.open(jmdictdb, sqlite3.OPEN_READWRITE)
    local res = {}

    local req = M.query_expr(word)

    if not db then
        vim.notify(string.format("rikai: could not open %s:\n%s", jmdictdb, errmsg))
    else
        logger.info("Looking up expr ".. tostring(word))
        for a in db:nrows(req) do
            -- vim.print(a)
            res [#res + 1] = a
        end
    end

    db:close()
    return res
end


return M

