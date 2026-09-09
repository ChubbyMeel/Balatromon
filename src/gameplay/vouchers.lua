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