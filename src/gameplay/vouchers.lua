local BM = Balatromon

local function get_profile()
    return G.PROFILES
        and G.SETTINGS
        and G.PROFILES[G.SETTINGS.profile]
end

local function get_digi_items_used()
    local profile =
        get_profile()

    if not profile
    or not profile.career_stats then
        return 0
    end

    return
        profile.career_stats.balatromon_digi_items_used
        or 0
end

local function get_rookie_champion_progress()
    local discovered = 0
    local total = 0

    for slug, def in pairs(
        BM.joker_defs or {}
    ) do
        if def.stage == 'Rookie'
        or def.stage == 'Champion' then
            total =
                total + 1

            local center =
                G.P_CENTERS
                and G.P_CENTERS[
                    BM.center_key(slug)
                ]

            if center
            and center.discovered then
                discovered =
                    discovered + 1
            end
        end
    end

    return discovered, total
end

local function all_rookies_champions_discovered()
    local discovered,
        total =
        get_rookie_champion_progress()

    return total > 0
        and discovered >= total
end

SMODS.Voucher {
    key = 'classic_goggles',

    atlas = 'Voucher',
    pos = {x = 0, y = 0},

    cost = 10,

    discovered = false,
    unlocked = true,

    loc_txt = {
        name = 'Classic Goggles',
        text = {
            '{C:attention}Digi Items{} appear',
            '{C:attention}2X{} more frequently',
            'in the shop'
        }
    },

    redeem = function(self, card)
        G.GAME.balatromon_digi_item_shop_mult =
            2

        G.GAME.digiitem_rate =
            2
    end,
}

SMODS.Voucher {
    key = 'digidestined',

    atlas = 'Voucher',
    pos = {x = 1, y = 0},

    cost = 10,

    discovered = false,
    unlocked = false,

    requires = {
        'v_DigiMeel_classic_goggles'
    },

    loc_txt = {
        name = 'Digidestined',

        text = {
            '{C:attention}Digi Items{} appear',
            '{C:attention}4X{} more frequently',
            'in the shop'
        },

        unlock = {
            'Use {C:attention}100{} Digi Items',
            '{C:inactive}(#1#/100 used){}'
        }
    },

    locked_loc_vars = function(
        self,
        info_queue,
        card
    )
        return {
            vars = {
                math.min(
                    100,
                    get_digi_items_used()
                )
            }
        }
    end,

    check_for_unlock = function(
        self,
        args
    )
        return
            get_digi_items_used()
            >= 100
    end,

    redeem = function(self, card)
        G.GAME.balatromon_digi_item_shop_mult =
            4

        G.GAME.digiitem_rate =
            4
    end,
}

SMODS.Voucher {
    key = 'digivice_abundance',

    atlas = 'Voucher',
    pos = {x = 2, y = 0},

    cost = 10,

    discovered = false,
    unlocked = true,

    loc_txt = {
        name = 'Digivice Abundance',
        text = {
            '{C:attention}Rookie{} and {C:attention}Champion{}',
            'Digimon appear more',
            'frequently in the shop'
        }
    },

    redeem = function(self, card)
        G.GAME.balatromon_digivice_abundance =
            true
    end,
}

SMODS.Voucher {
    key = 'mega_digivolution',

    atlas = 'Voucher',
    pos = {x = 3, y = 0},

    cost = 10,

    discovered = false,
    unlocked = false,

    requires = {
        'v_DigiMeel_digivice_abundance'
    },

    loc_txt = {
        name = 'Mega Digivolution',

        text = {
            '{C:attention}Ultimate{} Digimon',
            'can now appear',
            'in the shop'
        },

        unlock = {
            'Discover every {C:attention}Rookie{}',
            'and {C:attention}Champion{} Digimon',
            '{C:inactive}(#1#/#2# discovered){}'
        }
    },

    locked_loc_vars = function(
        self,
        info_queue,
        card
    )
        local discovered,
            total =
            get_rookie_champion_progress()

        return {
            vars = {
                discovered,
                total
            }
        }
    end,

    check_for_unlock = function(
        self,
        args
    )
        return
            all_rookies_champions_discovered()
    end,

    redeem = function(self, card)
        G.GAME.balatromon_mega_digivolution =
            true
    end,
}
local function get_foods_spoiled()
    local profile = get_profile()

    if not profile
    or not profile.career_stats then
        return 0
    end

    return profile.career_stats.balatromon_foods_spoiled or 0
end

local function get_baby_appmon_progress()
    local discovered = 0
    local total = 0

    for _, center in pairs(G.P_CENTERS or {}) do
        if center
        and center.balatromon_appmon == true
        and center.appmon_stage == 'Baby' then
            total = total + 1

            if center.discovered then
                discovered = discovered + 1
            end
        end
    end

    return discovered, total
end

local function all_baby_appmon_discovered()
    local discovered, total = get_baby_appmon_progress()
    return total > 0 and discovered >= total
end

local function voucher_active(slug)
    if not G or not G.GAME then
        return false
    end

    local key = 'v_' .. BM.PREFIX .. '_' .. tostring(slug)
    local flag = 'balatromon_' .. tostring(slug)

    return G.GAME[flag] == true
        or (
            G.GAME.used_vouchers
            and G.GAME.used_vouchers[key]
            == true
        )
end

