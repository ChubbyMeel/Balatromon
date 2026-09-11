local BM = Balatromon

local function install_appmon_tooltips()
    if not G
    or not G.localization
    or not G.localization.descriptions then
        return
    end

    G.localization.descriptions.Other =
        G.localization.descriptions.Other or {}

    SMODS.process_loc_text(
        G.localization.descriptions.Other,
        'balatromon_linked',
        {
            name = 'Linked',
            text = {
                'The {C:attention}Right Appmon{} is used',
                'to restore the uses of the',
                '{C:attention}Left Appmon{}',
                'Compatible Appmon {C:attention}combine{} instead'
            }
        }
    )
end

function BM.add_linked_tooltip(info_queue)
    if not info_queue then
        return
    end

    info_queue[#info_queue + 1] = {
        set = 'Other',
        key = 'balatromon_linked'
    }
end

local old_appmon_process_loc_text =
    SMODS.current_mod.process_loc_text

SMODS.current_mod.process_loc_text = function(self)
    if old_appmon_process_loc_text then
        old_appmon_process_loc_text(self)
    end

    install_appmon_tooltips()
end

install_appmon_tooltips()

function BM.can_timemon_undo()
    if not BM.timemon_last_action then
        return false
    end

    if G.STATE ~= G.STATES.SELECTING_HAND then
        return false
    end

    if BM.timemon_last_action == 'play' then
        return G.GAME.current_round.hands_left >= 0
    end

    if BM.timemon_last_action == 'discard' then
        return G.GAME.current_round.discards_left >= 0
    end

    return false
end

function BM.use_timemon(card)
    local action = BM.timemon_last_action

    if action ~= 'play'
    and action ~= 'discard' then
        return false
    end

    BM.initialise_appmon_uses(card)

    BM.timemon_last_action = nil

    card.ability.extra.uses = math.max(
        0,
        (card.ability.extra.uses or BM.APPMON_USE_COUNT) - 1
    )

    if card.ability.extra.uses <= 0 then
        card._bm_appmon_remove_at =
            (G.TIMERS.REAL or 0) + 0.6
    end

    if action == 'play' then
        ease_hands_played(1)

        card_eval_status_text(
            card,
            'extra',
            nil,
            nil,
            nil,
            {
                message = '+1 Hand',
                colour = G.C.BLUE
            }
        )

    elseif action == 'discard' then
        ease_discard(1)

        card_eval_status_text(
            card,
            'extra',
            nil,
            nil,
            nil,
            {
                message = '+1 Discard',
                colour = G.C.RED
            }
        )
    end

    card:juice_up(0.8, 0.5)

    return true
end


local function appmon_valid_last_consumable_key()
    if not G or not G.GAME or not G.P_CENTERS then
        return nil
    end

    local key = G.GAME.balatromon_last_consumable
        or G.GAME.last_tarot_planet

    local center = key and G.P_CENTERS[key]

    if not center
    or center.set == 'Appmon' then
        return nil
    end

    return key
end

function BM.get_perorimon_last_consumable_name()
    local key = appmon_valid_last_consumable_key()
    if not key then
        return 'None'
    end

    local center = G.P_CENTERS[key]

    if type(localize) == 'function'
    and center
    and center.set then
        local ok, name = pcall(localize, {
            type = 'name_text',
            set = center.set,
            key = key
        })

        if ok and type(name) == 'string' and name ~= '' then
            return name
        end
    end

    return center and center.name or key
end

if not BM._perorimon_last_consumable_hook
and Card
and Card.use_consumeable then
    local old_appmon_use_consumeable = Card.use_consumeable

    Card.use_consumeable = function(self, ...)
        local center = self
            and self.config
            and self.config.center

        if G
        and G.GAME
        and center
        and center.key
        and center.set ~= 'Appmon' then
            G.GAME.balatromon_last_consumable = center.key
        end

        return old_appmon_use_consumeable(self, ...)
    end

    BM._perorimon_last_consumable_hook = true
end

function BM.can_use_perorimon(card)
    if not G
    or not G.GAME
    or not G.consumeables
    or not BM.has_room(G.consumeables)
    or (tonumber(G.GAME.dollars) or 0) < 7 then
        return false
    end

    return appmon_valid_last_consumable_key() ~= nil
end

function BM.use_perorimon(card)
    local key = appmon_valid_last_consumable_key()

    if not key
    or not BM.can_use_perorimon(card) then
        return false
    end

    BM.consume_appmon_use(card)

    if type(ease_dollars) == 'function' then
        ease_dollars(-7)
    else
        G.GAME.dollars = math.max(0, (tonumber(G.GAME.dollars) or 0) - 7)
    end

    local center = G.P_CENTERS[key]
    local created = SMODS.add_card {
        set = center and center.set,
        area = G.consumeables,
        key = key,
        key_append = 'balatromon_perorimon_' .. tostring(card and card.sort_id or 0)
    }

    if created and card_eval_status_text then
        card_eval_status_text(
            card,
            'extra',
            nil,
            nil,
            nil,
            {
                message = 'Copied!',
                colour = G.C.SECONDARY_SET
                    and G.C.SECONDARY_SET.Spectral
                    or G.C.PURPLE
            }
        )
    end

    return created ~= nil
end

BM.hackmon_state = BM.hackmon_state or {
    halve_next_score = false
}

function BM.can_use_hackmon(card)
    return G
        and G.STATE == G.STATES.SELECTING_HAND
        and G.GAME
        and G.GAME.current_round
        and (G.GAME.current_round.discards_left or 0) > 0
        and G.GAME.balatromon_hackmon_armed ~= true
        and not BM.hackmon_state.halve_next_score
end

function BM.use_hackmon(card)
    if not card
    or BM.appmon_uses_remaining(card) <= 0
    or not G
    or not G.GAME
    or not G.GAME.current_round
    or (G.GAME.current_round.discards_left or 0) <= 0
    or G.GAME.balatromon_hackmon_armed == true
    or (BM.hackmon_state and BM.hackmon_state.halve_next_score) then
        return false
    end

    BM.consume_appmon_use(card)
    G.GAME.balatromon_hackmon_armed = true

    if card_eval_status_text then
        card_eval_status_text(
            card,
            'extra',
            nil,
            nil,
            nil,
            {
                message = 'Discard Armed!',
                colour = G.C.RED
            }
        )
    end

    return true
