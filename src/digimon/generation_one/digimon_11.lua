local BM = Balatromon

do
    local slug = 'relemon'
    local stage = 'Fresh'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Relemon', text = {
            {
                'Earn {C:money}$4{} at end of round',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 9, y = 9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Viximon',
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
    BM.joker_defs[slug] = {name = 'Relemon', stage = stage, evolves_to = 'Viximon', effect = 'Earn $4 at end of round'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'viximon'
    local stage = 'In-Training'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Viximon', text = {
            {
                'Earn {C:money}$5{} at end of round',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 0, y = 10},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Renamon',
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
    BM.joker_defs[slug] = {name = 'Viximon', stage = stage, evolves_to = 'Renamon', effect = 'Earn $5 at end of round'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end


do
    local slug = 'renamon'
    local stage = 'Rookie'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Renamon', text = {
            {
                'Earn {C:money}$5{} for each discarded {C:attention}#4#{}',
                '{C:inactive}(rank changes at end of round){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 1, y = 10},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Kyubimon, ZubaEagermon, Gatomon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            local target_rank=card and BM.ensure_shared_target('renamon_family_rank',BM.RANKS,'renamon_rank') or e.target_rank or 14
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
    BM.joker_defs[slug] = {name = 'Renamon', stage = stage, evolves_to = 'Kyubimon, ZubaEagermon, Gatomon', effect = 'Earn $5 for each discarded [rank] {C:inactive}(rank changes at end of round){}'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'kyubimon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Kyubimon', text = {
            {
                'Earn {C:money}$10{} at end of round. Payout increases by',
                '{C:money}$2{} when Boss Blind is defeated',
                '{C:inactive}(Currently {C:money}$#4#{C:inactive} payout){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 2, y = 10},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Taomon, LadyDevimon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            return {vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},e.payout or 10}}
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
    BM.joker_defs[slug] = {name = 'Kyubimon', stage = stage, evolves_to = 'Taomon, LadyDevimon', effect = 'Earn $10 at end of round. Payout increases by $2 when Boss Blind is defeated'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

do
    local slug = 'taomon'
    local stage = 'Ultimate'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name = 'Taomon', text = {
            {
                '{X:mult,C:white}X1{} Mult for every {C:money}$10{} owned',
                '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
            },
            {BM.care_status_text(stage)}
        }},
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,
        atlas = 'Joker', pos = {x = 3, y = 10},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Sakuyamon, Piedmon',
        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            local current = math.max(1,math.floor((G.GAME and G.GAME.dollars or 0)/10))
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
    BM.joker_defs[slug] = {name = 'Taomon', stage = stage, evolves_to = 'Sakuyamon, Piedmon', effect = 'X1 Mult for every $10 owned'}
    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {key = BM.center_key(slug), weight = weight, stage = stage} end
end

-- Need Nerf? Debating

do
    local slug = 'sakuyamon'
    local stage = 'Mega'

    local extra = {
        hunger = 1,
        bond = 0,
        care_mistakes = 0,
        care_rounds = 0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Sakuyamon',
            text = {
                {
                    '{X:mult,C:white}X1{} Mult for every {C:money}$10{} owned',
                    'Also has the {C:attention}Renamon{} effect',
                    '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
                },
                {
                    BM.care_status_text(stage),
                }

            }
        },

        config = {
            extra = extra
        },

        rarity = BM.stage_rarity(stage),
        cost = BM.digimon_costs[stage] or 5,

        atlas = 'Joker',
        pos = {x = 4, y = 10},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = '-',

        loc_vars = function(self, info_queue, card)
            local e =
                card
                and card.ability
                and card.ability.extra
                or extra

            local target_rank =
                card
                and BM.ensure_shared_target(
                    'renamon_family_rank',
                    BM.RANKS,
                    'renamon_rank'
                )
                or e.target_rank
                or 14

            local current_xmult =
                math.max(
                    1,
                    math.floor(
                        (G.GAME and G.GAME.dollars or 0) / 10
                    )
                )

            BM.add_digimon_tooltip(info_queue, 'renamon', card)

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    current_xmult
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

            return BM.run_effect(
                slug,
                card,
                context
            )
        end,
    }

    BM.joker_defs[slug] = {
        name = 'Sakuyamon',
        stage = stage,
        evolves_to = '-',
        effect = 'X1 Mult for every $10 owned, apply Renamon effect'
    }

    local weight =
        BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {
            key = BM.center_key(slug),
            weight = weight,
            stage = stage
        }
    end
end

