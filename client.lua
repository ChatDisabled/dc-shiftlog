local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('qb-shiftlog:server:OnPlayerUnload')
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(Player)
    if PlayerData.job.name ~= Player.job.name or PlayerData.job.onduty ~= Player.job.onduty then
        TriggerServerEvent('qb-shiftlog:server:SetPlayerData', Player)
        PlayerData = Player
    end
end)
