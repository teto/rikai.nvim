local lual = require("lual")

-- Centralized configuration
lual.config({

    level = lual.debug,
    -- pipelines = {
    --     { level = lual.warn, outputs = { lual.console }, presenter = lual.color },
    --     -- TODO load path from
    --     -- { level = lual.debug, outputs = { lual.file, path = "app.log" }, presenter = lual.json() }
    -- }
})

local logger = lual.logger("rikai")
logger:debug("Now this appears too!")
return logger
