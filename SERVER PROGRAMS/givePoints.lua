--[[
    A program which serves teleportation points to a client
]]

local ECORE = peripheral.find("endAutomata")
local MODEM = peripheral.find("modem")
if MODEM and ECORE then
    print()
else
    print("No modem/end automata found.")
end
rednet.open(peripheral.getName(MODEM))

while true do
    local id, message = rednet.receive("getPoints")
    if message == "getPoints" then
        local points = ECORE.points()
        print(points)
        if points then
            rednet.send(id, textutils.serialize(points), "givePoints")
        else
            rednet.send(id, "getPointsDeny:Points do not exist", "givePoints")
        end
    else
        rednet.send(id, "getPointsDeny:Points do not exist.", "givePoints")
    end
end