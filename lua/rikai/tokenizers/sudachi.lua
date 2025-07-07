--  sudachi-rs
--  echo 日高屋 | sudachi
-- 日高	名詞,固有名詞,人名,姓,*,*	日高
-- 屋	接尾辞,名詞的,一般,*,*,*	屋
-- EOS
local logger = require'rikai.log'

local M = {}

---@param content string
---@return table
M.tokenize = function (content)
    local tokens = {}
    -- Use format strings
    logger:print(string.format("Tokenizer called with content '%s'", content))

    local handle_line = function(_, data, name)
        logger:print("Handle_line called for event "..name)
        for _, line in ipairs(data) do
            -- ignore EOS too ? can sudachi be configured differently
            if line ~= "" then
                -- TODO keep only start, cut on first space
                logger:print("Inserting new token ".. line)
                table.insert(tokens, line)
            end
        end
    end


    local chan = vim.fn.jobstart({'sudachi'}, {
        on_stdout = handle_line,
        on_stderr = handle_line,
        on_exit = function () print("PROCESS FINISHED") end,
        pty = true,
        -- term = true
    })

    if chan == 0 then
        error("Invalid arguments")
    elseif chan == -1 then
        error("not executable")
    else

    end

    -- "出る"
    local sendres = vim.fn.chansend(chan, {
        content,
        ""
    })
    print("sendres: ", sendres)

    local timeout_ms = 2000


    local resarr = vim.fn.jobwait( { chan }, timeout_ms)
    vim.print(resarr)

    if resarr[1] < 0 then
        print("An error happened for sudachi")
        -- resarr[1]
    end

    -- local reskill = vim.fn.jobstop( chan )
    -- logger:print(reskill)

    logger:print("Found "..tostring(#tokens).. " different tokens")
    return tokens
end

return M
