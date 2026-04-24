local log = require("alogger")
local is_busted = package.loaded.busted ~= nil

-- configure work to save into file and print into stdout
log.setup({
	-- by default dont write log-messages to fs
	save = not is_busted,
	-- level = log.levels.DEBUG,
	level = is_busted and log.levels.FATAL or log.levels.TRACE,
	appname = "rikai",
	log_dir = vim.fn.stdpath("log"),
	log_file = "rikai", -- library appends .log

	-- do not print messages with DEBUG and TRACE level into StdOut (only to file)
	silent_debug = is_busted,
})

return log
