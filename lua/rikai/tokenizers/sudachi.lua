--  sudachi-rs
--  echo 日高屋 | sudachi
-- 日高	名詞,固有名詞,人名,姓,*,*	日高
-- 屋	接尾辞,名詞的,一般,*,*,*	屋
-- EOS
local logger = require'rikai.log'
local classifier = require 'rikai.classifier'

local M = {}

---@param content string
---@return table
M.tokenize = function (content)
    local tokens = {}
    -- Use format strings
    logger.info(string.format("Tokenizer called with content '%s'", content))

    local handle_line = function(_, data, name)
        logger.debug("Handle_line called for event "..name)
        for _, line in ipairs(data) do
            -- sudachi prints 'EOS' too. can sudachi be configured differently ?
            if line ~= "" and line ~= "EOS" then
                -- TODO keep only start, cut on first space
                local line_start = string.match(line, "%S+")

                -- iskeyword doesn't accept non-ascii ranges :'(
                -- https://groups.google.com/g/vim_dev/c/XrRP7Gcb9uc
                -- so till then we can't count on <cword> and have to classify stuff ourself
                if not classifier.is_japanese(line_start) then
                    logger.debug("Skipping non-japanese token", line_start)
                else
                    logger.debug("Inserting new token ".. line_start)
                    table.insert(tokens, line_start)
                end
            end
        end
    end


    local chan = vim.fn.jobstart({'sudachi'}, {
        on_stdout = handle_line,
        on_stderr = handle_line,
        on_exit = function ()
        end,
    })

    if chan == 0 then
        error("Invalid arguments")
    elseif chan == -1 then
        error("not executable")
    else

    end

    local sendres = vim.fn.chansend(chan, {
        content,
        ""
    })
    -- print("sendres: ", sendres)
    -- maybe we dont even need that ?
    local res = vim.fn.chanclose(chan, "stdin")

    local timeout_ms = 2000


    local resarr = vim.fn.jobwait( { chan }, timeout_ms)

    if resarr[1] < 0 then
        print("An error happened for sudachi")
        -- resarr[1]
        -- local reskill = vim.fn.jobstop( chan )
    end


    logger.debug("Found "..tostring(#tokens).. " different tokens")
    return tokens
end

return M
