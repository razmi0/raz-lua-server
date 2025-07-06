local _getInjected = function()
    local path = debug.getinfo(1, "S").source:sub(2)
    local dir = path:match("(.*[/\\])") or ""
    local file = io.open(dir .. "_hmr-injected.js", "r")
    if not file then
        print("[ERROR]: hmr middleware could not find dev injected client file")
        return
    end
    local injected = file:read("*a")
    file:close()
    return injected
end

---@return fun(c : Context, next : fun())
local hmr = function()
    return function(c, next)
        --
        next()
        if c.res:header("Content-Type") == "application/javascript" and c.res.status == 200 then
            local content = c.res.body
            local injected = _getInjected()
            c.res:setBody(
                injected
                ..
                content
            )
        end
    end
end

return hmr
