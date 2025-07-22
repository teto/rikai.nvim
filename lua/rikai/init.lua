-- local provider = require'rikai.providers.wordbase'
local provider = require'rikai.providers.sqlite'
local classifier = require'rikai.classifier'
local types = require'rikai.types'
local kanji = require'rikai.kanji'
local expr = require'rikai.expression'
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
---@param args vim.api.keyset.create_user_command.command_args
M.popup_lookup = function(args)
    logger.info("%s called", args.name)
    -- logger.debug("with args"..tostring(args.args))
    -- logger.debug("with fargs"..tostring(args.fargs))
    -- vim.print(args.fargs)
    -- local params = vim.lsp.util.make_position_params()
    local word
    word = args.fargs[1] or vim.fn.expand("<cWORD>")
    -- <cWORD>
    -- cword implementation is based

       logger.info("Looking into word: "..word)

        -- find the firest
        -- TODO if length is one, no need to tokenize !
        local tokens = { word }
        if utf8.len(word) > 1 then
            tokens = tokenizer.tokenize(word)
        else
            logger.debug("Word "..word.." is one character: skipping tokenization...")
        end

        if vim.tbl_isempty(tokens) then
            logger.debug("No tokens found")
            return
        end

        -- the chosen token
        local token = tokens[1]
        local token_code = vim.fn.char2nr(token)
        local token_type = classifier.chartype(token_code)
        local token_len = utf8.len(token)
        -- print("token1: ", token)
        -- print("token len: ", token_len)

        local results
        if token_len == 1 and token_type == types.CharacterType.KANJI then
            -- if the token is only a single kanji ask the kanji db
            results = provider.lookup_kanji(token)
        else
            -- we need to pass one character only
            -- lookup expression for vim.fn.char2nr("引く")
            -- vim.fn.nr2char(code)
            results = provider.lookup_expr(token)
        end

        logger.debug("Found "..tostring(#results).. " results")

        assert(results, "There must be a result")
        if vim.tbl_isempty(results) then
            print("No results matching token"..token)
            return
        end

        -- TODO check for kanjis for now but later we can deal with romajis/kanas etc
        -- if it's numeral, ask expression db
        local formatted_results = { "number of results:"..tostring(#results) }

        -- TODO limit loop according to max_results
        -- local max_results = 5
        -- TODO use config.ui.separator
        local separator = " ---------- "

        for i, r in ipairs(results) do

            -- add a separator if not first result
            if i > 1 then
                table.insert(formatted_results, separator)
            end

            if token_len == 1 and token_type == types.CharacterType.KANJI then
                -- vim.print(r)
                local new_result = kanji.format_kanji(r)
                for j = 1, #new_result do
                    table.insert(formatted_results, new_result[j])
                end

            else
                -- one could concat all results ?
                -- vim.print(r)

                local new_result = expr.format_expression(token, r)
                -- 'unpack' was renamed 'table.unpack' in lua5.1 / 5.4
                -- 
                -- freaking unpack
                -- https://stackoverflow.com/questions/37372182/what-is-happening-when-i-call-unpack-as-luas-function-arguments
                -- formatted_results = {unpack( formatted_results),  unpack(new_result) }
                -- vim.print(formatted_results)
                -- table.insert(formatted_results, unpack(new_result))
                -- TODO use table.unpack ?
                for j = 1, #new_result do
                    table.insert(formatted_results, new_result[j])
                end
            end
        end

          -- add a link to jisho
          require'rikai.popup'.create_popup( formatted_results, {} )

end


return M
