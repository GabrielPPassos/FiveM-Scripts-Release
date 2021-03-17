local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local config = module("passos_weed-delivery", "config")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

passos = {}
Proxy.addInterface("passos_weed-delivery", passos)
Tunnel.bindInterface("passos_weed-delivery", passos)

local pedido = 0

function passos.checkperm()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if config.usar_perm then
            if vRP.hasPermission(user_id, config.perm) then 
                return true 
            else
                TriggerClientEvent("Notify", source, "negado", "Permissões insuficientes.")
            end
        else
            return true
        end
    end
end

function passos.gerarEntrega()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local item_inventory = vRP.getInventoryItemAmount(user_id, config.item)
        local item_inventory2 = vRP.getInventoryItemAmount(user_id, config.item2)
        if parseInt(item_inventory) > 0 then
            local f = math.random(item_inventory)
            TriggerClientEvent("entrega-weed", source, true)
            TriggerClientEvent("atualizar-qtd2", source, f)
            TriggerClientEvent("returnTypeWeed", source, "pacote")
            TriggerClientEvent("Notify", source, "sucesso", "A rota foi <b>iniciada</b>, leve ".. f .." maconha(s) empacotada(s)")
            pedido = f
            return true
        else
            if parseInt(item_inventory2) > 0 then
                local f = math.random(item_inventory2)
                TriggerClientEvent("entrega-weed", source, true)
                TriggerClientEvent("atualizar-qtd2", source, f)
                TriggerClientEvent("returnTypeWeed", source, "baseado")
                TriggerClientEvent("Notify", source, "sucesso", "A rota foi <b>iniciada</b>, leve ".. f .." baseado(s)")
                pedido = f
                return true
            else
                TriggerClientEvent("Notify", source, "negado", "Você não possui nenhuma <b>maconha empacotada ou baseado</b> no inventário!")
                return false
            end
        end
    end
end

function passos.payment()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.tryGetInventoryItem(user_id, config.item, pedido) then
            local money = parseInt(config.price*pedido)
            vRP.giveInventoryItem(user_id, config.dinheiro_sujo, money)
            TriggerClientEvent("Notify", source, "sucesso", "Você entregou <b>".. pedido .."</b> maconha(s) empacotada(s) e recebeu <b>".. vRP.format(parseInt(money)) .." reais</b>!")
            return true
        else
            if vRP.tryGetInventoryItem(user_id, config.item2, pedido) then
                local money = parseInt(config.price*pedido)
                vRP.giveInventoryItem(user_id, config.dinheiro_sujo, money)
                TriggerClientEvent("Notify", source, "sucesso", "Você entregou <b>".. pedido .."</b> baseado(s) e recebeu <b>".. vRP.format(parseInt(money)) .." reais</b>!")
                return true
            else
                TriggerClientEvent("Notify", source, "negado", "Você não possui <b>".. pedido .."</b> maconha(s) empacotada(s) ou baseado(s) no inventário!")
                TriggerClientEvent("entrega-vinho", source, false)
                return false
            end
        end
    end
end