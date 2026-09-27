return function(Settings)
    local P = {}

    function P.get(key)
        return Settings.raw().perms[key] == true
    end

    function P.set(key, val)
        Settings.raw().perms[key] = val
        Settings.save()
    end

    function P.guard(key, fn, onDenied)
        if P.get(key) then return fn() end
        if onDenied then onDenied() end
        return nil
    end

    return P
end