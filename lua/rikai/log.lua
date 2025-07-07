local lual = require("lual")
local config = require('rikai.config')


-- TODO convert log level to lual's
-- config.log_level =

-- Centralized configuration

-- lual.config({
--
--     level = lual.debug,
--     pipelines = {
--         -- this prints on CLI so not great
--         -- { level = lual.warn, outputs = { lual.console }, presenter = lual.color },
--         -- {
--         --     outputs = {
--         --         { lual.file, path = "app.log" }
--         --     },
--         --     presenter = lual.text()
--         -- }
--
--         {
--             -- level = lual.debug,
--             outputs = { { lual.file, path = "rikai.log"} },
--             -- presenter = lual.text()
--         }
--     }
-- })

logger = lual.logger("rikai"
--     ,{
--             outputs = {
--                 { lual.file, path = "app.log" }
--             },
--             presenter = lual.text
--
-- }
)

-- logger:set_level(lual.debug)
--
-- logger:add_pipeline(
--         {
--             outputs = {
--                 { lual.file, path = "app.log" }
--             },
--             presenter = lual.text()
--         }
--
-- )

logger:debug("Now this appears too!")

function logger.print(self, msg)
    vim.print(msg)
end
return logger