end

local old_hackmon_mod_calculate = SMODS.current_mod.calculate

SMODS.current_mod.calculate = function(self, context)
    local ret

    if old_hackmon_mod_calculate then
        ret = old_hackmon_mod_calculate(self, context)
    end

    if context.final_scoring_step
    and G
    and G.GAME
    and G.GAME.balatromon_hackmon_scoring == true then
        G.GAME.balatromon_hackmon_scoring = false
        BM.hackmon_state.halve_next_score = false

        return {
            xmult = 0.5,
            message = 'Hackmon!',
            colour = G.C.RED
        }
    end

    return ret
end

if not BM._hackmon_start_run_hook
and Game
and Game.start_run then
    local old_hackmon_start_run = Game.start_run

    Game.start_run = function(self, args, ...)
        BM.hackmon_state.halve_next_score = false
        BM._hackmon_action_prepared = false
        BM._hackmon_scoring_discard = false

        if G and G.GAME then
            G.GAME.balatromon_hackmon_armed = false
            G.GAME.balatromon_hackmon_scoring = false
        end

        return old_hackmon_start_run(self, args, ...)
    end

    BM._hackmon_start_run_hook = true
end

G.FUNCS.balatromon_can_use_blind_appmon = function(e)
    local card =
        e
        and e.config
        and e.config.ref_table

    local can_use =
        card
        and card.can_use_consumeable
        and card:can_use_consumeable(true)

    if can_use then
        e.config.colour = G.C.RED
        e.config.button = 'use_card'
    else
        e.config.colour =
            G.C.UI.BACKGROUND_INACTIVE

        e.config.button = nil
    end
end


local function appmon_card_name(card)
    if not card then
        return 'Unknown card'
    end

    local rank = card.base and card.base.value or '?'
    local suit = card.base and card.base.suit or '?'
    local center = card.config and card.config.center
    local enhancement = center and center.name

    if center and G.P_CENTERS and center ~= G.P_CENTERS.c_base
    and enhancement and enhancement ~= 'Base' and enhancement ~= 'Default Base' then
        return tostring(rank) .. ' of ' .. tostring(suit) .. ' (' .. tostring(enhancement) .. ')'
    end

    return tostring(rank) .. ' of ' .. tostring(suit)
end

local function open_text_overlay(title, subtitle, rows)
    local contents = {
        {
            n = G.UIT.R,
            config = {align = 'cm', padding = 0.05},
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        text = title,
                        scale = 0.58,
                        colour = G.C.UI.TEXT_LIGHT,
                        shadow = true
                    }
                }
            }
        },
        {
            n = G.UIT.R,
            config = {align = 'cm', padding = 0.03},
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        text = subtitle,
                        scale = 0.3,
                        colour = G.C.UI.TEXT_INACTIVE
                    }
                }
            }
        }
    }

    for _, row in ipairs(rows) do
        contents[#contents + 1] = row
    end

    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu {
        definition = create_UIBox_generic_options {
            back_func = 'exit_overlay_menu',
            contents = contents
        }
    }
end

local AppmonPreviewSprite = Sprite:extend()

local GatchmonCardPreview = Moveable:extend()

function GatchmonCardPreview:init(source)
    local w = G.CARD_W * 0.82
    local h = G.CARD_H * 0.82

    Moveable.init(self, 0, 0, w, h)

    self.source = source
    self.children = {}
    self.states.drag.can = false
    self.states.click.can = false
    self.states.hover.can = false
    self.states.collide.can = false
    self.created_on_pause = true
    self.hover_tilt = 0
    self.tilt_var = {mx = 0, my = 0, dx = 0, dy = 0, amt = 0}
    self.dissolve = 0

    local source_center = source and source.children and source.children.center
    local source_front = source and source.children and source.children.front

    if source_center and source_center.atlas and source_center.sprite_pos then
        self.children.center = AppmonPreviewSprite(
            0,
            0,
            w,
            h,
            source_center.atlas,
            {x = source_center.sprite_pos.x, y = source_center.sprite_pos.y}
        )
    else
        local center = source and source.config and source.config.center or G.P_CENTERS.c_base
        local atlas = G.ASSET_ATLAS[(center and center.atlas) or 'centers'] or G.ASSET_ATLAS.centers
        local pos = center and center.pos or {x = 0, y = 0}
        self.children.center = AppmonPreviewSprite(0, 0, w, h, atlas, pos)
    end

    if source_front and source_front.atlas and source_front.sprite_pos then
        self.children.front = AppmonPreviewSprite(
            0,
            0,
            w,
            h,
            source_front.atlas,
            {x = source_front.sprite_pos.x, y = source_front.sprite_pos.y}
        )
    end

    for _, child in pairs(self.children) do
        child.states.drag.can = false
        child.states.click.can = false
        child.states.hover.can = false
        child.states.collide.can = false
        child.states.visible = true
        child.role.draw_major = self
        child.created_on_pause = true
    end

    self:hard_set_T(0, 0, w, h)
end

function GatchmonCardPreview:hard_set_T(x, y, w, h)
    x = x or self.T.x
    y = y or self.T.y
    w = w or self.T.w
    h = h or self.T.h

    Moveable.hard_set_T(self, x, y, w, h)

    for _, child in pairs(self.children or {}) do
        child:hard_set_T(x, y, w, h)
        child:hard_set_VT()
    end
end

function GatchmonCardPreview:draw()
    if not self.states.visible then
        return
    end

    self:hard_set_T(self.VT.x, self.VT.y, self.VT.w, self.VT.h)

    local center = self.children and self.children.center
    local front = self.children and self.children.front
    local source = self.source
    local edition = source and source.edition

    if center then
        if edition and edition.negative then
            center:draw_shader('negative', nil, nil, true)
        else
            center:draw_shader('dissolve', nil, nil, true)
        end
    end

    if front and not (source and source.ability and source.ability.effect == 'Stone Card') then
        if edition and edition.negative then
            front:draw_shader('negative', nil, nil, true)
        else
            front:draw_shader('dissolve', nil, nil, true)
        end
    end

    if edition then
        local shader = edition.holo and 'holo'
            or edition.foil and 'foil'
            or edition.polychrome and 'polychrome'

        if shader then
            if center then
                center:draw_shader(shader, nil, nil, true)
            end
            if front and not (source and source.ability and source.ability.effect == 'Stone Card') then
                front:draw_shader(shader, nil, nil, true)
            end
        end
    end

    if source and source.seal and G.shared_seals and G.shared_seals[source.seal] and center then
        local seal = G.shared_seals[source.seal]
        seal.role.draw_major = self
        seal:draw_shader('dissolve', nil, nil, true, center)
    end
end

function GatchmonCardPreview:remove()
    for _, child in pairs(self.children or {}) do
        if child and child.remove and not child.REMOVED then
            child:remove()
        end
    end
    self.children = {}
    Moveable.remove(self)
end

local function gatchmon_preview_column(label, source)
    local preview = GatchmonCardPreview(source)

    return {
        n = G.UIT.C,
        config = {align = 'cm', padding = 0.10, minw = 1.8},
        nodes = {
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.03},
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = label,
                            scale = 0.3,
                            colour = G.C.UI.TEXT_INACTIVE
                        }
                    }
                }
            },
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.04},
                nodes = {
                    {
                        n = G.UIT.O,
                        config = {
                            object = preview,
                            can_collide = false
                        }
                    }
                }
            },
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.02},
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = appmon_card_name(source),
                            scale = 0.26,
                            colour = G.C.UI.TEXT_LIGHT
                        }
                    }
                }
            }
        }
    }
