local configContent = LoadResourceFile(GetCurrentResourceName(), 'config.lua')
local config = load(configContent)()

local logConfigContent = LoadResourceFile(GetCurrentResourceName(), 'log_config.json')
local logConfig = json.decode(logConfigContent)

local playerConnectTimes = {}
local VORPcore = {}

function SendWebhook(data, webhook)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

function getID(source)
    local playerID = source
    local identifiers = GetPlayerIdentifiers(playerID)

    for _, id in ipairs(identifiers) do
        if string.match(id, "steam:") then
            return id
        elseif string.match(id, "license:") then
            return id
        end
    end
    return "N/A"
end

function getDiscordID(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, id in ipairs(identifiers) do
        if string.match(id, "discord:") then
            return string.gsub(id, "discord:", "")
        end
    end
    return nil
end

function secondsToHoursMinutes(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)

    if hours > 0 then
        return string.format("%dh %02dm", hours, minutes)
    else
        return string.format("%02d minutes", minutes)
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if not logConfig.resourceStart then
        return
    end

    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

    local timestamp = false
    if config.embed.onResourceStart.useTimestamp == true then
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    end

    local webhook = config.embed.onResourceStart.webhook

    local data = {
        embeds = {
            {
                title = config.embed.onResourceStart.title,
                color = config.embed.onResourceStart.embedColor,
                description = config.embed.onResourceStart.description,
                footer = {
                    text = config.embed.onResourceStart.footerText
                },
                timestamp = timestamp
            }
        }
    }
    SendWebhook(data, webhook)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if not logConfig.resourceStop then
        return
    end
    
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

    local timestamp = false
    if config.embed.onResourceStop.useTimestamp == true then
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    end

    local webhook = config.embed.onResourceStop.webhook

    local data = {
        embeds = {
            {
                title = config.embed.onResourceStop.title,
                color = config.embed.onResourceStop.embedColor,
                description = config.embed.onResourceStop.description,
                footer = {
                    text = config.embed.onResourceStop.footerText
                },
                timestamp = timestamp
            }
        }
    }
    SendWebhook(data, webhook)
end)

RegisterNetEvent('onCharacterCreation')
AddEventHandler('onCharacterCreation', function()
    if not logConfig.charCreate then
        return
    end

    local timestamp = false
    if config.embed.onCharacterCreate.useTimestamp == true then
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    end

    local webhook = config.embed.onCharacterCreate.webhook
    local id = getID(source)
    local discordId = getDiscordID(source)
    local discordProfile = discordId and ("<@" .. discordId .. ">") or "Not Linked"

    local data = {
        embeds = {
            {
                title = config.embed.onCharacterCreate.title,
                color = config.embed.onCharacterCreate.embedColor,
                fields = {
                    {
                        name = config.embed.onCharacterCreate.fields.player,
                        value = "```" .. GetPlayerName(source) .. "```",
                        inline = true
                    },
                    {
                        name = config.embed.onCharacterCreate.fields.playerID,
                        value = "```" .. id .. "```",
                        inline = true
                    },
                    {
                        name = "Discord Profile",
                        value = discordProfile,
                        inline = true
                    },
                },
                footer = {
                    text = config.embed.onCharacterCreate.footerText
                },
                timestamp = timestamp
            }
        }
    }
    SendWebhook(data, webhook)
end)

