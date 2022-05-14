RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('qb-shiftlog:server:OnPlayerUnload')
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(Player)
    TriggerServerEvent('qb-shiftlog:server:SetPlayerData', Player)
end)
