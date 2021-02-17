Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))
		local c,d,s = 441.04,-978.83,30.68
        local distance = Vdist(x,y,z,c,d,s)
        if distance <= 2.5 then
            DrawMarker(21,c,d,s-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
            DrawText3D(c,d,s, "~b~E - ~g~Registrar B.O")
            if IsControlJustPressed(0,38) then
                TriggerServerEvent("gerar_bo")
            end
        end	
	end
end)

function DrawText3D(x,y,z, text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,50)
end
