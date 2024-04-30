local isOnDuty = false

-- Function to check if the player is on-duty with Qb-Policejob
function CheckDutyStatus()
    local playerData = QBCore.Functions.GetPlayerData()
    if playerData and playerData.job and playerData.job.name == 'police' then
        isOnDuty = true
    else
        isOnDuty = false
    end
end

-- Function to notify the player using Qb-Notification
function Notify(message)
    QBCore.Functions.Notify(message, 'success')
end

-- Function to pull over the vehicle in front of the player
function PullOverVehicle()
    local playerPed = PlayerPedId()
    local vehicleAhead = GetVehicleInFront()

    if DoesEntityExist(vehicleAhead) and not IsPedInAnyVehicle(GetPedInVehicleSeat(vehicleAhead, -1), false) then
        TaskVehicleFollowWaypointRecording(playerPed, vehicleAhead, "WORLD_HUMAN_COP_IDLES", 0, 5, 15)
        Notify('NPC vehicle is pulling over.')
    else
        Notify('No NPC vehicle in front to pull over.')
    end
end

-- Function to pull over an NPC pedestrian in front of the player
function PullOverNPC()
    local playerPed = PlayerPedId()
    local targetPed = GetPedInFront()

    if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) then
        TaskHandsUp(targetPed, 1000, PlayerPedId(), 1000, 0)
        Notify('NPC pedestrian is complying.')
    else
        Notify('No NPC pedestrian in front to pull over.')
    end
end

-- Function to get the vehicle directly in front of the player's vehicle
function GetVehicleInFront()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local playerOffset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
    local rayHandle = StartShapeTestCapsule(playerPos.x, playerPos.y, playerPos.z, playerOffset.x, playerOffset.y, playerOffset.z, 2.5, 10, playerPed, 7)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
    return vehicle
end

-- Function to get the NPC pedestrian directly in front of the player
function GetPedInFront()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local playerOffset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.5, 0.0)
    local rayHandle = StartShapeTestCapsule(playerPos.x, playerPos.y, playerPos.z, playerOffset.x, playerOffset.y, playerOffset.z, 2.0, 10, playerPed, 511)
    local _, _, _, _, ped = GetShapeTestResult(rayHandle)
    return ped
end

-- MenuV event handler for F11 key press to open the menu
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if IsControlJustPressed(0, 344) then -- 344 is the INPUT_REPLAY_SHOWHOTKEY (F11 key)
            CheckDutyStatus()
            
            if isOnDuty then
                local elements = {
                    { label = 'Pull Over Vehicle', value = 'pull_vehicle' },
                    { label = 'Pull Over NPC', value = 'pull_npc' }
                }

                MenuV:OpenMenu({
                    title = 'Police Options',
                    sub_title = 'Select an action:',
                    button = {
                        enabled = true,
                        type = 'triggered',
                        button_id = 344
                    },
                    elements = elements
                })
            else
                Notify('You are not on duty as a police officer.')
            end
        end
    end
end)

-- MenuV event handler for menu selection
MenuV:OnMenuSelect(function(data, menuData)
    if data['current']['value'] == 'pull_vehicle' then
        PullOverVehicle()
    elseif data['current']['value'] == 'pull_npc' then
        PullOverNPC()
    end
end)
