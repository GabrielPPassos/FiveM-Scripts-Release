local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local cfg = module("passos_boletim", "config")
local passos = cfg.boletim

function create(user_id, nuser_id, reason)
    local consulta = vRP.getSData("passos:boletim")
    local result = json.decode(consulta) or 0
    vRP.setSData("passos:boletim", json.encode(parseInt(result) + 1))
    PerformHttpRequest(passos.webhook,function(err, text, headers) end,'POST',json.encode({content =  "**Boletim de Ocorrencia [N°".. parseInt(result) + 1 .."]** ```ini\n" .. "[ID]: " .. nuser_id .. "\n[Feito Por]: " .. user_id .. "\n[Caso]: " .. reason .. "\n[Data]: " .. os.date("%H:%M:%S %d/%m/%Y") .. "```"}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("gerar_bo")
AddEventHandler("gerar_bo", function()
    local src = source
    local user_id = vRP.getUserId(src)
    if user_id then
        if passos.use_perm then
            if vRP.hasPermission(user_id, passos.perm) then
                local id = vRP.prompt(src, "Passaporte do cidadão aqui", "")
                local caso = vRP.prompt(src, "Caso", "")
                if id == "" or caso == "" then
                    TriggerClientEvent("chatMessage", src, "Aviso Policial", { 65, 125, 255 }, "Está faltando algo, você vai precisar refazer o B.O")
                    return 
                end
                if tonumber(id) then
                    create(user_id, parseInt(id), caso)
                    TriggerClientEvent("chatMessage", src, "Aviso Policial", { 65, 125, 255 }, "Você registrou um B.O")
                    TriggerClientEvent("chatMessage", src, "Aviso Policial", { 65, 125, 255 }, "Verifique a sala do discord")
                else
                    TriggerClientEvent("chatMessage", src, "Aviso Policial", { 65, 125, 255 }, "O passaporte precisa ser um número")
                end
            else
                TriggerClientEvent("chatMessage", src, "Aviso", { 255, 0, 0 }, "Você não tem permissão para fazer isso")
            end
        else
            local id = vRP.prompt(src, "Passaporte do cidadão aqui", "")
            local caso = vRP.prompt(src, "Caso", "")
            if id == "" or caso == "" then
                TriggerClientEvent("chatMessage", src, "Aviso Policial", { 65, 125, 255 }, "Está faltando algo, você vai precisar refazer o B.O")
                return 
            end
            if tonumber(id) then
                create(user_id, parseInt(id), caso)
                TriggerClientEvent("chatMessage", src, "Aviso Policial", { 65, 125, 255 }, "Você registrou um B.O")
                TriggerClientEvent("chatMessage", src, "Aviso Policial", { 65, 125, 255 }, "Verifique a sala do discord")
            else
                TriggerClientEvent("chatMessage", src, "Aviso Policial", { 65, 125, 255 }, "O passaporte precisa ser um número")
            end
        end
    end
end)