local function random_food_key(seed)
    local slug = BM.random_element(
        {
            'food',
            'hefty_food',
            'frozen_meal',
            'spicy_buffet'
        },
        seed or 'balatromon_food_stamp'
    )

    return slug and ('c_' .. BM.PREFIX .. '_' .. slug) or nil
end

function BM.add_food_stamp_food(seed)
    if not G.consumeables
    or not BM.has_room(G.consumeables) then
        return nil
    end

    local key = random_food_key(seed)
    if not key or not G.P_CENTERS[key] then
        return nil
    end

    return SMODS.add_card {
        set = 'DigiItem',
        area = G.consumeables,
        key = key,
        key_append = seed or 'balatromon_food_stamp'
    }
end

SMODS.Voucher {
    key = 'appli_driver',

    atlas = 'Voucher',
    pos = {x = 0, y = 1},

    cost = 10,

    discovered = false,
    unlocked = true,

    loc_txt = {
        name = 'Appli Driver',
        text = {
            '{C:attention}+1{} Loader Slot'
        }
    },

    redeem = function(self, card)
        G.GAME.balatromon_appli_driver = true

        if BM.sync_loader_slots then
            BM.sync_loader_slots()
        end
    end,
}

SMODS.Voucher {
    key = 'ultimate_app_realise',

    atlas = 'Voucher',
    pos = {x = 1, y = 1},

    cost = 10,

    discovered = false,
    unlocked = false,

    requires = {
        'v_' .. BM.PREFIX .. '_appli_driver'
    },

    loc_txt = {
        name = 'Ultimate App Realise',
        text = {
            '{C:attention}Baby Appmon{} can now',
            'become non-Base {C:attention}Super Appmon{}'
        },
        unlock = {
            'Discover every {C:attention}Baby Appmon{}',
            '{C:inactive}(#1#/#2# discovered){}'
        }
    },

    locked_loc_vars = function(self, info_queue, card)
        local discovered, total = get_baby_appmon_progress()

        return {
            vars = {
                discovered,
                total
            }
        }
    end,

    check_for_unlock = function(self, args)
        return all_baby_appmon_discovered()
    end,

    redeem = function(self, card)
        G.GAME.balatromon_ultimate_app_realise = true
    end,
}

SMODS.Voucher {
    key = 'food_stamp',

    atlas = 'Voucher',
    pos = {x = 2, y = 1},

    cost = 10,

    discovered = false,
    unlocked = true,

    loc_txt = {
        name = 'Food Stamp',
        text = {
            'Bought {C:attention}Digimon{} have a',
            '{C:green}1 in 4{} chance to create',
            'a random {C:attention}Food{}',
            '{C:inactive}(Must have room){}'
        }
    },

    redeem = function(self, card)
        G.GAME.balatromon_food_stamp = true
    end,
}

SMODS.Voucher {
    key = 'food_warranty',

    atlas = 'Voucher',
    pos = {x = 3, y = 1},

    cost = 10,

    discovered = false,
    unlocked = false,

    requires = {
        'v_' .. BM.PREFIX .. '_food_stamp'
    },

    loc_txt = {
        name = 'Food Warranty',
        text = {
            'Spoiled {C:attention}Food{} creates',
            'a random {C:tarot}Tarot{} or',
            '{C:attention}Digi Item{}',
            '{C:inactive}(Must have room){}'
        },
        unlock = {
            'Spoil {C:attention}100{} Food',
            '{C:inactive}(#1#/100 spoiled){}'
        }
    },

    locked_loc_vars = function(self, info_queue, card)
        return {
            vars = {
                math.min(100, get_foods_spoiled())
            }
        }
    end,

    check_for_unlock = function(self, args)
        return get_foods_spoiled() >= 100
    end,

    redeem = function(self, card)
        G.GAME.balatromon_food_warranty = true
    end,
}

if not BM._food_stamp_buy_hook
and G.FUNCS
and G.FUNCS.buy_from_shop then
    local old_voucher_buy_from_shop = G.FUNCS.buy_from_shop

    G.FUNCS.buy_from_shop = function(e, ...)
        local card = e
            and e.config
            and e.config.ref_table

        local bought_digimon = card
            and BM.is_digimon(card)
            and not BM.is_appmon(card)

        local sort_id = card and card.sort_id or 0
        local result = old_voucher_buy_from_shop(e, ...)

        if bought_digimon
        and card
        and not card.REMOVED
        and card.area == G.jokers
        and voucher_active('food_stamp') then
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.1,
                func = function()
                    if card
                    and not card.REMOVED
                    and card.area == G.jokers
                    and G.consumeables
                    and BM.has_room(G.consumeables)
                    and SMODS.pseudorandom_probability(
                        card,
                        'balatromon_food_stamp_' .. tostring(sort_id),
                        1,
                        4
                    ) then
                        local made = BM.add_food_stamp_food(
                            'balatromon_food_stamp_' .. tostring(sort_id)
                        )

                        if made and card_eval_status_text then
                            card_eval_status_text(
                                card,
                                'extra',
                                nil,
                                nil,
                                nil,
                                {
                                    message = 'Food!',
                                    colour = G.C.GREEN
                                }
                            )
                        end
                    end

                    return true
                end
            })
        end

        return result
    end

    BM._food_stamp_buy_hook = true
end
