local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local config = module("passos_weed-farm", "config")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
WeedPassos = Tunnel.getInterface("passos_weed-farm")

passos_weed = {}
Proxy.addInterface("passos_weed-farm", passos_weed)
Tunnel.bindInterface("passos_weed-farm", passos_weed)

function passos_weed.checkperm()
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

function passos_weed.processarAdubo()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local adubo = config.itens['adubo']
        local adubo_qtd = vRP.getInventoryItemAmount(user_id, adubo)
        if adubo_qtd > 0 then
            local segundos = parseInt(config.tempo['processar_adubo']*1000) 
            vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
            vRP.tryGetInventoryItem(user_id, adubo, adubo_qtd)
            WeedPassos.attStatus(source, "padubo", true)
            TriggerClientEvent("progress",source,segundos,"processando ".. vRP.itemNameList(adubo))
            SetTimeout(segundos, function()
                vRP.giveInventoryItem(user_id, config.itens['fertilizante'], adubo_qtd)
                vRPclient._stopAnim(source, false)
                WeedPassos.attStatus(source, "padubo", false)
                TriggerClientEvent("Notify", source, "sucesso", "Você <b>processou</b> os seus <b>adubos</b>")
            end)
        else
            TriggerClientEvent("Notify", source, "negado", "Não encontramos nenhum <b>".. vRP.itemNameList(adubo) .."</b> na sua mochila")
        end
    end
end

function passos_weed.coletarCannabis()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local cannabis = config.itens['folha_maconha']
        local segundos = parseInt(config.tempo['coletar_maconha']*1000) 
        local random = math.random(parseInt(config.random_folha))
        vRPclient._playAnim(source,false,{{"amb@world_human_gardener_plant@female@base","base_female"}},true)
        WeedPassos.attStatus(source, "cmaconha", true)
        TriggerClientEvent("progress",source,segundos,"coletando folha de maconha")
        SetTimeout(segundos, function()
            vRP.giveInventoryItem(user_id, config.itens['folha_maconha'], random)
            vRPclient._stopAnim(source, false)
            WeedPassos.attStatus(source, "cmaconha", false)
            TriggerClientEvent("Notify", source, "sucesso", "<b>Coletado:</b> ".. random)
        end)
    end
end

function passos_weed.processarCannabis()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local fertilizante = config.itens['fertilizante']
        local cannabis = config.itens['folha_maconha']
        local fqtd = vRP.getInventoryItemAmount(user_id, fertilizante)
        local cqtd = vRP.getInventoryItemAmount(user_id, cannabis)
        if fqtd > 0 then
            if cqtd > 0 then
                if fqtd >= cqtd then
                    local segundos = parseInt(config.tempo['processar_maconha']*1000)
                    vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
                    vRP.tryGetInventoryItem(user_id, cannabis, cqtd)
                    vRP.tryGetInventoryItem(user_id, fertilizante, cqtd)
                    WeedPassos.attStatus(source, "pmaconha", true)
                    TriggerClientEvent("progress",source,segundos,"processando ".. vRP.itemNameList(cannabis))
                    SetTimeout(segundos, function()
                        vRP.giveInventoryItem(user_id, config.itens['maconha_pronta'], cqtd)
                        vRPclient._stopAnim(source, false)
                        WeedPassos.attStatus(source, "pmaconha", false)
                        TriggerClientEvent("Notify", source, "sucesso", "<b>Processado:</b> ".. cqtd)
                    end)
                else
                    TriggerClientEvent("Notify", source, "negado", "Você não tem <b>".. vRP.itemNameList(fertilizante) .."</b> suficiente na sua mochila")
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Você não tem <b>".. vRP.itemNameList(cannabis) .."</b> na sua mochila")
            end
        else
            TriggerClientEvent("Notify", source, "negado", "Você não tem <b>".. vRP.itemNameList(fertilizante) .."</b> na sua mochila")
        end
    end
end

