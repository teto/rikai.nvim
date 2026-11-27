local platform = require("rikai.platform")
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

local output_path = platform.stdpath("log") .. "/rikai.log"

local logger
if platform.has_vim then
	-- mega.logging depends on the neovim API
	local logging = require("mega.logging")
	logger = logging.get_logger({
		name = "rikai",
		level = is_busted and levels.FATAL or levels.TRACE,
		output_path = output_path,
		use_console = false,
		use_file = not is_busted,
		use_highlights = false,
	})
	---@cast logger RikaiLogger

	function logger:set_level(level)
		self.level = level
	end
else
	-- minimal file logger for the standalone executable
	local rank = { trace = 0, debug = 1, info = 2, warning = 3, error = 4, fatal = 5 }

	logger = {
		level = (os.getenv("RIKAI_LOG_LEVEL") or levels.WARN):lower(),
		output_path = os.getenv("RIKAI_LOG_FILE") or output_path,
	}

	function logger:set_level(level)
		self.level = level
	end

	local function make(name)
		return function(self, ...)
			if (rank[name] or 0) < (rank[self.level] or 0) then
				return
			end
			local parts = {}
			for i = 1, select("#", ...) do
				local v = select(i, ...)
				if type(v) == "table" then
					local items = {}
					for _, item in ipairs(v) do
						table.insert(items, tostring(item))
					end
					v = "{ " .. table.concat(items, ", ") .. " }"
				end
				table.insert(parts, tostring(v))
			end
			local line = string.format("%s [%s] %s\n", os.date("%Y-%m-%d %H:%M:%S"), name, table.concat(parts))
			local f = io.open(self.output_path, "a")
			if f then
				f:write(line)
				f:close()
			end
		end
	end

	for name, _ in pairs(rank) do
		logger[name] = make(name)
	end
	logger.warn = logger.warning
end

logger.levels = levels

---@cast logger RikaiLogger
return logger
