local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local config = module("passos_weed-delivery", "config")

vRP = Proxy.getInterface("vRP")
passos_weed = Tunnel.getInterface("passos_weed-delivery")

local blips = false
local entregando = false
local selecionado = 0
local pedido = 0 
local type

Citizen.CreateThread(function()
	while true do
		local otimizacao = 1000
		if not entregando then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
            local CoordenadaX,CoordenadaY,CoordenadaZ = -112.37,1882.1,197.34
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)
			if distance <= 3.0 then
				otimizacao = 1
				DrawMarker(21,CoordenadaX,CoordenadaY,CoordenadaZ-0.5,0,0,0,0,180.0,130.0,1.0,1.0,0.5,0,255,0,30,1,0,0,1)
				if distance <= 1.5 then
					drawTxt("PRESSIONE  ~g~E~w~  PARA INICIAR A ROTA DE MACONHA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and passos_weed.checkperm() then
						if passos_weed.gerarEntrega() then
							selecionado = math.random(9)
							cblip(entregas,selecionado)
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
		if entregando then
			local before 
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(config.entregas[selecionado].x,config.entregas[selecionado].y,config.entregas[selecionado].z)
			local distance = GetDistanceBetweenCoords(config.entregas[selecionado].x,config.entregas[selecionado].y,cdz,x,y,z,true)
			if distance <= 3.0 then
				otimizacao = 1
				DrawMarker(21,config.entregas[selecionado].x,config.entregas[selecionado].y,config.entregas[selecionado].z-0.7,0,0,0,0,180.0,130.0,1.0,1.0,0.5,240,200,80,30,1,0,0,1)
				if distance <= 1.5 then
					drawTxt("PRESSIONE  ~g~E~w~  PARA ENTREGAR",4,0.5,0.93,0.50,255,255,255,180)
                    if IsControlJustPressed(0,38) then
                        if passos_weed.payment() then
							RemoveBlip(blips)
							Wait(2000)
							if passos_weed.gerarEntrega() then
								before = selecionado
								selecionado = math.random(9)
								if selecionado == before then
									selecionado = selecionado + 1
								end
								cblip(entregas,selecionado)
							else
								entregando = false
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
        if entregando then
			otimizacao = 1
			if type == "pacote" then
		    	drawTxt("~c~PARA CANCELAR AS ENTREGAS PRESSIONE ~g~[F7]",4,0.270,0.905,0.45,255,255,255,200)
		    	drawTxt("VOCÊ PRECISA ENTREGAR ~g~".. pedido .." MACONHA(S) EMPACOTADA(S)",4,0.270,0.93,0.45,255,255,255,200)
			elseif type == "baseado" then
				drawTxt("~c~PARA CANCELAR AS ENTREGAS PRESSIONE ~r~[F7]",4,0.270,0.905,0.45,255,255,255,200)
		    	drawTxt("VOCÊ PRECISA ENTREGAR ~g~".. pedido .." BASEADO(S)",4,0.270,0.93,0.45,255,255,255,200)
			end
        end
        Citizen.Wait(otimizacao)
	end
end)

Citizen.CreateThread(function()
	while true do
		local otimizacao = 1000
		if entregando then
			otimizacao = 1
			if IsControlJustPressed(0,168) then
				entregando = false
				RemoveBlip(blips)
			end
		end
		Citizen.Wait(otimizacao)
	end
end)

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function cblip(locs,selecionado)
	blips = AddBlipForCoord(config.entregas[selecionado].x,config.entregas[selecionado].y,config.entregas[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega ilegal")
	EndTextCommandSetBlipName(blips)
end

RegisterNetEvent("returnTypeWeed") AddEventHandler("returnTypeWeed", function(x)  type = x end)
RegisterNetEvent("atualizar-qtd2") AddEventHandler("atualizar-qtd2", function(qtd) pedido = qtd end)
RegisterNetEvent("entrega-weed") AddEventHandler("entrega-weed", function(boolean) entregando = boolean end)
