ESX = nil
local cooldown = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local obj = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 1.0,-742198632, false, false, false)
        local objPosition = GetEntityCoords(obj)
        local dist = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, objPosition.x, objPosition.y, objPosition.z, true)
        if dist <= 1.8 then
            ShowFloatingHelpNotification("Press ~g~E~w~, to drink a cup of water.", vector3(objPosition.x, objPosition.y, objPosition.z + 1.0))
            if IsControlJustPressed(0, 38) then
                if not cooldown then
                    Citizen.CreateThread(function()
                        local prop = CreateObject(GetHashKey("prop_cs_paper_cup"), playerCoords.x, playerCoords.y, playerCoords.z + 0.2, true, true, true)
                        local boneIndex = GetPedBoneIndex(player, 18905)
                        AttachEntityToEntity(prop, player, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)
    
                        ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
                            cooldown = true
                            TaskPlayAnim(player, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
                            TriggerEvent('esx_status:add','thirst', 20)
                            Citizen.Wait(3000)
                            ClearPedSecondaryTask(player)
                            DeleteObject(prop)
                            Citizen.Wait(4500)
                            cooldown = false

                        end)
                    end)
                else
                    ShowNotification("~r~Dont drink so much...")
                end

            end
        end
    end
end)



function ShowNotification(msg)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
	DrawNotification(false, true)
end

function ShowFloatingHelpNotification(msg, coords)
    SetFloatingHelpTextWorldPosition(1, coords.x, coords.y, coords.z)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(2, false, true, 0)
  end
