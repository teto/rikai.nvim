-- local util = vim.lsp.util
local main = require'rikai'

-- local JapConfig = require('rikai.config')

-- todo add a preview function
local commandOpts = {bang= true, range = true}

-- vim.api.nvim_create_user_command('JapRo2Ka', require'rikai'.ro2ka, commandOpts)
-- vim.api.nvim_create_user_command('JapRo2Hi', require'rikai'.ro2hi, commandOpts)


-- print("RIKAI init")
-- vim.print( vim.g.rikai)
-- get current word translations
-- 
vim.api.nvim_create_user_command('RikaiLookup', main.popup_lookup, commandOpts)

vim.api.nvim_create_user_command('RikaiDownload', function()
    print("downloading dicts...")
    -- vim.curl
    vim.system(
    string.format(
      "curl -sSL  https://github.com/odrevet/edict_database/releases/download/v0.0.2/kanji.zip -o "..vim.g.rikai.kanjidb
    )
  )
  -- https://github.com/odrevet/edict_database/releases/download/v0.0.2/expression.zip
  -- return vim.v.shell_error == 0

end, { desc = 'Download required dicts' })


-- should depend on filetype and underlying character ?
-- TODO make delay configurable
-- vim.api.nvim_create_autocmd({"CursorHold"}, {
--     pattern = { "*.md", "*.txt", "*.org" },
-- 	desc = "Display translations on hover",
--    -- inspired by "hover"
-- 	callback = popup_lookup
-- })