RegisterNetEvent('vorpcharacter:deleteCharacter')
AddEventHandler('vorpcharacter:deleteCharacter', function(characterId)
    if not logConfig.charDelete then
        return
    end

    local timestamp = false
    if config.embed.onCharacterDelete.useTimestamp == true then
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    end

    local webhook = config.embed.onCharacterDelete.webhook
    local User = VORPcore.getUser(source)
    local id = getID(source)
    local discordId = getDiscordID(source)
    local discordProfile = discordId and ("<@" .. discordId .. ">") or "Not Linked"

    local charFirstName = nil
    local charLastName = nil

    local userCharacters = User.getUserCharacters

    for _, userCharacter in ipairs(userCharacters) do
        if userCharacter.charIdentifier == characterId then
            charFirstName = userCharacter.firstname
            charLastName = userCharacter.lastname
            break
        end
    end

    if not charFirstName and not charLastName then
        print("Character not found for charIdentifier: " .. characterId)
    end

    local data = {
        embeds = {
            {
                title = config.embed.onCharacterDelete.title,
                color = config.embed.onCharacterDelete.embedColor,
                fields = {
                    {
                        name = config.embed.onCharacterDelete.fields.player,
                        value = "```" .. GetPlayerName(source) .. "```",
                        inline = true
                    },
                    {
                        name = config.embed.onCharacterDelete.fields.playerID,
                        value = "```" .. id .. "```",
                        inline = true
                    },
                    {
                        name = "Discord Profile",
                        value = discordProfile,
                        inline = true
                    },
                    {
                        name = config.embed.onCharacterDelete.fields.characterID,
                        value = "```" .. characterId .. "```",
                        inline = true
                    },
                    {
                        name = config.embed.onCharacterDelete.fields.charFirstName,
                        value = "```" .. tostring(charFirstName) .. "```",
                        inline = true
                    },
                    {
                        name = config.embed.onCharacterDelete.fields.charLastName,
                        value = "```" .. tostring(charLastName) .. "```",
                        inline = true
                    },
                },
                footer = {
                    text = config.embed.onCharacterDelete.footerText
                },
                timestamp = timestamp
            }
        }
    }
    SendWebhook(data, webhook)
end)

RegisterNetEvent('onCharacterSelected')
AddEventHandler('onCharacterSelected', function()
    if not logConfig.charSelect then
        return
    end

    local timestamp = false
    if config.embed.onCharacterSelect.useTimestamp == true then
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    end

    local webhook = config.embed.onCharacterSelect.webhook
    local User = VORPcore.getUser(source)
    local Character = User.getUsedCharacter
    local id = getID(source)
    local discordId = getDiscordID(source)
    local discordProfile = discordId and ("<@" .. discordId .. ">") or "Not Linked"

    local data = {
        embeds = {
            {
                title = config.embed.onCharacterSelect.title,
                color = config.embed.onCharacterSelect.embedColor,
                fields = {
                    {
                        name = config.embed.onCharacterSelect.fields.player,
                        value = "```" .. GetPlayerName(source) .. "```",
                        inline = true
                    },
                    {
                        name = config.embed.onCharacterSelect.fields.playerID,
                        value = "```" .. id .. "```",
                        inline = true
                    },
                    {
                        name = "Discord Profile",
                        value = discordProfile,
                        inline = true
                    },
                    {
                        name = config.embed.onCharacterSelect.fields.characterID,
                        value = "```" .. Character.charIdentifier .. "```",
                        inline = true
                    },
                    {
                        name = config.embed.onCharacterSelect.fields.charFirstName,
                        value = "```" .. Character.firstname .. "```",
                        inline = true
                    },
                    {
                        name = config.embed.onCharacterSelect.fields.charLastName,
                        value = "```" .. Character.lastname .. "```",
                        inline = true
                    },
                },
                footer = {
                    text = config.embed.onCharacterSelect.footerText
                },
                timestamp = timestamp
            }
        }
    }
    SendWebhook(data, webhook)
end)

RegisterNetEvent('chatMessage')
AddEventHandler('chatMessage', function(source, author, text)
    if not logConfig.chat then
        return
    end

    local timestamp = false
    if config.embed.onMessage.useTimestamp == true then
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    end

    local webhook = config.embed.onMessage.webhook
    local id = getID(source)
    local discordId = getDiscordID(source)
    local discordProfile = discordId and ("<@" .. discordId .. ">") or "Not Linked"

    local data = {
        embeds = {
            {
                title = config.embed.onMessage.title,
                description = config.embed.onMessage.description,
                color = config.embed.onMessage.embedColor,
                fields = {
                    {
                        name = config.embed.onMessage.fields.player,
                        value = "```" .. GetPlayerName(source) .. "```",
                        inline = true
                    },
                    {
                        name = config.embed.onMessage.fields.playerID,
                        value = "```" .. id .. "```",
                        inline = true
                    },
                    {
                        name = "Discord Profile",
                        value = discordProfile,
                        inline = true
                    },
                    {
                        name = config.embed.onMessage.fields.message,
                        value = "```" .. text .. "```",
                        inline = false
                    },
                },
                footer = {
                    text = config.embed.onMessage.footerText
                },
                timestamp = timestamp
            }
        }
    }
    SendWebhook(data, webhook)
end)

