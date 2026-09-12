fx_version 'cerulean'
game 'gta5'

author 'Antoine Elibernier'
description 'Système de gestion d\'entreprises QBcore complet'
version '1.0.0'

shared_scripts {
    'shared/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}

escrow_ignore {
    'shared/*.lua',
    'client/*.lua',
    'server/*.lua',
    'ui/*.html',
    'ui/*.css',
    'ui/*.js'
}

dependencies {
    'qb-core',
    'qb-menu'
}