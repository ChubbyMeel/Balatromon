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
    key = 'Clipping',
    path = 'DigiMeel_Clipping.png',
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

local function apply_balatromon_main_menu()
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

local function load_lua_folder(folder)
    local files = NFS.getDirectoryItems(BM.MOD.path .. folder)
    table.sort(files)

    for _, file in ipairs(files) do
        if file:sub(-4) == '.lua' then
            assert(SMODS.load_file(folder .. '/' .. file))()
        end
    end
end

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
load_lua_folder('src/digimon/set_one')
assert(SMODS.load_file('src/digimon/attributes.lua'))()
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
assert(SMODS.load_file('src/core/clippings.lua'))()
assert(SMODS.load_file('src/core/artist_badges.lua'))()
assert(SMODS.load_file('src/items/vanilla_patches.lua'))()
assert(SMODS.load_file('src/gameplay/boss_blinds.lua'))()
assert(SMODS.load_file('src/gameplay/decks.lua'))()
assert(SMODS.load_file("ui.lua"))()
assert(SMODS.load_file('src/system/profile_mode.lua'))()
assert(SMODS.load_file('src/system/optimiser.lua'))()
assert(SMODS.load_file('src/system/music.lua'))()

BM.install_attribute_badges()

assert(SMODS.load_file('src/compat/pokermon_compat.lua'))()
assert(SMODS.load_file('src/compat/multiplayer_compat.lua'))()
assert(SMODS.load_file('src/compat/sleeves_compat.lua'))()
assert(SMODS.load_file('src/compat/jokerdisplay_compat.lua'))()
assert(SMODS.load_file('src/helpers/retrigger_hooks.lua'))()
assert(SMODS.load_file('src/ui/deckskins.lua'))()
assert(SMODS.load_file('src/ui/digivolution_tooltips.lua'))()

SMODS.current_mod.custom_collection_tabs = function(...)
    local tabs = {}

    if BM.add_vanilla_collection_tab then
        BM.add_vanilla_collection_tab(tabs, ...)
    end

    if BM.add_x_antibody_collection_tab then
        BM.add_x_antibody_collection_tab(tabs, ...)
    end

    return tabs
end

SMODS.current_mod.process_loc_text = function(self)
    if BM.install_attribute_clip_localization then
        BM.install_attribute_clip_localization()
    end

    if BM.install_appmon_localization then
        BM.install_appmon_localization()
    end

    if BM.install_x_antibody_localization then
        BM.install_x_antibody_localization()
    end

    local pokermon_compat = BM.pokermon_compat
    if pokermon_compat and pokermon_compat.install_localization then
        pokermon_compat.install_localization()
    end

    if BM.install_digivolution_localization then
        BM.install_digivolution_localization()
    end
end

SMODS.current_mod.calculate = function(self, context)
    BM.calculate_attribute_clip_context(context)
    local result

    if BM.calculate_evolution_tag then
        result = BM.calculate_evolution_tag(context)
    end

    if BM.calculate_hackmon then
        local hackmon_result = BM.calculate_hackmon(context)
        if hackmon_result then
            result = hackmon_result
        end
    end

    local pokermon_compat = BM.pokermon_compat
    if pokermon_compat and pokermon_compat.calculate then
        pokermon_compat.calculate(context)
    end

    return result
end

local balatromon_main_menu = Game.main_menu

function Game:main_menu(change_context)
    local result = balatromon_main_menu(self, change_context)

    apply_balatromon_main_menu()

    if BM.open_pending_profile_mode_picker then
        BM.open_pending_profile_mode_picker()
    end

    return result
end

local balatromon_start_run = Game.start_run

Game.start_run = function(self, args)
    local multiplayer_compat = BM.multiplayer_compat
    if multiplayer_compat
    and multiplayer_compat.is_active
    and multiplayer_compat.is_active()
    and multiplayer_compat.reset_transients then
        multiplayer_compat.reset_transients()
    end

    if BM.reset_hackmon_run_state then
        BM.reset_hackmon_run_state()
    end

    if BM.prepare_appmon_run then
        args = BM.prepare_appmon_run(args)
    end

    local loading_save = args and args.savetext ~= nil
    local result = balatromon_start_run(self, args)

    if BM.apply_run_mode then
        BM.apply_run_mode(loading_save)
    end

    if BM.finish_appmon_run then
        BM.finish_appmon_run()
    end

    return result
end

local balatromon_use_consumeable = Card.use_consumeable

Card.use_consumeable = function(self, ...)
    if BM.track_perorimon_consumable then
        BM.track_perorimon_consumable(self)
    end

    if BM.track_last_tarot then
        BM.track_last_tarot(self)
    end

    return balatromon_use_consumeable(self, ...)
end

local balatromon_set_cost = Card.set_cost

Card.set_cost = function(self, ...)
    local result = balatromon_set_cost(self, ...)

    BM.apply_attribute_clip_cost(self)

    if BM.apply_polarbearmon_shop_cost then
        BM.apply_polarbearmon_shop_cost(self)
    end

    if BM.apply_redvegiemon_shop_cost then
        BM.apply_redvegiemon_shop_cost(self)
    end

    return result
end

local balatromon_buy_from_shop = G.FUNCS.buy_from_shop

G.FUNCS.buy_from_shop = function(e, ...)
    local card = e
        and e.config
        and e.config.ref_table

    local sort_id = card and card.sort_id or 0
    local bought_digimon = card
        and BM.is_digimon(card)
        and not BM.is_appmon(card)

    local result

    if BM.buy_appmon_from_shop then
        result = BM.buy_appmon_from_shop(
            balatromon_buy_from_shop,
            e,
            ...
        )
    else
        result = balatromon_buy_from_shop(e, ...)
    end

    if BM.apply_food_stamp_after_buy then
        BM.apply_food_stamp_after_buy(
            card,
            sort_id,
            bought_digimon
        )
    end

    return result
end
