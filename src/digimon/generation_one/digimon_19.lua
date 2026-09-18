local BM = Balatromon

BM.register_digimon({
    slug = 'choromon',
    name = 'Choromon',
    stage = 'Fresh',
    evolves_to = 'Missimon',
    pos = {x = 2, y = 18},
    text = {
        'On a {C:attention}Boss Blind{}, create the {C:planet}Planet{} card',
        'of the first played poker hand',
        '{C:inactive}(Must have room){}',
    },
    effect = 'Create the Planet card of the first played poker hand on a Boss Blind'
})

BM.register_digimon({
    slug = 'missimon',
    name = 'Missimon',
    stage = 'In-Training',
    evolves_to = 'Solarmon, Hagurumon',
    pos = {x = 3, y = 18},
    text = {
        'When a poker hand is upgraded to an',
        '{C:attention}even-numbered level{}, upgrade it again',
    },
    effect = 'When a poker hand is upgraded to an even-numbered level, upgrade it again'
})

BM.register_digimon({
    slug = 'solarmon',
    name = 'Solarmon',
    stage = 'Rookie',
    evolves_to = 'Meramon, Flarerizamon',
    pos = {x = 4, y = 18},
    text = {
        '{C:mult}+4{} Mult for each unique {C:planet}Planet{} card',
        'used this run',
        '{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult){}',
    },
    dynamic_vars = function()
        return {
            4 * BM.unique_planets_used()
        }
    end,
    effect = '+4 Mult for each unique Planet card used this run'
})

BM.register_digimon({
    slug = 'hagurumon',
    name = 'Hagurumon',
    stage = 'Rookie',
    evolves_to = 'Meramon',
    pos = {x = 5, y = 18},
    text = {
        'Earn {C:money}$1{} at end of round for each unique',
        '{C:planet}Planet{} card used this run',
        '{C:inactive}(Currently {C:money}$#4#{C:inactive}){}',
    },
    dynamic_vars = function()
        return {
            BM.unique_planets_used()
        }
    end,
    effect = '$1 at end of round for each unique Planet card used this run'
})

BM.register_digimon({
    slug = 'meramon',
    name = 'Meramon',
    stage = 'Champion',
    evolves_to = 'BlueMeramon',
    pos = {x = 6, y = 18},
    extra = {
        xmult = 1
    },
    text = {
        'Gains {X:mult,C:white}X0.1{} Mult whenever a',
        '{C:planet}Planet{} card is used',
        '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
    },
    dynamic_vars = function(card, e)
        return {
            e.xmult or 1
        }
    end,
    effect = 'Gains X0.1 Mult whenever a Planet card is used'
})

BM.register_digimon({
    slug = 'flarerizamon',
    name = 'Flarerizamon',
    stage = 'Champion',
    evolves_to = 'Lavogaritamon',
    pos = {x = 7, y = 18},
    digimon_tooltips = {
        'solarmon',
        'hagurumon'
    },
    text = {
        'Also applies {C:attention}Solarmon{} and',
        '{C:attention}Hagurumon{} effects',
    },
    effect = 'Applies Solarmon and Hagurumon effects'
})

BM.register_digimon({
    slug = 'bluemeramon',
    name = 'BlueMeramon',
    stage = 'Ultimate',
    evolves_to = '-',
    pos = {x = 8, y = 18},
    extra = {
        xmult = 1
    },
    text = {
        'Gains {X:mult,C:white}X0.36{} Mult whenever a',
        '{C:planet}Planet{} card is used',
        '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
        '{C:inactive}(Carries Meramon\'s Mult when Digivolving){}',
    },
    dynamic_vars = function(card, e)
        return {
            e.xmult or 1
        }
    end,
    effect = 'Gains X0.36 Mult whenever a Planet card is used and inherits Meramon current XMult'
})

BM.register_digimon({
    slug = 'lavogaritamon',
    name = 'Lavogaritamon',
    stage = 'Ultimate',
    evolves_to = 'HippoGryphonmon',
    pos = {x = 9, y = 18},
    text = {
        'Each {C:planet}Planet{} card held in your',
        'consumable slots gives {X:mult,C:white}X1.2{} Mult',
    },
    effect = 'Each Planet card held in consumable slots gives X1.2 Mult'
})

