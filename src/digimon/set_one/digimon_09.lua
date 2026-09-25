local BM = Balatromon

do
    local slug = 'chibomon'
    local stage = 'Fresh'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Chibomon', text = {
            {
                'Retrigger last played card used in scoring',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 5, y = 8},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'DemiVeemon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0, elements = {BM.care_bars(e, stage)}}}
        end,
        in_pool = function(self, args)
            return stage == 'Fresh' or stage == 'In-Training' or stage == 'Rookie' or stage == 'Champion' or stage == 'Rare'
        end,
        add_to_deck = function(self, card, from_debuff) if not from_debuff then BM.on_add(card, slug) end end,
        remove_from_deck = function(self, card, from_debuff) if not from_debuff then BM.on_remove(card, slug) end end,
        can_sell = function(self, card, context) return BM.can_sell(card, slug) end,
        calculate = function(self, card, context)
            BM.care_tick(card, context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug, card, context)
        end,
    }
    BM.joker_defs[slug] = {name = 'Chibomon', stage = stage, evolves_to = 'DemiVeemon', effect = 'Retrigger last played card used in scoring'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'demiveemon'
    local stage = 'In-Training'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'DemiVeemon', text = {
            {
                'Retrigger first played card used in scoring',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 6, y = 8},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Veemon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0, elements = {BM.care_bars(e, stage)}}}
        end,
        in_pool = function(self, args)
            return stage == 'Fresh' or stage == 'In-Training' or stage == 'Rookie' or stage == 'Champion' or stage == 'Rare'
        end,
        add_to_deck = function(self, card, from_debuff) if not from_debuff then BM.on_add(card, slug) end end,
        remove_from_deck = function(self, card, from_debuff) if not from_debuff then BM.on_remove(card, slug) end end,
        can_sell = function(self, card, context) return BM.can_sell(card, slug) end,
        calculate = function(self, card, context)
            BM.care_tick(card, context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug, card, context)
        end,
    }
    BM.joker_defs[slug] = {name = 'DemiVeemon', stage = stage, evolves_to = 'Veemon', effect = 'Retrigger first played card used in scoring'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'veemon'
    local stage = 'Rookie'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Veemon', text = {
            {
                'Retrigger first played card used in scoring 2',
                'additional times',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 7, y = 8},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'ExVeemon, Flamedramon, Raidramon, Veedramon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0, elements = {BM.care_bars(e, stage)}}}
        end,
        in_pool = function(self, args)
            return stage == 'Fresh' or stage == 'In-Training' or stage == 'Rookie' or stage == 'Champion' or stage == 'Rare'
        end,
        add_to_deck = function(self, card, from_debuff) if not from_debuff then BM.on_add(card, slug) end end,
        remove_from_deck = function(self, card, from_debuff) if not from_debuff then BM.on_remove(card, slug) end end,
        can_sell = function(self, card, context) return BM.can_sell(card, slug) end,
        calculate = function(self, card, context)
            BM.care_tick(card, context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug, card, context)
        end,
    }
    BM.joker_defs[slug] = {name = 'Veemon', stage = stage, evolves_to = 'ExVeemon, Flamedramon, Raidramon, Veedramon', effect = 'Retrigger first played card used in scoring 2 additional times'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'exveemon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'ExVeemon', text = {
            {
                'Retrigger all played face cards',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 8, y = 8},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Paildramon, Magnamon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0, elements = {BM.care_bars(e, stage)}}}
        end,
        in_pool = function(self, args)
            return stage == 'Fresh' or stage == 'In-Training' or stage == 'Rookie' or stage == 'Champion' or stage == 'Rare'
        end,
        add_to_deck = function(self, card, from_debuff) if not from_debuff then BM.on_add(card, slug) end end,
        remove_from_deck = function(self, card, from_debuff) if not from_debuff then BM.on_remove(card, slug) end end,
        can_sell = function(self, card, context) return BM.can_sell(card, slug) end,
        calculate = function(self, card, context)
            BM.care_tick(card, context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug, card, context)
        end,
    }
    BM.joker_defs[slug] = {name = 'ExVeemon', stage = stage, evolves_to = 'Paildramon, Magnamon', effect = 'Retrigger all played face cards'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'flamedramon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Flamedramon',
            text={
                {
                    '{C:green}#4# in #5#{} chance to upgrade played poker hand after it is scored',
                },
                {
                    BM.care_status_text(stage),
                }

            }
        },

        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker',
        pos = {x = 9, y = 8},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Wingdramon, BlueMeramon',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra

            local numerator, denominator =
                SMODS.get_probability_vars(
                    card,
                    1,
                    5,
                    'flamedramon'
                )

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    numerator,
                    denominator
                }
            }
        end,

        in_pool = function(self, args)
            return stage == 'Fresh'
                or stage == 'In-Training'
                or stage == 'Rookie'
                or stage == 'Champion'
                or stage == 'Rare'
        end,

        add_to_deck = function(self, card, from_debuff)
            if not from_debuff then
                BM.on_add(card, slug)
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if not from_debuff then
                BM.on_remove(card, slug)
            end
        end,

        can_sell = function(self, card, context)
            return BM.can_sell(card, slug)
        end,

        calculate = function(self, card, context)
            BM.care_tick(card, context)

            if card.ability.extra.permanently_disabled then
                return
            end

            return BM.run_effect(slug, card, context)
        end,
    }

    BM.joker_defs[slug] = {
        name = 'Flamedramon',
        stage = stage,
        evolves_to = 'Wingdramon, BlueMeramon',
        effect = '1 in 5 chance to upgrade played poker hand'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {
            key=BM.center_key(slug),
            weight=weight,
            stage = stage
        }
    end
end

BM.register_digimon({
    slug = 'raidramon',
    name = 'Raidramon',
    stage = 'Champion',
    evolves_to = '-',
    pos = {x = 2, y = 19},

    text = {
        '{C:green}#4# in #5#{} chance for each',
        'played {V:1}#6#{} to give',
        '{X:chips,C:white}X1.25{} Chips',
        '{C:inactive}(suit changes at end of round){}'
    },

    dynamic_vars = function(card, e)
        BM.ensure_target(
            card,
            'target_suit',
            BM.deck_suits(),
            'raidramon_suit'
        )

        local numerator, denominator =
            SMODS.get_probability_vars(
                card,
                1,
                2,
                'raidramon'
            )

        local vars = {
            numerator,
            denominator,
            suit
        }
        vars.colours = {
            (
                G.C.SUITS
                and G.C.SUITS[suit]
            )
            or G.C.FILTER
        }
        return vars

    end,

    effect = '1 in 2 chance for played cards of the target suit to give X1.25 Chips'
})

do
    local slug = 'paildramon'
    local stage = 'Ultimate'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Paildramon', text = {
            {
                'Retrigger all played cards in final hand of',
                'the round 2 additional times',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 0, y = 9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Imperialdramon Fighter Mode, Imperialdramon Dragon Mode',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0, elements = {BM.care_bars(e, stage)}}}
        end,
        in_pool = function(self, args)
            return stage == 'Fresh' or stage == 'In-Training' or stage == 'Rookie' or stage == 'Champion' or stage == 'Rare'
        end,
        add_to_deck = function(self, card, from_debuff) if not from_debuff then BM.on_add(card, slug) end end,
        remove_from_deck = function(self, card, from_debuff) if not from_debuff then BM.on_remove(card, slug) end end,
        can_sell = function(self, card, context) return BM.can_sell(card, slug) end,
        calculate = function(self, card, context)
            BM.care_tick(card, context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug, card, context)
        end,
    }
    BM.joker_defs[slug] = {name = 'Paildramon', stage = stage, evolves_to = 'Imperialdramon Fighter Mode, Imperialdramon Dragon Mode', effect = 'Retrigger all played cards in final hand of the round 2 additional times'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'wingdramon'
    local stage = 'Ultimate'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Wingdramon', text = {
            {
                'Upgrade the level of the first discarded poker',
                'hand each round',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 1, y = 9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Gallantmon, BlackWarGreymon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0, elements = {BM.care_bars(e, stage)}}}
        end,
        in_pool = function(self, args)
            return stage == 'Fresh' or stage == 'In-Training' or stage == 'Rookie' or stage == 'Champion' or stage == 'Rare'
        end,
        add_to_deck = function(self, card, from_debuff) if not from_debuff then BM.on_add(card, slug) end end,
        remove_from_deck = function(self, card, from_debuff) if not from_debuff then BM.on_remove(card, slug) end end,
        can_sell = function(self, card, context) return BM.can_sell(card, slug) end,
        calculate = function(self, card, context)
            BM.care_tick(card, context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug, card, context)
        end,
    }
    BM.joker_defs[slug] = {name = 'Wingdramon', stage = stage, evolves_to = 'Gallantmon, BlackWarGreymon', effect = 'Upgrade the level of the first discarded poker hand each round'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

BM.register_digimon({
    slug = 'magnamon',
    name = 'Magnamon',
    stage = 'Mega',
    evolves_to = '-',
    pos = {x = 1, y = 19},

    text = {
        'Whenever a card is {C:attention}retriggered{},',
        'retrigger it {C:attention}1 additional time{}',
        '{C:inactive}(includes held-in-hand abilities){}'
    },

    effect = 'Retrigger an already retriggered card one additional time'
})

BM.register_digimon({
    slug = 'veedramon',
    name = 'Veedramon',
    stage = 'Champion',
    evolves_to = 'AeroVeedramon',
    pos = {x = 3, y = 19},

    text = {
        'Retrigger the {C:attention}first{} and {C:attention}last{}',
        'scoring cards {C:attention}2 additional times{}',
        'if they are {C:attention}enhanced{}'
    },

    effect = 'Retrigger enhanced first and last scoring cards twice'
})

BM.register_digimon({
    slug = 'aeroveedramon',
    name = 'AeroVeedramon',
    stage = 'Ultimate',
    evolves_to = 'UltraForceVeedramon',
    pos = {x = 4, y = 19},

    text = {
        'Cards sharing an {C:attention}Enhancement{}',
        'with the first scoring card',
        'retrigger {C:attention}2 additional times{}'
    },

    effect = 'Cards with the same enhancement as the first scoring card retrigger twice'
})

BM.register_digimon({
    slug = 'ultraforceveedramon',
    name = 'UltraForceVeedramon',
    stage = 'Mega',
    evolves_to = '-',
    pos = {x = 5, y = 19},

    text = {
        'Cards held in hand randomly give',
        '{X:mult,C:white}X2{} Mult or {C:money}$2{}',
        'Scoring cards have a {C:green}1 in 3{} chance',
        'to give {X:mult,C:white}X2{} Mult or {C:mult}+20{} Mult',
        '{C:inactive}Also applies AeroVeedramon{}'
    },

    effect = 'Held cards give X2 Mult or $2; scoring cards may give X2 Mult or +20 Mult; applies AeroVeedramon'
})

