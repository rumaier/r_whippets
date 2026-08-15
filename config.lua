--                _     _                  _
--  _ ____      _| |__ (_)_ __  _ __   ___| |_ ___
-- | '__\ \ /\ / / '_ \| | '_ \| '_ \ / _ \ __/ __|
-- | |   \ V  V /| | | | | |_) | |_) |  __/ |_\__ \ -- DO NOT DO WHIPPETS KIDS!! THEY MAKE YOUR BRAIN GO BAD!!
-- |_|____\_/\_/ |_| |_|_| .__/| .__/ \___|\__|___/
--  |_____|              |_|   |_|
--
--  Need support? Join our Discord server for help: https://discord.gg/rscripts
--
Cfg = {}

Cfg.Language = 'en'     -- Languages: 'en': English, 'es': Spanish, 'fr': French, 'de': German, 'pt': Portuguese, 'zh': Chinese
Cfg.VersionCheck = true -- Intermittent version checking (boolean) -- server-only, not sent to clients
Cfg.Debug = false       -- Debug prints, not recommended for live servers (boolean)

Cfg.Options = {
    WhippetShop = {
        Enabled = true,                                  -- Enable whippet shop (true: enabled, false: disabled)
        Locations = {                                    -- Whippet shop locations (vec4)
            vec4(-1171.52, -1572.57, 3.66, 115.16),
            vec4(201.28, -237.67, 52.97, 296.50),
        },
        PedModel = 'u_m_y_dancerave_01',                 -- Whippet shop ped model (ped model)
        Price = 40,                                      -- Whippet price (number)

        Blip = {                                         -- Whippet shop blip settings
            Sprite = 368,                                -- Blip sprite (number)
            Color = 7,                                   -- Blip color (number)
            Scale = 1.2,                                 -- Blip scale (number)
            Label = 'Whippet Shop',                      -- Blip label (string)
        }
    },
    PassoutTime = 10,                                    -- Passout time (seconds)
}
