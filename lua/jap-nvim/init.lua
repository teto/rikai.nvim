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
M.popup_lookup = function(args)
       -- :xa
       local params = vim.lsp.util.make_position_params()
       -- print(params)
       local word = vim.fn.expand("<cword>")
       if classifier.is_common_kanji(word) then
          local results = provider.lookup_kanji(word)
          local formatted_results = {}
          for r in results do
              formatted_results[#formatted_results] = kanji.format_kanji(r)
          end

          -- {"First line:", }
          require'jap-nvim.popup'.create_popup(formatted_results)
       end
       -- TODO create a class
       -- vim.print(results[1])
       -- vim.print(results[1]["record_id"])
       -- local record = results[1]["record"]["content"][1]
       -- print("results", results)

end

return M
