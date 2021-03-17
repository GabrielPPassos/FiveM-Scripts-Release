local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local config = module("passos_vinho-entregas", "config")

vRP = Proxy.getInterface("vRP")
passos_vinho = Tunnel.getInterface("passos_vinho-entregas")

local blips = false
local entregando = false
local selecionado = 0
local pedido = 0 

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if not entregando then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
            local CoordenadaX,CoordenadaY,CoordenadaZ = -313.01, -1032.11, 31.34
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)
			if distance <= 30.0 then
				DrawMarker(21,CoordenadaX,CoordenadaY,CoordenadaZ-0.5,0,0,0,0,180.0,130.0,1.0,1.0,0.5,240,0,0,30,1,0,0,1)
				if distance <= 1.5 then
					drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR A ROTA DE VINHO",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and passos_vinho.checkperm() then
						if passos_vinho.gerarEntrega() then
							selecionado = math.random(9)
							cblip(entregas,selecionado)
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if entregando then
			local before 
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(config.entregas[selecionado].x,config.entregas[selecionado].y,config.entregas[selecionado].z)
			local distance = GetDistanceBetweenCoords(config.entregas[selecionado].x,config.entregas[selecionado].y,cdz,x,y,z,true)
			if distance <= 30.0 then
				DrawMarker(21,config.entregas[selecionado].x,config.entregas[selecionado].y,config.entregas[selecionado].z-0.7,0,0,0,0,180.0,130.0,1.0,1.0,0.5,240,200,80,30,1,0,0,1)
				if distance <= 1.5 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA ENTREGAR ~r~".. pedido .." VINHO(S)",4,0.5,0.93,0.50,255,255,255,180)
                    if IsControlJustPressed(0,38) then
                        if passos_vinho.payment() then
							RemoveBlip(blips)
							Wait(2000)
							if passos_vinho.gerarEntrega() then
								before = selecionado
								selecionado = math.random(9)
								if selecionado == before then
									selecionado = selecionado + 1
								end
								cblip(entregas,selecionado)
							else
								entregando = false
							end
						else
							TriggerClientEvent("Notify", "negado", "Não encontramos nenhum <b>vinho</b> na sua mochila.")
						end
			        end
                end
            end
        end
	end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)
        if entregando then
		    drawTxt("~c~PARA CANCELAR AS ENTREGAS PRESSIONE ~r~[F7]",4,0.270,0.905,0.45,255,255,255,200)
		    drawTxt("VOCÊ PRECISA ENTREGAR ~r~".. pedido .." VINHO(S)",4,0.270,0.93,0.45,255,255,255,200)
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if entregando then
			if IsControlJustPressed(0,168) then
				entregando = false
				RemoveBlip(blips)
			end
		end
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
	AddTextComponentString("Entregar ".. pedido .." vinho(s)")
	EndTextCommandSetBlipName(blips)
end

RegisterNetEvent("atualizar-qtd") AddEventHandler("atualizar-qtd", function(qtd) pedido = qtd end)
RegisterNetEvent("entrega-vinho") AddEventHandler("entrega-vinho", function(boolean) entregando = boolean end)
