local BM = Balatromon
BM.X_ANTIBODY_ATLAS = 'XDigimon'
SMODS.Sticker {
    key = 'x_antibody',

    atlas = 'Seal',

    pos = {
        x = 6,
        y = 0
    },

    badge_colour = G.C.PURPLE,

    default_compat = false,

    sets = {
        Joker = true
    },

    needs_enable_flag = false,

    rate = 0,

    loc_txt = {
        name = 'X-Antibody',
        label = 'X-Antibody',

        text = {
            'This Digimon has the',
            '{C:attention}X-Antibody{}',
            '{C:inactive}(#1# rounds remaining){}'
        }
    },

    loc_vars = function(
        self,
        info_queue,
        card
    )
        return {
            vars = {
                BM.get_x_antibody_rounds(
                    card
                )
            }
        }
    end,

    should_apply = function(
        self,
        card,
        center,
        area,
        bypass_roll
    )
        return false
    end
}
BM.X_ANTIBODY_ROUNDS = 5

function BM.can_x_evolve_to(slug)
    if not slug then
        return false
    end

    return BM.x_antibody_viable
        and BM.x_antibody_viable[slug] == true
end

BM.x_antibody_viable = {
    agumon = true,
    greymon = true,
    metalgreymon = true,
    tyrannomon = true,
    numemon = true,
    wargreymon = true,
    blackwargreymon = true,
    guilmon = true,
    growlmon = true,
    monochromon = true,
    wargrowlmon = true,
    gallantmon = true,
    gabumon = true,
    garurumon = true,
    leomon = true,
    weregarurumon = true,
    metalgarurumon = true,
    monzaemon = true,
    gomamon = true,
    crabmon = true,
    seadramon = true,
    megaseadramon = true,
}

BM.x_antibody_extra_evolutions = {
    gomamon = {
        'seadramon'
    }
}

BM.x_antibody_forms = BM.x_antibody_forms or {}

BM.x_antibody_effects = BM.x_antibody_effects or {}

local function x_contains_suit(cards, suit)
    for _, played in ipairs(cards or {}) do
        if played:is_suit(suit) then
            return true
        end
    end

    return false
end

local function x_card_id(card)
    if not card then
        return nil
    end

    return tostring(
        card.playing_card
        or card.sort_id
        or card
    )
end

local function x_highest_card(cards)
    local best
    local best_value = -math.huge

    for _, played in ipairs(cards or {}) do
        local value =
            played:get_id()
            or 0

        if value > best_value then
            best = played
            best_value = value
        end
    end

    return best, best_value
end

BM.x_antibody_effects.agumon =
function(card, context, base)
    if context.joker_main then
        return {
            xmult = 2
        }
    end
end

BM.x_antibody_effects.greymon =
function(card, context, base)
    local e = card.ability.extra

    BM.ensure_target(
        card,
        'target_rank',
        BM.deck_ranks(),
        'greymon_rank'
    )

    if context.joker_main
    and BM.contains_rank(
        context.scoring_hand,
        e.target_rank
    ) then
        BM.emult(
            card,
            1.3
        )
    end

    if context.end_of_round then
        return base()
    end
end

BM.x_antibody_effects.metalgreymon =
function(card, context, base)
    if context.joker_main then
        BM.emult(
            card,
            1.5
        )
    end
end

BM.x_antibody_effects.tyrannomon =
function(card, context, base)
    local e = card.ability.extra

    BM.ensure_target(
        card,
        'target_suit',
        BM.deck_suits(),
        'tyrannomon_suit'
    )

    if context.joker_main
    and x_contains_suit(
        context.scoring_hand,
        e.target_suit
    ) then
        BM.emult(
            card,
            1.3
        )
    end

    if context.end_of_round then
        return base()
    end
end

BM.x_antibody_effects.numemon =
function(card, context, base)
    if context.joker_main then
        return {
            xmult = 2
        }
    end
end

