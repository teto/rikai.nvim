-- local provider = require'rikai.providers.wordbase'
local provider = require'rikai.providers.sqlite'
-- local classifier = require'rikai.classifier'
local kanji = require'rikai.kanji'
local tokenizer = require'rikai.tokenizers.sudachi'
local logger = require'rikai.log'
local utf8 = require'utf8'

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
       -- <cWORD>
       -- cword implementation is based
       local word = vim.fn.expand("<cWORD>")
       logger.info("Selected word: "..word)

       -- local code = vim.fn.char2nr(word)

       logger.info("popup_lookup looking into ")


        -- Use format strings
        logger.info("Tokenizer")

        -- find the firest
        local tokens = tokenizer.tokenize(word)

        if vim.tbl_isempty(tokens) then
            logger.debug("No tokens found")
            return
        end

        -- the chosen token
        local token = tokens[1]
        local token_len = utf8.len(token)

        local results
        if token_len == 1 and kanji.is_common_kanji(token) then
        -- if the token is only a single kanji ask the kanji db
            results = provider.lookup_kanji(vim.fn.nr2char(token))
        else
            -- we need to pass one character only
            -- lookup expression for vim.fn.char2nr("引く")
            -- vim.fn.nr2char(code)
            result = provider.lookup_expr(token)
        end

        -- TODO check for kanjis for now but later we can deal with romajis/kanas etc
        -- if it's numeral, ask expression db
        local formatted_results = {}

        if vim.tbl_isempty(results) then
            print("No results matching token"..token)
            return
        end
        -- vim.print("RESULTS:")
        -- vim.print(results)

        for _, r in ipairs(results) do
            -- vim.print(r)
            -- TODO do this only if kanji ?

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
