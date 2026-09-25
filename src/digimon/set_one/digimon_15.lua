local BM = Balatromon

do
    local slug = 'kuramon'
    local stage = 'Fresh'
    local extra = {
        hunger=1,
        bond=0,
        care_mistakes=0,
        care_rounds=0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Kuramon',
            text={
                {
                    '{C:mult}+3{} Mult for every Joker owned',
                    '{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult){}',
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
        pos = {x = 1, y = 13},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Tsumemon',

        loc_vars = function(self, info_queue, card)
            local e =
                card
                and card.ability
                and card.ability.extra
                or extra

            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    BM.count_owned_jokers() * 3
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
        name = 'Kuramon',
        stage = stage,
        evolves_to = 'Tsumemon',
        effect = '+3 Mult for every Joker owned'
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

do
    local slug = 'tsumemon'
    local stage = 'In-Training'
    local extra = {
        hunger=1,
        bond=0,
        care_mistakes=0,
        care_rounds=0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Tsumemon',
            text={
                {
                    'Add Mult equal to the total sell value',
                    'of all other owned Jokers',
                    '{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult){}',
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
        pos = {x = 2, y = 13},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Keramon, Espimon',

        loc_vars = function(self, info_queue, card)
            local e =
                card
                and card.ability
                and card.ability.extra
                or extra

            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    BM.sum_other_joker_sell_value(card)
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
        name = 'Tsumemon',
        stage = stage,
        evolves_to = 'Keramon, Espimon',
        effect = 'Add Mult equal to the sum of the sell values of all other owned Jokers'
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

do
    local slug = 'keramon'
    local stage = 'Rookie'
    local extra = {
        hunger=1,
        bond=0,
        care_mistakes=0,
        care_rounds=0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Keramon',
            text={
                {
                    '{C:mult}+8{} Mult for every empty Joker slot',
                    '{C:inactive}(Keramon is ignored when counting occupied slots){}',
                    '{C:inactive}(Currently #4# empty, {C:mult}+#5#{C:inactive} Mult){}',
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
        pos = {x = 3, y = 13},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Bakemon, Raremon',

        loc_vars = function(self, info_queue, card)
            local e =
                card
                and card.ability
                and card.ability.extra
                or extra

            local empty = BM.empty_joker_slots({
                keramon = true
            })

            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    empty,
                    empty * 8
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
        name = 'Keramon',
        stage = stage,
        evolves_to = 'Bakemon, Raremon',
        effect = '+8 Mult for every empty Joker slot, excluding Keramon'
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

do
    local slug = 'raremon'
    local stage = 'Champion'
    local extra = {
        hunger=1,
        bond=0,
        care_mistakes=0,
        care_rounds=0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Raremon',
            text={
                {
                    'Starts at {X:mult,C:white}X5{} Mult',
                    'Lose {X:mult,C:white}X1{} Mult for every Joker owned',
                    'after {X:mult,C:white}X1{}, each additional Joker',
                    'only loses {X:mult,C:white}X0.01{} Mult',
                    '{C:inactive}(Negative Jokers included){}',
                    '{C:inactive}(#4# Jokers, Currently {X:mult,C:white}X#5#{C:inactive} Mult){}',
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
        pos = {x = 4, y = 13},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Garbagemon',

        loc_vars = function(self, info_queue, card)
            local e =
                card
                and card.ability
                and card.ability.extra
                or extra

            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    BM.count_owned_jokers(),
                    BM.raremon_xmult()
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
        name = 'Raremon',
        stage = stage,
        evolves_to = 'Garbagemon',
        effect = 'X5 Mult, lose X1 per owned Joker until X1, then X0.01 per additional Joker'
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

do
    local slug = 'bakemon'
    local stage = 'Champion'
    local extra = {
        hunger=1,
        bond=0,
        care_mistakes=0,
        care_rounds=0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Bakemon',
            text={
                {
                    '{X:mult,C:white}X0.5{} Mult for every empty Joker slot',
                    '{C:inactive}(Bakemon, Raremon, Phantomon and Pumpkinmon ignored){}',
                    '{C:inactive}(Currently #4# empty, {X:mult,C:white}X#5#{C:inactive} Mult){}',
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
        pos = {x = 5, y = 13},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Phantomon',

        loc_vars = function(self, info_queue, card)
            local e =
                card
                and card.ability
                and card.ability.extra
                or extra

            local empty = BM.empty_joker_slots({
                raremon = true,
                phantomon = true,
                pumpkinmon = true,
                bakemon = true,
            })

            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    empty,
                    empty * 0.5
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
        name = 'Bakemon',
        stage = stage,
        evolves_to = 'Phantomon',
        effect = 'X0.5 Mult for every empty Joker slot, ignoring Bakemon, Raremon, Phantomon and Pumpkinmon'
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

do
    local slug = 'phantomon'
    local stage = 'Ultimate'
    local extra = {
        hunger=1,
        bond=0,
        care_mistakes=0,
        care_rounds=0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Phantomon',
            text={
                {
                    '{X:mult,C:white}X1{} Mult for every empty Joker slot',
                    '{C:inactive}(Bakemon, Raremon, Phantomon and Pumpkinmon ignored){}',
                    '{C:inactive}(Currently #4# empty, {X:mult,C:white}X#5#{C:inactive} Mult){}',
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
        pos = {x = 6, y = 13},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'MaloMyotismon, Puppetmon',

        loc_vars = function(self, info_queue, card)
            local e =
                card
                and card.ability
                and card.ability.extra
                or extra

            local empty = BM.empty_joker_slots({
                raremon = true,
                phantomon = true,
                pumpkinmon = true,
                bakemon = true,
            })

            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    empty,
                    empty
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
        name = 'Phantomon',
        stage = stage,
        evolves_to = 'MaloMyotismon, Puppetmon',
        effect = 'X1 Mult for every empty Joker slot, ignoring Bakemon, Raremon, Phantomon and Pumpkinmon'
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

do
    local slug = 'pumpkinmon'
    local stage = 'Ultimate'
    local extra = {
        hunger=1,
        bond=0,
        care_mistakes=0,
        care_rounds=0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Pumpkinmon',
            text={
                {
                    '{X:mult,C:white}X1{} Mult for every empty Joker slot',
                    '{C:inactive}(Bakemon, Raremon, Phantomon and Pumpkinmon ignored){}',
                    '{C:inactive}(Currently #4# empty, {X:mult,C:white}X#5#{C:inactive} Mult){}',
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
        pos = {x = 7, y = 13},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Puppetmon',

        loc_vars = function(self, info_queue, card)
            local e =
                card
                and card.ability
                and card.ability.extra
                or extra

            local empty = BM.empty_joker_slots({
                raremon = true,
                phantomon = true,
                pumpkinmon = true,
                bakemon = true,
            })

            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    empty,
                    empty
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
        name = 'Pumpkinmon',
        stage = stage,
        evolves_to = 'Puppetmon',
        effect = 'X1 Mult for every empty Joker slot, ignoring Bakemon, Raremon, Phantomon and Pumpkinmon'
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

do
    local slug = 'puppetmon'
    local stage = 'Mega'
    local extra = {
        hunger=1,
        bond=0,
        care_mistakes=0,
        care_rounds=0,
        xmult=4
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Puppetmon',
            text={
                {
                    'Starts with {X:mult,C:white}X4{} Mult',
                    'At end of round, gain {X:mult,C:white}X1{} Mult',
                    'for every empty Joker slot',
                    '{C:inactive}(Currently #4# empty slots){}',
                    '{C:inactive}(Currently {X:mult,C:white}X#5#{C:inactive} Mult){}',
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
        pos = {x = 8, y = 13},

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

            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    BM.empty_joker_slots(),
                    e.xmult or 4
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
        name = 'Puppetmon',
        stage = stage,
        evolves_to = '-',
        effect = 'Starts at X4 Mult and gains X1 Mult for every empty Joker slot at end of round'
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

