local M = {}

--- aint it weird that nvim commands dont pass columns ?
function M.get_visual_selection()
   -- does not handle rectangular selection
   local s_start = vim.fn.getpos "'<"
   -- in visual mode returns the other end of the connections
   local s_end = vim.fn.getpos "'>"
   -- getregionpos({pos1},
   local lines = vim.fn.getregion(s_start,s_end)
   vim.print(lines)
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

function M.print_variable_size(content, font_size)
    -- todo adapt the number of newlines
    return print("\\e]66;s="..tostring(font_size)..";"..content.."\a\n\n")
    -- printf "\e]66;s=2;Double sized text\a\n\n"
    -- printf "\e]66;s=3;Triple sized text\a\n\n\n"
    -- printf "\e]66;n=1:d=2;Half sized text\a\n"
end

return M
