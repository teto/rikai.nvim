local log = require("alogger")

-- configure work to save into file and print into stdout
log.setup({
	-- by default dont write log-messages to fs
	save = true,
	-- level = log.levels.DEBUG,
	level = log.levels.TRACE,
	appname = "rikai",
	log_dir = ".", -- defualt is "${HOME}/appname/"
	log_file = "rikai",

	-- (build_log_message)
	-- app_root = '.', -- used to make short source trace-lines from full-paths

	-- do not print messages with DEBUG and TRACE level into StdOut (only to file), defaults to true
	-- silent_debug = true,
})

-- lual was too buggy
-- local lual = require("lual")
-- logger = lual.logger("rikai"
-- --     ,{
-- --             outputs = {
-- --                 { lual.file, path = "app.log" }
-- --             },
-- --             presenter = lual.text
-- --
-- -- }
-- )
-- -- logger:set_level(lual.debug)
--

return log
