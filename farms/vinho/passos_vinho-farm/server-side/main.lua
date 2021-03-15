local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

_passos = {}
Proxy.addInterface("passos_vinho", _passos)
Tunnel.bindInterface("passos_vinho", _passos)

-- Configurações --
local webhook = "SEU WEBHOOK"

local itens = {
    ["before"] = "vinicola",    -- Item que será coletado
    ["after"] = "vinho"         -- Item que será dado após o item "before" ser processado
}

local coleta = {
    ["random"] = 5,             -- Quantidade que script poderá aleatorizar para o player coletar (Exempl. A pessoa poderá ganhar até 5 vinícolas, aleatorizando entre: 1 e 5)
    ["segundos"] = 10,           -- Tempo de coleta em segundos (Exempl. A pessoa ficará X segundos coletando)
}

local processo = {
    ["multi_value"] = 1.5,      -- Fator que será multiplicado pela quantidade de vinícola que o player tem no inventário (Exempl. A pessoa tem 10 vinícolas, no processo para virar vinho o quantidade que ele tem será multiplicada por esse fator - 10*1.5)
    ["segundos"] = 10,           -- Tempo de processo em segundos (Exempl. A pessoa ficará X segundos processando)
}

--[[ -- VENDA FOI DESATIVADA PQ CRIEI O SCRIPT DE ENTREGAS
local venda = { 
    ["valor"] = 10,             -- Valor recebido em reais por cada unidade (Exempl. A pessoa vendeu 5 vinhos no blip, ele receberá 50 reais.)
}
--]]

local cooldown = {              
    ["coleta"] = true,          -- Caso esteja "TRUE" a pessoa terá um cooldown para poder coletar novamente
    ["proc"] = true,            -- Caso esteja "FALSE" a pessoa terá um cooldown para poder processar novamente
    ["minutos_coleta"] = 1,     -- Tempo de espera (Exempl. A pessoa coleta uma vez e terá que esperar X minutos para coletar novamente)
    ["minutos_proc"] = 1,       -- Tempo de espera (Exempl. A pessa coleta uma vez e terá que esperar X minutos para coletar novamente)
}

-- Sistema de Cooldown

local minutos_coleta = {}
local minutos_processamento = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		for k,v in pairs(minutos_coleta) do
			if v > 0 then
				minutos_coleta[k] = v - 1
			end
		end
        for k,v in pairs(minutos_processamento) do
            if v > 0 then
				minutos_processamento[k] = v - 1
			end
        end
	end
end)

-- Funções

function _passos.logs(titulo, msg)
    PerformHttpRequest(webhook, 
        function(err, text, headers) end,'POST',
        json.encode({ content =  "**".. titulo .."** ".. msg }), 
        { ['Content-Type'] = 'application/json' }
    )
end

function _passos.coletar()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id  then
        if cooldown["coleta"] then
            if minutos_coleta[user_id] == 0 or not minutos_coleta[user_id] then
                local random = math.random(coleta["random"])
                if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(itens["before"])*random <= vRP.getInventoryMaxWeight(user_id) then
                    local segundos = parseInt(coleta["segundos"]*1000) 
                    vRPclient._playAnim(source,false,{{"amb@world_human_gardener_plant@female@base","base_female"}},true)
                    TriggerClientEvent("progress",source,segundos,"coletando ".. vRP.itemNameList(itens["before"]))
                    TriggerClientEvent("coletando-vinicola", source, true)
                    SetTimeout(segundos,function()
                        vRP.giveInventoryItem(user_id, itens["before"], random)
                        TriggerClientEvent("Notify", source, "sucesso", "<b>Recebido:</b> ".. random .." x ".. vRP.itemNameList(itens["before"]))
                        minutos_coleta[user_id] = cooldown["minutos_coleta"]
                        vRPclient._stopAnim(source, false)
                        TriggerClientEvent("coletando-vinicola", source, false)
                        _passos.logs("[".. user_id .."] - Coleta de Vinícola", "```ini\n[Recebido]: " .. vRP.itemNameList(itens["before"]) .. "\n[Quantidade]: " .. random .. "\n[Data]: " .. os.date("%H:%M:%S %d/%m/%Y") .. "```")
                    end)
                else
                    TriggerClientEvent("Notify", source, "negado", "Você não tem espaço no seu <b>inventário</b> para isso!")
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Você precisa esperar um pouco para fazer isso novamente.")
            end
        else
            local random = math.random(coleta["random"])
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(itens["before"])*random <= vRP.getInventoryMaxWeight(user_id) then
                local segundos = parseInt(coleta["segundos"]*1000) 
                vRPclient._playAnim(source,false,{{"amb@world_human_gardener_plant@female@base","base_female"}},true)
                TriggerClientEvent("coletando-vinicola", source, true)
                TriggerClientEvent("progress",source,segundos,"coletando ".. vRP.itemNameList(itens["before"]))
                SetTimeout(segundos,function()
                    vRP.giveInventoryItem(user_id, itens["before"], random)
                    TriggerClientEvent("Notify", source, "sucesso", "<b>Recebido:</b> ".. random .." x ".. vRP.itemNameList(itens["before"]))
                    vRPclient._stopAnim(source, false)
                    TriggerClientEvent("coletando-vinicola", source, false)
                    _passos.logs("[".. user_id .."] - Coleta de Vinícola", "```ini\n[Recebido]: " .. vRP.itemNameList(itens["before"]) .. "\n[Quantidade]: " .. random .. "\n[Data]: " .. os.date("%H:%M:%S %d/%m/%Y") .. "```")
                end)
            else
                TriggerClientEvent("Notify", source, "negado", "Você não tem espaço no seu <b>inventário</b> para isso!")
            end
        end
    end
