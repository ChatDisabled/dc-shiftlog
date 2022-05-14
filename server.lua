local QBCore = exports['qb-core']:GetCoreObject()
local OnlinePlayers = {}

local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    OnlinePlayers[#OnlinePlayers + 1] = {
        Name = GetPlayerName(Player.PlayerData.source),
        CID = Player.PlayerData.citizenid,
        Job = Player.PlayerData.job.label,
        Duty = Player.PlayerData.job.onduty,
        StartDate = os.date("%d/%m/%Y %H:%M:%S"),
        StartTime = os.time()
    }
end)

RegisterNetEvent('qb-shiftlog:server:OnPlayerUnload', function()
    local src = source
    local Player = OnlinePlayers[src]

    if not Player then return end -- if this is somehow still nill

    if Player.Duty then
        TriggerEvent('qb-log:server:CreateLog', 'shiftlog', 'Shift Log', 'green',
        string.format("**%s** (CitizenID: %s | ID: %s) - Started (his/her) shift at %s. Stopped working at %s. (His/Her) job is %s and duration was %s minutes",
        Player.Name, Player.CID, src, Player.StartDate, os.date("%d/%m/%Y %H:%M:%S"), Player.Job, round(os.difftime(os.time(), Player.StartTime) / 60, 2)))
    end
end)

AddEventHandler("playerDropped", function()
    local src = source
    local Player = OnlinePlayers[src]

    if not Player then return end -- if this is somehow still nill

    if Player.Duty then
        TriggerEvent('qb-log:server:CreateLog', 'shiftlog', 'Shift Log', 'green',
        string.format("**%s** (CitizenID: %s | ID: %s) - Started (his/her) shift at %s. Stopped working at %s. (His/Her) job is %s and duration was %s minutes",
        Player.Name, Player.CID, src, Player.StartDate, os.date("%d/%m/%Y %H:%M:%S"), Player.Job, round(os.difftime(os.time(), Player.StartTime) / 60, 2)))
    end
end)

RegisterNetEvent('qb-shiftlog:server:SetPlayerData', function(NewPlayer)
    local src = source
    local OldPlayer = OnlinePlayers[src]

    if not OldPlayer then return end -- if this is somehow still nill

    --- Check if the job has changed
    if NewPlayer.job.label ~= OldPlayer.Job then
        if OldPlayer.Duty then
            TriggerEvent('qb-log:server:CreateLog', 'shiftlog', 'Shift Log', 'green',
            string.format("**%s** (CitizenID: %s | ID: %s) - Started (his/her) shift at %s. Stopped working at %s. (His/Her) job is %s and duration was %s minutes",
            OldPlayer.Name, OldPlayer.CID, src, OldPlayer.StartDate, os.date("%d/%m/%Y %H:%M:%S"), OldPlayer.Job, round(os.difftime(os.time(), OldPlayer.StartTime) / 60, 2)))
            OnlinePlayers[src] = {Name = GetPlayerName(NewPlayer.source), CID = NewPlayer.citizenid, Job = NewPlayer.job.label, Duty = NewPlayer.job.onduty, StartDate = os.date("%d/%m/%Y %H:%M:%S"), StartTime = os.time()}
        else
            OnlinePlayers[src] = {Name = GetPlayerName(NewPlayer.source), CID = NewPlayer.citizenid, Job = NewPlayer.job.label, Duty = NewPlayer.job.onduty, StartDate = os.date("%d/%m/%Y %H:%M:%S"), StartTime = os.time()}
        end
    end

    --- Check if the duty has changed.
    if not NewPlayer.job.onduty and OldPlayer.Duty then
        TriggerEvent('qb-log:server:CreateLog', 'shiftlog', 'Shift Log', 'green',
        string.format("**%s** (CitizenID: %s | ID: %s) - Started (his/her) shift at %s. Stopped working at %s. (His/Her) job is %s and duration was %s minutes",
        OldPlayer.Name, OldPlayer.CID, src, OldPlayer.StartDate, os.date("%d/%m/%Y %H:%M:%S"), OldPlayer.Job, round(os.difftime(os.time(), OldPlayer.StartTime) / 60, 2)))
        OnlinePlayers[src] = {Name = GetPlayerName(NewPlayer.source), CID = NewPlayer.citizenid, Job = NewPlayer.job.label, Duty = NewPlayer.job.onduty, StartDate = os.date("%d/%m/%Y %H:%M:%S"), StartTime = os.time()}
    elseif not OldPlayer.Duty and NewPlayer.job.onduty then
        OnlinePlayers[src] = {Name = GetPlayerName(NewPlayer.source), CID = NewPlayer.citizenid, Job = NewPlayer.job.label, Duty = NewPlayer.job.onduty, StartDate = os.date("%d/%m/%Y %H:%M:%S"), StartTime = os.time()}
    end
end)
