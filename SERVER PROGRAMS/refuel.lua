while true do
    if turtle.refuel() then
        print("Current fuel level: " .. turtle.getFuelLevel())
    end
end
