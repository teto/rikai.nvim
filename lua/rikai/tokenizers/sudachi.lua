-- Using  sudachi-rs tokenizer https://github.com/WorksApplications/sudachi.rs
--
--  echo 日高屋 | sudachi
-- 日高	名詞,固有名詞,人名,姓,*,*	日高
-- 屋	接尾辞,名詞的,一般,*,*,*	屋
-- EOS
local logger = require'rikai.log'
local types = require'rikai.types'
local classifier = require 'rikai.classifier'

local M = {}

local _state = {}

local NUMERAL = "数詞"
local PROPER_NOUN = "固有名詞"
local PUNCTUATION = "補助記号"

-- PART of SPEECH
-- "固有名詞" lastname might appear as a subtype
-- so we mix both together
---@param pos table
---@return rikai.types.LexiconType
function M.lexicon_type(pos)
    local pos1 = pos[1]
    -- TODO 地名 = > nom de lieu, utiliser un bitfield ?

    if pos[2] == PROPER_NOUN then -- last name
        return types.LexiconType.PROPER_NOUN
    elseif pos[1] == "名詞" then -- last name
        return types.LexiconType.NAME
    elseif pos1 == "助詞" then
        return types.LexiconType.PARTICLE
    elseif pos1 == "補助記号" then
        return types.LexiconType.AUXILIARY
    elseif pos1 == PUNCTUATION then
        return types.LexiconType.PUNCTUATION
    end

    return types.LexiconType.UNKNOWN
end


---@param  lex_type rikai.types.LexiconType
---@return string
function M.lexicon_to_str(lex_type)
    local map = {
        [types.LexiconType.PUNCTUATION] = "punctuation",
        [types.LexiconType.PROPER_NOUN] = "proper_noun",
        [types.LexiconType.PARTICLE] = "particle",
        [types.LexiconType.NAME] = "name"
    }

    return map[lex_type] or "unknown"
end


-- M.tokenize = function (content, enable_pos_processing, force)
--     if 
-- end


--- Returns a table of TokenizationResult
---@param content string
---@param enable_pos_processing boolean enable part of speech processing
---@return table of TokenizationResult
M.tokenize = function (content, enable_pos_processing)

    local tokens = {}
    -- Use format strings
    -- TODO dont log the whole thing,
    logger.info(string.format("Tokenizer called with content '%s'", content))

    ---@param _ number
    ---@param data table
    ---@param name string
    local handle_line = function(_, data, name)

    -- output format described at:
    -- https://github.com/WorksApplications/sudachi.rs?tab=readme-ov-file#output
    -- Tab separated are:
    -- - Surface
    -- - Part-of-Speech Tags (comma separated)
    -- - Normalized Form
    -- Part of speech starts with word type

    logger.debug("Handle_line called for event "..name)
    for _, line in ipairs(data) do
        -- sudachi prints 'EOS' too. can sudachi be configured differently ?
        if line ~= "" and line ~= "EOS" then
            -- tab separated results
            local pieces = vim.split(line, "	")
            local line_start = pieces[1]
            local pos = pieces[2]

            if enable_pos_processing then
                local res = vim.split(pos, ",")

                pos = M.lexicon_type(res)
                -- print("type of token:", pos)
            end

            -- iskeyword doesn't accept non-ascii ranges :'(
            -- https://groups.google.com/g/vim_dev/c/XrRP7Gcb9uc
            -- so till then we can't count on <cword> and have to classify stuff ourself
            -- if not classifier.is_japanese(line_start) then
            --     logger.debug("Skipping non-japanese token", line_start)
            -- else
            -- logger.debug("Inserting description of token ".. line_start)
            table.insert(tokens, {
                pieces[1],
                pos -- processed or not
            })
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

    local _sendres = vim.fn.chansend(chan, {
        content,
        ""
    })
    -- maybe we dont even need that ?
    local _res = vim.fn.chanclose(chan, "stdin")

    local timeout_ms = 1000


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
