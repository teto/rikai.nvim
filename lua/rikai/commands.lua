-- command parser generated https://github.com/ColinKennedy/mega.cmdparse
local cmdparse = require("mega.cmdparse")
local lookup = require("rikai.commands.lookup")
local livehl = require("rikai.commands.live_hl")
local utils = require("rikai.utils")
local logger = require("rikai.log")
local tokenizer = require("rikai.tokenizer")
local utf8 = require("utf8")

local M = {}

---@return nil
function M.create_command()

	local parser = cmdparse.ParameterParser.new({ name = "Rikai", help = "Nested Subparsers" })
	local top_subparsers = parser:add_subparsers({ destination = "commands" })

	local lookup_parser = top_subparsers:add_parser({ name = "lookup", help = "Lookup the characters" })
	lookup_parser:add_parameter({ name = "expression", required = false, help = "Text to translate" })

    -- move this to its own file ?
	lookup_parser:set_execute(function(args)
		local megaargs = args.namespace
		local to_translate, to_tokenize
		-- number of items in range
		if megaargs.expression then
			to_tokenize = megaargs.expression
		elseif args.options.range ~= 0 then
			-- splits between kanas and kanjis
			-- https://github.com/neovim/neovim/discussions/35081
			-- todo use get_selection instead ?
			local visual_selection = utils.get_visual_selection()
			-- take first line of visual selection
			to_tokenize = visual_selection[1]
		else
			-- cto_tokenize implementation is based on \k
			-- TODO cto_tokenize is bad, we should tokenize, get current to_tokenize
            -- let's tokenize the whole line
            -- advantage of cword is that it doesn't care about
            -- local cursor_pos = vim.api.nvim_win_get_cursor(0)
			to_tokenize = vim.fn.expand("<cword>")
			-- to_tokenize = vim.api.nvim_get_current_line()
            -- line = cursor_pos
			-- TODO replace with get_current_token()
            -- vim.g.rikai._state._current_line = 
		end

        if utf8.len(to_tokenize) > 1 then
            -- todo get first element
            -- TODO tokenize should be called in caller instead
            local tokens = utils.timeit("tokenize", tokenizer.tokenize, to_tokenize, true)
            if vim.tbl_isempty(tokens) then
                -- todo notify as well
                utils.notify("No tokens found", vim.log.levels.INFO)
                -- logger.debug("No tokens found")
                return
            end
            -- returns an array of TokenizationResult
            to_translate = tokens[1][1]
        else
            logger.debug("Word " .. to_tokenize .. " is one character: skipping tokenization...")
            to_translate = to_tokenize
        end

		lookup.popup_lookup(to_translate)
	end)

	local livehl_parser = top_subparsers:add_parser({ name = "live_hl", help = "Highlight current token" })
	livehl_parser:add_parameter({
		name = "hl_command",
		choices = {
			"toggle",
			"clear",
			"enable",
			"disable",
		},
		help = "Autoupdate text highlights depending on their type: names, verbs, ...",
	})
	livehl_parser:set_execute(livehl.setup_hl_autocmds)

	local hl_parser = top_subparsers:add_parser({
		name = "hl",
		help = "Highlight differently words depending on their category (names, article, etc)",
	})

	-- maybe should be a subparser ?
	-- local hl_subparsers = hl_parser:add_subparsers({ destination = "hl_command", help = "What todo ?" })
	hl_parser:add_parameter({
		name = "hl_command",
		choices = {
			"toggle",
			"clear",
			"enable",
			"disable",
		},
		help = "Test word.",
	})
	hl_parser:add_parameter({ name = "--name", help = "highlight names ?" })
	-- args vim.api.keyset.create_user_command.command_args
	hl_parser:set_execute(function(args)
		local megaargs = args.namespace
		local pos = vim.fn.getpos(".")

		if megaargs.hl_command == "clear" then
			logger.info("clearing hl")
			-- 'RikaiProperNoun'
			-- hoping it exists ?
			vim.fn.matchdelete(vim.w.rikai_hl)
		end
		require("rikai.highlighter").toggle_highlights(pos, true)
	end)

	local download = top_subparsers:add_parser({ name = "download", help = "download the necessary dictionaries" })
	download:set_execute(function(_data)
		require("rikai.commands.download")()
	end)

	local speak = top_subparsers:add_parser({ name = "speak", help = "read selection out loud" })
	speak:set_execute(function(_data)
		require("rikai.commands.speak")()
	end)

	local furigana = top_subparsers:add_parser({ name = "furigana", help = "Print furigana" })
	furigana:set_execute(function(_data)
		-- TODO
		require("rikai.furigana").add_furigana()
	end)

	local log = top_subparsers:add_parser({ name = "log" , help = "" })
	log:set_execute(function(_data)
		-- TODO implement a log.get_logfile()
		vim.cmd.e("rikai.log")
	end)

	cmdparse.create_user_command(parser, nil, { range = true })
end

return M
