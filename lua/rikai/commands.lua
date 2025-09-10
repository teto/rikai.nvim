-- command parser generated https://github.com/ColinKennedy/mega.cmdparse
local cmdparse = require("mega.cmdparse")
local lookup = require'rikai.commands.lookup'
local utils = require 'rikai.utils'


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
    lookup_parser:set_execute(function(args)
        local megaargs = args.namespace
        local word
        -- number of items in range
        if megaargs.expression then
            word = megaargs.expression
        elseif args.options.range ~= 0 then
            -- splits between kanas and kanjis
            -- https://github.com/neovim/neovim/discussions/35081
            -- todo use get_selection instead ? 
            local visual_selection = utils.get_visual_selection()
            -- take first line of visual selection
            word = visual_selection[1]
        else
            -- cword implementation is based on \k
            word = vim.fn.expand("<cword>")
        end


        lookup.popup_lookup(word)
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
        require'rikai.commands.speak'()
    end)



    local log = top_subparsers:add_parser({ name = "log" })
    log:set_execute(function(_data)
        -- TODO implement a log.get_logfile()
        vim.cmd.e('rikai.log')
    end)

    cmdparse.create_user_command(parser, nil, { range = true })
end


return M
