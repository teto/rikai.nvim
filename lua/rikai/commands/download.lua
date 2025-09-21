local logger = require'rikai.log'
-- local config = require'rikai.config'

-- created just for convenience
-- vim.api.nvim_create_user_command('RikaiDownload', 

local dict_version = "v0.0.5"

local kanji_url = "https://github.com/odrevet/edict_database/releases/download/"..dict_version.."/kanji.zip"
local expression_url = "https://github.com/odrevet/edict_database/releases/download/"..dict_version.."/expression.zip"


---@param _args any
function download(_args)
    -- print("downloading dicts...")
    -- local furigana_url = "https://github.com/Doublevil/JmdictFurigana/releases/download/2.3.1%2B2024-11-25/JmdictFurigana.json.tar.gz"


    -- runs in fast context
    ---@param err string|nil
    ---@param _response any
    local on_reponse = function (err, _response)
        local msg = "placeholder message"
        if err then
            -- set ERROR level
            msg = "Downloading rikai DB failed:\n"..err
            logger.error(msg)
            print("Downloading rikai DB failed:\n"..err)
        else
            msg = "Finished downloading rikai dictionary."
            logger.info(msg)
            print(msg)
            -- vim.notify("Finished downloading rikai dictionary.")
        end

    end

    vim.net.request(kanji_url, {
        outpath = vim.g.rikai.kanjidb,
        verbose = true,
        -- retry = 3
    }, on_reponse)
    vim.net.request(expression_url, {
        outpath = vim.g.rikai.jmdictdb,
    }, on_reponse)
    -- TODO uncompress ?
    vim.net.request(expression_url, {
        outpath = vim.fn.stdpath("data").."/rikai/furigana.json",
    }, on_reponse)

end


return download
