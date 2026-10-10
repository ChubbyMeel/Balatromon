local BM = Balatromon
local atlas = 'Joker_2nd'

BM.register_digimon({
    slug = 'fufumon',
    name = 'Fufumon',
    stage = 'Fresh',
    evolves_to = 'Kyokyomon',
    atlas = atlas,
    pos = {x = 5, y = 2},
    natural_x = true,
    text = {
        '{C:mult}+2{} Mult for each {C:tarot}Tarot{} or',
        '{C:planet}Planet{} held in consumable slots'
    },
    effect = '+2 Mult for every Tarot or Planet held in consumable slots'
})

BM.register_digimon({
    slug = 'kyokyomon',
    name = 'Kyokyomon',
    stage = 'In-Training',
    evolves_to = 'Ryudamon',
    atlas = atlas,
    pos = {x = 6, y = 2},
    natural_x = true,
    text = {
        '{C:mult}+3{} Mult for each consumable',
        'held in consumable slots'
    },
    effect = '+3 Mult for every consumable held in consumable slots'
})

BM.register_digimon({
    slug = 'ryudamon',
    name = 'Ryudamon',
    stage = 'Rookie',
    evolves_to = 'Ginryumon',
    atlas = atlas,
    pos = {x = 7, y = 2},
    natural_x = true,
    text = {
        '{C:mult}+5{} Mult for each non-{C:attention}Food{}',
        'consumable held in consumable slots'
    },
    effect = '+5 Mult for every non-Food consumable held in consumable slots'
})

BM.register_digimon({
    slug = 'ginryumon',
    name = 'Ginryumon',
    stage = 'Champion',
    evolves_to = 'Hisyaryumon',
    atlas = atlas,
    pos = {x = 8, y = 2},
    natural_x = true,
    extra = {mult = 0},
    text = {
        'At end of round, gain {C:mult}+6{} Mult for each',
        'non-{C:dark_edition}Negative{} consumable held',
        '{C:inactive}(Currently {C:mult}+#4#{} {C:inactive}Mult){}'
    },
    dynamic_vars = function(card, e)
        return {e.mult or 0}
    end,
    effect = 'Gain +6 Mult for every non-Negative consumable held at end of round'
})

BM.register_digimon({
    slug = 'hisyaryumon',
    name = 'Hisyaryumon',
    stage = 'Ultimate',
    evolves_to = 'Ouryumon',
    atlas = atlas,
    pos = {x = 9, y = 2},
    natural_x = true,
    extra = {xmult = 1},
    text = {
        "At end of round, multiply this Joker's {X:mult,C:white}XMult{}",
        'by {X:mult,C:white}X1.4{} for each non-{C:dark_edition}Negative{} consumable held',
        'Resets to {X:mult,C:white}X1{} if consumable slots are empty',
        '{C:inactive}(Currently {X:mult,C:white}X#4#{} {C:inactive}Mult){}'
    },
    dynamic_vars = function(card, e)
        return {string.format('%.2f', e.xmult or 1)}
    end,
    effect = 'Gain X1.4 Mult for every non-Negative consumable held at end of round. Reset if consumable slots are empty'
})

BM.register_digimon({
    slug = 'ouryumon',
    name = 'Ouryumon',
    stage = 'Mega',
    evolves_to = 'Alphamon Ouryuken',
    atlas = atlas,
    pos = {x = 0, y = 3},
    natural_x = true,
    extra = {emult = 1},
    text = {
        "At end of round, multiply this Joker's {C:attention}^Mult{}",
        'by {C:attention}^1.04{} for each non-{C:dark_edition}Negative{} consumable held',
        'Resets to {C:attention}^1{} if consumable slots are empty',
        '{C:inactive}(Currently {C:attention}^#4#{} {C:inactive}Mult){}'
    },
    dynamic_vars = function(card, e)
        return {string.format('%.2f', e.emult or 1)}
    end,
    effect = 'Gain ^1.04 Mult for every non-Negative consumable held at end of round. Reset if consumable slots are empty'
})
