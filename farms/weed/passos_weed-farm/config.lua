local passos = {}

passos.usar_perm = false
passos.perm = "farm-maconha.permissao"
passos.random_folha = 5

passos.tempo = { 
    ['processar_adubo'] = 15,
    ['coletar_maconha'] = 15,
    ['processar_maconha'] = 15,
    ['empacotar_maconha'] = 15,
    ['desempacotar_maconha'] = 15,
    ['bolar_baseado'] = 15
}

passos.itens = {
    ['adubo'] = "adubo",
    ['fertilizante'] = "fertilizante",
    ['folha_maconha'] = "folha_maconha",
    ['pacotes'] = "pacotes",
    ['maconha_pronta'] = "maconha_pronta",
    ['maconha_empacotada'] = "maconha_empacotada",
    ['seda'] = "seda",
    ['baseado'] = "baseado"
}

passos.locais = { 
    ['processar_adubo'] = {
        { ['x'] = -1081.35, ['y'] = 4898.47, ['z'] = 214.28 },
    },

    ['coletar_folha'] = {
        { ['x'] = 2214.61, ['y'] = 5577.34, ['z'] = 53.76 },
    },

    ['processar_folha'] = {
        { ['x'] = 612.71, ['y'] = -3061.86, ['z'] = 6.07 },
    },

    ['empacotar_maconha'] = {
        { ['x'] = 1208.72, ['y'] = -3112.63, ['z'] = 5.75 },
    },

    ['baseados'] = {
        { ['x'] = 1456.49, ['y'] = 3754.01, ['z'] = 31.94 },
    },
}

return passos