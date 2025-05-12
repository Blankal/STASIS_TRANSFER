--[[
    --A program which handles TP requests from computers--

    Made for use with a turtle
    requires a modem and end automata(preferably empty) to be attached

    LOCATION NAMES MUST BE PREFIXED WITH THE PLAYER'S NAME
    e.g. "StinkyHeadLocationName" or "QuipisLocationName"
    THEY MUST ALSO NOT BE REPEATED
    e.g. "StinkyHeadLocationName" and "StinkyHeadLocationName2" are NOT valid
    e.g. "StinkyHeadLocationName" and "StinkyHeadLocationName" are valid
  ]]

local ECORE = peripheral.find("endAutomata")
local MODEM = peripheral.find("modem")

if MODEM and ECORE then
    print()
else
    print("No modem/end automata found.")
end

rednet.open(peripheral.getName(MODEM))

local config = dofile("tpHandlerConfig.lua")
local playerIDs = config.playerIDs
local pairedLOCATIONS = config.pairedLOCATIONS

--[[ 
    Assigns LOCATIONS to IDs
  ]]
local LOCATIONS = ECORE.points() -- grab saved LOCATIONS in end automata
print(textutils.serialize(LOCATIONS))
for _, location in ipairs(LOCATIONS) do -- assigns LOCATIONS to IDs
    if string.find(location, "StinkyHead") then
        table.insert(pairedLOCATIONS['StinkyHead'],location) -- keys will come out like ["1"]["locationName"]
    elseif string.find(location, "Quipis") then
        table.insert(pairedLOCATIONS['Quipis'],location)
    end
end


--[[
    --Function to handle transfer requests from players--

    Checks if player is associated with any LOCATIONS +
    will send a reply depending

    Returns ID of client, their saved LOCATIONS and transfer message +
    sends a reply with available LOCATIONS for teleportation
  ]]
function recieveTransferRequest()
    local senderID, message, protocol = rednet.receive("transferRequest") -- message should look like "StinkyHeadLocationName,transferRequestProtocol"
    
    for playerName, LOCATIONS in pairs(pairedLOCATIONS) do -- search for player's registered LOCATIONS
        if playerIDs[playerName] == senderID then
            print("Recieved transfer request from " .. playerName .. " (ID: " .. senderID .. ").")
            return senderID, pairedLOCATIONS[playerName], message, playerName -- return ID, client's locations and client message
        else
            print("Recieved transfer request from " .. senderID .. " but no LOCATIONS were found.")
            rednet.send(senderID, "transferDeny:No LOCATIONS found.", "transferReply") -- deny + denial message
            return senderID, nil, nil
        end
    end
end

--[[
    --Function to disrupt pearl and tp player + reset--

    TEST IF IT GIVES CORRECT PLAYER USERNAME
]]
function killStasis(clientID, location, playerName)
    ECORE.warpToPoint(location)-- LOCATIONS must be named like "StinkyHeadLocationName"
    turtle.down()
    print("Warping player '" .. playerName .. "' to " .. location .. " was successful.")
    sleep(1) -- timer to ensure pearl is tapped by bot
    ECORE.warpToPoint("HOME") -- resets bot and moves out of the way
    return true
end


function transferAccept(clientLOCATIONS,clientID,message,playerName)
    for _, location in ipairs(clientLOCATIONS) do -- check if message contains a location which is saved
        print("Recieved message: " .. message)
        print("Location:" .. location)
        print("Is location in message?: " , string.find(message, location))
        if message == location then -- check if message minus playerName is a location
            rednet.send(clientID, "transferAccept", "transferReply") -- accept + confirmation message
            print("Transferring client to location " .. location)
            killStasis(clientID,location,playerName) -- tp player
            return true
        end
    end
end

--[[
    --Puts everything together for looping--
]]
function main()
    while true do
        local clientID, clientLOCATIONS, message, playerName = recieveTransferRequest() -- wait for transfer request
        if clientID and clientLOCATIONS then
            transferAccept(clientLOCATIONS,clientID,message,playerName) -- accept transfer request
            print("Remaining fuel level: " .. turtle.getFuelLevel())
            print("a")
            print("a")
        else
            print("Recieved a faulty transfer request.")
            print(clientID,clientLOCATIONS, message)
        end
        -- add auto refuel func here later
    end
end


main()

--[[
    -- WORK IN PROGRESS -- 
]]
