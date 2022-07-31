local QBCore = exports['qb-core']:GetCoreObject()
local OnlinePlayers = {}
local Jobs = { --- Add specific jobs here to check. So that unemployed etc doesn't get logged. Don't forget to update the leaderboard down below.
    'police',
    'ambulance',
    'realestate'
}

--- Standard round function
local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function HasJob(Job)
    for i = 1, #Jobs do
        if Jobs[i] == Job then
            return true
        end
    end
    return false
end

--- As requested to make it easier to seperate jobs to certain logs. As you can see this just uses `qb-log:CreateLog` event. Simply change the unique name
--- of the webhook as seen here. 'shiftlogPolice', 'shiftlogAmbulance', etc. Update your qb-logs resource accordingly. Add as many in here as you want.
local function CreateLog(Player, source)
    if Player.Job == 'police' then
        TriggerEvent('qb-log:server:CreateLog', 'shiftlogPolice', 'Shift Log Police', 'green',
        string.format("**%s** (CitizenID: %s | ID: %s) \n**Name:** %s \n**Started Shift:** %s. \n**Stopped Shift:** %s. \n**Job:** %s \n**Duration:** %s minutes",
        Player.Name, Player.CID, source, Player.ICName, Player.StartDate, os.date("%d/%m/%Y %H:%M:%S"), Player.Label, round(os.difftime(os.time(), Player.StartTime) / 60, 2)))
    elseif Player.Job == 'ambulance' then
        TriggerEvent('qb-log:server:CreateLog', 'shiftlogAmbulance', 'Shift Log EMS', 'green',
        string.format("**%s** (CitizenID: %s | ID: %s) \n**Name:** %s \n**Started Shift:** %s. \n**Stopped Shift:** %s. \n**Job:** %s \n**Duration:** %s minutes",
        Player.Name, Player.CID, source, Player.ICName, Player.StartDate, os.date("%d/%m/%Y %H:%M:%S"), Player.Label, round(os.difftime(os.time(), Player.StartTime) / 60, 2)))
    elseif Player.Job == 'realestate' then
        TriggerEvent('qb-log:server:CreateLog', 'shiftlogRealestate', 'Shift Log Realestate', 'green',
        string.format("**%s** (CitizenID: %s | ID: %s) \n**Name:** %s \n**Started Shift:** %s. \n**Stopped Shift:** %s. \n**Job:** %s \n**Duration:** %s minutes",
        Player.Name, Player.CID, source, Player.ICName, Player.StartDate, os.date("%d/%m/%Y %H:%M:%S"), Player.Label, round(os.difftime(os.time(), Player.StartTime) / 60, 2)))
    end
end

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    if not HasJob(Player.PlayerData.job.name) then return end
    OnlinePlayers[#OnlinePlayers + 1] = {
        Name = GetPlayerName(Player.PlayerData.source),
        ICName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
        CID = Player.PlayerData.citizenid,
        Job = Player.PlayerData.job.name,
        Label = Player.PlayerData.job.label,
        Duty = Player.PlayerData.job.onduty,
        StartDate = os.date("%d/%m/%Y %H:%M:%S"),
        StartTime = os.time()
    }
end)

RegisterNetEvent('qb-shiftlog:server:OnPlayerUnload', function()
    local src = source
    local Player = OnlinePlayers[src]

    if not Player then return end -- if this is somehow still nill
    if not HasJob(Player.Job) then return end

    if Player.Duty then
        CreateLog(Player, src)
        local JobCurrentTime = GetResourceKvpFloat(Player.Job)
        JobTotalTime = JobCurrentTime + os.difftime(os.time(), Player.StartTime) / 60
        SetResourceKvpFloat(Player.Job, JobTotalTime)
    end
end)

AddEventHandler("playerDropped", function()
    local src = source
    local Player = OnlinePlayers[src]

    if not Player then return end -- if this is somehow still nill
    if not HasJob(Player.Job) then return end

    if Player.Duty then
        CreateLog(Player, src)
        local JobCurrentTime = GetResourceKvpFloat(Player.Job)
        JobTotalTime = JobCurrentTime + os.difftime(os.time(), Player.StartTime) / 60
        SetResourceKvpFloat(Player.Job, JobTotalTime)
    end
end)

