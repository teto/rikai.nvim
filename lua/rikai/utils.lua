local logger = require'rikai.log'

local M = {}


--- You may need to unpack the result
---@param name string used in logger
---@param op function
---@return any
function M.timeit(name, op, ...)
    local start = vim.uv.now()
    local res = {op(...)}
    vim.uv.update_time()
    local end_time = vim.uv.now()
    logger.debug(name.." operation took ".. tostring(end_time-start).. "ms")
    return unpack(res)
end

--- aint it weird that nvim commands dont pass columns ?
---@return table
function M.get_visual_selection()
   -- does not handle rectangular selection
   local s_start = vim.fn.getpos "'<"
   -- in visual mode returns the other end of the connections
   local s_end = vim.fn.getpos "'>"
   local lines = vim.fn.getregion(s_start,s_end)
   -- vim.print(lines)
   return lines
end

---@param expr string Japanese expression to search in dico
---@param as_kanji boolean true to link the kanji page
---@return string (link towards jisho.org)
function M.jisho_link(expr, as_kanji)
    local url = "https://jisho.org/search/"..expr
    if as_kanji then
        url = url.. "%23kanji"
    end
    return url
end

---@param content string
---@param font_size number
---@return nil
function M.print_variable_size(content, font_size)
    -- todo adapt the number of newlines
    return print("\\e]66;s="..tostring(font_size)..";"..content.."\a\n\n")
    -- printf "\e]66;s=2;Double sized text\a\n\n"
    -- printf "\e]66;s=3;Triple sized text\a\n\n\n"
    -- printf "\e]66;n=1:d=2;Half sized text\a\n"
end

return M
