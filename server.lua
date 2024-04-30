RegisterServerEvent('checkPlayerDuty')
AddEventHandler('checkPlayerDuty', function()
    local player = source
    local playerData = QBCore.Functions.GetPlayerData(player)

    if playerData and playerData.job and playerData.job.name == 'police' then
        TriggerClientEvent('playerOnDuty', player, true)
    else
        TriggerClientEvent('playerOnDuty', player, false)
    end
end)
