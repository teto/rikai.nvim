local config = require 'jap-nvim.config'
local provider = require 'jap-nvim.wordbase'

local M = {}

local util = vim.lsp.util

function M.create_popup()
       -- JapConfig
       local width = config.width
       local height = config.height
       local opts = {}
       util.make_floating_popup_options(width, height, opts)

       -- get text under cursor
       local word = vim.fn.expand("<cword>")

       local results = provider.lookup(word)
       local floating_bufnr, floating_winnr = util.open_floating_preview({"THIS IS THE CONTENT"}, "text", opts)

end

return M
