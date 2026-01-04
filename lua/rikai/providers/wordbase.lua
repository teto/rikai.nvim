
local M = {}

---@param word string
---@return table|nil
function M.lookup(word)

    local args = {'wordbase-cli', '--output=json', 'lookup', word}
    -- local output = ""
    vim.notify(vim.fn.join(args))
    local obj = vim.system(args, { text = true }):wait()
    -- vim.print(obj)
    if obj.code ~= 0 then
        error("exit code %d" % obj.code)
        return nil
    end

    return vim.fn.json_decode(obj.stdout)

end

return M
