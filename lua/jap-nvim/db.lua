-- (or sqlite3 = require('lsqlite3complete')) 
local sqlite3 = require('lsqlite3')
local config = require('jap-nvim.config')
local kanji = require('jap-nvim.kanji')

local M = {}


function M.search_kanji()
    print("Opening " .. config.kanjidb)
    local con = sqlite3.open(config.kanjidb)
    print("con", con)
    local res = {}

    local req = kanji.kanji_sql("多")

    for a in con:nrows(req) do
        -- vim.print(a)
        kanji.format_kanji(res)

    end

    con:close()
end
-- dbget_req

return M