end

function BM.open_gatchmon_peek()
    local deck = G.deck and G.deck.cards or {}
    local first = deck[#deck]
    local second = deck[#deck - 1]
    local columns = {}

    if first then
        columns[#columns + 1] = gatchmon_preview_column('Next draw', first)
    end

    if second then
        columns[#columns + 1] = gatchmon_preview_column('Then', second)
    end

    local rows

    if #columns > 0 then
        rows = {
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.05},
                nodes = columns
            }
        }
    else
        rows = {
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.05},
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = 'Your deck is empty.',
                            scale = 0.36,
                            colour = G.C.UI.TEXT_INACTIVE
                        }
                    }
                }
            }
        }
    end

    open_text_overlay('Gatchmon', 'Top 2 cards of your deck', rows)
end

local NAVIMON_RANKS = {
    'Any', '2', '3', '4', '5', '6', '7', '8', '9', '10',
    'Jack', 'Queen', 'King', 'Ace'
}

local NAVIMON_SUITS = {
    'Any', 'Spades', 'Hearts', 'Clubs', 'Diamonds'
}

BM.navimon_scan_state = BM.navimon_scan_state or {
    rank = 'Any',
    suit = 'Any',
    result = 'Choose a rank and/or suit, then scan.',
    scanned = false
}

G.FUNCS.balatromon_navimon_rank = function(args)
    if args and args.to_val then
        BM.navimon_scan_state.rank = args.to_val
        if not BM.navimon_scan_state.scanned then
            BM.navimon_scan_state.result = 'Choose a rank and/or suit, then scan.'
        end
    end
end

G.FUNCS.balatromon_navimon_suit = function(args)
    if args and args.to_val then
        BM.navimon_scan_state.suit = args.to_val
        if not BM.navimon_scan_state.scanned then
            BM.navimon_scan_state.result = 'Choose a rank and/or suit, then scan.'
        end
    end
end

local function navimon_matches(card, rank, suit)
    if not card or not card.base then
        return false
    end

    local rank_ok = rank == 'Any' or tostring(card.base.value) == tostring(rank)
    local suit_ok = suit == 'Any' or tostring(card.base.suit) == tostring(suit)
    return rank_ok and suit_ok
end

local function navimon_query_name(rank, suit)
    if rank ~= 'Any' and suit ~= 'Any' then
        return tostring(rank) .. ' of ' .. tostring(suit)
    elseif rank ~= 'Any' then
        return 'rank ' .. tostring(rank)
    elseif suit ~= 'Any' then
        return tostring(suit)
    end

    return 'a matching card'
end

G.FUNCS.balatromon_navimon_scan = function(e)
    local state = BM.navimon_scan_state
    if state.scanned then
        return
    end

    if state.rank == 'Any' and state.suit == 'Any' then
        state.result = 'Choose at least one rank or suit.'
        return
    end

    local deck = G.deck and G.deck.cards or {}
    local found_distance
    local found_card

    for distance = 1, #deck do
        local card = deck[#deck - distance + 1]
        if navimon_matches(card, state.rank, state.suit) then
            found_distance = distance
            found_card = card
            break
        end
    end

    local query = navimon_query_name(state.rank, state.suit)
    if found_distance then
        if found_distance == 1 then
            state.result = 'Next draw matches ' .. query .. ': ' .. appmon_card_name(found_card)
        else
            state.result = tostring(found_distance) .. ' draws until ' .. query
                .. ' (' .. tostring(found_distance - 1) .. ' cards before it)'
        end
    else
        state.result = 'No ' .. query .. ' remains in your deck.'
    end

    state.scanned = true
end

function BM.open_navimon_scan()
    BM.navimon_scan_state.rank = 'Any'
    BM.navimon_scan_state.suit = 'Any'
    BM.navimon_scan_state.result = 'Choose a rank and/or suit, then scan.'
    BM.navimon_scan_state.scanned = false

    local rows = {
        {
            n = G.UIT.R,
            config = {align = 'cm', padding = 0.04},
            nodes = {
                {
                    n = G.UIT.C,
                    config = {align = 'cm'},
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {align = 'cm', padding = 0.015},
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = 'Rank',
                                        scale = 0.32,
                                        colour = G.C.UI.TEXT_INACTIVE,
                                        shadow = true
                                    }
                                }
                            }
                        },
                        {
                            n = G.UIT.R,
                            config = {align = 'cm'},
                            nodes = {
                                create_option_cycle {
                                    label = '',
                                    options = NAVIMON_RANKS,
                                    current_option = 1,
                                    opt_callback = 'balatromon_navimon_rank',
                                    w = 3.4,
                                    scale = 0.72,
                                    no_pips = true
                                }
                            }
                        }
                    }
                }
            }
        },
        {
            n = G.UIT.R,
            config = {align = 'cm', padding = 0.04},
            nodes = {
                {
                    n = G.UIT.C,
                    config = {align = 'cm'},
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {align = 'cm', padding = 0.015},
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = 'Suit',
                                        scale = 0.32,
                                        colour = G.C.UI.TEXT_INACTIVE,
                                        shadow = true
                                    }
                                }
                            }
                        },
                        {
                            n = G.UIT.R,
                            config = {align = 'cm'},
                            nodes = {
                                create_option_cycle {
                                    label = '',
                                    options = NAVIMON_SUITS,
                                    current_option = 1,
                                    opt_callback = 'balatromon_navimon_suit',
                                    w = 3.4,
                                    scale = 0.72,
                                    no_pips = true
                                }
                            }
                        }
                    }
                }
            }
        },
        {
            n = G.UIT.R,
            config = {align = 'cm', padding = 0.08},
            nodes = {
                UIBox_button {
                    label = {'Scan'},
                    button = 'balatromon_navimon_scan',
                    minw = 2.6,
                    minh = 0.65,
                    scale = 0.4,
                    colour = G.C.BLUE
                }
            }
        },
        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.06,
                minw = 6.2,
                minh = 0.7,
                r = 0.08,
                colour = G.C.UI.TRANSPARENT_DARK
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        ref_table = BM.navimon_scan_state,
                        ref_value = 'result',
                        scale = 0.3,
                        colour = G.C.UI.TEXT_LIGHT,
                        shadow = true
                    }
                }
            }
        }
    }

    open_text_overlay(
        'Navimon',
        'Find the next card matching a rank, suit, or both',
        rows
    )
