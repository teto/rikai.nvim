local main = require'rikai'
local log = require'rikai.log'

-- local query = require'rikai.providers.sqlite'
-- local config = require'rikai.config'

-- todo add a preview function
local commandOpts = {bang= true, range = true}


-- Create a new highlight group linked to 'Comment'
vim.api.nvim_set_hl(0, 'RikaiVirtualText', { link = 'Comment' })
vim.api.nvim_set_hl(0, 'RikaiNames', { link = 'Search' })



-- get current word translations
vim.api.nvim_create_user_command('RikaiLookup', main.popup_lookup, {
        bang= true, range = true, nargs= "?"
    })
vim.api.nvim_create_user_command('RikaiNames', require'rikai.highlighter'.toggle_names, {
        bang= true, range = true, nargs= "?"
    })
vim.api.nvim_create_user_command('RikaiLog',
        function ()
            print(tostring(log.get_outfile()))
        end,
        commandOpts)

-- vim.api.nvim_create_user_command('JapRo2Ka', , commandOpts)
-- vim.api.nvim_create_user_command('JapRo2Hi', require'rikai'.ro2hi, commandOpts)
-- convert romajis into katakana
vim.api.nvim_create_user_command('RikaiRo2Ka', require'rikai.commands'.ro2ka, {
        bang= true, range = true, nargs= "?"
    })

vim.api.nvim_create_user_command('RikaiTranslate', require'rikai.translation.openai'.translate, {
        bang= true, range = true, nargs= "?"
    })

vim.api.nvim_create_user_command('RikaiFuri', require'rikai.furigana'.add_furigana, {
        bang= true, range = true, nargs= "?"
    })

vim.api.nvim_create_user_command('RikaiToggle', require'rikai.highlighter'.toggle_names, {
        bang= true, range = true, nargs= "?"
    })

-- created just for convenience
vim.api.nvim_create_user_command('RikaiDownload', function()
    print("downloading dicts...")
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

end, { desc = 'Download required dicts' })


-- should depend on filetype and underlying character ?
-- TODO make delay configurable
-- vim.api.nvim_create_autocmd({"CursorHold"}, {
--     pattern = { "*.md", "*.txt", "*.org" },
-- 	desc = "Display translations on hover",
--    -- inspired by "hover"
-- 	callback = popup_lookup
-- })

-- Function to execute on VimLeave
local function on_vim_leave()
    print("Exiting Neovim...")
    -- TODO close db when opened
end

-- Create an autocommand group for exiting
local exit_group = vim.api.nvim_create_augroup("ExitGroup", { clear = true })

-- Autocommand to trigger on VimLeave
vim.api.nvim_create_autocmd("VimLeave", {
    group = exit_group,
    pattern = "*",
    callback = on_vim_leave,
})


