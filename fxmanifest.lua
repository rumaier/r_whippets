---@diagnostic disable: undefined-global
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'r_whippets'
description 'Whippets script for FiveM'
author 'r_scripts'
version '1.0.2'

shared_scripts {
    '@ox_lib/init.lua',
    'utils/shared.lua',
    'src/shared/*.lua',
    'locales/*.lua',
    'config.lua',
}

server_scripts {
    'utils/server.lua',
    'src/server/*.lua',
}

client_scripts {
    'utils/client.lua',
    'src/client/*.lua',
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/styles.css',
    'ui/script.js'
}

data_file 'DLC_ITYP_REQUEST' 'stream/vello_gas_props_v1.ytyp'

dependencies {
    'ox_lib',
    'r_bridge',
}

escrow_ignore {
    'install/**/*.*',
    'locales/*.*',
    'config.*' 
}