BM.x_antibody_effects.wargreymon =
function(card, context, base)
    local e = card.ability.extra

    BM.ensure_card_target(
        card,
        'wargrey_card'
    )

    if context.before
    and context.main_eval
    and not context.blueprint then
        e._x_wargrey_seen = {}
    end

    if context.individual
    and context.cardarea == G.play
    and context.other_card
    and not context.other_card.debuff then
        local target =
            BM.ensure_card_target(
                card,
                'wargrey_card'
            )

        local target_rank =
            e.target_rank

        local target_suit =
            e.target_suit

        local played =
            context.other_card

        if BM.get_rank(played)
            == target_rank
        and played:is_suit(
            target_suit
        ) then
            e._x_wargrey_seen =
                e._x_wargrey_seen
                or {}

            local id =
                x_card_id(
                    played
                )

            if not e._x_wargrey_seen[
                id
            ] then
                e._x_wargrey_seen[id] =
                    true

                e.xmult =
                    (e.xmult or 1)
                    + 0.1

                return {
                    message =
                        '^'
                        .. tostring(
                            e.xmult
                        )
                        .. ' Mult',
                    colour =
                        G.C.MULT
                }
            end
        end
    end

    if context.joker_main then
        BM.emult(
            card,
            e.xmult or 1
        )
    end

    if context.end_of_round then
        e._x_wargrey_seen = nil
        return base()
    end
end

BM.x_antibody_effects.blackwargreymon =
function(card, context, base)
    local e = card.ability.extra

    if context.remove_playing_cards
    and context.removed then
        local count =
            #context.removed

        if count > 0 then
            e.xmult =
                (e.xmult or 1)
                + 0.1 * count

            return {
                message =
                    '^'
                    .. tostring(
                        e.xmult
                    )
                    .. ' Mult',
                colour =
                    G.C.MULT
            }
        end
    end

    if context.joker_main then
        BM.emult(
            card,
            e.xmult or 1
        )
    end
end

BM.x_antibody_effects.guilmon =
function(card, context, base)
    if context.joker_main
    and BM.contains_hand(
        context,
        'Flush'
    ) then
        return {
            xmult = 3
        }
    end
end

BM.x_antibody_effects.growlmon =
function(card, context, base)
    if context.joker_main
    and BM.contains_hand(
        context,
        'Four of a Kind'
    ) then
        return {
            xmult = 5
        }
    end
end

BM.x_antibody_effects.monochromon =
function(card, context, base)
    local e = card.ability.extra

    if context.before
    and context.main_eval
    and not context.blueprint then
        local highest,
            value =
            x_highest_card(
                context.scoring_hand
            )

        e._x_monochromon_mult =
            value > 0
            and value * 2
            or 0

        if highest
        and G.P_CENTERS.m_glass then
            highest:set_ability(
                G.P_CENTERS.m_glass,
                nil,
                true
            )

            highest:juice_up(
                0.7,
                0.5
            )
        end
    end

    if context.joker_main then
        return {
            mult =
                e._x_monochromon_mult
                or 0
        }
    end
end

BM.x_antibody_effects.wargrowlmon =
function(card, context, base)
    local e = card.ability.extra

    BM.ensure_target(
        card,
        'target_hand',
        BM.HANDS,
        'wargrowl_hand'
    )

    if e.x_antibody_wargrowl_xmult
        == nil then
        e.x_antibody_wargrowl_xmult =
            math.max(
                1,
                (e.mult or 0) / 10
            )
    end

    if context.before
    and context.main_eval
    and not context.blueprint
    and BM.contains_hand(
        context,
        e.target_hand
    ) then
        e.x_antibody_wargrowl_xmult =
            e.x_antibody_wargrowl_xmult
            + 0.5

        return {
            message =
                'X'
                .. tostring(
                    e.x_antibody_wargrowl_xmult
                )
                .. ' Mult',
            colour =
                G.C.MULT
        }
    end

    if context.joker_main then
        return {
            xmult =
                e.x_antibody_wargrowl_xmult
                or 1
        }
    end

    if context.end_of_round then
        return base()
    end
end

BM.x_antibody_effects.gallantmon =
function(card, context, base)
    local e = card.ability.extra

    if context.joker_main then
        local previous =
            e.previous_form_value

        if previous == nil then
            previous = 3
        end

        BM.emult(
            card,
            previous / 3
        )
    end
end

local function x_has_scoring_face(cards)
    for _, played in ipairs(cards or {}) do
        if played.is_face
        and played:is_face() then
            return true
        end
    end

    return false
end

local function x_face_after_number(cards)
    local saw_number = false

    for _, played in ipairs(cards or {}) do
        if played.is_face
        and played:is_face() then
            if saw_number then
                return true
            end
        else
            local rank =
                BM.get_rank(played)

            if rank
            and rank >= 2
            and rank <= 10 then
                saw_number = true
            end
        end
    end

    return false
end

local function x_chip_mult(card, field)
    local e =
        card.ability.extra

    e[field] =
        e[field] or 1

    return e[field]
end

