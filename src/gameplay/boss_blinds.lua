local BM = Balatromon

SMODS.Atlas {
    key = 'BossBlinds',
    path = 'DigiMeel_BossBlinds.png',
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
    fps = 10
}

local function split_targets(value)
    local out = {}

    if type(value) == 'table' then
        for _, target in ipairs(value) do
            local slug = BM.slug(target)

            if slug
            and slug ~= ''
            and slug ~= '-' then
                out[#out + 1] = slug
            end
        end

        return out
    end

    for part in tostring(value or ''):gmatch('[^,]+') do
        local target =
            part:match('^%s*(.-)%s*$')

        local slug =
            BM.slug(target)

        if slug
        and slug ~= ''
        and slug ~= '-' then
            out[#out + 1] = slug
        end
    end

    return out
end

local lineage_cache = {}

local function get_lineage(root)
    root = BM.slug(root)

    if lineage_cache[root] then
        return lineage_cache[root]
    end

    local found = {}
    local visiting = {}

    local function walk(slug)
        slug = BM.slug(slug)

        if visiting[slug] then
            return
        end

        visiting[slug] = true
        found[slug] = true

        local def =
            BM.joker_defs
            and BM.joker_defs[slug]

        if def then
            for _, target in ipairs(
                split_targets(
                    def.evolves_to
                )
            ) do
                walk(target)
            end
        end

        local x_targets =
            BM.x_antibody_extra_evolutions
            and BM.x_antibody_extra_evolutions[slug]

        for _, target in ipairs(
            x_targets or {}
        ) do
            walk(target)
        end
    end

    walk(root)

    lineage_cache[root] = found

    return found
end

local function digimon_in_line(card, root)
    if not BM.is_digimon(card) then
        return false
    end

    local slug =
        BM.get_card_slug(card)

    if not slug then
        return false
    end

    return
        get_lineage(root)[slug]
        == true
end

local function get_context(a, b)
    return b or a
end

local function is_tamer(card)
    if not card then
        return false
    end

    if BM.is_tamer
    and BM.is_tamer(card) then
        return true
    end

    local center =
        card.config
        and card.config.center

    return center
        and (
            center.set == 'Tamer'
            or center.balatromon_tamer
        )
end

local function is_consumable(card)
    if not card then
        return false
    end

    local center =
        card.config
        and card.config.center

    local ability =
        card.ability or {}

    if not center then
        return false
    end

    if center.consumeable
    or ability.consumeable then
        return true
    end

    local set =
        center.set
        or ability.set

    return
        SMODS.ConsumableTypes
        and set
        and SMODS.ConsumableTypes[set]
        ~= nil
end

local function palm_target(card)
    return
        is_consumable(card)
        and not is_tamer(card)
end

local PALM_SOURCE =
    'balatromon_palm'

local function palm_apply(card)
    if not palm_target(card) then
        return
    end

    SMODS.debuff_card(
        card,
        true,
        PALM_SOURCE
    )
end

local function palm_apply_all()
    for _, card in ipairs(
        G.consumeables
        and G.consumeables.cards
        or {}
    ) do
        palm_apply(card)
    end
end

local function palm_clear()
    for _, card in ipairs(
        G.consumeables
        and G.consumeables.cards
        or {}
    ) do
        SMODS.debuff_card(
            card,
            false,
            PALM_SOURCE
        )
    end
end

local function glass_or_lucky(card)
    if not card then
        return false
    end

    return
        BM.has_enhancement(
            card,
            'm_glass'
        )
        or
        BM.has_enhancement(
            card,
            'm_lucky'
        )
end

local function increase_all_hunger()
    for _, card in ipairs(
        G.jokers
        and G.jokers.cards
        or {}
    ) do
        if BM.is_digimon(card)
        and card.ability
        and card.ability.extra
        and not card.ability.extra
            .permanently_disabled then

            local e =
                card.ability.extra

            local old_hunger =
                e.hunger or 1

            e.hunger =
                math.min(
                    5,
                    old_hunger + 1
                )

            if e.hunger > old_hunger then
                if BM.care_animation then
                    BM.care_animation(
                        card,
                        'Hungry',
                        G.C.RED
                    )
                else
                    card:juice_up(
                        0.7,
                        0.5
                    )
                end
            end
        end
    end
end

local function line_recalc(root)
    return function(
        self,
        card,
        from_blind
    )
        return digimon_in_line(
            card,
            root
        )
    end
end

local function current_blind_key()
    local blind =
        G.GAME
        and G.GAME.blind

    local center =
        blind
        and blind.config
        and blind.config.blind

    return center
        and center.key
        or nil
end

local function blind_is(key)
    return
        current_blind_key()
        ==
        'bl_'
        .. BM.PREFIX
        .. '_'
        .. key
end

local function restore_chain_drag(card)
    if type(card) ~= 'table'
    or card.REMOVED then
        return
    end

    if card.states
    and card.states.drag then
        if card._balatromon_chain_old_drag ~= nil then
            card.states.drag.can =
                card._balatromon_chain_old_drag
        else
            card.states.drag.can =
                true
        end
    end

    card._balatromon_chain_old_drag =
        nil
end


local function lock_chain_card(card)
    if type(card) ~= 'table'
    or card.REMOVED
    or not card.states
    or not card.states.drag then
        return
    end

    if card._balatromon_chain_old_drag == nil then
        card._balatromon_chain_old_drag =
            card.states.drag.can
    end

    card.states.drag.can =
        false
end


local function chain_card_id(card)
    if type(card) ~= 'table' then
        return nil
    end

    return card.sort_id
end


local function find_chain_card(id)
    if id == nil
    or not G.jokers
    or not G.jokers.cards then
        return nil
    end

    for _, card in ipairs(
        G.jokers.cards
    ) do
        if card
        and card.sort_id == id then
            return card
        end
    end

    return nil
end


local function clear_chain()
    if not G.GAME then
        return
    end

    for _, card in ipairs(
        G.jokers
        and G.jokers.cards
        or {}
    ) do
        restore_chain_drag(
            card
        )
    end

    G.GAME.balatromon_chain_left_id =
        nil

    G.GAME.balatromon_chain_right_id =
        nil


    G.GAME.balatromon_chain_left =
        nil

    G.GAME.balatromon_chain_right =
        nil
end


local function start_chain()
    clear_chain()

    if not G.jokers
    or not G.jokers.cards
    or #G.jokers.cards == 0 then
        return
    end

    local left =
        G.jokers.cards[1]

    local right =
        G.jokers.cards[
            #G.jokers.cards
        ]

    G.GAME.balatromon_chain_left_id =
        chain_card_id(
            left
        )

    G.GAME.balatromon_chain_right_id =
        chain_card_id(
            right
        )

    lock_chain_card(
        left
    )

    if right ~= left then
        lock_chain_card(
            right
        )
    end
end


local function enforce_chain_positions()
    if not blind_is('chain')
    or not G.jokers
    or not G.jokers.cards
    or not G.GAME then
        return
    end

    local cards =
        G.jokers.cards

    local left =
        find_chain_card(
            G.GAME
                .balatromon_chain_left_id
        )

    local right =
        find_chain_card(
            G.GAME
                .balatromon_chain_right_id
        )


    if left
    and not left.REMOVED then
        for i = #cards, 1, -1 do
            if cards[i] == left then
                table.remove(
                    cards,
                    i
                )

                table.insert(
                    cards,
                    1,
                    left
                )

                break
            end
        end

        lock_chain_card(
            left
        )
    end


    if right
    and right ~= left
    and not right.REMOVED then
        for i = #cards, 1, -1 do
            if cards[i] == right then
                table.remove(
                    cards,
                    i
                )

                cards[
                    #cards + 1
                ] =
                    right

                break
            end
        end

        lock_chain_card(
            right
        )
    end
end

if CardArea
and CardArea.align_cards
and not BM._chain_align_wrapped then
    BM._chain_align_wrapped = true

    local old_align_cards =
        CardArea.align_cards

    CardArea.align_cards =
    function(self, ...)
        if self == G.jokers then
            enforce_chain_positions()
        end

        local result =
            old_align_cards(
                self,
                ...
            )

        if self == G.jokers then
            enforce_chain_positions()
        end

        return result
    end
end

local YGGDRASIL_DEBUFF_SOURCE =
    'balatromon_yggdrasil'

local function yggdrasil_clear_debuffs()
    for _, card in ipairs(
        G.jokers
        and G.jokers.cards
        or {}
    ) do
        SMODS.debuff_card(
            card,
            false,
            YGGDRASIL_DEBUFF_SOURCE
        )
    end
end

local function yggdrasil_restore_card(card)
    if not card
    or card.REMOVED
    or not card.ability
    or not card.ability.extra then
        return
    end

    local e =
        card.ability.extra

    if not e._yggdrasil_forced_x then
        return
    end

    e._yggdrasil_forced_x =
        nil

    e.x_antibody_rounds =
        nil

    e._x_antibody_ticked =
        nil

    card:remove_sticker(
        BM.PREFIX
        .. '_x_antibody'
    )

    if card.ability then
        card.ability[
            BM.PREFIX
            .. '_x_antibody'
        ] = nil
    end

    BM.restore_normal_digimon_sprite(
        card
    )

    card:juice_up(
        0.4,
        0.4
    )
end

local function yggdrasil_clear()
    yggdrasil_clear_debuffs()

    for _, card in ipairs(
        G.jokers
        and G.jokers.cards
        or {}
    ) do
        yggdrasil_restore_card(
            card
        )
    end
end

local function yggdrasil_apply_card(card)
    if not BM.is_digimon(card) then
        return
    end

    if BM.has_x_antibody
    and BM.has_x_antibody(card) then
        return
    end

    if BM.is_x_antibody_viable
    and BM.is_x_antibody_viable(card) then
        card.ability.extra =
            card.ability.extra or {}

        card.ability.extra
            ._yggdrasil_forced_x =
            true

        BM.restore_x_antibody(
            card,
            999
        )

        card:juice_up(
            0.4,
            0.4
        )

        return
    end

    SMODS.debuff_card(
        card,
        true,
        YGGDRASIL_DEBUFF_SOURCE
    )
end

local function yggdrasil_apply_all()
    for _, card in ipairs(
        G.jokers
        and G.jokers.cards
        or {}
    ) do
        yggdrasil_apply_card(
            card
        )
    end
end

local function yggdrasil_recalc(card)
    if not BM.is_digimon(card) then
        return
    end

    if BM.has_x_antibody
    and BM.has_x_antibody(card) then
        return false
    end

    if BM.is_x_antibody_viable
    and BM.is_x_antibody_viable(card) then
        return false
    end

    return true
end

SMODS.Blind {
    key = 'palm',

    loc_txt = {
        name = 'The Palm',
        text = {
            'All consumables are',
            'debuffed during this Blind',
            '{C:inactive}(Tamers are unaffected){}'
        }
    },

    atlas = 'BossBlinds',
    pos = {
        x = 0,
        y = 0
    },

    discovered = false,
    dollars = 5,
    mult = 2,

    boss = {
        min = 1
    },

    boss_colour =
        HEX('BB5BE5'),

    set_blind =
    function(self)
        palm_apply_all()
    end,

    calculate =
    function(
        self,
        a,
        b
    )
        local context =
            get_context(a, b)

        if not context then
            return
        end

        if context.card_added
        and context.card
        and G.GAME
        and G.GAME.blind
        and not G.GAME.blind.disabled then
            palm_apply(
                context.card
            )
        end
    end,

    press_play =
    function(self)
        palm_apply_all()
    end,

    disable =
    function(self)
        palm_clear()
    end,

    defeat =
    function(self)
        palm_clear()
    end
}

SMODS.Blind {
    key = 'unholy_halo',

    loc_txt = {
        name = 'The Unholy Halo',
        text = {
            '{C:attention}Glass{} and {C:attention}Lucky{}',
            'cards are debuffed'
        }
    },

    atlas = 'BossBlinds',
    pos = {
        x = 0,
        y = 1
    },

    discovered = false,
    dollars = 5,
    mult = 2,

    boss = {
        min = 2
    },

    boss_colour =
        HEX('646464'),

    recalc_debuff =
    function(
        self,
        card,
        from_blind
    )
        if glass_or_lucky(card) then
            return true
        end
    end
}

SMODS.Blind {
    key = 'destiny',

    loc_txt = {
        name = 'The Destiny',
        text = {
            'At the end of the round,',
            'the {C:attention}rightmost Joker{}',
            'becomes permanently {C:attention}Pinned to the left{}'
        }
    },

    atlas = 'BossBlinds',
    pos = {
        x = 0,
        y = 3
    },

    discovered = false,
    dollars = 5,
    mult = 2,

    boss = {
        min = 2
    },

    boss_colour =
        HEX('22BBDC'),

    defeat =
    function(self)
        if not G.jokers
        or not G.jokers.cards
        or #G.jokers.cards == 0 then
            return
        end

        local target =
            G.jokers.cards[
                #G.jokers.cards
            ]

        if not target then
            return
        end

        target.pinned = true

        target:juice_up(
            0.8,
            0.5
        )

        card_eval_status_text(
            target,
            'extra',
            nil,
            nil,
            nil,
            {
                message = 'Pinned!',
                colour = G.C.PURPLE
            }
        )
    end
}

SMODS.Blind {
    key = 'famished',

    loc_txt = {
        name = 'The Famished',
        text = {
            'Increase the {C:attention}Hunger{}',
            'of all Digimon by {C:red}1{}',
            'whenever a hand is played'
        }
    },

    atlas = 'BossBlinds',
    pos = {
        x = 0,
        y = 4
    },

    discovered = false,
    dollars = 5,
    mult = 2,

    boss = {
        min = 2
    },

    boss_colour =
        HEX('A8875F'),

    press_play =
    function(self)
        increase_all_hunger()
    end
}

SMODS.Blind {
    key = 'chain',

    loc_txt = {
        name = 'The Chain',
        text = {
            'The {C:attention}leftmost{} and',
            '{C:attention}rightmost Jokers{}',
            'cannot be moved'
        }
    },

    atlas = 'BossBlinds',
    pos = {
        x = 0,
        y = 7
    },

    discovered = false,
    dollars = 5,
    mult = 2,

    boss = {
        min = 2
    },

    boss_colour =
        HEX('6F7682'),

    set_blind =
    function(self)
        start_chain()
    end,

    disable =
    function(self)
        clear_chain()
    end,

    defeat =
    function(self)
        clear_chain()
    end
}

SMODS.Blind {
    key = 'yggdrasil',

    loc_txt = {
        name = 'Yggdrasil',
        text = {
            'All viable Digimon become',
            'their {C:attention}X-Antibody{} forms',
            'All other Digimon are debuffed'
        }
    },

    atlas = 'BossBlinds',
    pos = {
        x = 0,
        y = 8
    },

    discovered = false,
    dollars = 8,

    mult = 1.5,

    boss = {
        showdown = true
    },

    boss_colour =
        HEX('3B9F86'),

    set_blind =
    function(self)
        yggdrasil_apply_all()
    end,

    calculate =
    function(
        self,
        blind,
        context
    )
        if context.card_added
        and context.card
        and G.GAME.blind
        and not G.GAME.blind.disabled then
            yggdrasil_apply_card(
                context.card
            )
        end
    end,

    recalc_debuff =
    function(
        self,
        card,
        from_blind
    )
        return
            yggdrasil_recalc(
                card
            )
    end,

    disable =
    function(self)
        yggdrasil_clear()
    end,

    defeat =
    function(self)
        yggdrasil_clear()
    end
}

SMODS.Blind {
    key = 'hacked_decoder',

    loc_txt = {
        name = 'Hacked Decoder',
        text = {
            'Each Digimon has a {C:green}1 in 2{} chance',
            'to be {C:red}Hacked{} each played hand',
            '{C:inactive}Hacked Digimon do not activate{}'
        }
    },

    atlas = 'BossBlinds',
    pos = {
        x = 0,
        y = 9
    },

    discovered = false,
    dollars = 5,
    mult = 2,

    boss = {
        showdown = true
    },

    boss_colour =
        HEX('4E87A8')
}

SMODS.Blind {
    key = 'cowardice',

    loc_txt = {
        name = 'Cowardice',
        text = {
            'All Digimon in the',
            '{C:attention}Botamon Line{}',
            'are debuffed'
        }
    },

    atlas = 'BossBlinds',
    pos = {
        x = 0,
        y = 2
    },

    discovered = false,
    dollars = 8,
    mult = 2,

    boss = {
        showdown = true
    },

    boss_colour =
        HEX('138FD0'),

    recalc_debuff =
        line_recalc(
            'botamon'
        )
}

SMODS.Blind {
    key = 'hostility',

    loc_txt = {
        name = 'Hostility',
        text = {
            'All Digimon in the',
            '{C:attention}Punimon Line{}',
            'are debuffed'
        }
    },

    atlas = 'BossBlinds',
    pos = {
        x = 0,
        y = 5
    },

    discovered = false,
    dollars = 8,
    mult = 2,

    boss = {
        showdown = true
    },

    boss_colour =
        HEX('B99B22'),

    recalc_debuff =
        line_recalc(
            'punimon'
        )
}

SMODS.Blind {
    key = 'two_faced',

    loc_txt = {
        name = 'Two-Faced',
        text = {
            'All Digimon in the',
            '{C:attention}Yuramon Line{}',
            'are debuffed'
        }
    },

    atlas = 'BossBlinds',
    pos = {
        x = 0,
        y = 6
    },

    discovered = false,
    dollars = 8,
    mult = 2,

    boss = {
        showdown = true
    },

    boss_colour =
        HEX('9D52C7'),

    recalc_debuff =
        line_recalc(
            'yuramon'
        )
}


if BM.run_effect
and not BM._hacked_decoder_wrapped then
    BM._hacked_decoder_wrapped = true

    local old_run_effect =
        BM.run_effect

    local function hacked_context_group(context)
        if context.before
        or context.individual
        or context.repetition
        or context.joker_main
        or context.after then
            return 'hand'
        end

        if context.pre_discard
        or context.discard then
            return 'discard'
        end

        if context.end_of_round then
            return 'end_round'
        end

        if context.setting_blind then
            return 'setting_blind'
        end

        if context.remove_playing_cards then
            return 'remove_playing_cards'
        end

        if context.selling_card then
            return 'selling_card'
        end

        if context.selling_self then
            return 'selling_self'
        end

        if context.buying_card then
            return 'buying_card'
        end

        if context.reroll_shop then
            return 'reroll_shop'
        end

        if context.open_booster then
            return 'open_booster'
        end

        if context.skipping_booster then
            return 'skipping_booster'
        end

        if context.using_consumeable then
            return 'using_consumable'
        end

        if context.skip_blind then
            return 'skip_blind'
        end

        if context.first_hand_drawn then
            return 'first_hand_drawn'
        end

        return nil
    end

    local function hacked_context_id(group)
        local round =
            G.GAME
            and G.GAME.current_round
            or {}

        if group == 'hand' then
            return
                'hand_'
                .. tostring(
                    round.hands_played
                    or 0
                )
        end

        if group == 'discard' then
            return
                'discard_'
                .. tostring(
                    round.discards_used
                    or 0
                )
        end

        if group == 'end_round' then
            return
                'end_round_'
                .. tostring(
                    G.GAME
                    and G.GAME.round
                    or 0
                )
        end

        if group == 'setting_blind' then
            return
                'blind_'
                .. tostring(
                    G.GAME
                    and G.GAME.round
                    or 0
                )
        end

        return
            group
            .. '_'
            .. tostring(
                round.hands_played
                or 0
            )
            .. '_'
            .. tostring(
                round.discards_used
                or 0
            )
    end

    local function should_show_hacked(context, group)
        if group == 'hand' then
            return
                context.joker_main
        end

        if group == 'discard' then
            return
                context.pre_discard
                and context.main_eval
        end

        if group == 'end_round' then
            return
                context.end_of_round
                and context.main_eval
        end

        if group == 'setting_blind' then
            return
                context.setting_blind
                and context.main_eval
        end

        return false
    end

    BM.run_effect =
    function(
        slug,
        card,
        context
    )
        if not blind_is(
            'hacked_decoder'
        )
        or not card
        or not BM.is_digimon(card)
        or card.debuff
        or not context
        or context.blueprint
        or context.mod_probability
        or context.fix_probability
        or context.pseudorandom_result
        or context.check_eternal
        or context.retrigger_joker_check then
            return old_run_effect(
                slug,
                card,
                context
            )
        end

        local group =
            hacked_context_group(
                context
            )

        if not group then
            return old_run_effect(
                slug,
                card,
                context
            )
        end

        local id =
            hacked_context_id(
                group
            )

        card.ability.extra =
            card.ability.extra
            or {}

        local e =
            card.ability.extra

        e.hacked_decoder =
            e.hacked_decoder
            or {}

        local state =
            e.hacked_decoder

        if state.id ~= id then
            state.id = id

            state.hacked =
                pseudorandom(
                    'balatromon_hacked_decoder_'
                    .. tostring(
                        card.sort_id
                        or slug
                        or 'digimon'
                    )
                    .. '_'
                    .. tostring(id)
                )
                < 0.5

            state.shown = false
        end

        if state.hacked then
            if not state.shown
            and should_show_hacked(
                context,
                group
            ) then
                state.shown = true

                card_eval_status_text(
                    card,
                    'extra',
                    nil,
                    nil,
                    nil,
                    {
                        message = 'HACKED!',
                        colour = G.C.RED
                    }
                )
            end

            return
        end

        return old_run_effect(
            slug,
            card,
            context
        )
    end
end