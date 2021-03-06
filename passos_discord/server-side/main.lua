local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

link = {}
Proxy.addInterface("passos_discord", link)
Tunnel.bindInterface("passos_discord", link)

function link.returnID()
    local src = source
    local user_id = vRP.getUserId(src)
    return user_id
end