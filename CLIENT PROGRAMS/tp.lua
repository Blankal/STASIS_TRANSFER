--[[
    --A program which sends TP requests to a bot with the program "tpHandler.lua" running--

    Intended for use with a pocket computer
    Requires a modem
  ]]
local config = dofile("tpConfig.lua")
local OWNER = config.OWNER -- owner of pocket computer
local TURTLEID = config.TURTLEID -- ID# of server turtle

local MODEM = peripheral.find("modem")
if MODEM then
    print()
else
    print("No modem found.")
    return
end

rednet.open(peripheral.getName(MODEM))

while true do
    io.write("Enter warp point name: ")
    local input = io.read()
    if input and input ~= "" then
        local locationName = input
        print("")
        break
    else
        print("No location name provided.")
    end
end

-- handles transfer responses
print("Sending transfer request")
rednet.send(TURTLEID, OWNER .. locationName, "transferRequest")
local senderID, message, protocol = rednet.receive("transferReply")
if message == "transferAccept" then
    print("Transfer accepted, teleporting now.")
elseif string.sub(message,1,12) == "transferDeny" then
    print("Transfer denied, reason: " .. string.sub(message,13))
else
    print("Unknown response: " .. message)
end


