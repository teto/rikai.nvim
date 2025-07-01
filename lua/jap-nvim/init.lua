-- local provider = require'jap-nvim.providers.wordbase'
local provider = require'jap-nvim.providers.sqlite'
local classifier = require'jap-nvim.classifier'
local kanji = require'jap-nvim.kanji'
local util = vim.lsp.util

local M = {}


-- romaji to katakana
M.ro2ka = function (args)
    print("ro2ka called for range ", args.line1, args.line2)
    print("ro2ka not implemented yet, use jiten")
    -- TODO edit buffer
end


-- romaji to hiragana
M.ro2hi = function (args)
    print("ro2hi called for range ", args.line1, args.line2)
    print("ro2hi not implemented yet, use jiten")
end

-- we should tokenize and based on what we find lookup kanji or not ?
-- でる
-- 
-- How to translate "日高" from our sqlite dbs ?
-- 1. first we tokenize
-- 2. For the first tokenized item
--    a. we detect if it's one kanji (one character) or an expression (several characters)
--    b.
M.popup_lookup = function(args)
       -- :xa
       local params = vim.lsp.util.make_position_params()
       -- print(params)
       local word = vim.fn.expand("<cword>")
       local code = vim.fn.char2nr(word)

       if classifier.is_common_kanji(code) then
           -- we need to pass one character only
          local results = provider.lookup_kanji(vim.fn.nr2char(code))
          local formatted_results = {}
          -- vim.print("RESULTS:")
          -- vim.print(results)

          if vim.tbl_isempty(results) then
              return
          end

          for _, r in ipairs(results) do
                -- vim.print(r)
                formatted_results[#formatted_results + 1] = kanji.format_kanji(r)
          end

          -- {"First line:", }
          -- vim.print("Once formatted")
          -- vim.print(formatted_results)
          require'jap-nvim.popup'.create_popup( formatted_results[1] )
       end

end

return M
