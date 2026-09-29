local BM = Balatromon
local atlas = 'Joker_2nd'

BM.register_digimon({
    slug = 'puyomon',
    name = 'Puyomon',
    stage = 'Fresh',
    evolves_to = 'Puyoyomon',
    atlas = atlas,
    pos = {x = 8, y = 1},
    text = {
        'Each hand, protect a random',
        '{C:attention}playing card{} from being disabled',
        'by the {C:attention}Boss Blind{}'
    },
    effect = 'Each hand, protect a random playing card from being disabled by the Boss Blind'
})

BM.register_digimon({
    slug = 'puyoyomon',
    name = 'Puyoyomon',
    stage = 'In-Training',
    evolves_to = 'Jellymon Hidden, Jellymon Unfurl, Salamon',
    atlas = atlas,
    pos = {x = 9, y = 1},
    text = {
        'Sell this card to enable all',
        '{C:attention}playing cards{} that are disabled'
    },
    effect = 'Sell this card to enable all disabled playing cards'
})

BM.register_digimon({
    slug = 'jellymon_hidden',
    name = 'Jellymon',
    stage = 'Rookie',
    evolves_to = 'TeslaJellymon, Jellymon Unfurl',
    atlas = atlas,
    pos = {x = 0, y = 2},
    extra = {protected = false},
    text = {
        'Protect all {C:attention}playing cards{} from',
        'being disabled by the {C:attention}Boss Blind{}',
        'At end of round, {C:attention}Unfurl{} if',
        'this protected at least one card'
    },
    effect = 'Protect all playing cards from Boss Blind disabling. Unfurl at end of round if it protected any card'
})

BM.register_digimon({
    slug = 'jellymon_unfurl',
    name = 'Jellymon',
    stage = 'Rookie',
    evolves_to = 'TeslaJellymon, Jellymon Hidden',
    atlas = atlas,
    pos = {x = 1, y = 2},
    text = {
        'Protect the {C:attention}Digimon to the left{} from',
        'being disabled by the {C:attention}Boss Blind{}',
        'Immune to Boss Blind disabling'
    },
    effect = 'Protect the Digimon to the left from Boss Blind disabling and is immune to Boss Blind disabling'
})

BM.register_digimon({
    slug = 'teslajellymon',
    name = 'TeslaJellymon',
    stage = 'Champion',
    evolves_to = 'Thetismon',
    atlas = atlas,
    pos = {x = 2, y = 2},
    text = {
        'Protect the {C:attention}Digimon to the left{} from',
        'Boss Blind disabling, {C:attention}starvation{},',
        'and reverting from {C:attention}Care Mistakes{}'
    },
    effect = 'Protect the Digimon to the left from Boss Blind disabling, starvation, and reverting from Care Mistakes'
})

BM.register_digimon({
    slug = 'thetismon',
    name = 'Thetismon',
    stage = 'Ultimate',
    evolves_to = 'Amphimon',
    atlas = atlas,
    pos = {x = 3, y = 2},
    text = {
        '{C:green}#4# in #5#{} chance at end of round to',
        'reset a random Digimon\'s',
        '{C:attention}Hunger{} or {C:attention}Care Mistakes{}'
    },
    dynamic_vars = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, 10, 'thetismon_reset')
        return {numerator, denominator}
    end,
    effect = '1 in 10 chance at end of round to reset a random Digimon hunger or Care Mistakes'
})

BM.register_digimon({
    slug = 'amphimon',
    name = 'Amphimon',
    stage = 'Mega',
    evolves_to = '-',
    atlas = atlas,
    pos = {x = 4, y = 2},
    digimon_tooltips = {'thetismon', 'teslajellymon'},
    text = {
        'Applies {C:attention}Thetismon{} and',
        '{C:attention}TeslaJellymon{}'
    },
    effect = 'Apply Thetismon and TeslaJellymon'
})
