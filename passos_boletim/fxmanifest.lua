fx_version 'adamant'
game 'gta5'

files {
	'config.lua'
}

client_script {
	"@vrp/lib/utils.lua",
	"client-side/*.lua"
}

server_scripts{ 
	"@vrp/lib/utils.lua",
	"server-side/*.lua"
}