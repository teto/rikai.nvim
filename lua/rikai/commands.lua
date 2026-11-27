-- command parser generated https://github.com/ColinKennedy/mega.cmdparse
local logger = require("rikai.log")
local config = require("rikai.config")

local M = {}

---Check if we are in one visual mode
---@return boolean
local function visual_mode_enabled()
	-- - v: characterwise
	-- - V: linewise
	-- - \022: blockwise (\022 is Lua’s decimal escape for ASCII 22, Ctrl-V)
	return vim.fn.mode():match("^[vV\022]")
end

---@return nil
function M.create_command()
	local cmdparse = require("mega.cmdparse")
	local parser = cmdparse.ParameterParser.new({ name = "Rikai", help = "Nested Subparsers" })
	local top_subparsers = parser:add_subparsers({ destination = "commands" })

	local lookup_parser = top_subparsers:add_parser({ name = "lookup", help = "Lookup the characters" })
	lookup_parser:add_parameter({ name = "expression", required = false, help = "Text to translate" })

	-- move this to its own file ?
	lookup_parser:set_execute(function(args)
		local utils = require("rikai.utils")
		local tokenizer = require("rikai.tokenizer")
		local lookup = require("rikai.commands.lookup")
		---@type table
		local megaargs = args.namespace
		---@type string
		local to_tokenize_str = ""

		-- check if we are in visual mode
		-- number of items in range
		-- if token was on command line
		if megaargs.expression then
			to_tokenize_str = megaargs.expression
		elseif args.options.range ~= 0 or visual_mode_enabled() then
			-- splits between kanas and kanjis
			-- https://github.com/neovim/neovim/discussions/35081
			-- todo use get_selection instead ?
			local visual_selection = utils.get_visual_selection()
			-- take first line of visual selection
			to_tokenize_str = visual_selection[1]
		else
			-- cto_tokenize_str implementation is based on \k
			-- let's tokenize the whole line
			local token = tokenizer.get_current_token()
			if not token then
				utils.notify("No token under cursor", vim.log.levels.INFO)
				return
			end
			lookup.popup_lookup(token)
			return
		end

		local to_translate = require("rikai.lookup").resolve_token(to_tokenize_str)
		if not to_translate then
			utils.notify("No tokens found", vim.log.levels.INFO)
			return
		end

		lookup.popup_lookup(to_translate)
	end)

	local livehl_parser = top_subparsers:add_parser({ name = "live", help = "Highlight current token" })
	livehl_parser:add_parameter({
		name = "hl_command",
		choices = {
			"toggle",
			"clear",
			"enable",
			"disable",
		},
		-- doesn't complain even though it is required ?
		required = true,
		help = "Autoupdate text highlights depending on their type: names, verbs, ...",
	})
	livehl_parser:set_execute(function()
		local livehl = require("rikai.commands.live_hl")
		livehl.setup_hl_autocmds()
	end)

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
		help = "Choose behavior",
	})
	hl_parser:add_parameter({ name = "--name", help = "highlight names" })
	-- args vim.api.keyset.create_user_command.command_args
	hl_parser:set_execute(function(args)
		local megaargs = args.namespace
		local pos = vim.fn.getpos(".")

		if megaargs.hl_command == "clear" then
			logger:info("clearing hl")
			-- 'RikaiProperNoun'
			-- hoping it exists ?
			vim.fn.matchdelete(vim.w.rikai_hl)
		end
		require("rikai.highlighter").toggle_highlights(pos, true)
	end)

	local dl_parser = top_subparsers:add_parser({ name = "download", help = "download the necessary dictionaries" })
	dl_parser:add_parameter({
		name = "name",
		required = false,
		choices = vim.tbl_keys(config.dictionaries),
		help = "Dictionary name",
	})
	dl_parser:set_execute(function(args)
		require("rikai.download").run(args.namespace.name)
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

	local log = top_subparsers:add_parser({ name = "log", help = "" })
	log:set_execute(function(_data)
		vim.cmd("log rikai")
	end)

	cmdparse.create_user_command(parser, nil, { range = true })
end

return M
