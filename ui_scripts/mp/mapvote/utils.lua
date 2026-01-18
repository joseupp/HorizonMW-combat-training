Utils = {}

function Utils.formatMapName(map)
    local mapname = map:gsub('mp_', ''):gsub('_', ' '):gsub('^%l', string.upper)
    return Engine.Localize("@MPUI_" .. mapname)
end

function Utils.formatGameMode(gamemode)
    return Engine.Localize("@MPUI_" .. gamemode)
end


function Utils.getLoadscreen(map)
    if map == "mp_skidrow" then
        map = "mp_nightshift"
    end
    if map == "mp_plaza2" then
        map = "mp_plaza2ab"
    end

    return 'loadscreen_' .. map
end