RegisterNetEvent('playerJoining')
AddEventHandler('playerJoining', function()
    if not logConfig.join then
        return
    end

    local timestamp = false
    if config.embed.onPlayerJoin.useTimestamp == true then
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    end

    local webhook = config.embed.onPlayerJoin.webhook
    local id = getID(source)
    local discordId = getDiscordID(source)
    local discordProfile = discordId and ("<@" .. discordId .. ">") or "Not Linked"
    
    local playerID = source
    local connectTime = os.time()
    playerConnectTimes[playerID] = connectTime

    local data = {
        embeds = {
            {
                title = config.embed.onPlayerJoin.title,
                color = config.embed.onPlayerJoin.embedColor,
                fields = {
                    {
                        name = config.embed.onPlayerJoin.fields.player,
                        value = "```" .. GetPlayerName(source) .. "```",
                        inline = true
                    },
                    {
                        name = config.embed.onPlayerJoin.fields.playerID,
                        value = "```" .. id .. "```",
                        inline = true
                    },
                    {
                        name = "Discord Profile",
                        value = discordProfile,
                        inline = true
                    },
                },
                footer = {
                    text = config.embed.onPlayerJoin.footerText
                },
                timestamp = timestamp
            }
        }
    }

    SendWebhook(data, webhook)
end)

RegisterNetEvent('playerDropped')
AddEventHandler('playerDropped', function(reason)
    -- Handle Combat Log first if configured
    local User = VORPcore.getUser(source)
    if User ~= nil then
        local Character = User.getUsedCharacter
        if Character ~= nil then
            local isdead = Character.isdead
            if isdead and logConfig.combatLog then
                local webhook = config.embed.onPlayerDeath.webhook
                local id = getID(source)
                local discordId = getDiscordID(source)
                local discordProfile = discordId and ("<@" .. discordId .. ">") or "Not Linked"
                
                local combatData = {
                    embeds = {
                        {
                            title = "Combat Logged",
                            description = GetPlayerName(source) .. " combat logged (disconnected while dead). Reason: " .. tostring(reason),
                            color = 16711680,
                            fields = {
                                {
                                    name = "Player",
                                    value = "```" .. GetPlayerName(source) .. "```",
                                    inline = true
                                },
                                {
                                    name = "Player ID",
                                    value = "```" .. id .. "```",
                                    inline = true
                                },
                                {
                                    name = "Discord Profile",
                                    value = discordProfile,
                                    inline = true
                                },
                                {
                                    name = "Character ID",
                                    value = "```" .. Character.charIdentifier .. "```",
                                    inline = true
                                },
                            },
                            footer = {
                                text = config.translations.footerText
                            },
                            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                        }
                    }
                }
                SendWebhook(combatData, webhook)
            end
        end
    end

    if not logConfig.leave then
        return
    end

    local timestamp = false
    if config.embed.onPlayerLeave.useTimestamp == true then
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    end

    local webhook = config.embed.onPlayerLeave.webhook
    local id = getID(source)
    local discordId = getDiscordID(source)
    local discordProfile = discordId and ("<@" .. discordId .. ">") or "Not Linked"

    local playerID = source
    local connectTime = playerConnectTimes[playerID]
    local playTime = "N/A"

    if connectTime then
        local playTimeSeconds = os.time() - connectTime
        playTime = secondsToHoursMinutes(playTimeSeconds)
    end

    playerConnectTimes[playerID] = nil

    local data = {
        embeds = {
            {
                title = config.embed.onPlayerLeave.title,
                color = config.embed.onPlayerLeave.embedColor,
                fields = {
                    {
                        name = config.embed.onPlayerLeave.fields.player,
                        value = "```" .. GetPlayerName(source) .. "```",
                        inline = true
                    },
                    {
                        name = config.embed.onPlayerLeave.fields.playerID,
                        value = "```" .. id .. "```",
                        inline = true
                    },
                    {
                        name = "Discord Profile",
                        value = discordProfile,
                        inline = true
                    },
                },
                footer = {
                    text = config.embed.onPlayerLeave.footerText
                },
                timestamp = timestamp
            }
        }
    }
    SendWebhook(data, webhook)
end)