BM.x_antibody_effects.gabumon =
function(card, context, base)
    local e =
        card.ability.extra

    if e.x_gabumon_chips == nil then
        e.x_gabumon_chips = 1
    end

    if context.before
    and context.main_eval
    and not context.blueprint
    and x_face_after_number(
        context.scoring_hand
    ) then
        e.x_gabumon_chips =
            e.x_gabumon_chips
            + 0.25

        return {
            message =
                'X'
                .. tostring(
                    e.x_gabumon_chips
                )
                .. ' Chips',
            colour =
                G.C.CHIPS
        }
    end

    if context.joker_main then
        return {
            xchips =
                e.x_gabumon_chips
                or 1
        }
    end
end

BM.x_antibody_effects.garurumon =
function(card, context, base)
    local e =
        card.ability.extra

    if e.x_garurumon_chips == nil then
        e.x_garurumon_chips =
            e.x_gabumon_chips
            or 1
    end

    if context.before
    and context.main_eval
    and not context.blueprint
    and x_has_scoring_face(
        context.scoring_hand
    ) then
        e.x_garurumon_chips =
            e.x_garurumon_chips
            + 0.5

        return {
            message =
                'X'
                .. tostring(
                    e.x_garurumon_chips
                )
                .. ' Chips',
            colour =
                G.C.CHIPS
        }
    end

    if context.joker_main then
        return {
            xchips =
                e.x_garurumon_chips
                or 1
        }
    end
end

BM.x_antibody_effects.leomon =
function(card, context, base)
    local e =
        card.ability.extra

    BM.ensure_target(
        card,
        'target_hand',
        BM.HANDS,
        'leomon_hand'
    )

    if e.x_leomon_chips == nil then
        e.x_leomon_chips =
            e.x_gabumon_chips
            or 1
    end

    if context.before
    and context.main_eval
    and not context.blueprint
    and BM.contains_hand(
        context,
        e.target_hand
    ) then
        e.x_leomon_chips =
            e.x_leomon_chips
            + 0.5

        return {
            message =
                'X'
                .. tostring(
                    e.x_leomon_chips
                )
                .. ' Chips',
            colour =
                G.C.CHIPS
        }
    end

    if context.joker_main then
        return {
            xchips =
                e.x_leomon_chips
                or 1
        }
    end

    if context.end_of_round then
        return base()
    end
end

BM.x_antibody_effects.weregarurumon =
function(card, context, base)
    local e =
        card.ability.extra

    BM.ensure_target(
        card,
        'target_rank',
        BM.deck_ranks(),
        'weregaruru_rank'
    )

    e.x_weregarurumon_chips =
        e.x_weregarurumon_chips
        or 1

    if context.pre_discard
    and not context.blueprint then
        e._x_weregarurumon_upgraded =
            false
    end

    if context.discard
    and context.other_card
    and not e._x_weregarurumon_upgraded
    and BM.get_rank(
        context.other_card
    ) == e.target_rank then

        e._x_weregarurumon_upgraded =
            true

        e.x_weregarurumon_chips =
            e.x_weregarurumon_chips
            + 0.75

        return {
            message =
                'X'
                .. tostring(
                    e.x_weregarurumon_chips
                )
                .. ' Chips',
            colour =
                G.C.CHIPS
        }
    end

    if context.joker_main then
        return {
            xchips =
                e.x_weregarurumon_chips
                or 1
        }
    end

    if context.end_of_round then
        e._x_weregarurumon_upgraded =
            nil

        return base()
    end
end

BM.x_antibody_effects.metalgarurumon =
function(card, context, base)
    local e =
        card.ability.extra

    BM.ensure_card_target(
        card,
        'metalgaruru_card'
    )

    if context.before
    and context.main_eval
    and not context.blueprint then
        e._x_metalgarurumon_seen = {}
    end

    if context.individual
    and context.cardarea == G.play
    and context.other_card
    and not context.other_card.debuff then
        local played =
            context.other_card

        local rank =
            e.target_rank

        local suit =
            e.target_suit

        if BM.get_rank(played)
            == rank
        and played:is_suit(suit) then
            e._x_metalgarurumon_seen =
                e._x_metalgarurumon_seen
                or {}

            local id =
                x_card_id(
                    played
                )

            if not e._x_metalgarurumon_seen[
                id
            ] then
                e._x_metalgarurumon_seen[
                    id
                ] = true

                e.xchips =
                    (e.xchips or 1)
                    + 0.05

                return {
                    message =
                        '^'
                        .. tostring(
                            e.xchips
                        )
                        .. ' Chips',
                    colour =
                        G.C.CHIPS
                }
            end
        end
    end

    if context.joker_main then
        return {
            BM.echips(
                card,
                e.xchips or 1
            )
        }
    end

    if context.end_of_round then
        e._x_metalgarurumon_seen =
            nil

        return base()
    end
