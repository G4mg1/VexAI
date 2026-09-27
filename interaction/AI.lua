return function (...)
    local data = {...}
    local user      = rawget(data, "username")
    local chatInput = rawget(data, "chat")
    local perm      = rawget(data, "perm")
    local cpersona  = rawget(data, "currentpersona")

    local function getRequestFunction()
        return (syn and syn.request)
            or (http and http.request)
            or http_request
            or request
            or (fluxus and fluxus.request)
            or (krnl and krnl.request)
    end

    local http       = game:GetService("HttpService")
    local getreqfunc = getRequestFunction()

    if not getreqfunc then
        warn("your executor does not support HTTP requests.")
        return
    end

    print("your executor support huggingface provider ! ")

    local HF_API_KEY = getgenv().userdata.gethfkey()
    local MODEL_ID   = "openai/gpt-oss-120b:fireworks-ai"
    local API_URL    = "https://router.huggingface.co/v1/chat/completions"

    local history = {
        { role = "system", content = cpersona or getgenv().userdata.getpersona() }
    }

    local function chat(userMessage)
        table.insert(history, { role = "user", content = userMessage })

        local payload = {
            model = MODEL_ID,
            messages = history,
            stream = false,
        }

        local ok, res = pcall(function()
            return getreqfunc({
                Url = API_URL,
                Method = "POST",
                Headers = {
                    ["Authorization"] = HF_API_KEY,
                    ["Content-Type"]  = "application/json",
                },
                Body = http:JSONEncode(payload),
            })
        end)

        if not ok then warn("HTTP request failed:", res); return nil end
        if res.StatusCode ~= 200 then
            warn("API error " .. res.StatusCode .. ": " .. tostring(res.Body))
            return nil
        end

        local decoded
        local decodeOk, decodeErr = pcall(function()
            decoded = http:JSONDecode(res.Body)
        end)
        if not decodeOk then warn("JSON decode failed:", decodeErr); return nil end

        local reply = decoded
            and decoded.choices
            and decoded.choices[1]
            and decoded.choices[1].message
            and decoded.choices[1].message.content

        if not reply then warn("Unexpected response:", res.Body); return nil end

        table.insert(history, { role = "assistant", content = reply })
        return reply
    end

    return {
        chat    = chat,
        history = history,
        parent  = script.Parent,
        user    = user,
        perm    = perm,
    }
end