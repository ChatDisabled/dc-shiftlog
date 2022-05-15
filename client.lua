local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('qb-shiftlog:server:OnPlayerUnload')
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(Player)
    if not Player then return end
    if not PlayerData then return end
    if PlayerData.job.name ~= Player.job.name or PlayerData.job.onduty ~= Player.job.onduty then
        TriggerServerEvent('qb-shiftlog:server:SetPlayerData', Player)
        PlayerData = Player
    end
end)
