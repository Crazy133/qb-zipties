local QBCore = exports['qb-core']:GetCoreObject()
local BagOnHead = false
local isZiptied = false
local OGOutfit = {}

--! ^ Dont Touch ^ !--


--==FUNCTIONS==--

local function loadAnimDict(dict) -- interactions, job,
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

local function GetZiptiedAnimation(playerId)
    local ped = PlayerPedId()
    local ziptier = GetPlayerPed(GetPlayerFromServerId(playerId))
    local heading = GetEntityHeading(ziptier)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "Cuff", 0.2)
    loadAnimDict("mp_arrest_paired")
    SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(ziptier, 0.0, 0.45, 0.0))

	Wait(100)
	SetEntityHeading(ped, heading)
	TaskPlayAnim(ped, "mp_arrest_paired", "crook_p2_back_right", 3.0, 3.0, -1, 32, 0, 0, 0, 0 ,true, true, true)
	Wait(2500)
end

local function ZiptieAnimation()
    local ped = PlayerPedId()
    
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "Cuff", 0.2)


    loadAnimDict("mp_arrest_paired")
	Wait(100)
    TaskPlayAnim(ped, "mp_arrest_paired", "cop_p2_back_right", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "Cuff", 0.2)
	Wait(3500)
    TaskPlayAnim(ped, "mp_arrest_paired", "exit", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
end

local function BagWiggle()
    TriggerEvent('Crazy:Client:BagWiggle')
end
--==END OF FUNCTIONS==--











--==HEAD BAG SECTION==--
RegisterNetEvent('Crazy:Client:UseHeadBag', function()
    local Target = QBCore.Functions.GetClosestPlayer()
    local TargetId = GetPlayerServerId(Target)
    local TargetPed = GetPlayerPed(Target)
    local HasBag = QBCore.Functions.HasItem('headbag')
    
    if  not IsEntityPlayingAnim(TargetPed, "mp_arresting", "idle", 3) then return QBCore.Functions.Notify(Lang:t('error.cant_bag'), 'error', 3000) end
    if not HasBag then return QBCore.Functions.Notify(Lang:t('error.missing_item'), 'error', 3000) end 
    TriggerServerEvent('Crazy:Server:PutBagOn', TargetId)
    CrazyBagOff = exports['qb-radialmenu']:AddOption({
        id = 'crzbagoff',
        title = 'Remove Bag',
        icon = 'mask',
        type = 'client',
        event = 'Crazy:Client:BagOff',
        shouldClose = true,
    })
end)

RegisterNetEvent('Crazy:Client:GetBagOnHead', function(TargetId) -- Other Player
    local ped = PlayerPedId()
    QBCore.Functions.Notify(Lang:t('info.bagged'), 'primary', 3000)
    DoScreenFadeOut(0)
    BagOnHead = true -- unused atm
    OGOutfit.draw = GetPedDrawableVariation(PlayerPedId(), 1)
    OGOutfit.tex = GetPedTextureVariation(PlayerPedId(), 1)
    SetPedComponentVariation(PlayerPedId(), 1, Config.BagSelection, Config.BagTexture, 0)

    CrazyTakeBagOff = exports['qb-radialmenu']:AddOption({
        id = 'crazy-takebagoff',
        title = 'Take Off Head Covering',
        icon = 'mask',
        type = 'client',
        event = 'Crazy:Client:TakeBagOff',
        shouldClose = true
    })
    SetTimeout((Config.BagFallOffWait * 60000), BagWiggle)
end)

RegisterNetEvent('Crazy:Client:BagOff', function()
    local Target = QBCore.Functions.GetClosestPlayer()
    local TargetId = GetPlayerServerId(Target)

    TriggerServerEvent('Crazy:Server:BagOff', TargetId)
    exports['qb-radialmenu']:RemoveOption(CrazyBagOff)
    CrazyBagOff = nil
end)

RegisterNetEvent('Crazy:Client:GetBagOff', function(TargetId) -- Other Player
    QBCore.Functions.Notify(Lang:t('released.bag_off'), 'success', 3000)
    DoScreenFadeIn(0)
    SetPedComponentVariation(PlayerPedId(), 1, OGOutfit.draw, OGOutfit.tex, 0)
    exports['qb-radialmenu']:RemoveOption(CrazyTakeBagOff)
    CrazyTakeBagOff = nil
end)

RegisterNetEvent('Crazy:Client:TakeBagOff', function() -- Self
    QBCore.Functions.Notify(Lang:t('released.bag_off'), 'success', 3000)
    DoScreenFadeIn(0)
    SetPedComponentVariation(PlayerPedId(), 1, OGOutfit.draw, OGOutfit.tex, 0)
    exports['qb-radialmenu']:RemoveOption(CrazyTakeBagOff)
    CrazyTakeBagOff = nil
end)

RegisterNetEvent('Crazy:Client:BagWiggle', function() -- Self
    QBCore.Functions.Notify(Lang:t('released.wigglebag'), 'success', 3000)
    DoScreenFadeIn(0)
    SetPedComponentVariation(PlayerPedId(), 1, OGOutfit.draw, OGOutfit.tex, 0)
end)
--==END OF HEAD BAG SECTION==--














--==ZIPTIE SECTION==--
RegisterNetEvent('Crazy:Client:UseZiptie', function()
    local HasZiptie = QBCore.Functions.HasItem('ziptie')
    local Player = QBCore.Functions.GetClosestPlayer()
    local TargetId = GetPlayerServerId(Player)
    local TargetPed = GetPlayerPed(Player)

    if not HasZiptie then return QBCore.Functions.Notify(Lang:t('error.missing_item'), 'error', 3000) end
    if  (not IsEntityPlayingAnim(TargetPed, "missminuteman_1ig_2", "handsup_base", 3)) or isZiptied then return QBCore.Functions.Notify(Lang:t('error.cant_zip'), 'error', 3000) end

    if not IsPedRagdoll(PlayerPedId()) then
        if Player ~= -1 then
            local PlayerId = GetPlayerServerId(Player)
            if not IsPedInAnyVehicle(GetPlayerPed(Player)) and not IsPedInAnyVehicle(PlayerPedId()) then
                TriggerServerEvent("Crazy:Server:ZiptiePlayer", PlayerId)
                ZiptieAnimation()
            else
                QBCore.Functions.Notify("error.vehicle_zip", "error")
            end
        else
            QBCore.Functions.Notify("error.none_nearby", "error")
        end
    else
        Wait(2000)
    end
    CrazyZipOff = exports['qb-radialmenu']:AddOption({
        id = 'crzzipoff',
        title = 'Cut Ziptie',
        icon = 'hands-bound',
        type = 'client',
        event = 'Crazy:Client:ZipOff',
        shouldClose = true,
    })
end)

RegisterNetEvent('Crazy:Client:GetZiptied', function(playerId) -- Other Player
    local ped = PlayerPedId()
    if not isZiptied then
        isZiptied = true
        TriggerServerEvent("police:server:SetHandcuffStatus", isZiptied)
        ClearPedTasksImmediately(ped)
        if GetSelectedPedWeapon(ped) ~= `WEAPON_UNARMED` then
            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        end
        GetZiptiedAnimation(playerId)
        
        cuffType = 49
        QBCore.Functions.Notify(Lang:t('info.wiggle'), 'primary')
    end
end)

RegisterNetEvent('Crazy:Client:ZipOff', function()
    local Target, Distance = QBCore.Functions.GetClosestPlayer()
    local TargetId = GetPlayerServerId(Target)

    local HasItems = QBCore.Functions.HasItem(Config.UnZipItems)
    if not HasItems then return QBCore.Functions.Notify(Lang:t('error.no_zip_item'), 'error', 3000) end 

    if Distance > 2.5 then return end
    TriggerServerEvent('Crazy:Server:UnZiptie', TargetId)
    ZiptieAnimation()
    exports['qb-radialmenu']:RemoveOption(CrazyZipOff)
    CrazyZipOff = nil
end)

RegisterNetEvent('Crazy:Client:GetUnZiptied', function(TargetId) -- Other Player
    local Ped = PlayerPedId()
    if isZiptied then
        GetZiptiedAnimation(TargetId)
        isZiptied = false
        TriggerServerEvent("police:server:SetHandcuffStatus", isZiptied)
        ClearPedTasksImmediately(Ped)
    end
    QBCore.Functions.Notify(Lang:t('released.zipoff'), 'success', 3000)
end)

RegisterNetEvent('Crazy:Client:ZiptieWiggle', function()
    local Player = PlayerPedId()
    isZiptied = false
    TriggerServerEvent("police:server:SetHandcuffStatus", false)
    ClearPedTasksImmediately(Player)
    QBCore.Functions.Notify(Lang:t('released.wigglezip'), 'success', 3000)
end)

--==END OF ZIPTIE SECTION==--




--==THREAD / DEBUG==--
local ReleaseSpam = 0
CreateThread(function()
    while true do
        Wait(1)
        if isZiptied then
            DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 21, true) -- Sprint
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288, true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
            EnableControlAction(0, 249, true) -- Added for talking while cuffed
            EnableControlAction(0, 46, true)  -- Added for talking while cuffed

            if (not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) and not IsEntityPlayingAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3)) and not QBCore.Functions.GetPlayerData().metadata["isdead"] then
                loadAnimDict("mp_arresting")
                TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8, -1, cuffType, 0, 0, 0, 0)
            end
            
            if IsControlJustPressed(0, 29) then
                ReleaseSpam += 1
                if ReleaseSpam == Config.ZiptieWiggleAmount then
                    TriggerEvent('Crazy:Client:ZiptieWiggle')
                end
            end
        end
        if not isZiptied then
            Wait(2000)
        end
    end
end)

-- DEBUG COMMAND
RegisterCommand('crzdebug', function()
    DoScreenFadeIn(0)
    TriggerEvent('Crazy:Client:GetUnZiptied')
    TriggerEvent('Crazy:Client:')
end)
