local BM = Balatromon

-- Gabumon, my beloved

do
    local slug = 'punimon'
    local stage = 'Fresh'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Punimon', text = {
            {
                '{C:chips}+20{} Chips',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 0, y = 3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Tsunomon',
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
    BM.joker_defs[slug] = {name = 'Punimon', stage = stage, evolves_to = 'Tsunomon', effect = '+20 Chips'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'tsunomon'
    local stage = 'In-Training'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Tsunomon', text = {
            {
                '{C:chips}+90{} Chips',
                '{C:inactive}(-5 Chips per discard used){}',
                '{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 1, y = 3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Gabumon, Elecmon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            local current = 90 - 5 * (e.discards or 0)
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},current}}
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
    BM.joker_defs[slug] = {name = 'Tsunomon', stage = stage, evolves_to = 'Gabumon, Elecmon', effect = '+90 Chips (-5 Chips per discard used)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'gabumon'
    local stage = 'Rookie'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Gabumon', text = {
            {
                'Gain {C:chips}+8{} Chips if hand played contains a',
                'scoring face card after a scoring numbered',
                'card',
                '{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 2, y = 3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Garurumon, Numemon, Leomon, MadLeomon, Grizzlymon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},e.chips or 0}}
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
    BM.joker_defs[slug] = {name = 'Gabumon', stage = stage, evolves_to = 'Garurumon, Numemon, Leomon, MadLeomon, Grizzlymon', effect = 'Gain +8 Chips if hand played contains a scoring face card after a scoring numbered card'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

BM.register_digimon({
    slug = 'gabumon_naked',
    name = 'Gabumon',
    stage = 'Rare',
    evolves_to = '-',
    pos = {x = 9, y = 20},
    blueprint_compat = false,
    extra = {
        xchips = 1
    },
    text = {
        'Strip played cards of their {C:attention}Enhancement{}',
        'and replace it with the effect of the',
        'last {C:tarot}Tarot{} used',
        'Gain {X:chips,C:white}X0.15{} Chips for each',
        'Enhancement stripped',
        '{C:inactive}(Last Tarot Used: {C:tarot}#4#{C:inactive}){}',
        '{V:1}#5#{}',
        '{C:inactive}(Currently {X:chips,C:white}X#6#{C:inactive} Chips){}',
    },
    dynamic_vars = function(card, e)
        local tarot_name,
            compatibility,
            colour =
                BM.gabumon_naked_tarot_info()

        return {
            tarot_name,
            compatibility,
            e.xchips or 1,
            colours = {
                colour
            }
        }
    end,
    effect = 'Strips played card enhancements and applies the last compatible Tarot effect; gains X0.15 Chips per enhancement stripped'
})

do
    local slug = 'elecmon'
    local stage = 'Rookie'

    local extra = {
        hunger = 1,
        bond = 0,
        care_mistakes = 0,
        care_rounds = 0,
        stored_chips = 0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Elecmon',
            text = {
                'Stores {C:chips}+10{} Chips for every hand played',
                'Stored Chips are released during a {C:attention}Boss Blind{}',
                '{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}',
                '{C:inactive}(Resets when released){}',
                BM.care_status_text(stage),
            }
        },

        config = {
            extra = extra
        },

        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,

        atlas = 'Joker',
        pos = {x = 8, y = 17},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Leomon',

        loc_vars = function(
            self,
            info_queue,
            card
        )
            local e =
                card
                and card.ability
                and card.ability.extra
                or extra

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,

                    elements = {
                        BM.care_bars(
                            e,
                            stage
                        )
                    },

                    e.stored_chips or 0
                }
            }
        end,

        in_pool = function(self, args)
            return
                stage == 'Fresh'
                or stage == 'In-Training'
                or stage == 'Rookie'
                or stage == 'Champion'
                or stage == 'Rare'
        end,

        add_to_deck = function(
            self,
            card,
            from_debuff
        )
            if not from_debuff then
                BM.on_add(
                    card,
                    slug
                )
            end
        end,

        remove_from_deck = function(
            self,
            card,
            from_debuff
        )
            if not from_debuff then
                BM.on_remove(
                    card,
                    slug
                )
            end
        end,

        can_sell = function(
            self,
            card,
            context
        )
            return BM.can_sell(
                card,
                slug
            )
        end,

        calculate = function(
            self,
            card,
            context
        )
            BM.care_tick(
                card,
                context
            )

            if card.ability.extra
                .permanently_disabled then
                return
            end

            return BM.run_effect(
                slug,
                card,
                context
            )
        end,
    }

    BM.joker_defs[slug] = {
        name = 'Elecmon',
        stage = stage,
        evolves_to = 'Leomon',
        effect = 'Stores +10 Chips for every hand played; releases stored Chips during a Boss Blind'
    }

    local weight =
        BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[
            #BM.shop_joker_keys + 1
        ] = {
            key = BM.center_key(slug),
            weight = weight,
            stage = stage
        }
    end
