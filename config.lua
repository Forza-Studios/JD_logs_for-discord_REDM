local config = {}

config.webhooks = {
    chat   = "CHANGE ME",
    player = "CHANGE ME",
    system = "CHANGE ME",
    -- If you need more specific webhooks, copy and paste the below example, change the variable name, and then add the webhook url
    -- Then find which event you want to change the webhook to and change the webhook (see config.embed.onResourceStart for an example on how to change the webhook)
    -- example = "CHANGE ME",
}

-- Translations --
config.translations = {
    player                      = "Player",
    playerID                    = "Player ID",
    message                     = "Message",
    playerPlayTime              = "Play Time",
    characterID                 = "Character ID",
    charFirstName               = "First Name",
    charLastName                = "Last Name",
    vplayer                     = "Player (Victim)",
    vplayerID                   = "Player ID (Victim)",
    vcharacterID                = "Character ID (Victim)",
    vcharFirstName              = "First Name (Victim)",
    vcharLastName               = "Last Name (Victim)",
    killedWith                  = "Killed With",
    kplayer                     = "Player (Killer)",
    kplayerID                   = "Player ID (Killer)",
    kcharacterID                = "Character ID (Killer)",
    kcharFirstName              = "First Name (Killer)",
    kcharLastName               = "Last Name (Killer)",
    killedBy                    = "Killed By",

    titleResourceStart          = "",                                           -- Personally I like to keep these empty but you can add titles to them
    titleResourceStop           = "",                                           -- Personally I like to keep these empty but you can add titles to them
    titlePlayerChat             = "Chat Message",
    titlePlayerJoin             = "Player Joined",
    titlePlayerLeave            = "Player Left",
    titleCharCreated            = "Character Created",
    titleCharSelected           = "Character Selected",
    titleCharDeleted            = "Character Deleted",
    titlePlayerDeath            = "Player Killed",

    descriptionResourceStart    = "Connected to Royal Productions | RoyalRP | RedM",
    descriptionResourceStop     = "Disconnected from Royal Productions | RoyalRP | RedM",
    descriptionPlayerChat       = "",
    descriptionPlayerJoin       = "",
    descriptionPlayerLeave      = "",
    descriptionCharCreated      = "",
    descriptionCharSelected     = "",
    descriptionCharDeleted      = "",
    descriptionPlayerDeath      = "",

    footerText                  = "Royal Productions | RoyalRP | RedM",         -- If you want different footer text for different embeds, copy and paste the below line, and change the name to be something unique
    -- footerTextExample           = "This footer text is different",              -- Do not use footerText as that will cause issues and will not display correctly!
}

