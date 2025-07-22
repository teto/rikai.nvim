local config = require('rikai.config')
local log = require('alogger')

-- configure work to save into file and print into stdout
log.setup({
  save = true,
  level = log.levels.DEBUG,
  appname = 'rikai',
  log_dir = '.', -- defualt is "${HOME}/appname/"
  log_file = 'rikai',
  -- (build_log_message)
  -- app_root = '.', -- used to make short source trace-lines from full-paths
  -- do not print messages with DEBUG and TRACE level into StdOut (only to file)
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

-- function logger.print(self, msg)
--     vim.print(msg)
-- end

return log
