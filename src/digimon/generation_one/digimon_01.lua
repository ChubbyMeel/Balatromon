local BM = Balatromon

do
    local slug = 'botamon'
    local stage = 'Fresh'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Botamon', text = {
            {
                '{C:mult}+2{} Mult',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 0, y = 0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Koromon',
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
    BM.joker_defs[slug] = {name = 'Botamon', stage = stage, evolves_to = 'Koromon', effect = '+2 Mult'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'koromon'
    local stage = 'In-Training'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Koromon', text = {
            {
                '{C:mult}+4{} Mult',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 1, y = 0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Agumon',
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
    BM.joker_defs[slug] = {name = 'Koromon', stage = stage, evolves_to = 'Agumon', effect = '+4 Mult'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

--Aguman

do
    local slug = 'agumon'
    local stage = 'Rookie'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Agumon', text = {
            {
                '{C:mult}+6{} Mult',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 2, y = 0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Greymon, Tyrannomon, Numemon, Veedramon',
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
    BM.joker_defs[slug] = {name = 'Agumon', stage = stage, evolves_to = 'Greymon, Tyrannomon, Numemon, Veedramon', effect = '+6 Mult'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'greymon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Greymon', text = {
            {
                '{X:mult,C:white}X2{} Mult if played hand contains {C:attention}#4#{}',
                '{C:inactive}(rank changes at end of round){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 3, y = 0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MetalGreymon, SkullGreymon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            local target_rank=card and BM.ensure_target(card,'target_rank',BM.deck_ranks(),'greymon_rank') or e.target_rank or 14
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},BM.rank_name(target_rank)}}
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
    BM.joker_defs[slug] = {name = 'Greymon', stage = stage, evolves_to = 'MetalGreymon, SkullGreymon', effect = 'X2 Mult if played hand contains [Rank] (rank changes at end of round)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'metalgreymon'
    local stage = 'Ultimate'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'MetalGreymon', text = {
            {
                '{X:mult,C:white}X3{} Mult',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 4, y = 0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'WarGreymon, Machinedramon',
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
    BM.joker_defs[slug] = {name = 'MetalGreymon', stage = stage, evolves_to = 'WarGreymon, Machinedramon', effect = 'X3 Mult'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'skullgreymon'
    local stage = 'Ultimate'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'SkullGreymon', text = {
            {
                'Gain {X:mult,C:white}X0.25{} Mult every time a card is destroyed',
                '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 5, y = 0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'BlackWarGreymon',
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
    BM.joker_defs[slug] = {name = 'SkullGreymon', stage = stage, evolves_to = 'BlackWarGreymon', effect = 'Gain X0.25 Mult every time a card is destroyed'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'tyrannomon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Tyrannomon', text = {
            {
                '{X:mult,C:white}X2{} Mult if played hand contains {V:1}#4#{}',
                '{C:inactive}(suit changes at end of round){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 6, y = 0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MetalGreymon, SkullGreymon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            local target_suit=card and BM.ensure_target(card,'target_suit',BM.deck_suits(),'tyrannomon_suit') or e.target_suit or 'Hearts'
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},target_suit, colours={(G.C.SUITS and G.C.SUITS[target_suit]) or G.C.FILTER}}}
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
    BM.joker_defs[slug] = {name = 'Tyrannomon', stage = stage, evolves_to = 'MetalGreymon, SkullGreymon', effect = 'X2 Mult if played hand contains [Suit] (suit changes at end of round)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'numemon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Numemon', text = {
            {
                '{X:mult,C:white}X2{} Mult',
                '{C:inactive}(-X0.01 Mult for every discarded card){}',
                '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 7, y = 0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Garbagemon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},e.xmult or 2}}
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
    BM.joker_defs[slug] = {name = 'Numemon', stage = stage, evolves_to = 'Garbagemon', effect = 'X2 Mult (-X0.01 Mult for every discarded card)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'garbagemon'
    local stage = 'Ultimate'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Garbagemon', text = {
            {
                'Gain {X:mult,C:white}X0.75{} Mult for every {C:attention}#4#{} Discarded. Reset',
                'at the end of the round',
                '{C:inactive}(rank changes at end of round){}',
                '{C:inactive}(Currently {X:mult,C:white}X#5#{C:inactive} Mult){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 8, y = 0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            local target_rank=card and BM.ensure_shared_target('garbagemon_rank',BM.RANKS,'garbage_rank') or e.target_rank or 14
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},BM.rank_name(target_rank),e.round_xmult or 1}}
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
    BM.joker_defs[slug] = {name = 'Garbagemon', stage = stage, evolves_to = '-', effect = 'Gain X0.75 Mult for every [Rank] Discarded. Reset at the end of the round (rank changes at end of round)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

-- do Check why its peeking under stone card soon!!

do
    local slug = 'wargreymon'
    local stage = 'Mega'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'WarGreymon', text = {
            {
                'Gain {X:mult,C:white}X0.5{} Mult for every {C:attention}#4#{} of {V:1}#5#{} Played',
                '{C:inactive}(Upgrade limited once per card including',
                'retrigger){} {C:inactive}(card changes at end of round){}',
                '{C:inactive}(Currently {X:mult,C:white}X#6#{C:inactive} Mult){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 9, y = 0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Omegamon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra

            local target_rank=e.target_rank
            local target_suit=e.target_suit

            if card then
                target_rank,target_suit=BM.ensure_shared_card_target(
                    'wargreymon_card',
                    'wargrey_card'
            )
            end

            target_rank=target_rank or 14
            target_suit=target_suit or 'Hearts'

            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    BM.rank_name(target_rank),
                    target_suit,
                    e.xmult or 1,
                    colours={
                        (G.C.SUITS and G.C.SUITS[target_suit])
                        or G.C.FILTER
                    }
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
    BM.joker_defs[slug] = {name = 'WarGreymon', stage = stage, evolves_to = 'Omegamon', effect = 'Gain X0.5 Mult for every [Rank] of [Suit] Played (Upgrade limited once per card including retrigger) (card changes at end of round)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'machinedramon'
    local stage = 'Mega'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Machinedramon', text = {
            {
                'Gain {X:mult,C:white}X0.5{} Mult for every {C:attention}#4#{} of {V:1}#5#{} Held in',
                'hand at the end of the round',
                '{C:inactive}(card changes at end of round){}',
                '{C:inactive}(Currently {X:mult,C:white}X#6#{C:inactive} Mult){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 0, y = 1},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra

            local target_rank=e.target_rank
            local target_suit=e.target_suit

            if card then
                target_rank,target_suit=BM.ensure_shared_card_target(
                    'machinedramon_card',
                    'machine_card'
                )
            end

            target_rank=target_rank or 14
            target_suit=target_suit or 'Hearts'

            return {
                vars={
                e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    BM.rank_name(target_rank),
                    target_suit,
                    e.xmult or 1,
                    colours={
                        (G.C.SUITS and G.C.SUITS[target_suit])
                        or G.C.FILTER
                    }
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
    BM.joker_defs[slug] = {name = 'Machinedramon', stage = stage, evolves_to = '-', effect = 'Gain X0.5 Mult for every [Rank] of [Suit] Held in hand at the end of the round (card changes at end of round)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'blackwargreymon'
    local stage = 'Mega'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'BlackWarGreymon', text = {
            {
                'Gain {X:mult,C:white}X0.5{} Mult every time a card is destroyed',
                '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 1, y = 1},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
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
    BM.joker_defs[slug] = {name = 'BlackWarGreymon', stage = stage, evolves_to = '-', effect = 'Gain X0.5 Mult every time a card is destroyed'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

