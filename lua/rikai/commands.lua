-- command parser generated https://github.com/ColinKennedy/mega.cmdparse
local cmdparse = require("mega.cmdparse")
local lookup = require'rikai.commands.lookup'
local utils = require 'rikai.utils'
local logger = require'rikai.log'

local M = {}

---@return nil
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
            -- TODO cword is bad, we should tokenize, get current word
            word = vim.fn.expand("<cword>")
            -- TODO replace with get_current_token()
        end

        lookup.popup_lookup(word)
    end)

    local livehl_parser = top_subparsers:add_parser({ name = "live_hl", help = "Highlight current token" })
    livehl_parser:add_parameter({ name = "hl_command", choices={
            "toggle", "clear", "enable", "disable" }, help="Test word."}
        )
    livehl_parser:set_execute(function(_args)
        vim.api.nvim_create_autocmd({"CursorHold"}, {
            -- configurable ?
            pattern = { "*.md", "*.txt", "*.org" },
            desc = "Display translations on hover",
            -- inspired by "hover"
            callback = lookup.live_lookup
        })

        -- if megaargs.hl_command == "clear" then
        --     logger.info("clearing hl")
        --     -- renvoye -1 ptet
        --     vim.fn.matchdelete('RikaiProperNoun')
        -- end
        -- require'rikai.highlighter'.toggle_highlights(pos, true)
    end)

    local hl_parser = top_subparsers:add_parser({ name = "hl", help = "Highlight differently words depending on their category (names, article, etc)" })

    -- maybe should be a subparser ?
    -- local hl_subparsers = hl_parser:add_subparsers({ destination = "hl_command", help = "What todo ?" })
    hl_parser:add_parameter({ name = "hl_command", choices={
            "toggle", "clear", "enable", "disable" }, help="Test word."}
        )
    hl_parser:add_parameter({ name = "--name", help="highlight names ?"})
    -- args vim.api.keyset.create_user_command.command_args
    hl_parser:set_execute(function(args)
        local megaargs = args.namespace
        local pos = vim.fn.getpos(".")

        if megaargs.hl_command == "clear" then
            logger.info("clearing hl")
            -- renvoye -1 ptet
            
            -- 'RikaiProperNoun'
            -- hoping it exists ?
            vim.fn.matchdelete(vim.w.rikai_hl)
        end
        require'rikai.highlighter'.toggle_highlights(pos, true)
    end)

    local download = top_subparsers:add_parser({ name = "download", help = "download the necessary dictionaries" })
    download:set_execute(function(_data)
        require'rikai.commands.download'()
    end)

    local speak = top_subparsers:add_parser({ name = "speak", help = "read selection out loud" })
    speak:set_execute(function(_data)
        require'rikai.commands.speak'()
    end)

    local furigana = top_subparsers:add_parser({ name = "furigana", help = "Print furigana" })
    furigana:set_execute(function(_data)
        -- TODO
        require'rikai.furigana'.add_furigana()
    end)

    local log = top_subparsers:add_parser({ name = "log" })
    log:set_execute(function(_data)
        -- TODO implement a log.get_logfile()
        vim.cmd.e('rikai.log')
    end)

    cmdparse.create_user_command(parser, nil, { range = true })
end


return M
