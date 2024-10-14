--                                          _                    
-- _ __ ___  ___  ___  _   _ _ __ ___ ___  | |__   __ _ ___  ___ 
-- | '__/ _ \/ __|/ _ \| | | | '__/ __/ _ \ | '_ \ / _` / __|/ _ \
-- | | |  __/\__ \ (_) | |_| | | | (_|  __/ | |_) | (_| \__ \  __/
-- |_|  \___||___/\___/ \__,_|_|  \___\___| |_.__/ \__,_|___/\___|
--
--  Need support? Join our Discord server for help: https://discord.gg/r-scripts
--
Cfg = {
    --  ___  ___ _ ____   _____ _ __
    -- / __|/ _ \ '__\ \ / / _ \ '__|
    -- \__ \  __/ |   \ V /  __/ |
    -- |___/\___|_|    \_/ \___|_|
    Server = {
        Language = 'en',             -- Resource language ('en': English, 'es': Spanish, 'fr': French, 'de': German, 'pt': Portuguese, 'zh': Chinese)
        VersionCheck = true,         -- Version check (true: enabled, false: disabled)
    },
    --              _   _
    --   ___  _ __ | |_(_) ___  _ __  ___
    --  / _ \| '_ \| __| |/ _ \| '_ \/ __|
    -- | (_) | |_) | |_| | (_) | | | \__ \
    --  \___/| .__/ \__|_|\___/|_| |_|___/
    --       |_|
    Options = {

    },
    --             (_)/ _|
    --  _   _ _ __  _| |_ ___  _ __ _ __ ___
    -- | | | | '_ \| |  _/ _ \| '__| '_ ` _ \
    -- | |_| | | | | | || (_) | |  | | | | | |
    --  \__,_|_| |_|_|_| \___/|_|  |_| |_| |_|
    Uniform = {
        Enabled = true,         -- Wardrobe System (true: enabled, false: disabled)
        Outfit = {
            Male = {
                ['arms'] = 0,
                ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                ['torso_1'] = 86, ['torso_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['chain_1'] = 0, ['chain_2'] = 0,
                ['pants_1'] = 10, ['pants_2'] = 2,
                ['shoes_1'] = 56, ['shoes_2'] = 0,
                ['helmet_1'] = 14, ['helmet_2'] = 0,
            },
            Female = {
                ['arms'] = 0,
                ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                ['torso_1'] = 86, ['torso_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['chain_1'] = 0, ['chain_2'] = 0,
                ['pants_1'] = 10, ['pants_2'] = 2,
                ['shoes_1'] = 56, ['shoes_2'] = 0,
                ['helmet_1'] = 14, ['helmet_2'] = 0,
            },
        },
    },
    --               _     _                 _    
    -- __      _____| |__ | |__   ___   ___ | | __
    -- \ \ /\ / / _ \ '_ \| '_ \ / _ \ / _ \| |/ /
    --  \ V  V /  __/ |_) | | | | (_) | (_) |   < 
    --   \_/\_/ \___|_.__/|_| |_|\___/ \___/|_|\_\ 
    Webhook = {
        Enabled = true,            -- Webhook Logs (true: enabled, false: disabled)
        Url = 'YOUR_WEBHOOK_HERE', -- Webhook URL
    }, 
    --      _      _
    --   __| | ___| |__  _   _  __ _
    --  / _` |/ _ \ '_ \| | | |/ _` |
    -- | (_| |  __/ |_) | |_| | (_| |
    --  \__,_|\___|_.__/ \__,_|\__, |
    --                         |___/
    Debug = true -- Enable debug prints (true: enabled, false: disabled)
}