local BM = Balatromon
local atlas = 'Joker_2nd'

BM.register_digimon({
    slug = 'dodomon',
    name = 'Dodomon',
    stage = 'Fresh',
    evolves_to = 'Dorimon',
    atlas = atlas,
    pos = {x = 1, y = 3},
    natural_x = true,
    text = {
        'Sell this card to create an',
        '{C:attention}X-Antibody{} Digi Item'
    },
    effect = 'Sell to create an X-Antibody'
})

BM.register_digimon({
    slug = 'dorimon',
    name = 'Dorimon',
    stage = 'In-Training',
    evolves_to = 'DORUmon',
    atlas = atlas,
    pos = {x = 2, y = 3},
    natural_x = true,
    extra = {mult = 3},
    text = {
        'Gain {C:mult}+2{} Mult whenever an',
        '{C:attention}X-Antibody{} appears in a shop or pack',
        '{C:inactive}(Currently {C:mult}+#4#{} {C:inactive}Mult){}'
    },
    dynamic_vars = function(card, e)
        return {e.mult or 3}
    end,
    effect = 'Starts with +3 Mult. Gains +2 Mult whenever an X-Antibody appears in a shop or pack'
})

BM.register_digimon({
    slug = 'dorumon',
    name = 'DORUmon',
    stage = 'Rookie',
    evolves_to = 'DORUgamon, Raptordramon',
    atlas = atlas,
    pos = {x = 3, y = 3},
    natural_x = true,
    text = {
        '{C:mult}+5{} Mult for every {C:attention}X-Antibody{}',
        'used this run',
        '{C:inactive}(Currently {C:mult}+#4#{} {C:inactive}Mult){}'
    },
    dynamic_vars = function()
        return {5 * (G.GAME and G.GAME.balatromon_x_used or 0)}
    end,
    effect = '+5 Mult for each X-Antibody used this run'
})

BM.register_digimon({
    slug = 'dorugamon',
    name = 'DORUgamon',
    stage = 'Champion',
    evolves_to = 'DORUGreymon, Grademon',
    atlas = atlas,
    pos = {x = 4, y = 3},
    natural_x = true,
    text = {
        '{C:mult}+10{} Mult for every {C:attention}X-Antibody{}',
        'used this run',
        '{C:inactive}(Currently {C:mult}+#4#{} {C:inactive}Mult){}'
    },
    dynamic_vars = function()
        return {10 * (G.GAME and G.GAME.balatromon_x_used or 0)}
    end,
    effect = '+10 Mult for each X-Antibody used this run'
})

BM.register_digimon({
    slug = 'raptordramon',
    name = 'Raptordramon',
    stage = 'Champion',
    evolves_to = 'Grademon',
    atlas = atlas,
    pos = {x = 5, y = 3},
    natural_x = true,
    extra = {active = false},
    text = {
        'Become {C:attention}active{} when a {C:attention}Boss Blind{} starts',
        'While active, give a random viable Digimon',
        '{C:attention}X-Antibody{} at end of round',
        'Become inactive after giving one'
    },
    effect = 'Activates on a Boss Blind. Gives a random viable Digimon X-Antibody at end of round, then deactivates'
})

BM.register_digimon({
    slug = 'dorugreymon',
    name = 'DORUGreymon',
    stage = 'Ultimate',
    evolves_to = 'DORUgoramon, Alphamon',
    atlas = atlas,
    pos = {x = 6, y = 3},
    natural_x = true,
    text = {
        'Gain {X:mult,C:white}X0.3{} Mult for every',
        '{C:attention}X-Antibody{} used this run',
        '{C:inactive}(Currently {X:mult,C:white}X#4#{} {C:inactive}Mult){}'
    },
    dynamic_vars = function()
        return {string.format('%.2f', 1 + 0.3 * (G.GAME and G.GAME.balatromon_x_used or 0))}
    end,
    effect = 'Gain X0.3 Mult for every X-Antibody used this run'
})

BM.register_digimon({
    slug = 'grademon',
    name = 'Grademon',
    stage = 'Ultimate',
    evolves_to = 'Alphamon',
    atlas = atlas,
    pos = {x = 7, y = 3},
    natural_x = true,
    digimon_tooltips = {'raptordramon'},
    text = {
        'Retrigger {C:attention}X-Antibody{} Digimon',
        'immediately to the left once',
        'Applies {C:attention}Raptordramon{}'
    },
    effect = 'Retrigger X-Antibody Digimon immediately to the left once. Apply Raptordramon'
})

BM.register_digimon({
    slug = 'dorugoramon',
    name = 'DORUgoramon',
    stage = 'Mega',
    evolves_to = '-',
    atlas = atlas,
    pos = {x = 8, y = 3},
    natural_x = true,
    text = {
        'Gain {C:attention}^0.03{} Mult for every',
        '{C:attention}X-Antibody{} used this run',
        '{C:inactive}(Currently {C:attention}^#4#{} {C:inactive}Mult){}'
    },
    dynamic_vars = function()
        return {string.format('%.2f', 1 + 0.03 * (G.GAME and G.GAME.balatromon_x_used or 0))}
    end,
    effect = 'Gain ^0.03 Mult for every X-Antibody used this run'
})

BM.register_digimon({
    slug = 'alphamon',
    name = 'Alphamon',
    stage = 'Mega',
    evolves_to = 'Alphamon Ouryuken',
    atlas = atlas,
    pos = {x = 9, y = 3},
    natural_x = true,
    digimon_tooltips = {'raptordramon'},
    text = {
        'Retrigger all other {C:attention}X-Antibody{}',
        'Digimon once',
        'Applies {C:attention}Raptordramon{}'
    },
    effect = 'Retrigger all other X-Antibody Digimon once. Apply Raptordramon'
})

BM.register_digimon({
    slug = 'alphamon_ouryuken',
    name = 'Alphamon Ouryuken',
    stage = 'Beyond',
    evolves_to = '-',
    atlas = atlas,
    pos = {x = 0, y = 4},
    natural_x = true,
    digimon_tooltips = {'alphamon'},
    text = {
        'Gain {X:mult,C:white}^0.03{} Mult for every',
        '{C:attention}X-Antibody{} used this run and',
        '{X:chips,C:white}^1.05{} Chips per consumable held',
        'Apply {C:attention}Alphamon{} if consumable slots are empty',
        '{C:inactive}(Currently {X:mult,C:white}^#4#{C:inactive} Mult,',
        '{X:chips,C:white}^#5#{C:inactive} Chips){}'
    },
    dynamic_vars = function()
        local count = G.consumeables and #G.consumeables.cards or 0
        local used = G.GAME and G.GAME.balatromon_x_used or 0
        return {string.format('%.2f', 1 + 0.03 * used), string.format('%.2f', 1.05 ^ count)}
    end,
    effect = 'Gain ^0.03 Mult per X-Antibody used and ^1.05 Chips per consumable held. Apply Alphamon if consumables are empty'
})
