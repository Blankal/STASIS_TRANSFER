--[[
    --A program which returns a list of points the user can teleport to--

    Intended for use with "tpHandler.lua" and "tp.lua"
    Requires a modem
  ]]

local config = dofile("tpConfig.lua")
local TURTLEID = config.TURTLEID

local MODEM = peripheral.find("modem")
if MODEM then
    print()
else
    print("No modem found.")
    return
end

rednet.open(peripheral.getName(MODEM))

function getPoints()
    rednet.send(TURTLEID, "getPoints", "getPoints")
    local id, message = rednet.receive("givePoints")

    if string.sub(message,1,13) == "getPointsDeny" then
        print("Request denied, reason:" .. string.sub(message,15))
        return nil
    else
        return message
    end
end

return getPoints()
