local BM = Balatromon

BM.register_digimon({
    slug = 'twins',
    name = 'Tsubumon & Pabumon',
    stage = 'Fresh',
    evolves_to = 'Upamon, Motimon',
    pos = {x = 4, y = 15},
    blueprint_compat = false,
    seal_tooltips = {
        'Gold',
        'Blue',
        'digital'
    },
    text = {
        'If played hand is exactly a {C:attention}Pair{}, apply',
        'a {C:attention}Gold Seal{}, {C:attention}Blue Seal{}, or {C:attention}Digital Seal{}',
        'to the first scoring card',
    },
    effect = 'If played hand is a Pair, apply a Gold Seal, Blue Seal, or Digital Seal to the first scoring card'
})

BM.register_digimon({
    slug = 'upamon',
    name = 'Upamon',
    stage = 'In-Training',
    evolves_to = 'Armadillomon',
    pos = {x = 5, y = 15},
    blueprint_compat = false,
    seal_tooltips = {
        'Gold',
        'farm'
    },
    text = {
        'If played hand is {C:attention}High Card{}, apply',
        'a {C:attention}Gold Seal{} or {C:attention}Farm Seal{}',
        'to the scoring card',
    },
    effect = 'If played hand is High Card, apply a Gold Seal or Farm Seal to the scoring card'
})

BM.register_digimon({
    slug = 'motimon',
    name = 'Motimon',
    stage = 'In-Training',
    evolves_to = 'Tentomon',
    pos = {x = 6, y = 15},
    seal_tooltips = {
        'Blue'
    },
    text = {
        '{C:attention}Blue Seals{} held in hand each give',
        '{C:money}$3{} at the end of the round',
    },
    effect = 'Blue Seals held in hand each give $3 at the end of the round'
})

BM.register_digimon({
    slug = 'armadillomon',
    name = 'Armadillomon',
    stage = 'Rookie',
    evolves_to = 'Ankiromon, Digmon, Monochromon, Tortomon',
    pos = {x = 7, y = 15},
    seal_tooltips = {
        'Gold'
    },
    text = {
        'Scoring cards with a {C:attention}Gold Seal{}',
        'trigger its money effect {C:attention}1 additional time{}',
    },
    effect = 'Gold Seal cards trigger their money effect 1 additional time'
})

BM.register_digimon({
    slug = 'tentomon',
    name = 'Tentomon',
    stage = 'Rookie',
    evolves_to = 'Kabuterimon, Kuwagamon',
    pos = {x = 8, y = 15},
    blueprint_compat = false,
    seal_tooltips = {
        'Purple'
    },
    text = {
        'Discarded cards with a {C:attention}Purple Seal{}',
        'trigger its Tarot effect {C:attention}1 additional time{}',
    },
    effect = 'Purple Seal cards trigger their Tarot effect 1 additional time'
})

BM.register_digimon({
    slug = 'ankiromon',
    name = 'Ankiromon',
    stage = 'Champion',
    evolves_to = 'Triceramon, Tankdramon',
    pos = {x = 9, y = 15},
    seal_tooltips = {
        'Red'
    },
    text = {
        '{C:attention}Red Seal{} cards retrigger',
        '{C:attention}1 additional time{}',
    },
    effect = 'Red Seal cards retrigger 1 additional time'
})

BM.register_digimon({
    slug = 'digmon',
    name = 'Digmon',
    stage = 'Champion',
    evolves_to = 'MegaKabuterimon, Okuwamon',
    pos = {x = 0, y = 16},
    blueprint_compat = false,
    text = {
        'If played hand contains {C:attention}#5#{} and',
        'a scoring {C:attention}#4#{}, create a {C:spectral}Spectral{} card',
        '{C:inactive}(rank and poker hand change at end of round){}',
    },
    dynamic_vars = function(card, e)
        local rank =
            e.target_rank
            or 14

        local hand =
            e.target_hand
            or 'High Card'

        if card then
            rank =
                BM.ensure_target(
                    card,
                    'target_rank',
                    BM.deck_ranks(),
                    'digmon_rank'
                )
                or rank

            hand =
                BM.ensure_target(
                    card,
                    'target_hand',
                    BM.HANDS,
                    'digmon_hand'
                )
                or hand
        end

        return {
            BM.rank_name(rank),
            hand
        }
    end,
    effect = 'Creates a Spectral card if the hand contains the target poker hand and target rank; both targets change each round'
})

