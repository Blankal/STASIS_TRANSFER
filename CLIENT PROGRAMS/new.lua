local basalt = require("basalt")
local config = dofile("tpConfig.lua")
local OWNER = config.OWNER
local TURTLEID = config.TURTLEID

local MODEM = peripheral.find("modem")
if MODEM then
else
    print("No modem found.")
    return
end
rednet.open(peripheral.getName(MODEM))

local points = dofile("getPoints.lua")
if points then
    points = textutils.unserialize(points) -- "points" is a table of all tp points
else
    print("No points found.")
    return
end



local main = basalt.getMainFrame()
local dropdown = main:addDropdown()
dropdown:addItem("Select a point")

local function dropdownCallback(self, index, item, pointName)
    rednet.send(TURTLEID, OWNER .. pointName, "transferRequest")
end


local userPoints = {} -- table of strings containing the points belonging to this specific user
for _, point in ipairs(points) do
    if string.find(point, OWNER) then
        table.insert(userPoints, point)
        dropdown:addItem(string.gsub(point,OWNER,""))
    end
end

dropdown:onSelect(function(self, index, item) -- item is a table, to get the text use item.text
    dropdownCallback(self, index, item, dropdown:getSelectedItem().text)
end)

basalt.run()