end

do
    local slug = 'garurumon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Garurumon', text = {
            {
                'Gain {C:chips}+10{} Chips if played hand contains a',
                'scoring face card',
                '{C:inactive}(carried over Chips from Gabumon){}',
                '{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 3, y = 3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'WereGarurumon, Mammothmon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},e.chips or 0}}
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
    BM.joker_defs[slug] = {name = 'Garurumon', stage = stage, evolves_to = 'WereGarurumon, Mammothmon', effect = 'Gain +10 Chips if played hand contains a scoring face card (carried over Chips from Gabumon)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'leomon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Leomon', text = {
            {
                'Gain {C:chips}+15{} Chips if played hand contains {C:attention}#4#{}',
                '{C:inactive}(carried over Chips from Gabumon){} {C:inactive}(poker hand',
                'changes at end of round){}',
                '{C:inactive}(Currently {C:chips}+#5#{C:inactive} Chips){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 4, y = 3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'LoaderLeomon, Knightmon, GrapLeomon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            local target_hand=card and BM.ensure_target(card,'target_hand',BM.HANDS,'leomon_hand') or e.target_hand or 'High Card'
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},target_hand,e.chips or 0}}
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
    BM.joker_defs[slug] = {name = 'Leomon', stage = stage, evolves_to = 'LoaderLeomon, Knightmon, GrapLeomon', effect = 'Gain +15 Chips if played hand contains [poker hand] (carried over Chips from Gabumon) (poker hand changes at end of round)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'madleomon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'MadLeomon', text = {
            {
                '{C:chips}+1000{} Chips',
                '{C:inactive}(-100 Chips for each card of hand size){}',
                '{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 5, y = 3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'LoaderLeomon, Knightmon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            local current = 1000 - 100 * (G.hand and G.hand.config and G.hand.config.card_limit or 0)
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},current}}
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
    BM.joker_defs[slug] = {name = 'MadLeomon', stage = stage, evolves_to = 'LoaderLeomon, Knightmon', effect = '+1000 Chips (-100 Chips for each card of hand size)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'weregarurumon'
    local stage = 'Ultimate'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'WereGarurumon', text = {
            {
                'Gain {C:chips}+20{} Chips if {C:attention}#4#{} is discarded.',
                '{C:inactive}(can upgrade once per discard){}',
                '{C:inactive}(rank changes every round){}',
                '{C:inactive}(carried over Chips from Garurumon){}',
                '{C:inactive}(Currently {C:chips}+#5#{C:inactive} Chips){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 6, y = 3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MetalGarurumon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            local target_rank=card and BM.ensure_shared_target('weregarurumon_rank',BM.RANKS,'weregaruru_rank') or e.target_rank or 14
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},BM.rank_name(target_rank),e.chips or 0}}
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
    BM.joker_defs[slug] = {name = 'WereGarurumon', stage = stage, evolves_to = 'MetalGarurumon', effect = 'Gain +20 Chips if [Rank] is discarded. (can upgrade once per discard) (carried over Chips from Garurumon) (rank changes at end of round)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'grapleomon'
    local stage = 'Ultimate'

    local extra = {
        hunger = 1,
        bond = 0,
        care_mistakes = 0,
        care_rounds = 0,
        stored_chips = 0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'GrapLeomon',
            text = {
                'Stores {C:chips}+60{} Chips when the',
                '{C:attention}most played poker hand{} is played',
                'Releases stored Chips while this',
                'Joker is {C:attention}leftmost{}',
                '{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}',
                '{C:inactive}(Resets when released){}',
                BM.care_status_text(stage),
            }
        },

        config = {
            extra = extra
        },

        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,

        atlas = 'Joker',
        pos = {x = 9, y = 17},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'SaberLeomon',

        loc_vars = function(
            self,
            info_queue,
            card
        )
            local e =
                card
                and card.ability
                and card.ability.extra
                or extra

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,

                    elements = {
                        BM.care_bars(
                            e,
                            stage
                        )
                    },

                    e.stored_chips or 0
                }
            }
        end,

        in_pool = function(self, args)
            return
                stage == 'Fresh'
                or stage == 'In-Training'
                or stage == 'Rookie'
                or stage == 'Champion'
                or stage == 'Rare'
        end,

        add_to_deck = function(
            self,
            card,
            from_debuff
        )
            if not from_debuff then
                BM.on_add(
                    card,
                    slug
                )
            end
        end,

        remove_from_deck = function(
            self,
            card,
            from_debuff
        )
            if not from_debuff then
                BM.on_remove(
                    card,
                    slug
                )
            end
        end,

        can_sell = function(
            self,
            card,
            context
        )
            return BM.can_sell(
                card,
                slug
            )
        end,

        calculate = function(
            self,
            card,
            context
        )
            BM.care_tick(
                card,
                context
            )

            if card.ability.extra
                .permanently_disabled then
                return
            end

            return BM.run_effect(
                slug,
                card,
                context
            )
        end,
    }

    BM.joker_defs[slug] = {
        name = 'GrapLeomon',
        stage = stage,
        evolves_to = 'SaberLeomon',
        effect = 'Stores +60 Chips when the most played poker hand is played; releases while leftmost'
    }

    local weight =
        BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[
            #BM.shop_joker_keys + 1
        ] = {
            key = BM.center_key(slug),
            weight = weight,
            stage = stage
        }
    end
