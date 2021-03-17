local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local config = module("passos_weed-farm", "config")

vRP = Proxy.getInterface("vRP")
WeedPassos = Tunnel.getInterface("passos_weed-farm")

passos_weed = {}
Proxy.addInterface("passos_weed-farm", passos_weed)
Tunnel.bindInterface("passos_weed-farm", passos_weed)

local padubo = false
local cmaconha = false
local pmaconha = false
local emaconha = false
local bbaseado = false
local desempac = false

Citizen.CreateThread(function()
    while true do
        local otimizacao = 1000
        for k,v in pairs(config.locais['processar_adubo']) do
            local x,y,z = v.x, v.y, v.z
            local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),x,y,z, true)
            if distance <= 7 then
                otimizacao = 1
                DrawMarker(23, x,y,z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.5,0, 95, 140, 80, 0, 0, 0, 0)
                if distance <= 5 then
                    if padubo then
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "~g~PROCESSANDO O ADUBO...", math.floor(255 - (distance * 40)), 0.54, 0.54)
                        end
                    else
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "Pressione ~g~E~w~ para processar o adubo", math.floor(255 - (distance * 40)), 0.54, 0.54)
                            if IsControlJustPressed(0, 38) and WeedPassos.checkperm() then
                                WeedPassos.processarAdubo()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(otimizacao)
    end
end)

Citizen.CreateThread(function()
    while true do
        local otimizacao = 1000
        for k,v in pairs(config.locais['coletar_folha']) do
            local x,y,z = v.x, v.y, v.z
            local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),x,y,z, true)
            if distance <= 7 then
                otimizacao = 1
                DrawMarker(23, x,y,z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.5,0, 95, 140, 80, 0, 0, 0, 0)
                if distance <= 5 then
                    if cmaconha then
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "~g~COLHENDO A FOLHA DE MACONHA...", math.floor(255 - (distance * 40)), 0.54, 0.54)
                        end
                    else
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "Pressione ~g~E~w~ para colher a Folha de Maconha", math.floor(255 - (distance * 40)), 0.54, 0.54)
                            if IsControlJustPressed(0, 38) and WeedPassos.checkperm() then
                                WeedPassos.coletarCannabis()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(otimizacao)
    end
end)

Citizen.CreateThread(function()
    while true do
        local otimizacao = 1000
        for k,v in pairs(config.locais['processar_folha']) do
            local x,y,z = v.x, v.y, v.z
            local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),x,y,z, true)
            if distance <= 7 then
                otimizacao = 1
                DrawMarker(23, x,y,z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.5,0, 95, 140, 80, 0, 0, 0, 0)
                if distance <= 5 then
                    if pmaconha then
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "~g~PROCESSANDO A FOLHA DE MACONHA...", math.floor(255 - (distance * 40)), 0.54, 0.54)
                        end
                    else
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "Pressione ~g~E~w~ para processar a Folha de Maconha", math.floor(255 - (distance * 40)), 0.54, 0.54)
                            if IsControlJustPressed(0, 38) and WeedPassos.checkperm() then
                                WeedPassos.processarCannabis()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(otimizacao)
    end
end)

Citizen.CreateThread(function()
    while true do
        local otimizacao = 1000
        for k,v in pairs(config.locais['empacotar_maconha']) do
            local x,y,z = v.x, v.y, v.z
            local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),x,y,z, true)
            if distance <= 7 then
                otimizacao = 1
                DrawMarker(23, x,y,z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.5,0, 95, 140, 80, 0, 0, 0, 0)
                if distance <= 5 then
                    if emaconha then
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "~g~EMPACOTANDO A MACONHA...", math.floor(255 - (distance * 40)), 0.54, 0.54)
                        end
                    else
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "Pressione ~g~E~w~ para empacotar a maconha", math.floor(255 - (distance * 40)), 0.54, 0.54)
                            if IsControlJustPressed(0, 38) and WeedPassos.checkperm() then
                                WeedPassos.empacotarMaconha()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(otimizacao)
    end
end)

Citizen.CreateThread(function()
    while true do
        local otimizacao = 1000
        for k,v in pairs(config.locais['baseados']) do
            local x,y,z = v.x, v.y, v.z
            local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),x,y,z, true)
            if distance <= 7 then
                otimizacao = 1
                DrawMarker(23, x,y,z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.5,0, 95, 140, 80, 0, 0, 0, 0)
                if distance <= 5 then
                    if bbaseado then
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "~g~BOLANDO UM BASEADO...", math.floor(255 - (distance * 40)), 0.54, 0.54)
                        end
                    elseif desempac then
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "~g~DESEMPACOTANDO A MACONHA...", math.floor(255 - (distance * 40)), 0.54, 0.54)
                        end
                    else
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "Pressione ~g~E~w~ para bolar um baseado", math.floor(255 - (distance * 40)), 0.54, 0.54)
                            if IsControlJustPressed(0, 38) and WeedPassos.checkperm() then
                                WeedPassos.bolarBaseado()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(otimizacao)
    end
end)

function TextoMarker(x,y,z, text, Opacidade, s1, s2)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())    
    if onScreen then 
        SetTextScale(s1, s2)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, Opacidade)
        SetTextDropshadow(0, 0, 0, 0, Opacidade)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function passos_weed.attStatus(t, boolean)
    if t == "padubo" then
        padubo = boolean
    elseif t == "cmaconha" then
        cmaconha = boolean
    elseif t == "pmaconha" then
        pmaconha = boolean
    elseif t == "emaconha" then
        emaconha = boolean
    elseif t == "bbaseado" then
        bbaseado = boolean
    elseif t == "desempac" then
        desempac = boolean
    end
end