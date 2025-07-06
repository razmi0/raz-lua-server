local server = require("lib/server")
local logger = require("lib/middleware/logger")
local serve = require("lib/middleware/static")
local hmr = require("lib/middleware/hmr")
local app = require("lib/app").new()

app:use("*", hmr(), logger(), serve({ root = "public" }))
server.new(app):start()