end

BM.onmon_state = BM.onmon_state or {
    armed = false,
    active = false
}

function BM.arm_onmon()
    BM.onmon_state = {
        armed = true,
        active = false
    }

    card_eval_status_text(
        G.GAME.blind,
        'extra',
        nil,
        nil,
        nil,
        {
            message = 'Next action protected!'
        }
    )
end

function BM.begin_onmon_action(action)
    local state = BM.onmon_state

    if not state
    or not state.armed
    or not G.GAME
    or not G.GAME.blind
    or not G.GAME.blind.boss then
        return
    end

    local blind = G.GAME.blind

    state.armed = false
    state.active = true
    state.action = action

    state.blind = blind
    state.definition = blind.config.blind

    state.chips = blind.chips
    state.dollars = blind.dollars
    state.sound_pings = blind.sound_pings

    state.hands = copy_table(blind.hands)
    state.only_hand = blind.only_hand
    state.prepped = blind.prepped
    state.triggered = blind.triggered

    state.start_hands =
        G.GAME.current_round.hands_played or 0

    state.start_discards =
        G.GAME.current_round.discards_used or 0

    blind:disable()
end

function BM.restore_onmon_blind()
    local state = BM.onmon_state

    if not state
    or not state.active then
        return
    end

    local blind = state.blind

    if not blind
    or blind ~= G.GAME.blind then
        BM.onmon_state = {
            armed = false,
            active = false
        }

        return
    end

    blind:set_blind(
        state.definition,
        false,
        true
    )

    blind.chips = state.chips
    blind.chip_text = number_format(state.chips)

    blind.dollars = state.dollars
    blind.sound_pings = state.sound_pings

    blind.hands = state.hands
    blind.only_hand = state.only_hand
    blind.prepped = state.prepped
    blind.triggered = state.triggered

    blind:set_text()

    for _, playing_card in ipairs(G.playing_cards or {}) do
        blind:debuff_card(playing_card)
    end

    for _, joker in ipairs(G.jokers and G.jokers.cards or {}) do
        blind:debuff_card(joker)
    end

    BM.onmon_state = {
        armed = false,
        active = false
    }
end

function BM.update_onmon_state()
    local state = BM.onmon_state

    if not state
    or not state.active then
        return
    end

    if G.GAME.blind ~= state.blind then
        BM.onmon_state = {
            armed = false,
            active = false
        }

        return
    end

    local round = G.GAME.current_round

    local action_finished = false

    if state.action == 'play' then
        action_finished =
            (round.hands_played or 0)
            > state.start_hands
    elseif state.action == 'discard' then
        action_finished =
            (round.discards_used or 0)
            > state.start_discards
    end

    if action_finished then
        state.restore_at =
            state.restore_at
            or ((G.TIMERS.REAL or 0) + 0.25)
    end

    if state.restore_at
    and (G.TIMERS.REAL or 0) >= state.restore_at
    and G.STATE == G.STATES.SELECTING_HAND then
        BM.restore_onmon_blind()
    end
end

function BM.capture_timemon_snapshot(action)
    if action ~= 'play' and action ~= 'discard' then
        return
    end

    BM.timemon_last_action = action
end

local old_appmon_play_cards =
    G.FUNCS.play_cards_from_highlighted



G.FUNCS.play_cards_from_highlighted =
function(e, ...)
    local action = BM._hackmon_scoring_discard
        and 'discard'
        or 'play'

    if not BM._hackmon_action_prepared then
        if BM.capture_timemon_snapshot then
            BM.capture_timemon_snapshot(action)
        end

        if BM.begin_onmon_action then
            BM.begin_onmon_action(action)
        end
    end

    return old_appmon_play_cards(e, ...)
end


local old_appmon_discard_cards =
    G.FUNCS.discard_cards_from_highlighted

