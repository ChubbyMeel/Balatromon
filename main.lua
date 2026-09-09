Balatromon = Balatromon or {}
local BM = Balatromon
BM.MOD_ID = 'Balatromon'
BM.PREFIX = 'DigiMeel'
BM.MOD = BM.MOD or SMODS.current_mod


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
    key = 'Appmon',
    path = 'DigiMeel_Appmon.png',
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

SMODS.Atlas {
    key = 'Deck',
    path = 'DigiMeel_Deck.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'Undiscovered',
    path = 'DigiMeel_Undiscovered.png',
    px = 71,
    py = 95
}

Balatromon.EXPERIMENTAL_BUILD = true
Balatromon.LATEST_RELEASE_URL = 'https://github.com/ChubbyMeel/Balatromon/releases/latest'

G.FUNCS.balatromon_open_latest_release = function()
    love.system.openURL(Balatromon.LATEST_RELEASE_URL)
end

G.FUNCS.balatromon_close_experimental_notice = function()
    G.FUNCS.exit_overlay_menu()
end

local function balatromon_experimental_notice()
    G.FUNCS.overlay_menu({
        definition = create_UIBox_generic_options({
            back_func = 'balatromon_close_experimental_notice',
            contents = {
                {
                    n = G.UIT.R,
                    config = {
                        align = 'cm',
                        padding = 0.15
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = 'Experimental Balatromon Build',
                                scale = 0.6,
                                colour = G.C.RED
                            }
                        }
                    }
                },

                {
                    n = G.UIT.R,
                    config = {
                        align = 'cm',
                        padding = 0.1
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = 'You are playing a development branch of Balatromon.',
                                scale = 0.4,
                                colour = G.C.WHITE
                            }
                        }
                    }
                },

                {
                    n = G.UIT.R,
                    config = {
                        align = 'cm',
                        padding = 0.05
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = 'This version may contain experimental features,',
                                scale = 0.35,
                                colour = G.C.UI.TEXT_LIGHT
                            }
                        }
                    }
                },

                {
                    n = G.UIT.R,
                    config = {
                        align = 'cm',
                        padding = 0.05
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = 'unfinished content, bugs, or save incompatibilities.',
                                scale = 0.35,
                                colour = G.C.UI.TEXT_LIGHT
                            }
                        }
                    }
                },

                {
                    n = G.UIT.R,
                    config = {
                        align = 'cm',
                        padding = 0.1
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = 'For normal play, the latest stable release is recommended.',
                                scale = 0.38,
                                colour = G.C.YELLOW
                            }
                        }
                    }
                },

                {
                    n = G.UIT.R,
                    config = {
                        align = 'cm',
                        padding = 0.15
                    },
                    nodes = {
                        UIBox_button({
                            label = {'Latest Release'},
                            button = 'balatromon_open_latest_release',
                            colour = G.C.GREEN,
                            minw = 4
                        }),

                        UIBox_button({
                            label = {'Continue Anyway'},
                            button = 'balatromon_close_experimental_notice',
                            colour = G.C.RED,
                            minw = 4
                        })
                    }
                }
            }
        })
    })
end

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

    if Balatromon.EXPERIMENTAL_BUILD
        and not Balatromon._experimental_notice_shown then

        Balatromon._experimental_notice_shown = true

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            blocking = false,
            func = function()

                if G.STAGE == G.STAGES.MAIN_MENU
                    and not G.OVERLAY_MENU then

                    balatromon_experimental_notice()
                end

                return true
            end
        }))
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


assert(SMODS.load_file('src/core/modes.lua'))()
assert(SMODS.load_file('src/core/core.lua'))()
assert(SMODS.load_file('src/core/attributes.lua'))()
assert(SMODS.load_file('src/core/target_hints.lua'))()
assert(SMODS.load_file('src/digimon/tired.lua'))()
assert(SMODS.load_file('src/compat/element_compat.lua'))()
assert(SMODS.load_file('src/core/rarities.lua'))()
assert(SMODS.load_file('src/digimon/evolution.lua'))()
assert(SMODS.load_file('src/items/digi_items.lua'))()
assert(SMODS.load_file('src/digimon/effects.lua'))()
assert(SMODS.load_file('src/gameplay/poker_hands.lua'))()
assert(SMODS.load_file('src/digimon/royal_knights.lua'))()
assert(SMODS.load_file('src/digimon/jokers.lua'))()
assert(SMODS.load_file('src/appmon/appmon.lua'))()
assert(SMODS.load_file('src/appmon/appmon_effect.lua'))()
assert(SMODS.load_file('src/items/boosters.lua'))()
assert(SMODS.load_file('src/items/tarot_revisions.lua'))()
assert(SMODS.load_file('src/gameplay/shop.lua'))()
assert(SMODS.load_file('src/items/enhancements.lua'))()
assert(SMODS.load_file('src/items/seals.lua'))()
assert(SMODS.load_file('src/gameplay/tags.lua'))()
assert(SMODS.load_file('src/gameplay/vouchers.lua'))()
assert(SMODS.load_file('src/ui/collections.lua'))()
assert(SMODS.load_file('src/items/editions.lua'))()
assert(SMODS.load_file('src/items/stickers.lua'))()
assert(SMODS.load_file('src/items/tamers.lua'))()
assert(SMODS.load_file('src/ui/evolution_map.lua'))()
assert(SMODS.load_file('src/x_antibody/x_antibody.lua'))()
assert(SMODS.load_file('src/x_antibody/x_collection.lua'))()
assert(SMODS.load_file('src/core/artist_badges.lua'))()
assert(SMODS.load_file('src/items/vanilla_patches.lua'))()
assert(SMODS.load_file('src/gameplay/boss_blinds.lua'))()
assert(SMODS.load_file('src/gameplay/decks.lua'))()
assert(SMODS.load_file("ui.lua"))()
assert(SMODS.load_file('src/system/profile_mode.lua'))()
assert(SMODS.load_file('src/system/optimiser.lua'))()
assert(SMODS.load_file('src/system/music.lua'))()

BM.install_attribute_badges()

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


assert(SMODS.load_file('src/compat/pokermon_compat.lua'))()
assert(SMODS.load_file('src/compat/multiplayer_compat.lua'))()
assert(SMODS.load_file('src/compat/sleeves_compat.lua'))()
assert(SMODS.load_file('src/compat/jokerdisplay_compat.lua'))()
assert(SMODS.load_file('src/helpers/retrigger_hooks.lua'))()
assert(SMODS.load_file('src/ui/deckskins.lua'))()
assert(SMODS.load_file('src/ui/digivolution_tooltips.lua'))()

