local passos = {}

passos.usar_perm = false                                  -- Caso esteja "true" o script vai checar se o player tem a permissão de "passos.perm"
passos.perm = "venda-maconha.permissao"                   -- Caso "passos.usar_perm" esteja em "true" o script vai checar se o player tem essa permissão.
passos.price = 100                                        -- Dinheiro que o player vai ganhar por unidade (Exempl. Um player entrega 18 baseados, ele vai receber 1.800 reais)
passos.item = "maconha_empacotada"                        -- Item da entrega
passos.item2 = "baseado"                                  -- 2° Item da entrega
passos.dinheiro_sujo = "dinheiro-sujo"                    -- Item do dinheiro Sujo

-- Localizações que poderão ser geradas para entregar vinho (Caso adicione ou remova alguma, não se esqueca de mudar os valores dos randoms no client-side).

passos.entregas = {
    [1] = { ['x'] = 1697.39, ['y'] = 3596.01, ['z'] = 35.58 },
    [2] = { ['x'] = 905.88, ['y'] = 3586.26, ['z'] = 33.44 },
    [3] = { ['x'] = 2435.66, ['y'] = 4975.93, ['z'] = 46.58 },
    [4] = { ['x'] = 1915.4, ['y'] = 582.6, ['z'] = 176.37 },
    [5] = { ['x'] = 499.03, ['y'] = -550.34, ['z'] = 24.76 },
    [6] = { ['x'] = 725.6, ['y'] = -694.22, ['z'] = 27.52 },
    [7] = { ['x'] = 765.51, ['y'] = -1763.83, ['z'] = 30.36 },
    [8] = { ['x'] = 930.31, ['y'] = -1807.58, ['z'] = 31.39 },
    [9] = { ['x'] = -3167.03, ['y'] = 1074.01, ['z'] = 20.85 }
}

return passos