end

BM.x_antibody_effects.monzaemon =
function(card, context, base)
    if context.setting_blind
    and not context.blueprint
    and G.consumeables
    and BM.has_room(
        G.consumeables
    ) then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,

            func = function()
                if not BM.has_room(
                    G.consumeables
                ) then
                    return true
                end

                local tarot =
                    create_card(
                        'Tarot',
                        G.consumeables,
                        nil,
                        nil,
                        nil,
                        nil,
                        nil,
                        'x_monzaemon'
                    )

                tarot:set_edition(
                    {
                        negative = true
                    },
                    true
                )

                tarot:add_to_deck()

                G.consumeables:
                    emplace(
                        tarot
                    )

                return true
            end
        }))

        return {
            message =
                'Negative Tarot!',
            colour =
                G.C.PURPLE
        }
    end
end

BM.x_antibody_effects.gomamon =
function(card, context, base)
    local e =
        card.ability.extra

    BM.ensure_target(
        card,
        'target_suit',
        BM.deck_suits(),
        'x_gomamon_suit'
    )

    if context.joker_main
    and BM.contains_suit(
        context.scoring_hand,
        e.target_suit
    ) then
        return {
            xchips = 2
        }
    end

    if context.end_of_round then
        e.target_suit =
            BM.random_element(
                BM.deck_suits(),
                'x_gomamon_suit_'
                .. tostring(
                    card.sort_id or 0
                )
            )
    end
end

BM.x_antibody_effects.crabmon =
function(card, context, base)
    local e =
        card.ability.extra

    BM.ensure_target(
        card,
        'target_rank',
        BM.deck_ranks(),
        'x_crabmon_rank'
    )

    if context.joker_main
    and BM.contains_rank(
        context.scoring_hand,
        e.target_rank
    ) then
        return {
            xchips = 2
        }
    end

    if context.end_of_round then
        e.target_rank =
            BM.random_element(
                BM.deck_ranks(),
                'x_crabmon_rank_'
                .. tostring(
                    card.sort_id or 0
                )
            )
    end
end

BM.x_antibody_effects.seadramon =
function(card, context, base)
    if context.individual
    and context.cardarea == G.play
    and context.other_card
    and context.other_card.is_face
    and context.other_card:is_face() then
        return {
            xchips = 1.5
        }
    end
end

BM.x_antibody_effects.megaseadramon =
function(card, context, base)
    if context.individual
    and context.cardarea == G.play
    and context.other_card
    and context.other_card.is_face
    and context.other_card:is_face()
    and not context.blueprint then

        local played =
            context.other_card

        played.ability =
            played.ability
            or {}

        played.ability.perma_x_chips =
            (
                played.ability
                    .perma_x_chips
                or 1
            )
            * 1.02

        return {
            message =
                'X1.02 Chips',
            colour =
                G.C.CHIPS
        }
    end
end

local function x_sticker_key()
    return BM.PREFIX .. '_x_antibody'
end

function BM.has_x_antibody(card)
    if not card
    or not card.ability
    or not card.ability.extra then
        return false
    end

    return (
        card.ability.extra.x_antibody_rounds
        or 0
    ) > 0
end

function BM.get_x_antibody_rounds(card)
    if not card
    or not card.ability
    or not card.ability.extra then
        return 0
    end

    return card.ability.extra
        .x_antibody_rounds
        or 0
end

function BM.is_x_antibody_viable(card)
    if not card
    or card.REMOVED
    or not BM.is_digimon(card) then
        return false
    end

    local slug =
        BM.get_card_slug(card)

    if not slug
    or slug == 'recovery_digitama' then
        return false
    end

    local e =
        card.ability
        and card.ability.extra
        or {}

    if e.permanently_disabled then
        return false
    end

    if BM.has_x_antibody(card) then
        return false
    end

    if BM.x_antibody_viable == nil then
        return true
    end

    return BM.x_antibody_viable[slug]
        == true
end

function BM.set_x_antibody_sprite(card)
    if not card
    or card.REMOVED then
        return
    end

    local slug =
        BM.get_card_slug(card)

    local form =
        BM.x_antibody_forms
        and BM.x_antibody_forms[slug]

    if not form then
        return
    end

    local sprite =
        card.children
        and card.children.center

    if not sprite then
        return
    end

    local atlas_key =
        form.atlas
        or BM.X_ANTIBODY_ATLAS

    local atlas =
        G.ASSET_ATLAS
        and (
            G.ASSET_ATLAS[atlas_key]
            or G.ASSET_ATLAS[
                BM.PREFIX
                .. '_'
                .. atlas_key
            ]
        )

    if not atlas then
        return
    end

    sprite.atlas =
        atlas

    if form.pos
    and sprite.set_sprite_pos then
        sprite:set_sprite_pos(
            form.pos
        )
    end
