-- command parser generated https://github.com/ColinKennedy/mega.cmdparse
local cmdparse = require("mega.cmdparse")
local lookup = require'rikai.commands.lookup'


local M = {}

-- parser:add_parameter({ name = "items", nargs="*", help="non-flag arguments." })
-- parser:add_parameter({ name = "--fizz", help="A word." })
-- parser:add_parameter({ name = "-d", action="store_true", help="Delta single-word." })
function M.create_command()
    -- local parser = cmdparse.ParameterParser.new({ name = "Rikai", help = "Hello, World!"})
    -- parser:set_execute(function(data) print("Hello, World!") end)
    -- cmdparse.create_user_command(parser)

    local parser = cmdparse.ParameterParser.new({ name = "Rikai", help = "Nested Subparsers" })
    local top_subparsers = parser:add_subparsers({ destination = "commands" })

    local lookup_parser = top_subparsers:add_parser({ name = "lookup", help = "Lookup the characters" })
    lookup_parser:add_parameter({ name="expression", required=false, help="Text to translate"})
    lookup_parser:set_execute(function(data)
        lookup.popup_lookup(data)
    end)

    local names = top_subparsers:add_parser({ name = "names", help = "Highlight stuff" })

    names:set_execute(function(data)
        require'rikai.highlighter'.toggle_names(data)
    end)


    local download = top_subparsers:add_parser({ name = "download", help = "download the necessary dictionaries" })
    download:set_execute(function(data)
        -- print(string.format('Opening "%s" log path.', "hello world"))
        require'rikai.commands.download'()
    end)

    local speak = top_subparsers:add_parser({ name = "speak", help = "read selection out loud" })
    speak:set_execute(function(data)
        -- get_selection()
        require'rikai.commands.speak'()
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
