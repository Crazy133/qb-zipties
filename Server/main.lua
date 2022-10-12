local QBCore = exports['qb-core']:GetCoreObject()


--==USEUABLE ITEMS==--

QBCore.Functions.CreateUseableItem('headbag', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local HasHeadbag = QBCore.Functions.HasItem(src, 'headbag')
    if not HasHeadbag then return end
    TriggerClientEvent('Crazy:Client:UseHeadBag', src)
end)

QBCore.Functions.CreateUseableItem('ziptie', function(source) 
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    local HasZiptie = QBCore.Functions.HasItem(src, 'ziptie')
    if not HasZiptie then return end
    TriggerClientEvent('Crazy:Client:UseZiptie', src)
end)
--==END OF USEABLE ITEMS==--


--==ZIPTIE==--

RegisterNetEvent('Crazy:Server:ZiptiePlayer', function(playerId)
    local src = source
    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed)
    local targetCoords = GetEntityCoords(targetPed)
    
    if #(playerCoords - targetCoords) > 2.5 then return TriggerEvent("qb-log:server:CreateLog", "anticheat", "Crazy-Kidnapping: Distance > 2.5", "orange", string.format("User: ** %s **\nIdentifier: ** %s **\nCitizenId: ** %s **\nServer Id: ** %s **", GetPlayerName(src), GetPlayerIdentifier(src, fivem), Player.PlayerData.citizenid, src)) end
    local Player = QBCore.Functions.GetPlayer(src)
    local ZiptiedPlayer = QBCore.Functions.GetPlayer(playerId)
    
    local HasZiptie = QBCore.Functions.HasItem(src, 'ziptie')
    if HasZiptie then
        if Player.Functions.RemoveItem('ziptie', 1) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['ziptie'], 'remove')
            TriggerClientEvent("Crazy:Client:GetZiptied", ZiptiedPlayer.PlayerData.source, Player.PlayerData.source)
        end
    end    
end)


RegisterNetEvent('Crazy:Server:UnZiptie', function(TargetId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local UnZiptiedPlayer = QBCore.Functions.GetPlayer(TargetId)
    local PlayerPed = GetPlayerPed(src)
    local TargetPed = GetPlayerPed(TargetId)
    local uzpPos = GetEntityCoords(TargetPed)
    local pPos = GetEntityCoords(PlayerPed)
    local Distance = #(pPos - uzpPos)
    local HasItems = QBCore.Functions.HasItem(src, Config.UnZipItems)
    
    if Distance > 2.5 then return TriggerEvent("qb-log:server:CreateLog", "anticheat", "Crazy-Kidnapping: Distance > 2.5", "orange", string.format("User: ** %s **\nIdentifier: ** %s **\nCitizenId: ** %s **\nServer Id: ** %s **", GetPlayerName(src), GetPlayerIdentifier(src, fivem), Player.PlayerData.citizenid, src)) end
    if HasItems then
        TriggerClientEvent('Crazy:Client:GetUnZiptied', UnZiptiedPlayer.PlayerData.source, Player.PlayerData.source)
    end
end)
--==END OF ZIPTIE==--





--==BAG==--

RegisterNetEvent('Crazy:Server:PutBagOn', function(TargetId) -- (Good)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(TargetId)
    
    local PlayerPed = GetPlayerPed(src)
    local TargetPed = GetPlayerPed(TargetId)
    local TargetPedCoords = GetEntityCoords(TargetPed)
    local PlayerPedCoords = GetEntityCoords(PlayerPed)
    local Distance = #(PlayerPedCoords - TargetPedCoords)

    if Distance > 2.5 then return end
    local HasBag = QBCore.Functions.HasItem(src, 'headbag')
    if HasBag then
        if Player.Functions.RemoveItem('headbag', 1) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['headbag'], 'remove')
            TriggerClientEvent('Crazy:Client:GetBagOnHead', Target.PlayerData.source, Player.PlayerData.source)
        end
    end
end)

RegisterNetEvent('Crazy:Server:BagOff', function(TargetId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(TargetId)
    

    TriggerClientEvent('Crazy:Client:GetBagOff', Target.PlayerData.source, Player.PlayerData.source)
end)
--==END OF BAG==--
