---@diagnostic disable: undefined-global
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'base'
description 'base for r_scripts resources'
author 'r_scripts'
version '0.9.9'

shared_scripts {
    '@ox_lib/init.lua',
    'utils/shared.lua',
    -- 'src/shared/*.lua',
    'locales/*.lua',
    'config.lua',
}

server_scripts {
    -- '@oxmysql/lib/MySQL.lua',
    'utils/server.lua',
    'src/server/*.lua',
}

client_scripts {
    'utils/client.lua',
    'src/client/*.lua',
}

-- ui_page 'html/index.html'

-- files {
--     'html/index.html',
--     'html/styles.css',
--     'html/script.js'
-- }

dependencies {
    'ox_lib',
    'r_bridge',
    -- 'oxmysql'
}

escrow_ignore {
    'install/**/*.*',
    'locales/*.*',
    'config.*' 
}