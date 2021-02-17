-------------------------------------------------------------------------------------------------------------------
-- CONFIG
-------------------------------------------------------------------------------------------------------------------
local faccoes = {
    { nome = "Comunidade do Campinho", marker = 630, tamanho = 0.6, cor = 1, x = 757.86, y = -284.90, z = 59.88},
    { nome = "Comunidade da Barragem", marker = 630, tamanho = 0.6, cor = 2, x = 1671.25, y = -36.17, z = 173.77},
    { nome = "Comunidade do Helipa", marker = 630, tamanho = 0.6, cor = 47, x = 1375.85, y = -740.48, z = 67.23},
}

-------------------------------------------------------------------------------------------------------------------
-- SISTEMA
-------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    for k,v in pairs(faccoes) do
        local blip = AddBlipForRadius(v.x, v.y, v.z , 140.0)
        SetBlipHighDetail(blip, true)
        SetBlipColour(blip, v.cor)
        SetBlipAlpha(blip, 128)
        local marker = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipColour(marker, v.cor)
        SetBlipSprite(marker, v.marker)
        SetBlipScale(marker, v.tamanho)
        SetBlipColour(marker, v.cor)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.nome)
        EndTextCommandSetBlipName(marker)
    end
end)
