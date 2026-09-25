local BM = Balatromon
local atlas = 'Joker_2nd'

BM.register_digimon({
    slug = 'curimon',
    name = 'Curimon',
    stage = 'Fresh',
    evolves_to = 'Gurimon',
    atlas = atlas,
    pos = {x = 0, y = 0},
    text = {
        'At end of round, create a random',
        '{C:planet}attributed Planet{} matching the Attribute',
        'of the {C:attention}Digimon to the left{}'
    },
    effect = 'At end of round, create a random attributed Planet matching the Attribute of the Digimon to the left'
})

BM.register_digimon({
    slug = 'gurimon',
    name = 'Gurimon',
    stage = 'In-Training',
    evolves_to = 'Gammamon',
    atlas = atlas,
    pos = {x = 1, y = 0},
    text = {
        'At end of round, if money is above',
        'the {C:money}interest cap{}, create a random',
        '{C:tarot}attributed Tarot{}'
    },
    effect = 'At end of round, if money is above the interest cap, create a random attributed Tarot'
})

BM.register_digimon({
    slug = 'gammamon',
    name = 'Gammamon',
    stage = 'Rookie',
    evolves_to = 'GulusGammamon, BetelGammamon, KausGammamon, WezenGammamon',
    atlas = atlas,
    pos = {x = 2, y = 0},
    extra = {data_count = 0, vaccine_count = 0, virus_count = 0, free_count = 0},
    text = {
        'When another {C:attention}Digimon{} triggers,',
        'add {C:attention}1{} to its Attribute counter',
        'At end of round, create a random attributed',
        'consumable matching the highest counter',
        '{C:inactive}(Data: #4# | Vaccine: #5# | Virus: #6# | Free: #7#){}'
    },
    dynamic_vars = function(card, e)
        return {e.data_count or 0, e.vaccine_count or 0, e.virus_count or 0, e.free_count or 0}
    end,
    effect = 'When another Digimon triggers, increase its matching Attribute counter; at end of round create an attributed consumable matching the highest counter'
})

BM.register_digimon({
    slug = 'gulusgammamon',
    name = 'GulusGammamon',
    stage = 'Champion',
    evolves_to = 'Regulusmon',
    atlas = atlas,
    pos = {x = 3, y = 0},
    extra = {virus_mult = 0},
    text = {
        'Gain {C:mult}+7{} Mult whenever a',
        '{C:attention}Virus{} attributed consumable is used',
        '{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult){}'
    },
    dynamic_vars = function(card, e) return {e.virus_mult or 0} end,
    effect = 'Gain +7 Mult whenever a Virus attributed consumable is used'
})

BM.register_digimon({
    slug = 'betelgammamon',
    name = 'BetelGammamon',
    stage = 'Champion',
    evolves_to = 'Canoweissmon',
    atlas = atlas,
    pos = {x = 4, y = 0},
    extra = {vaccine_mult = 0},
    text = {
        'Gain {C:mult}+3{} Mult whenever a',
        '{C:attention}Vaccine{} attributed consumable is used',
        '{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult){}'
    },
    dynamic_vars = function(card, e) return {e.vaccine_mult or 0} end,
    effect = 'Gain +3 Mult whenever a Vaccine attributed consumable is used'
})

BM.register_digimon({
    slug = 'kausgammamon',
    name = 'KausGammamon',
    stage = 'Champion',
    evolves_to = 'Wingdramon',
    atlas = atlas,
    pos = {x = 5, y = 0},
    extra = {data_chips = 0},
    text = {
        'Gain {C:chips}+15{} Chips whenever a',
        '{C:attention}Data{} attributed consumable is used',
        '{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}'
    },
    dynamic_vars = function(card, e) return {e.data_chips or 0} end,
    effect = 'Gain +15 Chips whenever a Data attributed consumable is used'
})

BM.register_digimon({
    slug = 'wezengammamon',
    name = 'WezenGammamon',
    stage = 'Champion',
    evolves_to = 'Triceramon, Lamortmon',
    atlas = atlas,
    pos = {x = 6, y = 0},
    text = {
        'Create a random {C:tarot}unattributed Tarot{}',
        'whenever a {C:attention}Free{} attributed consumable is used',
        '{C:inactive}(Must have room){}'
    },
    effect = 'Create a random unattributed Tarot whenever a Free attributed consumable is used'
})

BM.register_digimon({
    slug = 'canoweissmon',
    name = 'Canoweissmon',
    stage = 'Ultimate',
    evolves_to = 'Siriusmon',
    atlas = atlas,
    pos = {x = 7, y = 0},
    extra = {vaccine_xmult = 1},
    text = {
        'Gain {X:mult,C:white}X0.25{} Mult whenever a',
        '{C:attention}Vaccine{} attributed consumable is used',
        '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}'
    },
    dynamic_vars = function(card, e) return {e.vaccine_xmult or 1} end,
    effect = 'Gain X0.25 Mult whenever a Vaccine attributed consumable is used'
})

BM.register_digimon({
    slug = 'regulusmon',
    name = 'Regulusmon',
    stage = 'Ultimate',
    evolves_to = 'Arcturusmon',
    atlas = atlas,
    pos = {x = 8, y = 0},
    extra = {virus_xmult = 1},
    text = {
        'Gain {X:mult,C:white}X0.3{} Mult whenever a',
        '{C:attention}Virus{} attributed consumable is used',
        '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}'
    },
    dynamic_vars = function(card, e) return {e.virus_xmult or 1} end,
    effect = 'Gain X0.3 Mult whenever a Virus attributed consumable is used'
})

BM.register_digimon({
    slug = 'siriusmon',
    name = 'Siriusmon',
    stage = 'Mega',
    evolves_to = 'Proximamon',
    atlas = atlas,
    pos = {x = 9, y = 0},
    extra = {vaccine_xmult = 1},
    digimon_tooltips = {'canoweissmon', 'wezengammamon'},
    text = {
        'Applies {C:attention}Canoweissmon{} and',
        '{C:attention}WezenGammamon{}'
    },
    effect = 'Apply Canoweissmon and WezenGammamon'
})

BM.register_digimon({
    slug = 'arcturusmon',
    name = 'Arcturusmon',
    stage = 'Mega',
    evolves_to = 'Proximamon',
    atlas = atlas,
    pos = {x = 0, y = 1},
    extra = {virus_xmult = 1, data_count = 0, vaccine_count = 0, virus_count = 0, free_count = 0},
    digimon_tooltips = {'regulusmon', 'gammamon'},
    text = {
        'Applies {C:attention}Regulusmon{} and',
        '{C:attention}Gammamon{}'
    },
    effect = 'Apply Regulusmon and Gammamon'
})

BM.register_digimon({
    slug = 'proximamon',
    name = 'Proximamon',
    stage = 'Beyond',
    evolves_to = '-',
    atlas = atlas,
    pos = {x = 1, y = 1},
    extra = {
        vaccine_xmult = 1,
        virus_xmult = 1,
        data_count = 0,
        vaccine_count = 0,
        virus_count = 0,
        free_count = 0
    },
    digimon_tooltips = {'siriusmon', 'arcturusmon'},
    text = {
        'Applies {C:attention}Siriusmon{} and',
        '{C:attention}Arcturusmon{}'
    },
    effect = 'Apply Siriusmon and Arcturusmon'
})
