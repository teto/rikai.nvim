local logging = require("mega.logging")
local is_busted = package.loaded.busted ~= nil

local levels = {
	TRACE = "trace",
	DEBUG = "debug",
	INFO = "info",
	WARN = "warning",
	WARNING = "warning",
	ERROR = "error",
	FATAL = "fatal",
}

---@class RikaiLogger: mega.logging.Logger
---@field levels table<string, string>
---@field set_level fun(self: RikaiLogger, level: string)

local logger = logging.get_logger({
	name = "rikai",
	level = is_busted and levels.FATAL or levels.TRACE,
	output_path = vim.fn.stdpath("log") .. "/rikai.log",
	use_console = false,
	use_file = not is_busted,
	use_highlights = false,
})
---@cast logger RikaiLogger

logger.levels = levels

function logger:set_level(level)
	self.level = level
end

return logger