RegisterNetEvent('qb-shiftlog:server:SetPlayerData', function(NewPlayer)
    local src = source
    local OldPlayer = OnlinePlayers[src]

    if not OldPlayer then return end -- if this is somehow still nill

    --- Check if the job has changed
    if NewPlayer.job.label ~= OldPlayer.Label then
        if OldPlayer.Duty then
            OnlinePlayers[src] = {Name = GetPlayerName(NewPlayer.source), ICName = NewPlayer.charinfo.firstname.. ' ' ..NewPlayer.charinfo.lastname, CID = NewPlayer.citizenid, Job = NewPlayer.job.name, Label = NewPlayer.job.label, Duty = NewPlayer.job.onduty, StartDate = os.date("%d/%m/%Y %H:%M:%S"), StartTime = os.time()}
            if not HasJob(OldPlayer.Job) then return end
            CreateLog(OldPlayer, src)
            local JobCurrentTime = GetResourceKvpFloat(OldPlayer.Job)
            JobTotalTime = JobCurrentTime + os.difftime(os.time(), OldPlayer.StartTime )/ 60
            SetResourceKvpFloat(OldPlayer.Job, JobTotalTime)
        else
            OnlinePlayers[src] = {Name = GetPlayerName(NewPlayer.source), ICName = NewPlayer.charinfo.firstname.. ' ' ..NewPlayer.charinfo.lastname, CID = NewPlayer.citizenid, Job = NewPlayer.job.name, Label = NewPlayer.job.label, Duty = NewPlayer.job.onduty, StartDate = os.date("%d/%m/%Y %H:%M:%S"), StartTime = os.time()}
        end
    end

    --- Check if the duty has changed.
    if not NewPlayer.job.onduty and OldPlayer.Duty then
        OnlinePlayers[src] = {Name = GetPlayerName(NewPlayer.source), ICName = NewPlayer.charinfo.firstname.. ' ' ..NewPlayer.charinfo.lastname, CID = NewPlayer.citizenid, Job = NewPlayer.job.name, Label = NewPlayer.job.label, Duty = NewPlayer.job.onduty, StartDate = os.date("%d/%m/%Y %H:%M:%S"), StartTime = os.time()}
        if not HasJob(OldPlayer.Job) then return end
        CreateLog(OldPlayer, src)
        local JobCurrentTime = GetResourceKvpFloat(OldPlayer.Job)
        JobTotalTime = JobCurrentTime + os.difftime(os.time(), OldPlayer.StartTime) / 60
        SetResourceKvpFloat(OldPlayer.Job, JobTotalTime)
    elseif not OldPlayer.Duty and NewPlayer.job.onduty then
        OnlinePlayers[src] = {Name = GetPlayerName(NewPlayer.source), ICName = NewPlayer.charinfo.firstname.. ' ' ..NewPlayer.charinfo.lastname, CID = NewPlayer.citizenid, Job = NewPlayer.job.name, Label = NewPlayer.job.label, Duty = NewPlayer.job.onduty, StartDate = os.date("%d/%m/%Y %H:%M:%S"), StartTime = os.time()}
    end
end)

CreateThread(function()
    while true do
        local JobCurrentTimes = {}
        for i = 1, #Jobs do
            JobCurrentTimes[i] = {
                Name = Jobs[i],
                Time = GetResourceKvpFloat(Jobs[i])
            }
        end
        table.sort(JobCurrentTimes, function(a, b) return a.Time > b.Time end)
        TriggerEvent('qb-log:server:CreateLog', 'shiftlogJobLeaderboard', 'Shift Log Job Leaderboard', 'green',
        string.format("1. %s | %s minutes \n2. %s | %s minutes \n3. %s | %s minutes",
        JobCurrentTimes[1].Name, round(JobCurrentTimes[1].Time, 2), JobCurrentTimes[2].Name, round(JobCurrentTimes[2].Time, 2), JobCurrentTimes[3].Name, round(JobCurrentTimes[3].Time, 2)))
        Wait(720000) -- Post log every 12 minutes
    end
end)

--- Example on how to increase the leaderboard if you want to add more jobs

-- TriggerEvent('qb-log:server:CreateLog', 'shiftlogJobLeaderboard', 'Shift Log Job Leaderboard', 'green',
-- string.format("1. %s | %s minutes \n2. %s | %s minutes \n3. %s | %s minutes \n4. %s | %s minutes \n5. %s | %s minutes \n6. %s | %s minutes \n7. %s | %s minutes \n8. %s | %s minutes",
-- JobCurrentTimes[1].Name, round(JobCurrentTimes[1].Time, 2), JobCurrentTimes[2].Name, round(JobCurrentTimes[2].Time, 2), JobCurrentTimes[3].Name, round(JobCurrentTimes[3].Time, 2), JobCurrentTimes[4].Name, round(JobCurrentTimes[4].Time, 2),
-- JobCurrentTimes[5].Name, round(JobCurrentTimes[5].Time, 2), JobCurrentTimes[6].Name, round(JobCurrentTimes[6].Time, 2), JobCurrentTimes[7].Name, round(JobCurrentTimes[7].Time, 2), JobCurrentTimes[8].Name, round(JobCurrentTimes[8].Time, 2)))