end
function BM.restore_x_antibody(card, rounds)
    if not card
    or card.REMOVED
    or not rounds
    or rounds <= 0 then
        return
    end

    card.ability.extra =
        card.ability.extra or {}

    card.ability.extra.x_antibody_rounds =
        rounds

    card:add_sticker(
        BM.PREFIX .. '_x_antibody',
        true
    )

    BM.set_x_antibody_sprite(
        card
    )
end
function BM.restore_normal_digimon_sprite(card)
    if not card
    or card.REMOVED
    or not card.config
    or not card.config.center then
        return
    end

    local center =
        card.config.center

    local sprite =
        card.children
        and card.children.center

    if not sprite then
        return
    end

    local atlas =
        G.ASSET_ATLAS[
            center.atlas
        ]

    if atlas then
        sprite.atlas = atlas
    end

    if center.pos
    and sprite.set_sprite_pos then
        sprite:set_sprite_pos(
            center.pos
        )
    end
end

function BM.apply_x_antibody(card)
    if not BM.is_x_antibody_viable(
        card
    ) then
        return false
    end

    card.ability.extra =
        card.ability.extra or {}

    card.ability.extra
        .x_antibody_rounds =
        BM.X_ANTIBODY_ROUNDS

    card:add_sticker(
        x_sticker_key(),
        true
    )

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.15,

        func = function()
            if card
            and not card.REMOVED then
                play_sound(
                    'tarot1',
                    1,
                    0.8
                )

                card:juice_up(
                    0.3,
                    0.5
                )

                card_eval_status_text(
                    card,
                    'extra',
                    nil,
                    nil,
                    nil,
                    {
                        message =
                            'X-Antibody!',
                        colour =
                            G.C.PURPLE
                    }
                )
            end

            return true
        end
    }))

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.35,

        func = function()
            if card
            and not card.REMOVED then
                card:flip()

                play_sound(
                    'card1',
                    1.15
                )

                card:juice_up(
                    0.3,
                    0.3
                )
            end

            return true
        end
    }))

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.30,

        func = function()
            if card
            and not card.REMOVED then
                BM.set_x_antibody_sprite(
                    card
                )
            end

            return true
        end
    }))

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.35,

        func = function()
            if card
            and not card.REMOVED then
                card:flip()

                play_sound(
                    'tarot2',
                    0.85,
                    0.6
                )

                card:juice_up(
                    0.4,
                    0.4
                )
            end

            return true
        end
    }))

    return true
end

function BM.remove_x_antibody(card)
    if not card
    or card.REMOVED then
        return false
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.15,

        func = function()
            if card
            and not card.REMOVED then
                play_sound(
                    'tarot1',
                    0.9,
                    0.7
                )

                card:juice_up(
                    0.3,
                    0.4
                )
            end

            return true
        end
    }))

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.35,

        func = function()
            if card
            and not card.REMOVED then
                card:flip()

                play_sound(
                    'card1',
                    1.05
                )

                card:juice_up(
                    0.3,
                    0.3
                )
            end

            return true
        end
    }))

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.30,

        func = function()
            if card
            and not card.REMOVED then
                BM.restore_normal_digimon_sprite(
                    card
                )

                if card.ability
                and card.ability.extra then
                    card.ability.extra
                        .x_antibody_rounds =
                        nil

                    card.ability.extra
                        ._x_antibody_ticked =
                        nil
                end

                card:remove_sticker(
                    x_sticker_key()
                )

                if card.ability then
                    card.ability[
                        x_sticker_key()
                    ] = nil
                end
            end

            return true
        end
    }))

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.35,

        func = function()
            if card
            and not card.REMOVED then
                card:flip()

                play_sound(
                    'tarot2',
                    0.8,
                    0.6
                )

                card:juice_up(
                    0.4,
                    0.4
                )

                card_eval_status_text(
                    card,
                    'extra',
                    nil,
                    nil,
                    nil,
                    {
                        message =
                            'X-Antibody expired',

                        colour =
                            G.C.FILTER
                    }
                )
            end

            return true
        end
    }))

    return true
end

