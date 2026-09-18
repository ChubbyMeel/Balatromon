local BM = Balatromon

BM.register_digimon({
    slug = 'aoibotamamon',
    name = 'AoiBotamamon',
    stage = 'Fresh',
    evolves_to = 'Wanyamon',
    pos = {x = 2, y = 17},
    text = {
        'Each played {C:hearts}Heart{} and {C:spades}Spade{}',
        'gives {C:mult}+3{} Mult when scored',
    },
    effect = 'Each played Heart and Spade gives +3 Mult'
})

BM.register_digimon({
    slug = 'wanyamon',
    name = 'Wanyamon',
    stage = 'In-Training',
    evolves_to = 'Bearmon',
    pos = {x = 3, y = 17},
    text = {
        'Each played {C:diamonds}Diamond{} and {C:clubs}Club{}',
        'gives {C:mult}+3{} Mult when scored',
    },
    effect = 'Each played Diamond and Club gives +3 Mult'
})

BM.register_digimon({
    slug = 'bearmon',
    name = 'Bearmon',
    stage = 'Rookie',
    evolves_to = 'Grizzlymon, Garurumon, Leomon, MadLeomon',
    pos = {x = 4, y = 17},
    text = {
        'Each played card gives {C:mult}Mult{} equal to the',
        'sum of its rank differences from scoring cards to its left',
    },
    effect = 'Each played card gives Mult equal to the sum of its rank differences from scoring cards to its left'
})

BM.register_digimon({
    slug = 'grizzlymon',
    name = 'Grizzlymon',
    stage = 'Champion',
    evolves_to = 'GreatGrizzlymon, LoaderLeomon',
    pos = {x = 5, y = 17},
    joker_tooltips = {
        'j_bloodstone',
        'j_arrowhead',
        'j_onyx_agate',
        'j_rough_gem'
    },
    text = {
        'Scored {C:attention}Wild Cards{} have a {C:green}1 in 2{} chance',
        'to activate {C:attention}Bloodstone{}, {C:attention}Arrowhead{},',
        '{C:attention}Onyx Agate{}, or {C:attention}Rough Gem{} at random',
    },
    effect = 'Wild cards have a 1 in 2 chance to activate Bloodstone, Arrowhead, Onyx Agate, or Rough Gem at random'
})

BM.register_digimon({
    slug = 'greatgrizzlymon',
    name = 'GreatGrizzlymon',
    stage = 'Ultimate',
    evolves_to = 'Callismon',
    pos = {x = 6, y = 17},
    digimon_tooltips = {
        'grizzlymon',
        'bearmon'
    },
    joker_tooltips = {
        'j_bloodstone',
        'j_arrowhead',
        'j_onyx_agate',
        'j_rough_gem'
    },
    text = {
        'Also applies {C:attention}Grizzlymon{} and',
        '{C:attention}Bearmon{} effects',
    },
    effect = 'Applies Grizzlymon and Bearmon effects'
})

BM.register_digimon({
    slug = 'callismon',
    name = 'Callismon',
    stage = 'Mega',
    evolves_to = '-',
    pos = {x = 7, y = 17},
    digimon_tooltips = {
        'greatgrizzlymon',
        'grizzlymon',
        'bearmon'
    },
    joker_tooltips = {
        'j_bloodstone',
        'j_arrowhead',
        'j_onyx_agate',
        'j_rough_gem'
    },
    text = {
        'After the scoring hand finishes, rescore it repeatedly,',
        'omitting the {C:attention}last card{} each time until',
        'only {C:attention}1 card{} remains',
        'Also applies {C:attention}GreatGrizzlymon{} effect',
    },
    effect = 'After the scoring hand finishes, repeatedly rescore it while omitting the last card until one remains; also applies GreatGrizzlymon'
})

