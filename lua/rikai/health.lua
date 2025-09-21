---@mod rikai.health rikai.nvim health checks

-- must return a Lua table containing a `check()`

local M = {}

local h = vim.health

-- ideally we would return the version
---@return boolean is_installed
---@return string|nil version
local check_installed = function(dep)
    if vim.fn.executable(dep) == 1 then
            return true
    end
    return false
end

local function validate(name, value, validator, optional, message)
    local ok, err = pcall(vim.validate, name, value, validator, optional, message)
    return ok or false, "Rocks: Invalid config" .. (err and ": " .. err or "")
end

-- expose bits of it to test validation
local function check_config()
    h.start("Checking rocks.nvim config")

    local cfg = vim.g.rikai
    local ok, err = validate("kanjidb", cfg.kanjidb, "string")
    -- TODO check the file exists ! and if it's outdated ?
    if not ok then
        h.error(err or "" .. vim.g.rikai and "" or " This looks like a plugin bug!")
        return false, err
    end
end



function M.check()
    local external_dependencies = {
        "sudachi"
    }
    h.start("Checking external dependencies")
    for _, dep in ipairs(external_dependencies) do
        if check_installed(dep) then
            h.ok("Program '"..dep.."' is executable")
        else
            h.error("Program '"..dep.."' is not executable")
        end

    end

    check_config()
end

return M