BM.register_digimon({
    slug = 'tortomon',
    name = 'Tortomon',
    stage = 'Champion',
    evolves_to = 'Triceramon, Tankdramon',
    pos = {x = 1, y = 16},
    text = {
        'Each sealed card played or held in hand',
        'gives {X:mult,C:white}X1.25{} Mult',
    },
    effect = 'Each sealed card played or held in hand gives X1.25 Mult'
})

BM.register_digimon({
    slug = 'kabuterimon',
    name = 'Kabuterimon',
    stage = 'Champion',
    evolves_to = 'MegaKabuterimon',
    pos = {x = 2, y = 16},
    blueprint_compat = false,
    text = {
        'If the first hand of the round is a single {C:attention}8{},',
        'destroy it and create a {C:spectral}Spectral{} card',
        '{C:inactive}(Must have room){}',
    },
    effect = 'If the first hand of the round is a single 8, destroy it and create a Spectral card'
})

BM.register_digimon({
    slug = 'kuwagamon',
    name = 'Kuwagamon',
    stage = 'Champion',
    evolves_to = 'Okuwamon',
    pos = {x = 3, y = 16},
    blueprint_compat = false,
    text = {
        'If played poker hand is a {C:attention}Straight Flush{}',
        'or {C:attention}Flush Five{}, create a random {C:spectral}Spectral{} card',
        '{C:inactive}(Must have room){}',
    },
    effect = 'Creates a random Spectral card when a Straight Flush or Flush Five is played'
})

BM.register_digimon({
    slug = 'megakabuterimon',
    name = 'MegaKabuterimon',
    stage = 'Ultimate',
    evolves_to = 'HerculesKabuterimon',
    pos = {x = 4, y = 16},
    blueprint_compat = false,
    negative_tooltip = true,
    text = {
        'When a scoring {C:attention}#4#{} scores, destroy it',
        'and create a {C:dark_edition}Negative{} {C:spectral}Spectral{} card',
        '{C:inactive}(rank changes at end of round){}',
    },
    dynamic_vars = function(card, e)
        local rank =
            e.target_rank
            or 14

        if card then
            rank =
                BM.ensure_shared_target(
                    'megakabuterimon_rank',
                    BM.deck_ranks(),
                    'megakabuterimon_rank'
                )
                or rank
        end

        return {
            BM.rank_name(rank)
        }
    end,
    effect = 'When the target rank scores, destroy it and create a Negative Spectral card; target rank changes each round'
})

BM.register_digimon({
    slug = 'okuwamon',
    name = 'Okuwamon',
    stage = 'Ultimate',
    evolves_to = 'HerculesKabuterimon',
    pos = {x = 5, y = 16},
    blueprint_compat = false,
    text = {
        'If played hand is one of your most played poker hands,',
        'create a {C:spectral}Spectral{} card and permanently',
        '{C:red}debuff{} all cards played in that hand',
        '{C:inactive}(Must have room){}',
    },
    effect = 'When one of your most played poker hands is played, create a Spectral card and permanently debuff all cards played'
})

BM.register_digimon({
    slug = 'herculeskabuterimon',
    name = 'HerculesKabuterimon',
    stage = 'Mega',
    evolves_to = '-',
    pos = {x = 6, y = 16},
    blueprint_compat = false,
    negative_tooltip = true,
    digimon_tooltips = {
        'megakabuterimon',
        'okuwamon'
    },
    text = {
        '{C:spectral}Spectral{} cards appear frequently in the shop',
        'Also applies {C:attention}MegaKabuterimon{} and',
        '{C:attention}Okuwamon{} effects',
        '{C:inactive}(MegaKabuterimon target: {C:attention}#4#{C:inactive}){}',
    },
    dynamic_vars = function(card, e)
        local rank =
            e.target_rank
            or 14

        if card then
            rank =
                BM.ensure_shared_target(
                    'megakabuterimon_rank',
                    BM.deck_ranks(),
                    'megakabuterimon_rank'
                )
                or rank
        end

        return {
            BM.rank_name(rank)
        }
    end,
    effect = 'Spectral cards appear frequently in the shop and applies MegaKabuterimon and Okuwamon effects'
})

