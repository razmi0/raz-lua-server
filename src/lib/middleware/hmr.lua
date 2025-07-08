local injected = (function()
    local path = debug.getinfo(1, "S").source:sub(2)
    local dir = path:match("(.*[/\\])") or ""
    local file = io.open(dir .. "_hmr-injected.js", "r")
    if not file then
        print("[ERROR]: hmr middleware could not find dev injected client file")
        return
    end
    local inj = file:read("*a")
    file:close()
    return inj
end)()


---@return fun(c : Context, next : fun())
local hmr = function()
    return function(c, next)
        --
        next()
        if c.res:header("Content-Type") == "application/javascript" and c.res.status == 200 then
            local content = c.res.body
            c.res:setBody(
                injected
                ..
                "\nhmrClient(import.meta);\n"
                ..
                content
            )
        end
    end
end

return hmr