function BM.x_antibody_tick(
    card,
    context
)
    if not BM.has_x_antibody(card) then
        return
    end

    if not (
        context
        and context.end_of_round
        and context.main_eval
        and not context.blueprint
    ) then
        return
    end

    local e =
        card.ability.extra

    if e._x_antibody_ticked then
        return
    end

    e._x_antibody_ticked =
        true

    e.x_antibody_rounds =
        math.max(
            0,
            (
                e.x_antibody_rounds
                or BM.X_ANTIBODY_ROUNDS
            )
            - 1
        )

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0,

        func = function()
            if card
            and not card.REMOVED
            and card.ability
            and card.ability.extra then
                card.ability.extra
                    ._x_antibody_ticked =
                    nil
            end

            return true
        end
    }))

    if e.x_antibody_rounds <= 0 then
        BM.remove_x_antibody(
            card
        )

        return
    end

    card_eval_status_text(
        card,
        'extra',
        nil,
        nil,
        nil,
        {
            message =
                tostring(
                    e.x_antibody_rounds
                )
                .. (
                    e.x_antibody_rounds == 1
                    and ' round'
                    or ' rounds'
                ),
            colour =
                G.C.PURPLE
        }
    )
end

local old_care_tick =
    BM.care_tick

BM.care_tick =
function(card, context)
    local result

    if old_care_tick then
        result =
            old_care_tick(
                card,
                context
            )
    end

    BM.x_antibody_tick(
        card,
        context
    )

    return result
end

local old_run_effect =
    BM.run_effect

BM._run_effect_without_x =
    old_run_effect

BM.run_effect =
function(slug, card, context)
    if BM.has_x_antibody(card) then
        local x_effect =
            BM.x_antibody_effects[
                slug
            ]

        if x_effect then
            return x_effect(
                card,
                context,
                function()
                    return old_run_effect(
                        slug,
                        card,
                        context
                    )
                end
            )
        end
    end

    return old_run_effect(
        slug,
        card,
        context
    )
end

