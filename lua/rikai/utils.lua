local M = {}

---@param expr string Japanese expression to search in dico
---@return string (link towards jisho.org)
function M.jisho_link(expr)
    local url = "https://jisho.org/search/"..expr
    return url
end

return M
