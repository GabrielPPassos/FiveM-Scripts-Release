local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local count = 0 

RegisterCommand('ptr', function(source, args, rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    if args[1] and args[2] then
        if args[1] == "add" then
            if parseInt(args[2]) > 0 then
                if vRP.hasPermission(user_id, "policia.permissao") then
                    count = count + args[2]
                    TriggerClientEvent("chatMessage", source, "COPOM", { 6, 160, 255 }, "A contagem de policiais em ptr foi atualizada para: ".. parseInt(count))
                else
                    TriggerClientEvent("chatMessage", source, "Error", { 255, 0, 0 }, "Permissões Insuficientes")
                end
            else
                TriggerClientEvent("chatMessage", source, "Error", { 255, 0, 0 }, "O valor precisa ser positivo")
            end
        elseif args[1] == "rem" then
            if parseInt(args[2]) > 0 then
                if vRP.hasPermission(user_id, "policia.permissao") then
                    count = count - args[2]
                    TriggerClientEvent("chatMessage", source, "COPOM", { 6, 160, 255 }, "A contagem de policiais em ptr foi atualizada para: ".. parseInt(count))
                else
                    TriggerClientEvent("chatMessage", source, "Error", { 255, 0, 0 }, "Permissões Insuficientes")
                end
            else
                TriggerClientEvent("chatMessage", source, "Error", { 255, 0, 0 }, "O valor precisa ser positivo")
            end
        end
    else
        if count > 0 then
            TriggerClientEvent("chatMessage", source, "Policiais em PTR", { 6, 160, 255 }, count)
        else
            TriggerClientEvent("chatMessage", source, "Error", { 255, 0, 0 }, "Sem policiais em patrulhamento")
        end
    end
end)