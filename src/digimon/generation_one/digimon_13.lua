local BM = Balatromon

BM.register_digimon({
    slug = 'conomon',
    name = 'Conomon',
    stage = 'Fresh',
    evolves_to = 'Kokomon',

    pos = {
        x = 9,
        y = 19
    },

    text = {
        'Each played {C:attention}face card{} has a',
        '{C:green}#4# in #5#{} chance to give {C:money}$2{}'
    },

    dynamic_vars =
    function(card, e)
        local numerator,
        denominator =
            SMODS.get_probability_vars(
                card,
                1,
                2,
                'conomon_face'
            )

        return {
            numerator,
            denominator
        }
    end,

    effect =
        'Each played face card has a 1 in 2 chance to give $2'
})

BM.register_digimon({
    slug = 'kokomon',
    name = 'Kokomon',
    stage = 'In-Training',
    evolves_to = 'Lopmon',

    pos = {
        x = 0,
        y = 20
    },

    digimon_tooltips = {
        'conomon'
    },

    text = {
        'Gains {C:money}$3{} of sell value',
        'at the end of each round',
        'Also applies {C:attention}Conomon{} effect'
    },

    effect =
        'Gain $3 sell value at end of round and apply Conomon'
})

BM.register_digimon({
    slug = 'lopmon',
    name = 'Lopmon',
    stage = 'Rookie',

    evolves_to =
        'Turuiemon, Wendigomon',

    pos = {
        x = 1,
        y = 20
    },

    text = {
        'If played hand contains a {C:attention}King{},',
        '{C:attention}Queen{}, and {C:attention}10{},',
        '{C:green}#4# in #5#{} chance to create a',
        'random {C:planet}Planet{} card and',
        '{C:green}#6# in #7#{} chance to create a',
        'random {C:spectral}Spectral{} card',
        '{C:inactive}(Must have room){}'
    },

    dynamic_vars =
    function(card, e)
        local planet_n,
        planet_d =
            SMODS.get_probability_vars(
                card,
                1,
                3,
                'lopmon_planet'
            )

        local spectral_n,
        spectral_d =
            SMODS.get_probability_vars(
                card,
                1,
                5,
                'lopmon_spectral'
            )

        return {
            planet_n,
            planet_d,
            spectral_n,
            spectral_d
        }
    end,

    effect =
        'If hand contains King, Queen and 10, 1 in 3 chance for Planet and 1 in 5 chance for Spectral'
})

BM.register_digimon({
    slug = 'turuiemon',
    name = 'Turuiemon',
    stage = 'Champion',
    evolves_to = 'Antylamon',

    pos = {
        x = 2,
        y = 20
    },

    extra = {
        mult = 0
    },

    text = {
        'Gains {C:mult}+10{} Mult for every',
        'consecutive played hand that is',
        'one of your {C:attention}most played poker hands{}',
        'Resets when the streak is broken',
        '{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult){}'
    },

    dynamic_vars =
    function(card, e)
        return {
            e.mult or 0
        }
    end,

    effect =
        'Gain +10 Mult for consecutive most-played poker hands; resets when streak breaks'
})

BM.register_digimon({
    slug = 'wendigomon',
    name = 'Wendigomon',
    stage = 'Champion',
    evolves_to = 'Antylamon',

    pos = {
        x = 3,
        y = 20
    },

    extra = {
        mult = 0
    },

    text = {
        'Gains {C:mult}+15{} Mult for every',
        'consecutive played hand that is',
        '{C:attention}not{} one of your most played poker hands',
        'Resets when the streak is broken',
        '{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult){}'
    },

    dynamic_vars =
    function(card, e)
        return {
            e.mult or 0
        }
    end,

    effect =
        'Gain +15 Mult for consecutive non-most-played poker hands; resets when streak breaks'
})

BM.register_digimon({
    slug = 'antylamon',
    name = 'Antylamon',
    stage = 'Ultimate',

    evolves_to =
        'Cherubimon (Good), Cherubimon (Evil)',

    pos = {
        x = 4,
        y = 20
    },

    extra = {
        good_xmult = 1,
        evil_xmult = 1
    },

    text = {
        'Has a {C:green}Good{} and {C:purple}Evil{} stat',
        'Playing one of your {C:attention}most played{} poker hands',
        'permanently gives {C:green}Good{} {X:mult,C:white}X0.2{} Mult',
        'Otherwise permanently gives',
        '{C:purple}Evil{} {X:mult,C:white}X0.75{} Mult',
        'Uses the corresponding stat when scoring',
        '{C:inactive}(Good {X:mult,C:white}X#4#{C:inactive} / Evil {X:mult,C:white}X#5#{C:inactive}){}'
    },

    dynamic_vars =
    function(card, e)
        return {
            e.good_xmult or 1,
            e.evil_xmult or 1
        }
    end,

    effect =
        'Good gains X0.2 on most-played hands, Evil gains X0.75 otherwise; corresponding stat scores'
})

BM.register_digimon({
    slug = 'cherubimon_good',
    name = 'Cherubimon G',
    stage = 'Mega',
    evolves_to = '-',

    pos = {
        x = 5,
        y = 20
    },

    extra = {
        emult = 1
    },

    text = {
        'Whenever one of your {C:attention}most played{}',
        'poker hands is played, permanently',
        'gains {X:mult,C:white}^0.01{} Mult',
        '{C:inactive}(Currently {X:mult,C:white}^#4#{C:inactive} Mult){}'
    },

    dynamic_vars =
    function(card, e)
        return {
            e.emult or 1
        }
    end,

    effect =
        'Gain ^0.01 Mult whenever a most-played poker hand is played'
})

BM.register_digimon({
    slug = 'cherubimon_evil',
    name = 'Cherubimon E',
    stage = 'Mega',
    evolves_to = '-',

    pos = {
        x = 6,
        y = 20
    },

    extra = {
        emult = 1
    },

    text = {
        'Whenever a poker hand that is {C:attention}not{}',
        'one of your most played hands is played,',
        'permanently gains {X:mult,C:white}^0.03{} Mult',
        '{C:inactive}(Currently {X:mult,C:white}^#4#{C:inactive} Mult){}'
    },

    dynamic_vars =
    function(card, e)
        return {
            e.emult or 1
        }
    end,

    effect =
        'Gain ^0.03 Mult whenever a non-most-played poker hand is played'
})