G.FUNCS.discard_cards_from_highlighted =
function(e, hook, ...)
    if not hook
    and BM.hackmon_state
    and G
    and G.GAME
    and G.GAME.balatromon_hackmon_armed == true then
        local round = G
            and G.GAME
            and G.GAME.current_round

        if not round
        or (round.discards_left or 0) <= 0 then
            return old_appmon_discard_cards(e, hook, ...)
        end

        G.GAME.balatromon_hackmon_armed = false
        G.GAME.balatromon_hackmon_scoring = true
        BM.hackmon_state.halve_next_score = true
        BM._hackmon_scoring_discard = true
        BM._hackmon_action_prepared = true

        if BM.capture_timemon_snapshot then
            BM.capture_timemon_snapshot('discard')
        end

        if BM.begin_onmon_action then
            BM.begin_onmon_action('discard')
        end

        round.discards_used = (round.discards_used or 0) + 1

        if type(ease_discard) == 'function' then
            ease_discard(-1)
        else
            round.discards_left = math.max(0, (round.discards_left or 0) - 1)
        end

        local normal_ease_hands_played = ease_hands_played

        if type(normal_ease_hands_played) == 'function' then
            ease_hands_played = function(mod, ...)
                if BM._hackmon_scoring_discard
                and tonumber(mod)
                and tonumber(mod) < 0 then
                    return
                end

                return normal_ease_hands_played(mod, ...)
            end
        end

        local ok, result = pcall(
            G.FUNCS.play_cards_from_highlighted,
            e,
            ...
        )

        if type(normal_ease_hands_played) == 'function' then
            ease_hands_played = normal_ease_hands_played
        end

        BM._hackmon_action_prepared = false
        BM._hackmon_scoring_discard = false

        if not ok then
            G.GAME.balatromon_hackmon_scoring = false
            BM.hackmon_state.halve_next_score = false
            error(result)
        end

        return result
    end

    if not hook then
        if BM.capture_timemon_snapshot then
            BM.capture_timemon_snapshot('discard')
        end

        if BM.begin_onmon_action then
            BM.begin_onmon_action('discard')
        end
    end

    return old_appmon_discard_cards(
        e,
        hook,
        ...
    )
end


local function appmon_boss_select_ready()
    return G
        and G.GAME
        and G.GAME.round_resets
        and G.GAME.round_resets.blind_choices
        and G.GAME.round_resets.blind_choices.Boss
        and G.blind_select_opts
        and G.blind_select_opts.boss
end

function BM.can_use_boss_select_appmon()
    return G.STATE == G.STATES.BLIND_SELECT
        and appmon_boss_select_ready()
end

function BM.appmon_valid_boss_pool(exclude_current)
    local pool = {}

    if not G
    or not G.GAME
    or not G.P_BLINDS then
        return pool
    end

    local ante = G.GAME.round_resets.ante or 1
    local win_ante = G.GAME.win_ante or 8

    local showdown =
        ante >= 2
        and ante % win_ante == 0

    local current =
        G.GAME.round_resets.blind_choices
        and G.GAME.round_resets.blind_choices.Boss

    for key, blind in pairs(G.P_BLINDS) do
        if blind
        and blind.boss
        and not (G.GAME.banned_keys and G.GAME.banned_keys[key]) then

            local boss = blind.boss

            local correct_type =
                (showdown and boss.showdown)
                or (not showdown and not boss.showdown)

            local above_min =
                not boss.min
                or ante >= boss.min

            local below_max =
                not boss.max
                or ante <= boss.max

            if correct_type
            and above_min
            and below_max
            and (not exclude_current or key ~= current) then
                pool[#pool + 1] = {
                    key = key,
                    blind = blind
                }
            end
        end
    end

    table.sort(pool, function(a, b)
        return tostring(a.blind.name or a.key)
            < tostring(b.blind.name or b.key)
    end)

    return pool
end

function BM.set_boss_blind_choice(blind_key)
    if not blind_key
    or not G.P_BLINDS[blind_key]
    or not appmon_boss_select_ready() then
        return false
    end

    local old_box = G.blind_select_opts.boss
    local parent = old_box.parent

    if not parent then
        return false
    end

    G.GAME.round_resets.blind_choices.Boss = blind_key

    old_box:remove()

    G.blind_select_opts.boss = UIBox {
        T = {
            parent.T.x,
            0,
            0,
            0
        },

        definition = {
            n = G.UIT.ROOT,
            config = {
                align = 'cm',
                colour = G.C.CLEAR
            },
            nodes = {
                UIBox_dyn_container(
                    {
                        create_UIBox_blind_choice('Boss')
                    },
                    false,
                    get_blind_main_colour('Boss'),
                    mix_colours(
                        G.C.BLACK,
                        get_blind_main_colour('Boss'),
                        0.8
                    )
                )
            }
        },

        config = {
            align = 'bmi',
            offset = {
                x = 0,
                y = G.ROOM.T.y + 9
            },
            major = parent,
            xy_bond = 'Weak'
        }
    }

    parent.config.object =
        G.blind_select_opts.boss

    parent.config.object:recalculate()

    G.blind_select_opts.boss.parent =
        parent

    G.blind_select_opts.boss.alignment.offset.y =
        0

    play_sound('other1', 0.8, 0.7)

    return true
end

function BM.reroll_boss_with_logimon()
    if not appmon_boss_select_ready() then
        return false
    end

    local old_key =
        G.GAME.round_resets.blind_choices.Boss

    local new_key

    if get_new_boss then
        for i = 1, 12 do
            local candidate = get_new_boss()

            if candidate
            and candidate ~= old_key then
                new_key = candidate
                break
            end
        end
    end

    if not new_key then
        local pool =
            BM.appmon_valid_boss_pool(true)

        if #pool > 0 then
            local chosen =
                BM.random_element(
                    pool,
                    'logimon_'
                        .. tostring(G.GAME.round_resets.ante)
                        .. '_'
                        .. tostring(G.TIMERS.REAL or 0)
                )

            new_key =
                chosen
                and chosen.key
        end
    end

    if not new_key then
        return false
    end

    G.GAME.balatromon_bootmon_bonus = nil

    return BM.set_boss_blind_choice(new_key)
end

local function craftmon_boss_pool()
    local pool = {}

    for key, blind in pairs(G.P_BLINDS or {}) do
        if blind
        and blind.boss then
            pool[#pool + 1] = {
                key = key,
                blind = blind
            }
        end
    end

    table.sort(pool, function(a, b)
        return a.key < b.key
    end)

    return pool
end

function BM.apply_craftmon_blind()
    if not G.GAME
    or not G.GAME.blind then
        return nil
    end

    local current = G.GAME.blind
    local old_reward = current.dollars or 0

    local pool = craftmon_boss_pool()

    if #pool == 0 then
        return nil
    end

    local chosen =
        BM.random_element(
            pool,
            'craftmon_'
                .. tostring(G.GAME.round_resets.ante)
                .. '_'
                .. tostring(G.GAME.current_round.hands_played or 0)
        )

    if not chosen then
        return nil
    end

    current:set_blind(
        chosen.blind,
        false,
        true
    )

    current.dollars = old_reward * 2
    current.sound_pings = current.dollars + 2

    current:set_text()

    return chosen.blind