function passos_weed.empacotarMaconha()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local maconha = config.itens['maconha_pronta']
        local pacotes = config.itens['pacotes']
        local pqtd = vRP.getInventoryItemAmount(user_id, pacotes)
        local mqtd = vRP.getInventoryItemAmount(user_id, maconha)
        if mqtd > 0 then
            if pqtd > 0 then
                local segundos = parseInt(config.tempo['empacotar_maconha']*1000)
                vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
                vRP.tryGetInventoryItem(user_id, maconha, mqtd)
                vRP.tryGetInventoryItem(user_id, pacotes, 1)
                WeedPassos.attStatus(source, "emaconha", true)
                TriggerClientEvent("progress",source,segundos,"empacotando ".. vRP.itemNameList(maconha))
                SetTimeout(segundos, function()
                    vRP.giveInventoryItem(user_id, config.itens['maconha_empacotada'], mqtd)
                    vRPclient._stopAnim(source, false)
                    WeedPassos.attStatus(source, "emaconha", false)
                    TriggerClientEvent("Notify", source, "sucesso", "<b>Empacotado:</b> ".. mqtd)
                end)
            else
                TriggerClientEvent("Notify", source, "negado", "Você não tem <b>".. vRP.itemNameList(pacotes) .."</b> na sua mochila")
            end
        else
            TriggerClientEvent("Notify", source, "negado", "Você não tem <b>".. vRP.itemNameList(maconha) .."</b> na sua mochila")
        end
    end
end

function passos_weed.bolarBaseado()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local maconha = config.itens['maconha_empacotada']
        local maconha2 = config.itens['maconha_pronta']
        local baseado = config.itens['baseado']
        local seda = config.itens['seda']
        local mqtd = vRP.getInventoryItemAmount(user_id, maconha)
        local mqtd2 = vRP.getInventoryItemAmount(user_id, maconha2)
        local sqtd = vRP.getInventoryItemAmount(user_id, seda)
        if mqtd > 0 then
            if sqtd > 0 then
                local segundos = parseInt(config.tempo['desempacotar_maconha']*1000)
                TriggerClientEvent("progress",source,segundos,"desempacotando ".. vRP.itemNameList(maconha))
                vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
                vRP.tryGetInventoryItem(user_id, maconha, 1)
                WeedPassos.attStatus(source, "desempac", true)
                SetTimeout(segundos, function()
                    TriggerClientEvent("Notify", source, "sucesso", "Você <b>desempacotou</b> a <b>maconha</b>, agora você vai bolar o baseado.")
                    local segundos2 = parseInt(config.tempo['bolar_baseado']*1000)
                    vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
                    TriggerClientEvent("progress",source,segundos2,"bolando ".. vRP.itemNameList(baseado))
                    vRP.tryGetInventoryItem(user_id, seda, 1)
                    WeedPassos.attStatus(source, "desempac", false)
                    WeedPassos.attStatus(source, "bbaseado", true)
                    SetTimeout(segundos2, function()
                        vRP.giveInventoryItem(user_id, config.itens['baseado'], 1)
                        vRPclient._stopAnim(source, false)
                        TriggerClientEvent("Notify", source, "sucesso", "Você <b>bolou</b> um baseado")
                        WeedPassos.attStatus(source, "bbaseado", false)
                    end)
                end)
            else
                TriggerClientEvent("Notify", source, "negado", "Você não tem <b>".. vRP.itemNameList(seda) .."</b> na sua mochila")
            end
        else
            if mqtd2 > 0 then
                if sqtd > 0 then
                    local segundos = parseInt(config.tempo['bolar_baseado']*1000)
                    vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
                    vRP.tryGetInventoryItem(user_id, seda, 1)
                    vRP.tryGetInventoryItem(user_id, maconha2, 1)
                    WeedPassos.attStatus(source, "bbaseado", true)
                    TriggerClientEvent("progress",source,segundos,"bolando ".. vRP.itemNameList(baseado))
                    SetTimeout(segundos, function()
                        vRP.giveInventoryItem(user_id, config.itens['baseado'], 1)
                        vRPclient._stopAnim(source, false)
                        WeedPassos.attStatus(source, "bbaseado", false)
                        TriggerClientEvent("Notify", source, "sucesso", "Você <b>bolou</b> um baseado")
                    end)
                else
                    TriggerClientEvent("Notify", source, "negado", "Você não tem <b>".. vRP.itemNameList(seda) .."</b> na sua mochila")
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Você não tem <b>".. vRP.itemNameList(maconha) .."</b> na sua mochila")
            end
        end
    end
end