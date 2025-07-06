--  sudachi-rs
--  echo 日高屋 | sudachi
-- 日高	名詞,固有名詞,人名,姓,*,*	日高
-- 屋	接尾辞,名詞的,一般,*,*,*	屋
-- EOS
local logger = require'jap-nvim.log'

local M = {}

---@param content string
---@return table
M.tokenize = function (content)
    local tokens = {}
    -- Use format strings
    logger:info("Tokenizer called with content '%s'", content)

    local handle_line = function(_, data, _)
        for _, line in ipairs(data) do
            if line ~= "" then
                table.insert(tokens, line)
            end
        end
    end


    local chan = vim.fn.jobstart({'sudachi'}, {
        on_stdout = handle_line,
        on_stderr = handle_line,
    })

    vim.fn.chansend(chan, "出る")

    return tokens
end

return M
