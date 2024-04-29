RegisterCommand("pullvehicleover", function(source, args)
    local player = source
    local playerId = GetPlayerIdentifier(player, 0)
    local playerPed = GetPlayerPed(player)
    local jobName = QBCore.Functions.GetPlayerData().job.name

    if jobName == 'police' then
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicleAhead = GetVehicleInFront()

            if DoesEntityExist(vehicleAhead) and not IsPedInAnyVehicle(GetPedInVehicleSeat(vehicleAhead, -1), false) then
                TriggerClientEvent('pullOverVehicle', -1, vehicleAhead)
            else
                TriggerClientEvent('chat:addMessage', player, { args = { '^1Error', 'No vehicle in front to pull over.' } })
            end
        else
            TriggerClientEvent('chat:addMessage', player, { args = { '^1Error', 'You are not in a vehicle.' } })
        end
    else
        TriggerClientEvent('chat:addMessage', player, { args = { '^1Error', 'You are not a police officer.' } })
    end
end)

function GetVehicleInFront()
    local playerPed = GetPlayerPed(-1)
    local playerPos = GetEntityCoords(playerPed)
    local playerOffset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
    local rayHandle = StartShapeTestCapsule(playerPos.x, playerPos.y, playerPos.z, playerOffset.x, playerOffset.y, playerOffset.z, 2.5, 10, playerPed, 7)

    SetEntityVisible(playerPed, false)

    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
    
    SetEntityVisible(playerPed, true)

    return vehicle
end
