local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
_Passos = Tunnel.getInterface("passos_vinho")

local coletando = false
local processando = false

-- Locais de Coleta/Processo/Venda
local coletas = { 
    { 1922.41, 5033.97, 45.89 },
}

local processos = {
    { 1982.05, 5178.16, 47.63 },
}

--[[
local vendas = {
    { 412.90, 152.01, 103.20 },
}--]]

-- Threads
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        for k,v in pairs(coletas) do
            local x,y,z = v[1], v[2], v[3]
            local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),x,y,z, true)
            if distance <= 7 then
                DrawMarker(23, x,y,z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.5,0, 95, 140, 80, 0, 0, 0, 0)
                if distance <= 5 then
                    if coletando then
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "~r~COLETANDO VINÍCOLA...", math.floor(255 - (distance * 40)), 0.54, 0.54)
                        end
                    else
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "Pressione ~r~E~w~ para coletar a vinícola", math.floor(255 - (distance * 40)), 0.54, 0.54)
                            if IsControlJustPressed(0, 38) then
                                _Passos.coletar()
                            end
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        for k,v in pairs(processos) do
            local x,y,z = v[1], v[2], v[3]
            local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),x,y,z, true)
            if distance <= 5 then
                DrawMarker(23, x,y,z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.5,0, 95, 140, 80, 0, 0, 0, 0)
                if distance <= 2 then
                    if processando then
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "~r~PROCESSANDO VINÍCOLA...", math.floor(255 - (distance * 40)), 0.54, 0.54)
                        end
                    else
                        if distance < 3 then
                            TextoMarker(x,y,z+1.0, "Pressione ~r~E~w~ para processar a vinícola", math.floor(255 - (distance * 40)), 0.54, 0.54)
                            if IsControlJustPressed(0, 38) then
                                _Passos.processar()
                            end
                        end
                    end
                end
            end
        end
    end
end)
--[[
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        for k,v in pairs(vendas) do
            local x,y,z = v[1], v[2], v[3]
            local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),x,y,z, true)
            if distance <= 5 then
                DrawMarker(23, x,y,z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.5,0, 95, 140, 80, 0, 0, 0, 0)
                if distance <= 2 then
                    if distance < 3 then
                        TextoMarker(x,y,z+1.0, "Pressione ~r~E~w~ para vender vinho", math.floor(255 - (distance * 40)), 0.54, 0.54)
                        if IsControlJustPressed(0, 38) then
                            _Passos.vender()
                        end
                    end
                end
            end
        end
    end
end)
--]]
-- Funções

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

-- Eventos
RegisterNetEvent("coletando-vinicola")
AddEventHandler("coletando-vinicola", function(boolean)
    coletando = boolean
end)

RegisterNetEvent("processando-vinicola")
AddEventHandler("processando-vinicola", function(boolean)
    processando = boolean
end)