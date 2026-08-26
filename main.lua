-- Balatromon
-- Generated from the Balatromon design database.

Balatromon = Balatromon or {}
local BM = Balatromon
BM.MOD_ID = 'Balatromon'
BM.PREFIX = 'DigiMeel'

-- Some Balatromon effects need these modern SMODS contexts.
SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
        post_trigger = true,
        cardareas = {
            discard = true,
            deck = true,
        },
    }
end

-- Keep the atlas key short: DigiMeel is already the mod prefix.
SMODS.Atlas {
    key = 'Joker',
    path = 'DigiMeel_Joker.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'Consumable',
    path = 'DigiMeel_Consumable.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'Enhancement',
    path = 'DigiMeel_Enhancement.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'Seal',
    path = 'DigiMeel_Seal.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'Tag',
    path = 'DigiMeel_Tag.png',
    px = 34,
    py = 34,
}

SMODS.Atlas {
    key = 'Voucher',
    path = 'DigiMeel_Voucher.png',
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = 'Booster',
    path = 'DigiMeel_Booster.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'balatro',
    path = 'Balatromon_Title.png',
    px = 389,
    py = 216,
    prefix_config = {
        key = false
    }
}

SMODS.Atlas {
    key = 'XDigimon',
    path = 'DigiMeel_Xanti.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'Tamer',
    path = 'DigiMeel_Tamer.png',
    px = 71,
    py = 95
}

SMODS.current_mod.menu_cards = function()
    return {
        remove_original = true,

        {
            key = BM.center_key('botamon')
        },

        func = function()
            if not G.title_top
            or not G.title_top.cards
            or not G.title_top.cards[1] then
                return
            end

            local card = G.title_top.cards[1]

            card.T.w = G.CARD_W * 0.83
            card.T.h = G.CARD_H * 0.83

            card.VT.w = card.T.w
            card.VT.h = card.T.h
        end
    }
end

G.C.BALATROMON_SPLASH_RED = HEX('B7475D')
G.C.BALATROMON_SPLASH_BLUE = HEX('35566C')

local balatromon_old_main_menu = Game.main_menu

Game.main_menu = function(change_context)
    local ret =
        balatromon_old_main_menu(change_context)

    if G.SPLASH_BACK then
        G.SPLASH_BACK:define_draw_steps({
            {
                shader = 'splash',
                send = {
                    {
                        name = 'time',
                        ref_table = G.TIMERS,
                        ref_value = 'REAL_SHADER'
                    },
                    {
                        name = 'vort_speed',
                        val = 0.4
                    },
                    {
                        name = 'colour_1',
                        ref_table = G.C,
                        ref_value = 'BALATROMON_SPLASH_RED'
                    },
                    {
                        name = 'colour_2',
                        ref_table = G.C,
                        ref_value = 'BALATROMON_SPLASH_BLUE'
                    },
                    {
                        name = 'mid_flash',
                        val = 0
                    },
                }
            }
        })
    end

    return ret
end

SMODS.Sound {
    key = 'music_menu',
    path = 'butterfly8.ogg',
    pitch = 1,
    volume = 0.6,

    select_music_track = function(self)
        if G.STAGE == G.STAGES.MAIN_MENU then
            return 100
        end
    end
}


assert(SMODS.load_file('src/core.lua'))()
assert(SMODS.load_file('src/element_compat.lua'))()
assert(SMODS.load_file('src/rarities.lua'))()
assert(SMODS.load_file('src/evolution.lua'))()
assert(SMODS.load_file('src/digi_items.lua'))()
assert(SMODS.load_file('src/effects.lua'))()
assert(SMODS.load_file('src/jokers.lua'))()
assert(SMODS.load_file('src/boosters.lua'))()
assert(SMODS.load_file('src/tarot_revisions.lua'))()
assert(SMODS.load_file('src/shop.lua'))()
assert(SMODS.load_file('src/enhancements.lua'))()
assert(SMODS.load_file('src/seals.lua'))()
assert(SMODS.load_file('src/tags.lua'))()
assert(SMODS.load_file('src/vouchers.lua'))()
assert(SMODS.load_file('src/collections.lua'))()
assert(SMODS.load_file('src/editions.lua'))()
assert(SMODS.load_file('src/stickers.lua'))()
assert(SMODS.load_file('src/tamers.lua'))()
assert(SMODS.load_file('src/evolution_map.lua'))()
assert(SMODS.load_file('src/x_antibody.lua'))()
assert(SMODS.load_file('src/artist_badges.lua'))()
assert(SMODS.load_file('src/vanilla_patches.lua'))()
assert(SMODS.load_file('src/boss_blinds.lua'))()
assert(SMODS.load_file("ui.lua"))()

SMODS.current_mod.process_loc_text = function()
    G.localization.descriptions.Other['DigiMeel_sakuyamon_renamon_effect'] = {
        name = 'Renamon Effect',
        text = {
            'Earn {C:money}$5{} for each',
            'discarded {C:attention}#1#{}',
            '{C:inactive}(rank changes at end of round){}'
        }
    }
end


local function wrap_digimon_tooltip_text(text, max_length)
    max_length = max_length or 34

    if not text or text == '' then
        return {''}
    end

    local lines = {}
    local current = ''

    for word in tostring(text):gmatch('%S+') do
        if current == '' then
            current = word
        elseif #current + #word + 1 <= max_length then
            current = current .. ' ' .. word
        else
            lines[#lines + 1] = current
            current = word
        end
    end

    if current ~= '' then
        lines[#lines + 1] = current
    end

    return lines
end

local old_process_loc_text =
    SMODS.current_mod.process_loc_text

SMODS.current_mod.process_loc_text = function(self)
    if old_process_loc_text then
        old_process_loc_text(self)
    end

    G.localization.descriptions.Other =
        G.localization.descriptions.Other or {}

    for slug, def in pairs(
        Balatromon.joker_defs or {}
    ) do
        local key =
            Balatromon.PREFIX
            .. '_digimon_ref_'
            .. slug

        SMODS.process_loc_text(
            G.localization.descriptions.Other,
            key,
            {
                name = def.name or slug,
                text = wrap_digimon_tooltip_text(
                    def.effect
                        or 'No effect description',
                    34
                )
            }
        )
    end
end