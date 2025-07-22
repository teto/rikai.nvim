local config = require 'rikai.config'

local M = {}

local util = vim.lsp.util

-- M.create_popup = function (content)
--     vim.validate{
--         content={content,'table' }
--     }
--     local params = vim.lsp.util.make_position_params()
--     vim.pretty_print(params)
--     local popupOptions = util.make_floating_popup_options(width, height, opts)
--     local _floating_bufnr, _floating_winnr = util.open_floating_preview(content, "text", popupOptions)
-- end
--

---@param lines table toto
---@param opts `vim.lsp.util.open_floating_preview.Opts?` forwarded to create popup
function M.create_popup(lines, opts)
       -- JapConfig
       local width = config.width
       local height = (#lines or config.max_height) + 1
       local lopts = {
           title = "jap.nvim",
           wrap = true,
           max_height = 20,
       }
       local popupOptions = util.make_floating_popup_options(width, height, lopts)

       util.open_floating_preview(lines, "txt", popupOptions)

       end

return M
