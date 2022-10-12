fx_version 'cerulean' 
game 'gta5'

author 'Crazy-Scripts'
description 'Crazy-Kidnapping // qb-kidnapping'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'Config.lua'
}

client_scripts {
    'Client/main.lua'
}

server_scripts {
    'Server/main.lua'
}

lua54 'yes'
