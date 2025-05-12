ECORE = peripheral.find("endAutomata")

print("CURRENTLY INSTALLED POINTS:")
print(textutils.serialize(ECORE.points(),{compact = true}))
print(" ")

io.write("Add new point?: y/n")
userAddPoint = io.read()
if userAddPoint == "y" or userAddPoint == "Y" then
    io.write("Input point name, leave blank to cancel.")
    print("")
    userPointName = io.read()
    if userPointName then
        if ECORE.savePoint(userPointName) then
            print("Point '" .. userPointName .. "' has been added.")
        else
            print("Point could not be added.")
        end
    else
        print("Request canceled.")
        return
    end
elseif userAddPoint == "n" or userAddPoint == "N" then
    return
else
    print("Invalid response.")
end