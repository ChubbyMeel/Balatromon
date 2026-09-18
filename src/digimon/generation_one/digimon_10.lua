local BM = Balatromon

BM.register_digimon({
    slug = 'leafmon',
    name = 'Leafmon',
    stage = 'Fresh',
    evolves_to = 'Minomon',
    pos = {x = 7, y = 16},
    text = {
        'Retrigger each played {C:attention}9{}',
        '{C:attention}1 additional time{}',
    },
    effect = 'Retrigger each played 9 one additional time'
})

BM.register_digimon({
    slug = 'minomon',
    name = 'Minomon',
    stage = 'In-Training',
    evolves_to = 'Wormmon',
    pos = {x = 8, y = 16},
    text = {
        'Retrigger each played {C:attention}7{} and {C:attention}4{}',
        '{C:attention}1 additional time{}',
    },
    effect = 'Retrigger each played 7 and 4 one additional time'
})

BM.register_digimon({
    slug = 'wormmon',
    name = 'Wormmon',
    stage = 'Rookie',
    evolves_to = 'Stingmon',
    pos = {x = 9, y = 16},
    text = {
        'Retrigger each played {C:attention}3{}, {C:attention}4{}, or {C:attention}5{}',
        '{C:attention}1 additional time{}',
    },
    effect = 'Retrigger each played 3, 4, or 5 one additional time'
})

BM.register_digimon({
    slug = 'stingmon',
    name = 'Stingmon',
    stage = 'Champion',
    evolves_to = 'Dinobeemon',
    pos = {x = 0, y = 17},
    text = {
        'Retrigger each played {C:attention}2{}, {C:attention}3{}, {C:attention}4{},',
        '{C:attention}5{}, or {C:attention}10{} {C:attention}2 additional times{}',
    },
    effect = 'Retrigger each played 2, 3, 4, 5, or 10 two additional times'
})

BM.register_digimon({
    slug = 'dinobeemon',
    name = 'Dinobeemon',
    stage = 'Ultimate',
    evolves_to = 'Imperialdramon Fighter Mode, Imperialdramon Dragon Mode',
    pos = {x = 1, y = 17},
    text = {
        'Retrigger all played cards in the',
        'first hand of each round',
        '{C:attention}1 additional time{}',
    },
    effect = 'Retrigger all played cards in the first hand of each round one additional time'
})

do
    local slug = 'imperialdramon_dragon_mode'
    local stage = 'Mega'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Imperialdramon Dragon Mode', text = {
            {
                'Retrigger all cards held in hand abilities',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 2, y = 9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Imperialdramon Fighter Mode, Imperialdramon Paladin Mode',
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
    BM.joker_defs[slug] = {name = 'Imperialdramon Dragon Mode', stage = stage, evolves_to = 'Imperialdramon Fighter Mode, Imperialdramon Paladin Mode', effect = 'Retrigger all cards held in hand abilities'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'imperialdramon_fighter_mode'
    local stage = 'Mega'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Imperialdramon Fighter Mode', text = {
            {
                'Retrigger all played cards 2 additional times',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 3, y = 9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Imperialdramon Dragon Mode, Imperialdramon Paladin Mode',
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
    BM.joker_defs[slug] = {name = 'Imperialdramon Fighter Mode', stage = stage, evolves_to = 'Imperialdramon Dragon Mode, Imperialdramon Paladin Mode', effect = 'Retrigger all played cards 2 additional times'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

BM.register_digimon({
    slug = 'imperialdramon_paladin_mode',
    name = 'Imperialdramon Paladin Mode',
    stage = 'Beyond',
    evolves_to = '-',
    pos = {x = 6, y = 19},

    text = {
        'Retrigger all played cards',
        '{C:attention}2 additional times{}',
        'Retrigger all held-in-hand abilities',
        '{C:attention}1 additional time{}',
        '{C:attention}+3{} hand size'
    },

    effect = 'Apply both Imperialdramon modes and +3 hand size'
})

do
    local slug = 'gekkomon'
    local stage = 'Rare'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Gekkomon', text = {
            {
                'Copies the Digimon Joker\'s effect to the right',
                'of this Joker',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 4, y = 9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
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
    BM.joker_defs[slug] = {name = 'Gekkomon', stage = stage, evolves_to = '-', effect = 'Copies the Digimon Joker\'s effect to the right of this Joker'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'troopmon'
    local stage = 'Rare'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Troopmon', text = {
            {
                'Copies the leftmost Digimon Joker\'s effect',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 5, y = 9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
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
    BM.joker_defs[slug] = {name = 'Troopmon', stage = stage, evolves_to = '-', effect = 'Copies the leftmost Digimon Joker\'s effect'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'digitamamon'
    local stage = 'Rare'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Digitamamon', text = {
            {
                'Retrigger the rightmost Joker\'s effect 2',
                'additional times. Perpetually rental.',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 6, y = 9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
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
    BM.joker_defs[slug] = {name = 'Digitamamon', stage = stage, evolves_to = '-', effect = 'Retrigger the rightmost Joker\'s effect 2 additional times. Perpetually rental.'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'espimon'
    local stage = 'Rare'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Espimon', text = {
            {
                'After {C:attention}2{} rounds, sell this card to',
                'Duplicate a random Joker',
                '{C:inactive}(Removes Negative from copy){}',
                '{C:inactive}(Currently {C:attention}#4#{C:inactive}/2 rounds){}',
                '{C:inactive}(Evolve using D-Ark){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 7, y = 9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'HoverEspimon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            local rounds = math.min(e.sell_rounds or 0, 2)

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    rounds
                }
            }
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
    BM.joker_defs[slug] = {name = 'Espimon', stage = stage, evolves_to = 'HoverEspimon', effect = 'After 2 rounds, sell this card to Duplicate a random Joker (Removes Negative from copy)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'hoverespimon'
    local stage = 'Mega'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'HoverEspimon', text = {
            {
                'After {C:attention}3{} rounds, sell this card to',
                'Duplicate the leftmost Joker',
                '{C:inactive}(Currently {C:attention}#4#{C:inactive}/3 rounds){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 8, y = 9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            local rounds = math.min(e.sell_rounds or 0, 3)

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    rounds
                }
            }
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
    BM.joker_defs[slug] = {name = 'HoverEspimon', stage = stage, evolves_to = '-', effect = 'After 3 rounds, sell this card to Duplicate the leftmost Joker'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