end

local DOGATCHMON_RANKS = {
    '2', '3', '4', '5', '6', '7', '8', '9', '10',
    'Jack', 'Queen', 'King', 'Ace'
}

BM.dogatchmon_state = BM.dogatchmon_state or {
    rank = '2',
    result = 'Choose a rank.',
    card = nil,
    submitted = false
}

G.FUNCS.balatromon_dogatchmon_rank = function(args)
    if args and args.to_val then
        BM.dogatchmon_state.rank = args.to_val
        BM.dogatchmon_state.result = 'Choose a rank.'
    end
end

G.FUNCS.balatromon_dogatchmon_draw = function(e)
    local state = BM.dogatchmon_state

    if state.submitted
    or not state.card
    or state.card.REMOVED
    or BM.appmon_uses_remaining(state.card) <= 0
    or not G.deck then
        return
    end

    local targets = {}

    for i = #G.deck.cards, 1, -1 do
        local target = G.deck.cards[i]

        if target
        and target.base
        and tostring(target.base.value) == tostring(state.rank) then
            targets[#targets + 1] = target

            if #targets >= 2 then
                break
            end
        end
    end

    if #targets == 0 then
        state.result = 'No ' .. tostring(state.rank) .. ' remains in your deck.'
        return
    end

    state.submitted = true

    BM.consume_appmon_use(state.card)

    G.FUNCS.exit_overlay_menu()

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,

        func = function()
            for i, target in ipairs(targets) do
                draw_card(
                    G.deck,
                    G.hand,
                    i * 100 / #targets,
                    'up',
                    true,
                    target,
                    0.08
                )
            end

            return true
        end
    }))
end

function BM.open_dogatchmon_draw(card)
    BM.dogatchmon_state.rank = '2'
    BM.dogatchmon_state.result = 'Choose a rank.'
    BM.dogatchmon_state.card = card
    BM.dogatchmon_state.submitted = false

    local rows = {
        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.04
            },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        align = 'cm'
                    },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {
                                align = 'cm',
                                padding = 0.015
                            },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = 'Rank',
                                        scale = 0.32,
                                        colour = G.C.UI.TEXT_INACTIVE,
                                        shadow = true
                                    }
                                }
                            }
                        },
                        {
                            n = G.UIT.R,
                            config = {
                                align = 'cm'
                            },
                            nodes = {
                                create_option_cycle {
                                    label = '',
                                    options = DOGATCHMON_RANKS,
                                    current_option = 1,
                                    opt_callback = 'balatromon_dogatchmon_rank',
                                    w = 3.4,
                                    scale = 0.72,
                                    no_pips = true
                                }
                            }
                        }
                    }
                }
            }
        },

        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.08
            },
            nodes = {
                UIBox_button {
                    label = {'Draw'},
                    button = 'balatromon_dogatchmon_draw',
                    minw = 2.6,
                    minh = 0.65,
                    scale = 0.4,
                    colour = G.C.BLUE
                }
            }
        },

        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.06,
                minw = 6.2,
                minh = 0.7,
                r = 0.08,
                colour = G.C.UI.TRANSPARENT_DARK
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        ref_table = BM.dogatchmon_state,
                        ref_value = 'result',
                        scale = 0.3,
                        colour = G.C.UI.TEXT_LIGHT,
                        shadow = true
                    }
                }
            }
        }
    }

    open_text_overlay(
        'Dogatchmon',
        'Draw 2 cards of a selected rank',
        rows
    )
end

BM.globemon_state = BM.globemon_state or {
    rank = '2',
    result = 'Choose a rank.',
    card = nil,
    submitted = false
}

G.FUNCS.balatromon_globemon_rank = function(args)
    if args and args.to_val then
        BM.globemon_state.rank = args.to_val
        BM.globemon_state.result =
            'Choose a rank.'
    end
end

G.FUNCS.balatromon_globemon_draw = function(e)
    local state = BM.globemon_state

    if state.submitted
    or not state.card
    or state.card.REMOVED
    or BM.appmon_uses_remaining(state.card) <= 0
    or not G.deck then
        return
    end

    local targets = {}

    for i = #G.deck.cards, 1, -1 do
        local target = G.deck.cards[i]

        if target
        and target.base
        and tostring(target.base.value)
            == tostring(state.rank) then

            targets[#targets + 1] =
                target

            if #targets >= 4 then
                break
            end
        end
    end

    if #targets == 0 then
        state.result =
            'No '
            .. tostring(state.rank)
            .. ' remains in your deck.'

        return
    end

    state.submitted = true

    BM.consume_appmon_use(state.card)

    G.FUNCS.exit_overlay_menu()

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,

        func = function()
            local round =
                G.GAME.current_round

            local max_hands =
                G.GAME.round_resets.hands or 0

            local max_discards =
                G.GAME.round_resets.discards or 0

            local hands_to_restore =
                math.max(
                    0,
                    max_hands
                    - (round.hands_left or 0)
                )

            local discards_to_restore =
                math.max(
                    0,
                    max_discards
                    - (round.discards_left or 0)
                )

            if hands_to_restore > 0 then
                ease_hands_played(
                    hands_to_restore
                )
            end

            if discards_to_restore > 0 then
                ease_discard(
                    discards_to_restore
                )
            end

            for i, target in ipairs(targets) do
                draw_card(
                    G.deck,
                    G.hand,
                    i * 100 / #targets,
                    'up',
                    true,
                    target,
                    0.08
                )
            end

            return true
        end
    }))
end