end

do
    local slug = 'loaderleomon'
    local stage = 'Ultimate'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'LoaderLeomon', text = {
            {
                'Gain {C:chips}+50{} Chips if {C:attention}#4#{} is discarded.',
                '{C:inactive}(poker hand changes at end of round){}',
                '{C:inactive}(Currently {C:chips}+#5#{C:inactive} Chips){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 7, y = 3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'HeavyLeomon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            local target_hand=card and BM.ensure_shared_target('loaderleomon_hand',BM.HANDS,'loader_hand') or e.target_hand or 'High Card'
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},target_hand,e.chips or 0}}
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
    BM.joker_defs[slug] = {name = 'LoaderLeomon', stage = stage, evolves_to = 'HeavyLeomon', effect = 'Gain +50 Chips if [poker hand] is discarded. (poker hand changes at end of round)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'metalgarurumon'
    local stage = 'Mega'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'MetalGarurumon', text = {
            {
                'Gain {X:chips,C:white}X0.25{} Chips for every {C:attention}#4#{} of {V:1}#5#{} Played',
                '{C:inactive}(Upgrade limited once per card including',
                'retrigger){} {C:inactive}(card changes at end of round){}',
                '{C:inactive}(Currently {X:chips,C:white}X#6#{C:inactive} Chips){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 8, y = 3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Omegamon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra

            local target_rank=e.target_rank
            local target_suit=e.target_suit

            if card then
                target_rank,target_suit=BM.ensure_shared_card_target(
                    'metalgarurumon_card',
                    'metalgaruru_card'
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
                    e.xchips or 1,
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
    BM.joker_defs[slug] = {name = 'MetalGarurumon', stage = stage, evolves_to = 'Omegamon', effect = 'Gain X0.25 Chips for every [Rank] of [Suit] Played (Upgrade limited once per card including retrigger) (card changes at end of round)'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'heavyleomon'
    local stage = 'Mega'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'HeavyLeomon', text = {
            {
                'Gain {X:chips,C:white}X0.25{} Chips every time the least played',
                'poker hand is upgraded',
                '{C:inactive}(Currently {X:chips,C:white}X#4#{C:inactive} Chips){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 9, y = 3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},e.xchips or 1}}
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
    BM.joker_defs[slug] = {name = 'HeavyLeomon', stage = stage, evolves_to = '-', effect = 'Gain X0.25 Chips every time the least played poker hand is upgraded'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'saberleomon'
    local stage = 'Mega'

    local extra = {
        hunger = 1,
        bond = 0,
        care_mistakes = 0,
        care_rounds = 0,
        stored_xchips = 1
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'SaberLeomon',
            text = {
                'Doubles stored {C:chips}Chips{} when the',
                '{C:attention}non-most played poker hand{} is played',
                'Releases stored Chips while this',
                'Joker is {C:attention}leftmost{}',
                '{C:inactive}(Currently {X:chips,C:white}X#4#{C:inactive} Chips){}',
                '{C:inactive}(Resets to {X:chips,C:white}X1{C:inactive} when released){}',
                BM.care_status_text(stage),
            }
        },

        config = {
            extra = extra
        },

        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,

        atlas = 'Joker',
        pos = {x = 0, y = 18},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = '-',

        loc_vars = function(
            self,
            info_queue,
            card
        )
            local e =
                card
                and card.ability
                and card.ability.extra
                or extra

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,

                    elements = {
                        BM.care_bars(
                            e,
                            stage
                        )
                    },

                    e.stored_xchips or 1
                }
            }
        end,

        in_pool = function(self, args)
            return
                stage == 'Fresh'
                or stage == 'In-Training'
                or stage == 'Rookie'
                or stage == 'Champion'
                or stage == 'Rare'
        end,

        add_to_deck = function(
            self,
            card,
            from_debuff
        )
            if not from_debuff then
                BM.on_add(
                    card,
                    slug
                )
            end
        end,

        remove_from_deck = function(
            self,
            card,
            from_debuff
        )
            if not from_debuff then
                BM.on_remove(
                    card,
                    slug
                )
            end
        end,

        can_sell = function(
            self,
            card,
            context
        )
            return BM.can_sell(
                card,
                slug
            )
        end,

        calculate = function(
            self,
            card,
            context
        )
            BM.care_tick(
                card,
                context
            )

            if card.ability.extra
                .permanently_disabled then
                return
            end

            return BM.run_effect(
                slug,
                card,
                context
            )
        end,
    }

    BM.joker_defs[slug] = {
        name = 'SaberLeomon',
        stage = stage,
        evolves_to = '-',
        effect = 'Doubles stored Chips when the least played poker hand is played; releases while leftmost'
    }

    local weight =
        BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[
            #BM.shop_joker_keys + 1
        ] = {
            key = BM.center_key(slug),
            weight = weight,
            stage = stage
        }
    end
end

BM.register_digimon({
    slug =
        'bancholeomon',

    name =
        'BanchoLeomon',

    stage =
        'Mega',

    evolves_to =
        'BanchoLeomon Burst Mode',

    unlocked = false,

    unlock = {
        'Have any {C:attention}Leomon{}',
        'die from {C:attention}starvation{}'
    },

    check_for_unlock = function(
        self,
        args
    )
        return args
            and args.type
                == 'balatromon_leomon_died'
    end,

    pos = {
        x = 7,
        y = 19
    },

    blueprint_compat =
        false,

    negative_tooltip =
        true,

    text = {
        'At the end of a',
        '{C:attention}Boss Blind{}, create a',
        'random {C:dark_edition}Negative{}',
        '{C:attention}Leomon{}'
    },

    effect =
        'At the end of a Boss Blind, create a Negative random Leomon'
})

BM.register_digimon({
    slug =
        'bancholeomon_burst_mode',

    name =
        'BanchoLeomon Burst Mode',

    stage =
        'Beyond',

    evolves_to =
        '-',

    pos = {
        x = 8,
        y = 19
    },

    blueprint_compat =
        false,

    negative_tooltip =
        true,

    digimon_tooltips = {
        'bancholeomon'
    },

    text = {
        'At the end of the round,',
        'each other {C:attention}Leomon{} gains',
        '{C:attention}twice{} its normal',
        'scaling amount',
        'Applies {C:attention}BanchoLeomon{}'
    },

    effect =
        'Double the normal scaling gain of each Leomon at end of round and apply BanchoLeomon'
})

BM.register_digimon({
    slug = 'omegamon',
    name = 'Omegamon',
    stage = 'Beyond',
    evolves_to = '-',
    pos = {x = 0, y = 19},

    extra = {
        emult = 1,
        xchips = 1
    },

    text = {
        'Gain {X:mult,C:white}^0.15{} Mult and',
        '{X:chips,C:white}X1{} Chips whenever',
        'a {C:attention}#4#{} of {V:1}#5#{} is triggered',
        '{C:inactive}(card changes at end of round){}',
        '{C:inactive}(Currently {X:mult,C:white}^#6#{C:inactive} Mult,',
        '{X:chips,C:white}X#7#{C:inactive} Chips){}'
    },

    dynamic_vars = function(card, e)
        local rank, suit =
            BM.ensure_shared_card_target(
                'omegamon_card',
                'omegamon_card'
            )

        local vars = {
            BM.rank_name(rank),
            suit,
            e.emult or 1,
            e.xchips or 1
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

    effect = 'Gain ^0.15 Mult and X1 Chips whenever the target card is triggered'
})

