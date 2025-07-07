-- local provider = require'rikai.providers.wordbase'
local provider = require'rikai.providers.sqlite'
local classifier = require'rikai.classifier'
local kanji = require'rikai.kanji'
local tokenizer = require'rikai.tokenizers.sudachi'
local logger = require'rikai.log'

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
       local word = vim.fn.expand("<cWORD>")
       local code = vim.fn.char2nr(word)

        -- Use format strings
       -- vim.print(logger)
       logger:info("popup_lookup looking into ") -- %s", "PLACEHOLDER")


        -- Use format strings
        logger:info("Tokenizer")

        -- find the firest
        local tokens = tokenizer.tokenize(word)

        -- TODO check for kanjis for now but later we can deal with romajis/kanas etc
        -- if classifier.is_common_kanji(code) then

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

          -- add a link to jisho
          -- formatted_results[#formatted_results + 1] = "

          -- {"First line:", }
          -- vim.print("Once formatted")
          -- vim.print(formatted_results)
          require'rikai.popup'.create_popup( formatted_results[1] )
       -- end

end


return M
