local BM = Balatromon
local atlas = 'Joker_2nd'

BM.register_digimon({
    slug = 'pyonmon',
    name = 'Pyonmon',
    stage = 'Fresh',
    evolves_to = 'Bosamon',
    atlas = atlas,
    pos = {x = 2, y = 1},
    text = {
        'At end of round, if an',
        '{C:attention}attributed consumable{} is held,',
        'create a random {C:tarot}Tarot{} or {C:planet}Planet{}'
    },
    effect = 'At end of round, if an attributed consumable is held, create a random Tarot or Planet'
})

BM.register_digimon({
    slug = 'bosamon',
    name = 'Bosamon',
    stage = 'In-Training',
    evolves_to = 'Angoramon',
    atlas = atlas,
    pos = {x = 3, y = 1},
    text = {
        'After a hand is played, if the score is',
        'at least {C:attention}50%{} of the Blind requirement,',
        'create a random {C:tarot}Tarot{} or {C:planet}Planet{}'
    },
    effect = 'After a hand is played, if the score is at least 50% of the Blind requirement, create a random Tarot or Planet'
})

BM.register_digimon({
    slug = 'angoramon',
    name = 'Angoramon',
    stage = 'Rookie',
    evolves_to = 'SymbareAngoramon',
    atlas = atlas,
    pos = {x = 4, y = 1},
    text = {
        'After a hand is played while',
        'you have {C:money}$0{} or less,',
        'create a random {C:tarot}Tarot{} or {C:planet}Planet{}'
    },
    effect = 'After a hand is played with $0 or less, create a random Tarot or Planet'
})

BM.register_digimon({
    slug = 'symbareangoramon',
    name = 'SymbareAngoramon',
    stage = 'Champion',
    evolves_to = 'Lamortmon',
    atlas = atlas,
    pos = {x = 5, y = 1},
    text = {
        'After a hand is played while',
        'you have {C:money}$4{} or less,',
        'create a random {C:tarot}Tarot{} or {C:planet}Planet{}'
    },
    effect = 'After a hand is played with $4 or less, create a random Tarot or Planet'
})

BM.register_digimon({
    slug = 'lamortmon',
    name = 'Lamortmon',
    stage = 'Ultimate',
    evolves_to = 'Diarbbitmon, MegaGargomon',
    atlas = atlas,
    pos = {x = 6, y = 1},
    blueprint_compat = false,
    digimon_tooltips = {'symbareangoramon'},
    text = {
        'If the Blind would defeat you while',
        'you have scored at least {C:attention}15%{}',
        'of its requirement, consume this card',
        'to {C:attention}save the run{}',
        'Applies {C:attention}SymbareAngoramon{}'
    },
    effect = 'Consumes itself to save the run if at least 15% of the Blind requirement was scored. Apply SymbareAngoramon'
})

BM.register_digimon({
    slug = 'diarbbitmon',
    name = 'Diarbbitmon',
    stage = 'Mega',
    evolves_to = '-',
    atlas = atlas,
    pos = {x = 7, y = 1},
    blueprint_compat = false,
    digimon_tooltips = {'lamortmon', 'wezengammamon'},
    text = {
        'Applies {C:attention}Lamortmon{} and',
        '{C:attention}WezenGammamon{}'
    },
    effect = 'Apply Lamortmon and WezenGammamon'
})