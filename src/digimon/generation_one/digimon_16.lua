local BM = Balatromon

do
    local slug = 'yuramon'
    local stage = 'Fresh'
    local extra = {
        hunger = 1,
        bond = 0,
        care_mistakes = 0,
        care_rounds = 0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Yuramon',
            text = {
                {
                    'Feeds itself and only itself',
                    'at the end of each round',
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
        pos = {x = 9, y = 13},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_self_feed = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Tanemon',

        loc_vars = function(self, info_queue, card)
            local e = card
                and card.ability
                and card.ability.extra
                or extra

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)}
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
        name = 'Yuramon',
        stage = stage,
        evolves_to = 'Tanemon',
        effect = 'Feeds itself and only itself at the end of each round'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {
            key = BM.center_key(slug),
            weight = weight,
            stage = stage
        }
    end
end

do
    local slug = 'tanemon'
    local stage = 'In-Training'
    local extra = {
        hunger = 1,
        bond = 0,
        care_mistakes = 0,
        care_rounds = 0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Tanemon',
            text = {
                {
                    'Feeds itself at the end of each round',
                    'At the end of a {C:attention}Boss Blind{}, create',
                    'a {C:attention}Food{} or {C:attention}Hefty Food{}',
                    '{C:inactive}(Must have room){}',
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
        pos = {x = 0, y = 14},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_self_feed = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Palmon, Lalamon, Mushroomon',

        loc_vars = function(self, info_queue, card)
            local e = card
                and card.ability
                and card.ability.extra
                or extra

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)}
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
        name = 'Tanemon',
        stage = stage,
        evolves_to = 'Palmon, Lalamon, Mushroomon',
        effect = 'Feeds itself and creates Food or Hefty Food at the end of a Boss Blind'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {
            key = BM.center_key(slug),
            weight = weight,
            stage = stage
        }
    end
end

do
    local slug = 'palmon'
    local stage = 'Rookie'
    local extra = {
        hunger = 1,
        bond = 0,
        care_mistakes = 0,
        care_rounds = 0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Palmon',
            text = {
                {
                    'Feeds itself at the end of each round',
                    '{C:mult}+3{} Mult for every {C:attention}Food Item{} and',
                    'in your consumable area',
                    '{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult){}',
                    'Also applies {C:attention}Tanemon{} effect',
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
        pos = {x = 1, y = 14},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_self_feed = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Togemon, Numemon',

        loc_vars = function(self, info_queue, card)
            local e = card
                and card.ability
                and card.ability.extra
                or extra

            BM.add_digimon_tooltip(
                info_queue,
                'tanemon'
            )

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    3 * BM.count_food()
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
        name = 'Palmon',
        stage = stage,
        evolves_to = 'Togemon, Numemon',
        effect = '+3 Mult for each Food Item, also applies Tanemon effect'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {
            key = BM.center_key(slug),
            weight = weight,
            stage = stage
        }
    end
end

do
    local slug = 'lalamon'
    local stage = 'Rookie'
    local extra = {
        hunger = 1,
        bond = 0,
        care_mistakes = 0,
        care_rounds = 0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Lalamon',
            text = {
                {
                    'Feeds itself at the end of each round',
                    '{C:chips}+30{} Chips for every {C:attention}Food Item{} and',
                    'in your consumable area',
                    '{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}',
                    'Also applies {C:attention}Tanemon{} effect',
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
        pos = {x = 2, y = 14},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_self_feed = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Sunflowmon',

        loc_vars = function(self, info_queue, card)
            local e = card
                and card.ability
                and card.ability.extra
                or extra

            BM.add_digimon_tooltip(
                info_queue,
                'tanemon'
            )

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    30 * BM.count_food()
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
        name = 'Lalamon',
        stage = stage,
        evolves_to = 'Sunflowmon',
        effect = '+30 Chips for each Food Item, also applies Tanemon effect'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {
            key = BM.center_key(slug),
            weight = weight,
            stage = stage
        }
    end
end

do
    local slug = 'mushroomon'
    local stage = 'Rookie'
    local extra = {
        hunger = 1,
        bond = 0,
        care_mistakes = 0,
        care_rounds = 0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Mushroomon',
            text = {
                {
                    'Feeds itself at the end of each round',
                    'Earn {C:money}$2{} at end of round for every',
                    '{C:attention}Food Item{} held',
                    '{C:inactive}(Currently {C:money}$#4#{C:inactive}){}',
                    'Also applies {C:attention}Tanemon{} effect',
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
        pos = {x = 3, y = 14},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_self_feed = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'RedVegiemon, Woodmon',

        loc_vars = function(self, info_queue, card)
            local e = card
                and card.ability
                and card.ability.extra
                or extra

            BM.add_digimon_tooltip(
                info_queue,
                'tanemon'
            )

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    2 * BM.count_food()
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
        name = 'Mushroomon',
        stage = stage,
        evolves_to = 'RedVegiemon, Woodmon',
        effect = '$2 at end of round for each Food Item, also applies Tanemon effect'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {
            key = BM.center_key(slug),
            weight = weight,
            stage = stage
        }
    end
end

do
    local slug = 'togemon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Togemon',
            text = {
                {
                    'Feeds itself at the end of each round',
                    'Each {C:attention}Food Item{} gives',
                    '{X:mult,C:white}X0.5{} Mult',
                    '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
                    'Also applies {C:attention}Tanemon{} effect',
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
        pos = {x = 4, y = 14},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_self_feed = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Lillymon',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra

            BM.add_digimon_tooltip(info_queue,'tanemon')

            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                    1 + 0.5 * BM.count_food()
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
        name = 'Togemon',
        stage = stage,
        evolves_to = 'Lillymon',
        effect = 'Each Food Item gives X0.5 Mult, also applies Tanemon effect'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1]={
            key=BM.center_key(slug),
            weight=weight,
            stage = stage
        }
    end
end

do
    local slug = 'sunflowmon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Sunflowmon',
            text={
                {
                    'Feeds itself at the end of each round',
                    'All {C:attention}Digital Packs{} in the shop',
                    'become {C:attention}Mega Digital Packs{}',
                    'Also applies {C:attention}Lalamon{} effect',
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
        pos = {x = 5, y = 14},

        blueprint_compat = false,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_self_feed = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Lilamon, Pumpkinmon',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            BM.add_digimon_tooltip(info_queue,'lalamon')
            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)}
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
        name = 'Sunflowmon',
        stage = stage,
        evolves_to = 'Lilamon, Pumpkinmon',
        effect = 'All Digital Packs in the shop become Mega Digital Packs, also applies Lalamon effect'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1]={
            key=BM.center_key(slug),
            weight=weight,
            stage = stage
        }
    end
end

do
    local slug = 'redvegiemon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'RedVegiemon',
            text={
                {
                    'Feeds itself at the end of each round',
                    '{C:attention}Food Item{}',
                    'in the shop are {C:money}free{}',
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
        pos = {x = 6, y = 14},

        blueprint_compat = false,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_self_feed = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Jagamon, Pumpkinmon',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra

            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)}
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
        name = 'RedVegiemon',
        stage = stage,
        evolves_to = 'Jagamon, Pumpkinmon',
        effect = 'Food Item in the shop are free'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1]={
            key=BM.center_key(slug),
            weight=weight,
            stage = stage
        }
    end
end

do
    local slug = 'woodmon'
    local stage = 'Champion'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Woodmon',
            text={
                {
                    'Prevents all other Jokers from Digivolving',
                    'except the Joker directly to its left',
                    'At end of round, create a random',
                    'playing card with a {C:attention}Farm Seal{}',
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
        pos = {x = 7, y = 14},

        blueprint_compat = false,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Cherrymon',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra

            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)}
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
        name = 'Woodmon',
        stage = stage,
        evolves_to = 'Cherrymon',
        effect = 'Only the Joker to its left and Woodmon can Digivolve; creates a Farm Seal card each round'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1]={
            key=BM.center_key(slug),
            weight=weight,
            stage = stage
        }
    end
end

do
    local slug = 'lillymon'
    local stage = 'Ultimate'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Lillymon',
            text={
                {
                    'Feeds itself at the end of each round',
                    'At the start of the round, apply {C:attention}Bloom{}',
                    'to a random card drawn to hand',
                    'Consumes itself at end of round',
                    'if no {C:attention}Food{} or {C:attention}Hefty Food{} is held',
                    'Also applies {C:attention}Togemon{} effect',
                    '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
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
        pos = {x = 8, y = 14},

        blueprint_compat = false,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_self_feed = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Rosemon',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            BM.add_digimon_tooltip(info_queue,'togemon')
            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)},
                1 + 0.5 * BM.count_food()
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
        name = 'Lillymon',
        stage = stage,
        evolves_to = 'Rosemon',
        effect = 'Applies Bloom to a random drawn card, consumes itself if no Food is held, and also applies Togemon effect'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1]={
            key=BM.center_key(slug),
            weight=weight,
            stage = stage
        }
    end
end

do
    local slug = 'lilamon'
    local stage = 'Ultimate'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Lilamon',
            text={
                {
                    'Feeds itself at the end of each round',
                    'At the start of the round, apply {C:attention}Bloom{}',
                    'to a random card drawn to hand',
                    'Consumes itself at end of round',
                    'if {C:attention}Food{} or {C:attention}Hefty Food{} is held',
                    'Also applies {C:attention}Sunflowmon{} effect',
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
        pos = {x = 9, y = 14},

        blueprint_compat = false,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_self_feed = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Rosemon',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            BM.add_digimon_tooltip(info_queue,'sunflowmon')
            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)}
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
        name = 'Lilamon',
        stage = stage,
        evolves_to = 'Rosemon',
        effect = 'Applies Bloom to a random drawn card, consumes itself if Food is held, and also applies Sunflowmon effect'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1]={
            key=BM.center_key(slug),
            weight=weight,
            stage = stage
        }
    end
end

do
    local slug = 'jagamon'
    local stage = 'Ultimate'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Jagamon',
            text={
                {
                    'Feeds itself at the end of each round',
                    'When {C:attention}Food{} or {C:attention}Hefty Food{} is used,',
                    'create a free {C:dark_edition}Negative{} {C:tarot}The Tower{}',
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
        pos = {x = 0, y = 15},

        blueprint_compat = false,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_self_feed = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Hydramon',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra

            if G.P_CENTERS
            and G.P_CENTERS.c_tower then
                info_queue[#info_queue+1] =
                    G.P_CENTERS.c_tower
            end

            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)}
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
        name = 'Jagamon',
        stage = stage,
        evolves_to = 'Hydramon',
        effect = 'Creates a free Negative Tower whenever Food or Hefty Food is used'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1]={
            key=BM.center_key(slug),
            weight=weight,
            stage = stage
        }
    end
end

do
    local slug = 'cherrymon'
    local stage = 'Ultimate'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Cherrymon',
            text={
                {
                    'Prevents all other Jokers from Digivolving',
                    'except the Joker directly to its left',
                    'At end of round, create a random playing',
                    'card with {C:attention}Farm Seal{} and {C:attention}Bloom{}',
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
        pos = {x = 1, y = 15},

        blueprint_compat = false,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Rosemon',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra

            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
elements = {BM.care_bars(e, stage)}
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
        name = 'Cherrymon',
        stage = stage,
        evolves_to = 'Rosemon',
        effect = 'Only the Joker to its left and Cherrymon can Digivolve; creates a Bloom Farm Seal card each round'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1]={
            key=BM.center_key(slug),
            weight=weight,
            stage = stage
        }
    end
end

do
    local slug = 'rosemon'
    local stage = 'Mega'
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Rosemon',
            text={
                {
                    'If the first hand of the round has only',
                    '{C:attention}1{} card, add a permanent copy to your deck',
                    'with {C:attention}Bloom{} and a {C:attention}Farm Seal{},',
                    'then draw that copy to hand',
                    'Also applies {C:attention}Lillymon{} positive effect',
                    '{C:inactive}(Inherited Mult: {X:mult,C:white}X#4#{C:inactive}){}',
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
        pos = {x = 2, y = 15},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = '-',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            BM.add_digimon_tooltip(info_queue,'lillymon')
            return {
                vars={
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
                    elements = {BM.care_bars(e, stage)},
                    1 + 0.5 * BM.count_food()
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
        name = 'Rosemon',
        stage = stage,
        evolves_to = '-',
        effect = 'Copies a single-card first hand into a permanent Bloom Farm Seal card, also applies Lillymon effect without self-consumption'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1]={
            key=BM.center_key(slug),
            weight=weight,
            stage = stage
        }
    end
end

