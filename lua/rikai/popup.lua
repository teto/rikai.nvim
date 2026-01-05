local config = require 'rikai.config'

local M = {}

local util = vim.lsp.util


---@param focus_id string Popup identifier to focus or create
---@param lines table Content lines to display in popup
---@param opts table forwarded to create popup
---@return number window ID
function M.create_popup(focus_id, lines,  opts)

    local width = config.width
    local height = (#lines or config.max_height) + 1
    -- vim.lsp.util.open_floating_preview.Opts?
    local lopts = vim.tbl_extend('error', opts, {
        wrap = true,
        max_height = 20,
        -- focus_id is ignored see below :'(
        close_events = { "CursorMoved" }
    })

    -- it ignores the focus_id option
    -- see https://github.com/neovim/neovim/issues/29267
    local popupOptions = util.make_floating_popup_options(width, height, lopts)

    -- vim.w.[winid][focus_id] will be set to bufnr
    local popupOptionsFinal = vim.tbl_extend('error', popupOptions, {
        focus_id = focus_id
    })

    local _bufnr, winid = util.open_floating_preview(lines, "markdown", popupOptionsFinal)

    return winid

end

return M