RegisterNetEvent('onPlayerDeath')
AddEventHandler('onPlayerDeath', function(killerID, deathType, weaponName)
    if not logConfig.death then
        return
    end

    local timestamp = false
    if config.embed.onPlayerDeath.useTimestamp == true then
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    end

    local webhook = config.embed.onPlayerDeath.webhook
    local User = VORPcore.getUser(source)
    local Character = User.getUsedCharacter
    local id = getID(source)
    local discordId = getDiscordID(source)
    local discordProfile = discordId and ("<@" .. discordId .. ">") or "Not Linked"

    local victimName = GetPlayerName(source)
    local embedDesc = ""
    if deathType == "suicide" then
        embedDesc = victimName .. " committed suicide."
    elseif deathType == "killed" and killerID then
        local killerName = GetPlayerName(killerID) or "Unknown Killer"
        embedDesc = killerName .. " killed " .. victimName .. "."
    else
        embedDesc = victimName .. " died."
    end

    local data = {
        embeds = {
            {
                title = config.embed.onPlayerDeath.title,
                description = embedDesc,
                color = config.embed.onPlayerDeath.embedColor,
                fields = {
                    {
                        name = config.embed.onPlayerDeath.fields.vplayer,
                        value = "```" .. victimName .. "```",
                        inline = true
                    },
                    {
                        name = config.embed.onPlayerDeath.fields.vplayerID,
                        value = "```" .. id .. "```",
                        inline = true
                    },
                    {
                        name = "Discord Profile (Victim)",
                        value = discordProfile,
                        inline = true
                    },
                    {
                        name = config.embed.onPlayerDeath.fields.vcharacterID,
                        value = "```" .. Character.charIdentifier .. "```",
                        inline = true
                    },
                    {
                        name = config.embed.onPlayerDeath.fields.vcharFirstName,
                        value = "```" .. Character.firstname .. "```",
                        inline = true
                    },
                    {
                        name = config.embed.onPlayerDeath.fields.vcharLastName,
                        value = "```" .. Character.lastname .. "```",
                        inline = true
                    },
                    {
                        name = config.embed.onPlayerDeath.fields.killedWith,
                        value = "```" .. weaponName .. "```",
                        inline = false
                    },
                },
                footer = {
                    text = config.embed.onPlayerDeath.footerText
                },
                timestamp = timestamp
            }
        }
    }

    if deathType == "killed" and killerID then
        local killerUser = VORPcore.getUser(killerID)
        if killerUser then
            local killerCharacter = killerUser.getUsedCharacter
            local kId = getID(killerID)
            local kDiscordId = getDiscordID(killerID)
            local kDiscordProfile = kDiscordId and ("<@" .. kDiscordId .. ">") or "Not Linked"

            table.insert(data.embeds[1].fields, {
                name = config.embed.onPlayerDeath.fields.kplayer,
                value = "```" .. (GetPlayerName(killerID) or "Unknown") .. "```",
                inline = true
            })
            table.insert(data.embeds[1].fields, {
                name = config.embed.onPlayerDeath.fields.kplayerID,
                value = "```" .. kId .. "```",
                inline = true
            })
            table.insert(data.embeds[1].fields, {
                name = "Discord Profile (Killer)",
                value = kDiscordProfile,
                inline = true
            })
            table.insert(data.embeds[1].fields, {
                name = config.embed.onPlayerDeath.fields.kcharacterID,
                value = "```" .. killerCharacter.charIdentifier .. "```",
                inline = true
            })
            table.insert(data.embeds[1].fields, {
                name = config.embed.onPlayerDeath.fields.kcharFirstName,
                value = "```" .. killerCharacter.firstname .. "```",
                inline = true
            })
            table.insert(data.embeds[1].fields, {
                name = config.embed.onPlayerDeath.fields.kcharLastName,
                value = "```" .. killerCharacter.lastname .. "```",
                inline = true
            })
        end
    end

    SendWebhook(data, webhook)
end)
