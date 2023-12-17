fx_version 'cerulean'
game 'gta5'
author 'Bostra'
description "Menus for Businesses"
version '1.0.0'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

ui_page 'web/dist/index.html'

client_scripts {    
	"client/*.lua"
}

server_scripts {
    'server/*.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
	'config.lua'
}


files {
	'web/dist/index.html',
	'web/dist/**/*',
}

dependencies {
	'ox_lib'
}

data_file 'DLC_ITYP_REQUEST' 'stream/prop_drinkmenu.ytyp' 
