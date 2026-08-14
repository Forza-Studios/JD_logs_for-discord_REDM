-- Debug Kill player command
RegisterCommand("killme", function()
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, 0)
end, false)

RegisterNetEvent("vorp:initNewCharacter")
AddEventHandler("vorp:initNewCharacter", function()
    TriggerServerEvent('onCharacterCreation', charid)
end)

RegisterNetEvent("vorp:SelectedCharacter")
AddEventHandler("vorp:SelectedCharacter", function(charId)
    TriggerServerEvent('onCharacterSelected', charid)
end)

-- Player Death Event --
local isDead = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        local playerPed = PlayerPedId()
        local health = GetEntityHealth(playerPed)

        if health <= 0 and not isDead then
            isDead = true
            local PedKiller = GetPedSourceOfDeath(playerPed)
            local DeathCauseHash = GetPedCauseOfDeath(playerPed)
            local weaponName = WeaponNames[tostring(DeathCauseHash)] or "Unknown/None"

            local killerServerId = nil
            local deathType = "died" -- "died", "suicide", "killed"

            if PedKiller and PedKiller ~= 0 then
                local killerPed = nil
                if IsEntityAPed(PedKiller) then
                    killerPed = PedKiller
                elseif IsEntityAVehicle(PedKiller) then
                    killerPed = GetPedInVehicleSeat(PedKiller, -1)
                end

                if killerPed and IsPedAPlayer(killerPed) then
                    local killerPlayer = NetworkGetPlayerIndexFromPed(killerPed)
                    if killerPlayer and killerPlayer ~= -1 then
                        if killerPlayer == PlayerId() then
                            deathType = "suicide"
                        else
                            deathType = "killed"
                            killerServerId = GetPlayerServerId(killerPlayer)
                        end
                    end
                end
            end

            TriggerServerEvent("onPlayerDeath", killerServerId, deathType, weaponName)

        elseif health > 0 and isDead then
            isDead = false
        end
    end
end)
-- End Player Death Event --
