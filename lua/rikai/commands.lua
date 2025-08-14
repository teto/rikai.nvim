-- inspired by rocks.nvim
-- https://github.com/neovim/neovim/issues/32263
-- see https://github.com/ColinKennedy/mega.cmdparse
-- local rocks_command_tbl = {
-- not found
local cmdparse = require("mega.cmdparse")
local main = require'rikai'


local M = {}

function M.create_command()
    -- local parser = cmdparse.ParameterParser.new({ name = "Rikai", help = "Hello, World!"})
    -- parser:set_execute(function(data) print("Hello, World!") end)
    -- cmdparse.create_user_command(parser)

    local parser = cmdparse.ParameterParser.new({ name = "Rikai", help = "Nested Subparsers" })
    local top_subparsers = parser:add_subparsers({ destination = "commands" })

    local lookup = top_subparsers:add_parser({ name = "lookup", help = "Lookup the characters" })
    lookup:set_execute(function(data)
        main.popup_lookup()
    end)

    local names = top_subparsers:add_parser({ name = "names", help = "Highlight stuff" })

    names:set_execute(function(data)
        require'rikai.highlighter'.toggle_names(data)
    end)


    local download = top_subparsers:add_parser({ name = "download", help = "download the necessary dictionaries" })
    download:set_execute(function(data)
        print(string.format('Opening "%s" log path.', "hello world"))
    end)



    -- local view_subparsers = view:add_subparsers({ destination = "view_commands" })
    --
    local log = top_subparsers:add_parser({ name = "log" })
    log:add_parameter({ name = "path", help = "Open a log path file." })
    -- log:add_parameter({ name = "--relative", action="store_true", help = "A relative log path." })
    log:set_execute(function(data)
        print(string.format('Opening "%s" log path.', data.namespace.path))
    end)

    cmdparse.create_user_command(parser)
end


return M
