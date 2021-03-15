local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local config = module("passos_vinho-entregas", "config")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

passos = {}
Proxy.addInterface("passos_vinho-entregas", passos)
Tunnel.bindInterface("passos_vinho-entregas", passos)

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
        if parseInt(item_inventory) > 0 then
            local f = math.random(item_inventory)
            TriggerClientEvent("entrega-vinho", source, true)
            TriggerClientEvent("atualizar-qtd", source, f)
            TriggerClientEvent("Notify", source, "sucesso", "Você precisa entregar <b>".. f .." vinho(s)</b>, localização macarda no GPS.")
            pedido = f
        else
            TriggerClientEvent("Notify", source, "negado", "Você não tem nenhum <b>vinho</b> na mochila.")
        end
    end
end

function passos.payment()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local bank = vRP.getBankMoney(user_id)
        if vRP.tryGetInventoryItem(user_id, config.item, pedido) then
            local money = parseInt(config.price*pedido)
            TriggerClientEvent("Notify", source, "sucesso", "Você entregou <b>".. pedido .." vinho(s)</b> e recebeu <b>".. vRP.format(parseInt(money)) .." reais</b>!")
            vRP.setBankMoney(user_id, bank+money)
            return true
        else
            TriggerClientEvent("Notify", source, "negado", "Você não possui <b>".. pedido .." vinho(s)</b> no inventário!")
            TriggerClientEvent("entrega-vinho", source, false)
            return false
        end
    end
end