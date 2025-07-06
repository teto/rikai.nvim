local config = require 'jap-nvim.config'

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

---@param {string} lines toto
function M.create_popup(lines)
       -- JapConfig
       local width = config.width
       local height = config.height
       local opts = {
           title = "jap.nvim"
       }
       local popupOptions = util.make_floating_popup_options(width, height, opts)

       util.open_floating_preview(lines, "txt", popupOptions)

       end

return M
