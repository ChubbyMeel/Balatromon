local BM = Balatromon

do
    local slug = 'poyomon'
    local stage = 'Fresh'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Poyomon', text = {
            {
                'Each played lucky card gives {C:mult}+2{} Mult',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 6, y = 5},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Tokomon, Pagumon',
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
    BM.joker_defs[slug] = {name = 'Poyomon', stage = stage, evolves_to = 'Tokomon, Pagumon', effect = 'Each played lucky card gives +2 Mult'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'tokomon'
    local stage = 'In-Training'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Tokomon', text = {
            {
                'Create a negative magician at the end of a',
                'boss blind',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 7, y = 5},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Patamon',
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
    BM.joker_defs[slug] = {name = 'Tokomon', stage = stage, evolves_to = 'Patamon', effect = 'Create a negative magician at the end of a boss blind'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'patamon'
    local stage = 'Rookie'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Patamon', text = {
            {
                'If the played hand is a single card,',
                'turn it into a lucky card',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 8, y = 5},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Angemon, Pegasusmon',
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
    BM.joker_defs[slug] = {name = 'Patamon', stage = stage, evolves_to = 'Angemon, Pegasusmon', effect = 'If the first played card is a single card, turn it into a lucky card'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'angemon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Angemon', text = {
            {
                'All played cards with rank 7 turn to lucky',
                'cards. Also applies Patamon’s effect',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 9, y = 5},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MagnaAngemon',
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
    BM.joker_defs[slug] = {name = 'Angemon', stage = stage, evolves_to = 'MagnaAngemon', effect = 'All played cards with rank 7 turn to lucky cards. Also applies Patamon’s effect'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'pegasusmon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Pegasusmon', text = {
            {
                'Double any probability',
                '{C:inactive}(eg, {C:green}1 in 3{} to 2 in 3){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 0, y = 6},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MagnaAngemon, HippoGryphonmon',
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
    BM.joker_defs[slug] = {name = 'Pegasusmon', stage = stage, evolves_to = 'MagnaAngemon, HippoGryphonmon', effect = 'Double any probability (eg, 1 in 3 to 2 in 3)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'magnaangemon'
    local stage = 'Ultimate'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'MagnaAngemon', text = {
            {
                'Gain {X:mult,C:white}X0.3{} Mult every time a Lucky Card',
                'triggers',
                '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 1, y = 6},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Seraphimon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},e.xmult or 1}}
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
    BM.joker_defs[slug] = {name = 'MagnaAngemon', stage = stage, evolves_to = 'Seraphimon', effect = 'Gain X0.3 Mult every time a Lucky Card triggers'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'seraphimon'
    local stage = 'Mega'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Seraphimon', text = {
            {
                'Lucky cards can give {X:mult,C:white}X2{} Mult on money hit',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 2, y = 6},
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
    BM.joker_defs[slug] = {name = 'Seraphimon', stage = stage, evolves_to = '-', effect = 'Lucky cards can give X2 Mult on money hit'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