BM.x_antibody_tooltips = {
    agumon = {
        name = 'Agumon X',
        stage = 'Rookie',
        text = {
            '{X:mult,C:white}X2{} Mult'
        }
    },

    greymon = {
        name = 'Greymon X',
        stage = 'Champion',
        text = {
            '{X:mult,C:white}^1.3{} Mult if played hand contains {C:attention}#4#{}',
            '{C:inactive}(rank changes at end of round){}'
        }
    },

    metalgreymon = {
        name = 'MetalGreymon X',
        stage = 'Ultimate',
        text = {
            '{X:mult,C:white}^1.5{} Mult'
        }
    },

    tyrannomon = {
        name = 'Tyrannomon X',
        stage = 'Champion',
        text = {
            '{X:mult,C:white}^1.3{} Mult if played hand contains {V:1}#4#{}',
            '{C:inactive}(suit changes at end of round){}'
        }
    },

    numemon = {
        name = 'Numemon X',
        stage = 'Champion',
        text = {
            '{X:mult,C:white}X2{} Mult'
        }
    },

    wargreymon = {
        name = 'WarGreymon X',
        stage = 'Mega',
        text = {
            'Gain {X:mult,C:white}^0.1{} Mult for every',
            '{C:attention}#4#{} of {V:1}#5#{} played',
            '{C:inactive}(Upgrade limited once per card including retriggers){}',
            '{C:inactive}(card changes at end of round){}',
            '{C:inactive}(Currently {X:mult,C:white}^#6#{C:inactive} Mult){}'
        }
    },

    blackwargreymon = {
        name = 'BlackWarGreymon X',
        stage = 'Mega',
        text = {
            'Gain {X:mult,C:white}^0.1{} Mult every time',
            'a card is destroyed',
            '{C:inactive}(Currently {X:mult,C:white}^#4#{C:inactive} Mult){}'
        }
    },

    guilmon = {
        name = 'Guilmon X',
        stage = 'Rookie',
        text = {
            '{X:mult,C:white}X3{} Mult if played hand',
            'contains a {C:attention}Flush{}'
        }
    },

    growlmon = {
        name = 'Growlmon X',
        stage = 'Champion',
        text = {
            '{X:mult,C:white}X5{} Mult if played hand contains',
            '{C:attention}Four of a Kind{}'
        }
    },

    monochromon = {
        name = 'Monochromon X',
        stage = 'Champion',
        text = {
            'Add to Mult {C:attention}double{} the highest',
            'valued card in played hand and',
            'turn it into a {C:attention}Glass Card{}'
        }
    },

    wargrowlmon = {
        name = 'WarGrowlmon X',
        stage = 'Ultimate',
        text = {
            'Gain {X:mult,C:white}X0.5{} Mult every time',
            '{C:attention}#4#{} is played',
            '{C:inactive}(poker hand changes at end of round){}',
            '{C:inactive}(Currently {X:mult,C:white}X#5#{C:inactive} Mult){}'
        }
    },

    gallantmon = {
        name = 'Gallantmon X',
        stage = 'Mega',
        text = {
            'Gives {X:mult,C:white}^#4#{} Mult',
            '{C:inactive}(1/3 of its previous form\'s stored value){}'
        }
    },

    gabumon = {
    name = 'Gabumon X',
    stage = 'Rookie',

    text = {
        'Gain {X:chips,C:white}X0.25{} Chips if hand played',
        'contains a scoring face card after',
        'a scoring numbered card',
        '{C:inactive}(Currently {X:chips,C:white}X#4#{C:inactive} Chips){}'
    }
},

garurumon = {
    name = 'Garurumon X',
    stage = 'Champion',

    text = {
        'Gain {X:chips,C:white}X0.5{} Chips if played hand',
        'contains a scoring face card',
        '{C:inactive}(Currently {X:chips,C:white}X#4#{C:inactive} Chips){}'
    }
},

leomon = {
    name = 'Leomon X',
    stage = 'Champion',

    text = {
        'Gain {X:chips,C:white}X0.5{} Chips if played hand',
        'contains {C:attention}#4#{}',
        '{C:inactive}(poker hand changes at end of round){}',
        '{C:inactive}(Currently {X:chips,C:white}X#5#{C:inactive} Chips){}'
    }
},

weregarurumon = {
    name = 'WereGarurumon X',
    stage = 'Ultimate',

    text = {
        'Gain {X:chips,C:white}X0.75{} Chips if {C:attention}#4#{} is discarded',
        '{C:inactive}(can upgrade once per discard){}',
        '{C:inactive}(rank changes at end of round){}',
        '{C:inactive}(Currently {X:chips,C:white}X#5#{C:inactive} Chips){}'
    }
},

metalgarurumon = {
    name = 'MetalGarurumon X',
    stage = 'Mega',

    text = {
        'Gain {X:chips,C:white}^0.05{} Chips for every',
        '{C:attention}#4#{} of {V:1}#5#{} played',
        '{C:inactive}(Upgrade limited once per card including retriggers){}',
        '{C:inactive}(card changes at end of round){}',
        '{C:inactive}(Currently {X:chips,C:white}^#6#{C:inactive} Chips){}'
    }
},

monzaemon = {
    name = 'Monzaemon X',
    stage = 'Champion',

    text = {
        'Create a {C:dark_edition}Negative{} {C:tarot}Tarot{} card',
        'when Blind is selected',
        '{C:inactive}(must have room){}'
    }
},

gomamon = {
    name = 'Gomamon X',
    stage = 'Rookie',

    text = {
        '{X:chips,C:white}X2{} Chips if played hand',
        'contains a {V:1}#4#{}',
        '{C:inactive}(suit changes at end of round){}'
    }
},

crabmon = {
    name = 'Crabmon X',
    stage = 'Rookie',

    text = {
        '{X:chips,C:white}X2{} Chips if played hand',
        'contains a {C:attention}#4#{}',
        '{C:inactive}(rank changes at end of round){}'
    }
},

seadramon = {
    name = 'Seadramon X',
    stage = 'Champion',

    text = {
        'Every scoring face card gives',
        '{X:chips,C:white}X1.5{} Chips'
    }
},

megaseadramon = {
    name = 'MegaSeadramon X',
    stage = 'Ultimate',

    text = {
        'Scoring face cards permanently gain',
        '{X:chips,C:white}X1.02{} Chips'
    }
},
}

local old_process_loc_text =
    SMODS.current_mod.process_loc_text

SMODS.current_mod.process_loc_text =
function()
    if old_process_loc_text then
        old_process_loc_text()
    end

    G.localization.descriptions.Joker =
        G.localization.descriptions.Joker
        or {}

    for slug, def in pairs(
        BM.x_antibody_tooltips
    ) do
        local normal_key =
            BM.center_key(slug)

        local x_key =
            normal_key
            .. '_x_antibody'

        SMODS.process_loc_text(
            G.localization.descriptions.Joker,
            x_key,
            {
                name = def.name,

                text = {
                    def.text,
                    {
                        BM.care_status_text(
                            def.stage
                        )
                    }
                }
            }
        )
    end
end