function BM.open_globemon_draw(card)
    BM.globemon_state.rank = '2'
    BM.globemon_state.result =
        'Choose a rank.'
    BM.globemon_state.card = card
    BM.globemon_state.submitted = false

    local rows = {
        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.04
            },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        align = 'cm'
                    },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {
                                align = 'cm',
                                padding = 0.015
                            },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = 'Rank',
                                        scale = 0.32,
                                        colour = G.C.UI.TEXT_INACTIVE,
                                        shadow = true
                                    }
                                }
                            }
                        },

                        {
                            n = G.UIT.R,
                            config = {
                                align = 'cm'
                            },
                            nodes = {
                                create_option_cycle {
                                    label = '',
                                    options = DOGATCHMON_RANKS,
                                    current_option = 1,
                                    opt_callback = 'balatromon_globemon_rank',
                                    w = 3.4,
                                    scale = 0.72,
                                    no_pips = true
                                }
                            }
                        }
                    }
                }
            }
        },

        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.08
            },
            nodes = {
                UIBox_button {
                    label = {'Draw'},
                    button = 'balatromon_globemon_draw',
                    minw = 2.6,
                    minh = 0.65,
                    scale = 0.4,
                    colour = G.C.BLUE
                }
            }
        },

        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.06,
                minw = 6.2,
                minh = 0.7,
                r = 0.08,
                colour = G.C.UI.TRANSPARENT_DARK
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        ref_table = BM.globemon_state,
                        ref_value = 'result',
                        scale = 0.3,
                        colour = G.C.UI.TEXT_LIGHT,
                        shadow = true
                    }
                }
            }
        }
    }

    open_text_overlay(
        'Globemon',
        'Draw 4 cards of a selected rank',
        rows
    )
end

BM.bootmon_state = BM.bootmon_state or {
    selected = nil,
    key_by_name = {},
    card = nil,
    submitted = false
}

G.FUNCS.balatromon_bootmon_boss = function(args)
    if args and args.to_val then
        BM.bootmon_state.selected =
            args.to_val
    end
end

G.FUNCS.balatromon_bootmon_confirm = function(e)
    local state = BM.bootmon_state

    if state.submitted
    or not state.card
    or state.card.REMOVED
    or BM.appmon_uses_remaining(state.card) <= 0 then
        return
    end

    local key =
        state.key_by_name[state.selected]

    if not key
    or not G.P_BLINDS[key] then
        return
    end

    state.submitted = true

    BM.consume_appmon_use(state.card)

    G.GAME.balatromon_bootmon_bonus = {
        key = key,
        ante = G.GAME.round_resets.ante,
        mult = 2
    }

    G.FUNCS.exit_overlay_menu()

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.05,

        func = function()
            BM.set_boss_blind_choice(key)
            return true
        end
    }))
end

function BM.open_bootmon_selector(card)
    local pool =
        BM.appmon_valid_boss_pool(false)

    local current =
        G.GAME.round_resets.blind_choices.Boss

    local options = {}
    local key_by_name = {}

    for _, entry in ipairs(pool) do
        if entry.key ~= current then
            local name =
                entry.blind.name
                or entry.key

            local display = name

            if key_by_name[display] then
                display =
                    name
                    .. ' ['
                    .. entry.key
                    .. ']'
            end

            options[#options + 1] =
                display

            key_by_name[display] =
                entry.key
        end
    end

    if #options == 0 then
        return
    end

    BM.bootmon_state.selected =
        options[1]

    BM.bootmon_state.key_by_name =
        key_by_name

    BM.bootmon_state.card = card
    BM.bootmon_state.submitted = false

    local rows = {
        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.06
            },
            nodes = {
                create_option_cycle {
                    label = 'Boss Blind',
                    options = options,
                    current_option = 1,
                    opt_callback =
                        'balatromon_bootmon_boss',
                    w = 4.6,
                    scale = 0.65,
                    no_pips = true
                }
            }
        },

        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.08
            },
            nodes = {
                UIBox_button {
                    label = {'Choose'},
                    button =
                        'balatromon_bootmon_confirm',
                    minw = 2.8,
                    minh = 0.65,
                    scale = 0.4,
                    colour = G.C.BLUE
                }
            }
        }
    }

    local title = card
        and card.config
        and card.config.center
        and card.config.center.name
        or 'Bootmon'

    open_text_overlay(
        title,
        'Choose the upcoming Boss Blind',
        rows
    )
end

if not BM._bootmon_blind_reward_hook then
    local old_appmon_set_blind =
        Blind.set_blind

    function Blind:set_blind(blind, ...)
        local result =
            old_appmon_set_blind(
                self,
                blind,
                ...
            )

        local bonus =
            G.GAME
            and G.GAME.balatromon_bootmon_bonus

        if bonus
        and blind
        and blind.key == bonus.key
        and G.GAME.round_resets.ante
            == bonus.ante then

            self.dollars =
                (tonumber(self.dollars) or 0)
                * (bonus.mult or 2)

            self.sound_pings =
                self.dollars + 2

            G.GAME.current_round.dollars_to_be_earned =
                self.dollars > 0
                and string.rep(
                    localize('$'),
                    self.dollars
                )
                or ''

            self:set_text()

            G.GAME.balatromon_bootmon_bonus =
                nil
        end

        return result
    end

    BM._bootmon_blind_reward_hook = true
end



function BM.can_use_scoring_appmon()
    return G
        and G.STATE == G.STATES.SELECTING_HAND
        and G.GAME
        and G.GAME.blind
        and G.GAME.blind.name ~= ''
        and G.GAME.blind.chips
end

local function appmon_finish_blind_if_won()
    if not G
    or not G.GAME
    or not G.GAME.blind
    or not G.GAME.blind.chips then
        return
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.65,
        blockable = false,
        func = function()
            if G.GAME
            and G.GAME.blind
            and G.GAME.blind.chips
            and G.GAME.chips >= G.GAME.blind.chips
            and G.STATE ~= G.STATES.NEW_ROUND then
                G.STATE = G.STATES.NEW_ROUND
                G.STATE_COMPLETE = false
                end_round()
            end
            return true
        end
    }))
end

function BM.appmon_gain_blind_score(card, numerator, denominator)
    if not G
    or not G.GAME
    or not G.GAME.blind
    or not G.GAME.blind.chips then
        return 0
    end

    numerator = tonumber(numerator) or 0
    denominator = tonumber(denominator) or 1

    if denominator == 0 then
        return 0
    end

    local gain = math.max(
        0,
        math.floor((tonumber(G.GAME.blind.chips) or 0) * numerator / denominator)
    )

    if gain <= 0 then
        return 0
    end

    if type(ease_chips) == 'function' then
        ease_chips(gain)
    else
        G.GAME.chips = (tonumber(G.GAME.chips) or 0) + gain
    end

    if card and card_eval_status_text then
        card_eval_status_text(
            card,
            'extra',
            nil,
            nil,
            nil,
            {
                message = '+' .. number_format(gain) .. ' Chips',
                colour = G.C.CHIPS
            }
        )
    end

    appmon_finish_blind_if_won()

    return gain
