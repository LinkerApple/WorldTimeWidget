function UpdateOffsets()
    local cities = {
        {tz = "America/Edmonton", var = "OffCal"},
        {tz = "America/Toronto", var = "OffTor"},
        {tz = "Etc/UTC", var = "OffUTC"},
        {tz = "Europe/Berlin", var = "OffBer"},
        {tz = "Europe/Kyiv", var = "OffKyi"},
        {tz = "Europe/Moscow", var = "OffMos"}
    }

    local web = SKIN:MakePathAbsolute("temp.json")
    for _, city in ipairs(cities) do
        os.execute('curl -s "https://timeapi.io/api/Time/current/zone?timeZone=' .. city.tz .. '" -o "' .. web .. '"')
        local file = io.open(web, "r")
        if file then
            local content = file:read("*all")
            file:close()
            
            local hourAPI = tonumber(content:match('"hour"%s*:%s*(%d+)'))
            local minAPI = tonumber(content:match('"minute"%s*:%s*(%d+)'))
            
            if hourAPI and minAPI then
                local totalMinAPI = (hourAPI * 60) + minAPI
                local totalMinLocal = (tonumber(os.date("%H")) * 60) + tonumber(os.date("%M"))
                
                -- Вычисляем разницу в часах как дробное число
                local offsetHours = (totalMinAPI - totalMinLocal) / 60
                
                SKIN:Bang('!SetVariable', city.var, offsetHours)
            end
        end
    end
    SKIN:Bang('!Show')
end