function BM.install_x_antibody_tooltips()
    for slug, def in pairs(
        BM.x_antibody_tooltips
    ) do
        local center_key =
            BM.center_key(slug)

        local center =
            SMODS.Centers
            and SMODS.Centers[
                center_key
            ]

        if center
        and not center._bm_x_loc_wrapped then
            local old_loc_vars =
                center.loc_vars

            center.loc_vars =
            function(
                self,
                info_queue,
                card
            )
                local result

                if old_loc_vars then
                    result =
                        old_loc_vars(
                            self,
                            info_queue,
                            card
                        )
                end

                result =
                    result or {}

                result.vars =
                    result.vars
                    or {}

                if card
and BM.has_x_antibody(
    card
) then
    result.key =
        self.key
        .. '_x_antibody'

    local e =
        card.ability
        and card.ability.extra
        or {}

    if slug == 'wargrowlmon' then
        result.vars[5] =
            e.x_antibody_wargrowl_xmult
            or math.max(
                1,
                (e.mult or 0)
                / 10
            )

    elseif slug == 'gabumon' then
        result.vars[4] =
            e.x_gabumon_chips
            or 1

    elseif slug == 'garurumon' then
        result.vars[4] =
            e.x_garurumon_chips
            or e.x_gabumon_chips
            or 1

    elseif slug == 'leomon' then
        result.vars[5] =
            e.x_leomon_chips
            or e.x_gabumon_chips
            or 1

    elseif slug == 'weregarurumon' then
        result.vars[5] =
            e.x_weregarurumon_chips
            or 1
    end

            end

                return result
            end

            center._bm_x_loc_wrapped =
                true
        end
    end
end

BM.install_x_antibody_tooltips()

if G.localization
and G.localization.descriptions
and G.localization.descriptions.Joker then
    for slug, def in pairs(
        BM.x_antibody_tooltips
    ) do
        local x_key =
            BM.center_key(slug)
            .. '_x_antibody'

        SMODS.process_loc_text(
            G.localization.descriptions.Joker,
            x_key,
            {
                name = def.name,

                text = {
                    def.text,
                    {
                        BM.care_status_text(
                            def.stage
                        )
                    }
                }
            }
        )
    end
end



BM.x_antibody_forms = {
    agumon = {
        pos = {x = 0, y = 0}
    },

    greymon = {
        pos = {x = 1, y = 0}
    },

    metalgreymon = {
        pos = {x = 2, y = 0}
    },

    tyrannomon = {
        pos = {x = 3, y = 0}
    },

    numemon = {
        pos = {x = 4, y = 0}
    },

    wargreymon = {
        pos = {x = 5, y = 0}
    },

    blackwargreymon = {
        pos = {x = 6, y = 0}
    },

    guilmon = {
        pos = {x = 7, y = 0}
    },

    growlmon = {
        pos = {x = 8, y = 0}
    },

    monochromon = {
        pos = {x = 9, y = 0}
    },

    wargrowlmon = {
        pos = {x = 0, y = 1}
    },

    gallantmon = {
        pos = {x = 1, y = 1}
    },

    gabumon = {
        pos = {x = 2, y = 1}
    },

    garurumon = {
        pos = {x = 3, y = 1}
    },

    leomon = {
        pos = {x = 4, y = 1}
    },

    weregarurumon = {
        pos = {x = 5, y = 1}
    },

    metalgarurumon = {
        pos = {x = 6, y = 1}
    },

    monzaemon = {
        pos = {x = 7, y = 1}
    },

    gomamon = {
        pos = {x = 8, y = 1}
    },

    crabmon = {
        pos = {x = 9, y = 1}
    },

    seadramon = {
        pos = {x = 0, y = 2}
    },

    megaseadramon = {
        pos = {x = 1, y = 2}
    }
}




function BM.get_x_evolution_targets(slug)
    local out = {}
    local seen = {}

    local def =
        BM.joker_defs
        and BM.joker_defs[slug]

    if def then
        for part in tostring(
            def.evolves_to or ''
        ):gmatch('[^,]+') do
            local name =
                part:match(
                    '^%s*(.-)%s*$'
                )

            local target =
                BM.slug(name)

            if target ~= ''
            and target ~= '-'
            and BM.can_x_evolve_to(target)
            and not seen[target] then
                seen[target] = true
                out[#out + 1] = target
            end
        end
    end

    local extras =
        BM.x_antibody_extra_evolutions
        and BM.x_antibody_extra_evolutions[slug]

    for _, target in ipairs(
        extras or {}
    ) do
        if BM.can_x_evolve_to(target)
        and not seen[target] then
            seen[target] = true
            out[#out + 1] = target
        end
    end

    return out
end