end

function BM.can_use_offmon()
    return BM.can_use_scoring_appmon()
        and G.GAME.current_round
        and (G.GAME.current_round.discards_left or 0) > 0
end

function BM.use_offmon(card)
    BM.consume_appmon_use(card)
    ease_discard(-1)
    BM.appmon_gain_blind_score(card, 2, 15)
    return true
end

local function appmon_left_digimon(card)
    if not card
    or not G
    or not G.jokers
    or not G.jokers.cards then
        return nil
    end

    local card_x = card.T and card.T.x
    local nearest = nil
    local nearest_x = nil

    if card_x then
        for _, candidate in ipairs(G.jokers.cards) do
            local candidate_x = candidate
                and candidate.T
                and candidate.T.x

            if candidate ~= card
            and BM.is_digimon(candidate)
            and candidate_x
            and candidate_x < card_x
            and (not nearest_x or candidate_x > nearest_x) then
                nearest = candidate
                nearest_x = candidate_x
            end
        end

        if nearest then
            return nearest
        end
    end

    for i, candidate in ipairs(G.jokers.cards) do
        if candidate == card then
            for j = i - 1, 1, -1 do
                local target = G.jokers.cards[j]
                if target and BM.is_digimon(target) then
                    return target
                end
            end
            break
        end
    end

    return nil
end

function BM.appmon_increase_digimon_hunger(card, amount)
    if not card
    or card.REMOVED
    or not BM.is_digimon(card)
    or not card.ability
    or not card.ability.extra then
        return false
    end

    local extra = card.ability.extra

    if extra.permanently_disabled then
        return false
    end

    local hunger_max = BM.get_hunger_max
        and BM.get_hunger_max()
        or 5

    local old_hunger = tonumber(extra.hunger) or 1
    local new_hunger = math.min(
        hunger_max,
        old_hunger + math.max(0, tonumber(amount) or 1)
    )

    if new_hunger <= old_hunger then
        return false
    end

    extra.hunger = new_hunger

    if BM.care_animation then
        BM.care_animation(
            card,
            '+Hunger',
            G.C.RED
        )
    end

    if new_hunger >= hunger_max then
        local slug = BM.get_card_slug
            and BM.get_card_slug(card)

        if slug
        and BM.is_leomon_slug
        and BM.is_leomon_slug(slug)
        and BM.kill_starved_leomon then
            BM.kill_starved_leomon(card)
            return true
        end

        extra.permanently_disabled = true

        if slug
        and BM.has_passive_deck_effect
        and BM.has_passive_deck_effect(slug)
        and BM.on_remove then
            BM.on_remove(card, slug)
        end

        if SMODS.debuff_card then
            SMODS.debuff_card(
                card,
                true,
                'balatromon_hunger'
            )
        end
    end

    return true
end

function BM.can_use_virusmon(card)
    if not G then
        return false
    end

    local target = appmon_left_digimon(card)

    if not target then
        return false
    end

    local extra = target.ability
        and target.ability.extra

    if not extra
    or extra.permanently_disabled then
        return false
    end

    local hunger_max = BM.get_hunger_max
        and BM.get_hunger_max()
        or 5

    return (tonumber(extra.hunger) or 1) < hunger_max
end

function BM.use_virusmon(card)
    local target = appmon_left_digimon(card)

    if not target then
        return false
    end

    if not BM.appmon_increase_digimon_hunger(target, 1) then
        return false
    end

    BM.consume_appmon_use(card)

    if card_eval_status_text then
        card_eval_status_text(
            card,
            'extra',
            nil,
            nil,
            nil,
            {
                message = 'Hunger +1',
                colour = G.C.RED
            }
        )
    end

    return true
end

function BM.use_rebootmon(card)
    local extra = card
        and card.ability
        and card.ability.extra
    local mode = extra and extra.rebootmon_mode

    if extra then
        extra.rebootmon_mode = nil
    end

    if mode == 'boss_select' then
        BM.open_bootmon_selector(card)
        return true
    end

    if mode ~= 'blind'
    or not G.GAME
    or not G.GAME.blind
    or G.GAME.blind.name == '' then
        return false
    end

    BM.consume_appmon_use(card)
    BM.appmon_gain_blind_score(card, 1, 4)

    if G.GAME.blind.boss
    and not G.GAME.blind.disabled
    and G.GAME.blind.disable then
        G.GAME.blind:disable()

        if card_eval_status_text then
            card_eval_status_text(
                card,
                'extra',
                nil,
                nil,
                nil,
                {
                    message = 'Boss Disabled!',
                    colour = G.C.RED
                }
            )
        end
    end

    return true
end

function BM.appmon_gain_full_blind_requirement(card)
    if not G
    or not G.GAME
    or not G.GAME.blind
    or not G.GAME.blind.chips then
        return false
    end

    local gain = math.max(0, tonumber(G.GAME.blind.chips) or 0)

    if gain <= 0 then
        return false
    end

    if type(ease_chips) == 'function' then
        ease_chips(gain)
    else
        G.GAME.chips = (tonumber(G.GAME.chips) or 0) + gain
    end

    if card and card_eval_status_text then
        card_eval_status_text(
            card,
            'extra',
            nil,
            nil,
            nil,
            {
                message = '+' .. number_format(gain) .. ' Chips',
                colour = G.C.CHIPS
            }
        )
    end

    return true
end

function BM.use_rebootmon_virus(card)
    if not G
    or not G.GAME
    or not G.GAME.blind
    or G.GAME.blind.name == '' then
        return false
    end

    BM.consume_appmon_use(card)

    local targets = {}
    for _, candidate in ipairs(
        G.jokers
        and G.jokers.cards
        or {}
    ) do
        if BM.is_digimon(candidate) then
            targets[#targets + 1] = candidate
        end
    end

    for _, target in ipairs(targets) do
        BM.appmon_increase_digimon_hunger(target, 1)
    end

    return BM.appmon_gain_full_blind_requirement(card)
end