end

function _passos.processar()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id  then
        if cooldown["proc"] then
            if minutos_processamento[user_id] == 0 or not minutos_processamento[user_id] then
                local item_qtd = vRP.getInventoryItemAmount(user_id, itens["before"])
                local new_qtd = item_qtd*processo["multi_value"]
                if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(itens["after"])*new_qtd <= vRP.getInventoryMaxWeight(user_id) then
                    if vRP.tryGetInventoryItem(user_id, itens["before"], item_qtd) then
                        local segundos = parseInt(processo["segundos"]*1000) 
                        vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
                        TriggerClientEvent("processando-vinicola", source, true)
                        TriggerClientEvent("progress",source,segundos,"processando ".. vRP.itemNameList(itens["before"]))
                        SetTimeout(segundos,function()
                            vRP.giveInventoryItem(user_id, itens["after"], new_qtd)
                            TriggerClientEvent("Notify", source, "sucesso", "Você <b>processou</b> a(s) <b>".. vRP.itemNameList(itens["before"]) .."(s)</b> do seu inventário!")
                            TriggerClientEvent("processando-vinicola", source, false)
                            vRPclient._stopAnim(source, false)
                            minutos_processamento[user_id] = cooldown["minutos_proc"]
                            _passos.logs("[".. user_id .."] - Processo de Vinícola", "```ini\n[Recebido]: " .. vRP.itemNameList(itens["after"]) .. "\n[Quantidade]: " .. new_qtd .. "\n[Data]: " .. os.date("%H:%M:%S %d/%m/%Y") .. "```")
                        end)            
                    else
                        TriggerClientEvent("Notify", source, "negado", "Você não possui <b>".. vRP.itemNameList(itens["before"]) .. "</b> no inventário")
                    end        
                else
                    TriggerClientEvent("Notify", source, "negado", "Você não tem espaço no seu <b>inventário</b> para isso!")
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Você precisa esperar um pouco para fazer isso novamente.")
            end
        else
            local item_qtd = vRP.getInventoryItemAmount(user_id, itens["before"])
            local new_qtd = item_qtd*processo["multi_value"]
            if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(itens["after"])*new_qtd <= vRP.getInventoryMaxWeight(user_id) then
                if vRP.tryGetInventoryItem(user_id, itens["before"], item_qtd) then
                    local segundos = parseInt(processo["segundos"]*1000) 
                    vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
                    TriggerClientEvent("processando-vinicola", source, true)
                    TriggerClientEvent("progress",source,segundos,"processando ".. vRP.itemNameList(itens["before"]))
                    SetTimeout(segundos,function()
                        vRP.giveInventoryItem(user_id, itens["after"], new_qtd)
                        TriggerClientEvent("Notify", source, "sucesso", "<b>Recebido:</b> ".. new_qtd .." x ".. vRP.itemNameList(itens["after"]))
                        TriggerClientEvent("processando-vinicola", source, false)
                        vRPclient._stopAnim(source, false)
                        _passos.logs("[".. user_id .."] - Processo de Vinícola", "```ini\n[Recebido]: " .. vRP.itemNameList(itens["after"]) .. "\n[Quantidade]: " .. new_qtd .. "\n[Data]: " .. os.date("%H:%M:%S %d/%m/%Y") .. "```")
                    end)
                else
                    TriggerClientEvent("Notify", source, "negado", "Você não possui <b>".. vRP.itemNameList(itens["before"]) .. "</b> no inventário")
                end        
            else
                TriggerClientEvent("Notify", source, "negado", "Você não tem espaço no seu <b>inventário</b> para isso!")
            end
        end
    end
end
--[[
function _passos.vender()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id  then
        local qtd = vRP.prompt(source, "Quantidade que deseja Vender", "")
        if qtd == "" then
            return TriggerClientEvent("Notify", source, "negado", "Você precisa colocar a quantidade")
        end
        if not tonumber(qtd) then
            return TriggerClientEvent("Notify", source, "negado", "Precisa ser um número")
        end
        if tonumber(qtd) <= 0 then
            return TriggerClientEvent("Notify", source, "negado", "Precisa ser um número positivo")
        end
        if vRP.request(source, "Deseja vender <b>".. qtd .." x ".. vRP.itemNameList(itens["after"]) .."</b> ?", 15) then
            if vRP.tryGetInventoryItem(user_id, itens["after"], qtd) then
                local banco = vRP.getBankMoney(user_id)
                local valor = qtd*venda["valor"]
                vRP.setBankMoney(user_id, parseInt(banco+valor))
                TriggerClientEvent("Notify", source, "sucesso", "Você vendeu <b>".. qtd .." x ".. vRP.itemNameList(itens["after"]) .."</b> por <b>".. vRP.format(valor) .." reais")
                _passos.logs("[".. user_id .."] - Venda de Vinho", "```ini\n[Enviado]: " .. vRP.itemNameList(itens["after"]) .. "\n[Quantidade]: " .. qtd .. "\n[Recebido]: " .. vRP.format(valor) .. " reais\n[Data]: " .. os.date("%H:%M:%S %d/%m/%Y") .. "```")
            else
                TriggerClientEvent("Notify", source, "negado", "Você não possui <b>".. qtd .." x ".. vRP.itemNameList(itens["after"]) .. "</b> no inventário")
            end
        end
    end
end
--]]