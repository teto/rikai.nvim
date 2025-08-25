
-- created just for convenience
-- vim.api.nvim_create_user_command('RikaiDownload', 

function download(_args)
    -- print("downloading dicts...")
    local kanji_url = "https://github.com/odrevet/edict_database/releases/download/v0.0.2/kanji.zip"
    local expression_url = "https://github.com/odrevet/edict_database/releases/download/v0.0.2/expression.zip"
    local furigana_url = "https://github.com/Doublevil/JmdictFurigana/releases/download/2.3.1%2B2024-11-25/JmdictFurigana.json.tar.gz"
    local cb = function (err, _response)
            if err then
                -- set ERROR level
                -- vim.notify("Downloading rikai DB failed:\n"..err)
                print("Downloading rikai DB failed:\n"..err)
            else
                -- vim.notify("Finished downloading rikai dictionary.")
                print("Finished downloading rikai dictionary.")
            end

        end

    vim.net.request(kanji_url, {
        outpath = vim.g.rikai.kanjidb,
    }, cb)
    vim.net.request(expression_url, {
        outpath = vim.g.rikai.jmdictdb,
    }, cb)
    -- TODO uncompress ?
    vim.net.request(expression_url, {
        outpath = vim.fn.stdpath("data").."/rikai/furigana.json",
    }, cb)

end


return download