-- Embed Configurations --
config.embed = {
    -- When rp_dLogger, or the server starts
    onResourceStart = {
        webhook             = config.webhooks.system,                            -- (string)  The webhook to send the events message to.
        -- webhook             = config.webhooks.example                            -- You can change this to any of the webhooks in config.webhooks (example: system, chat, player, etc.)
        enable              = true,                                             -- (boolean) options: [ true | false ] - Enable / Disable the event
        useTimestamp        = true,                                             -- (boolean) options: [ true | false ] - Enable / Disable timestamp on embed
        embedColor          = 7824229,                                          -- (integer) The color of the embed (see this webpage to get color values: https://www.mathsisfun.com/hexadecimal-decimal-colors.html)
        title               = config.translations.titleResourceStart,           -- (string)  The title of the embed (see config.translations.title<event name> to change this)
        description         = config.translations.descriptionResourceStart,     -- (string)  The description of the embed (see config.translations.description<event name> to change this)
        footerText          = config.translations.footerText,                   -- (string)  The footer of the embed (see config.translations.footerText to change this)
        -- footerText          = config.translations.footerTextExample,            -- Example on how to change footer text to be unique for each event
    },
    -- When rp_dLogger, or the server is stopped
    onResourceStop = {
        webhook             = config.webhooks.system,
        enable              = true,
        useTimestamp        = true,
        embedColor          = 14502612,
        title               = config.translations.titleResourceStop,
        description         = config.translations.descriptionResourceStop,
        footerText          = config.translations.footerText,
    },
    -- When a player sends a message in the chat
    onMessage = {
        webhook             = config.webhooks.chat,
        enable              = true,
        useTimestamp        = true,
        embedColor          = 5592406,
        title               = config.translations.titlePlayerChat,
        description         = config.translations.descriptionPlayerChat,
        fields = {
            player          = config.translations.player,
            playerID        = config.translations.playerID,
            message         = config.translations.message,
        },
        footerText          = config.translations.footerText,
    },
    -- When a player joins the server
    onPlayerJoin = {
        webhook             = config.webhooks.player,
        enable              = true,
        useTimestamp        = true,
        embedColor          = 3066993,
        title               = config.translations.titlePlayerJoin,
        description         = config.translations.descriptionPlayerJoin,
        fields = {
            player          = config.translations.player,
            playerID        = config.translations.playerID,
        },
        footerText          = config.translations.footerText,
    },
    -- When a player leaves the server
    onPlayerLeave = {
        webhook             = config.webhooks.player,
        enable              = true,
        useTimestamp        = true,
        embedColor          = 16711704,
        title               = config.translations.titlePlayerLeave,
        description         = config.translations.descriptionPlayerLeave,
        fields = {
            player          = config.translations.player,
            playerID        = config.translations.playerID,
            playerPlayTime  = config.translations.playerPlayTime,                -- This currently does nothing
        },
        footerText          = config.translations.footerText,
    },
    -- When a player creates a new character
    onCharacterCreate = {
        webhook             = config.webhooks.player,
        enable              = true,
        useTimestamp        = true,
        embedColor          = 11922239,
        title               = config.translations.titleCharCreated,
        description         = config.translations.descriptionCharCreated,
        fields = {
            player          = config.translations.player,
            playerID        = config.translations.playerID,
        },
        footerText          = config.translations.footerText,
    },
    -- When a player selects a character to play (also after the player creates a new character)
    onCharacterSelect = {
        webhook             = config.webhooks.player,
        enable              = true,
        useTimestamp        = true,
        embedColor          = 15844367,
        title               = config.translations.titleCharSelected,
        description         = config.translations.descriptionCharSelected,
        fields = {
            player          = config.translations.player,
            playerID        = config.translations.playerID,
            characterID     = config.translations.characterID,
            charFirstName   = config.translations.charFirstName,
            charLastName    = config.translations.charLastName,
        },
        footerText          = config.translations.footerText,
    },
    -- When a player deletes a character
    onCharacterDelete = {
        webhook             = config.webhooks.player,
        enable              = true,
        useTimestamp        = true,
        embedColor          = 9109504,
        title               = config.translations.titleCharDeleted,
        description         = config.translations.descriptionCharDeleted,
        fields = {
            player          = config.translations.player,
            playerID        = config.translations.playerID,
            characterID     = config.translations.characterID,
            charFirstName   = config.translations.charFirstName,
            charLastName    = config.translations.charLastName,
        },
        footerText          = config.translations.footerText,
    },
    -- When a player dies
    onPlayerDeath = {
        webhook             = config.webhooks.player,
        enable              = true,
        useTimestamp        = true,
        embedColor          = 15844367,
        title               = config.translations.titlePlayerDeath,
        description         = config.translations.descriptionCharDeleted,
        fields = {
            vplayer         = config.translations.vplayer,
            vplayerID       = config.translations.vplayerID,
            vcharacterID    = config.translations.vcharacterID,
            vcharFirstName  = config.translations.vcharFirstName,
            vcharLastName   = config.translations.vcharLastName,
            killedWith      = config.translations.killedWith,
            kplayer         = config.translations.kplayer,
            kplayerID       = config.translations.kplayerID,
            kcharacterID    = config.translations.kcharacterID,
            kcharFirstName  = config.translations.kcharFirstName,
            kcharLastName   = config.translations.kcharLastName,
            killedBy        = config.translations.killedBy,
        },
        footerText          = config.translations.footerText,
    },
}

return config
