local passos = {}

passos.usar_perm = false        -- Caso esteja "true" o script vai checar se o player tem a permissão de "passos.perm"
passos.perm = "farm.vinho"      -- Caso "passos.usar_perm" esteja em "true" o script vai checar se o player tem essa permissão.
passos.price = 100              -- Dinheiro que o player vai ganhar por unidade (Exempl. Um player entrega 18 vinhos, ele vai receber 1.800 reais)
passos.item = "vinho"           -- Item da entrega

-- Localizações que poderão ser geradas para entregar vinho (Caso adicione ou remova alguma, não se esqueca de mudar os valores dos randoms no client-side).

passos.entregas = {
    [1] = { ['x'] = 376.09, ['y'] = 319.25,   ['z'] = 104.09 },
    [2] = { ['x'] = 222.3,  ['y'] = 304.16,   ['z'] = 106.68 },
    [3] = { ['x'] = 241.48, ['y'] = 357.8,    ['z'] = 106.42 },
    [4] = { ['x'] = -66.17, ['y'] = -799.45,  ['z'] = 44.9 },
    [5] = { ['x'] = 68.38,  ['y'] = -960.66,  ['z'] = 30.27 },
    [6] = { ['x'] = 253.16, ['y'] = -1012.8,  ['z'] = 29.65 },
    [7] = { ['x'] = 273.79, ['y'] = -833.91,  ['z'] = 29.59 },
    [8] = { ['x'] = 383.44, ['y'] = -1076.15, ['z'] = 29.94 },
    [9] = { ['x'] = 130.36, ['y'] = -1300.5,  ['z'] = 29.68 }
}

return passos