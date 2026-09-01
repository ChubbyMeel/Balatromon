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
    tokomon = true,
    pegasusmon = true,
    salamon = true,
    gatomon = true,
    nefertimon = true,
    angewomon = true,
    magnadramon = true,
    ladydevimon = true,
    myotismon = true,
    renamon = true,
    sakuyamon = true,
    terriermon = true,
    rapidmon = true,
    garudamon = true,
    phoenixmon = true,
    keramon = true,
    palmon = true,
    togemon = true,
    lillymon = true,
    rosemon = true,
    kuwagamon = true,
    okuwamon = true,
    herculeskabuterimon = true,
    magnamon = true,
    omegamon = true,
}

BM.x_antibody_extra_evolutions = {
    gomamon = {
        'seadramon'
    },
    tokomon = {
        'salamon',
        'renamon',
        'terriermon'
    },
    angewomon = {
        'sakuyamon'
    },
    salamon = {
        'pegasusmon'
    },
    gatomon = {
        'myotismon',
        'ladydevimon'
    },
    terriermon = {
        'rapidmon'
    },
    nefertimon = {
        'garudamon'
    },
    pegasusmon = {
        'garudamon'
    },
    keramon = {
        'monzaemon',
        'kuwagamon'
    }

}

BM.evolution_rules.salamon.pegasusmon = {
    device = 'd3',
    note = 'D-3 Armor route'
}

BM.x_antibody_forms = BM.x_antibody_forms or {}

BM.x_antibody_effects = BM.x_antibody_effects or {}

local function x_contains_suit(
    cards,
    suit
)
    for _, played in ipairs(
        cards or {}
    ) do
        if BM.card_has_suit(
            played,
            suit
        ) then
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

    e.target_rank, e.target_suit = BM.ensure_shared_card_target(
        'wargreymon_card',
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
        e.target_rank, e.target_suit = BM.ensure_shared_card_target(
            'wargreymon_card',
            'wargrey_card'
        )

        local target_rank =
            e.target_rank

        local target_suit =
            e.target_suit

        local played =
            context.other_card

        if BM.card_matches_target(
            played,
            target_rank,
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
        if BM.is_face(played) then
            return true
        end
    end

    return false
end

local function x_card_has_number(played)
    for _, identity in ipairs(
        BM.card_identities(played)
    ) do
        if identity.rank
        and identity.rank >= 2
        and identity.rank <= 10 then
            return true
        end
    end

    return false
end

local function x_face_after_number(cards)
    local saw_number = false

    for _, played in ipairs(cards or {}) do
        if BM.is_face(played)
        and saw_number then
            return true
        end

        if x_card_has_number(played) then
            saw_number = true
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

    e.target_rank = BM.ensure_shared_target(
        'weregarurumon_rank',
        BM.deck_ranks(),
        'weregaruru_rank'
    )

    e.x_weregarurumon_chips =
        e.x_weregarurumon_chips
        or e.x_garurumon_chips
        or 1

    if context.pre_discard
    and not context.blueprint then
        e._x_weregarurumon_upgraded =
            false
    end

    if context.discard
    and context.other_card
    and not e._x_weregarurumon_upgraded
    and BM.card_has_rank(
        context.other_card,
        e.target_rank
    ) then

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

    e.target_rank, e.target_suit = BM.ensure_shared_card_target(
        'metalgarurumon_card',
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

        if BM.card_matches_target(
            played,
            rank,
            suit
        ) then
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

    e.target_suit = BM.ensure_shared_target(
        'x_gomamon_suit',
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

    if context.end_of_round
    and context.main_eval
    and not context.blueprint then
        e.target_suit = BM.reroll_shared_target(
            'x_gomamon_suit',
            BM.deck_suits(),
            'x_gomamon_suit'
        )
    end
end

BM.x_antibody_effects.crabmon =
function(card, context, base)
    local e =
        card.ability.extra

    e.target_rank = BM.ensure_shared_target(
        'x_crabmon_rank',
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

    if context.end_of_round
    and context.main_eval
    and not context.blueprint then
        e.target_rank = BM.reroll_shared_target(
            'x_crabmon_rank',
            BM.deck_ranks(),
            'x_crabmon_rank'
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

local function x_first_hand_transform(context, enhancement, limit)
    if not context.before
    or not context.main_eval
    or context.blueprint
    or (G.GAME.current_round.hands_played or 0) ~= 0 then
        return false
    end

    local changed = false

    for i, played in ipairs(context.full_hand or {}) do
        if not limit or i <= limit then
            changed =
                BM.set_enhancement(
                    played,
                    enhancement
                )
                or changed
        end
    end

    return changed
end

local function x_angewomon_emult(e)
    if e.x_angewomon_emult == nil then
        e.x_angewomon_emult =
            1
            + math.max(
                0,
                (e.xmult or 1) - 1
            ) / 100
    end

    return e.x_angewomon_emult
end

local function x_money_emult()
    local dollars =
        G.GAME
        and G.GAME.dollars
        or 0

    return
        1
        + 0.1
        * math.max(
            0,
            math.floor(dollars / 10)
        )
end

BM.x_antibody_effects.tokomon =
function(card, context, base)
    if x_first_hand_transform(
        context,
        'm_lucky'
    ) then
        return {
            message = 'Lucky!',
            colour = G.C.GREEN
        }
    end
end

BM.x_antibody_effects.pegasusmon =
function(card, context, base)
    if context.pseudorandom_result
    and context.result
    and context.trigger_obj
    and SMODS.is_playing_card(
        context.trigger_obj
    )
    and BM.has_enhancement(
        context.trigger_obj,
        'm_lucky'
    ) then
        return {
            xmult = 2
        }
    end

    if context.mod_probability then
        return base()
    end
end

BM.x_antibody_effects.salamon =
function(card, context, base)
    if x_first_hand_transform(
        context,
        'm_glass',
        2
    ) then
        return {
            message = 'Glass!',
            colour = G.C.MULT
        }
    end
end

BM.x_antibody_effects.gatomon =
function(card, context, base)
    if x_first_hand_transform(
        context,
        'm_glass'
    ) then
        return {
            message = 'Glass!',
            colour = G.C.MULT
        }
    end
end

BM.x_antibody_effects.nefertimon =
function(card, context, base)
    if context.individual
    and context.cardarea == G.play
    and context.other_card
    and BM.has_enhancement(
        context.other_card,
        'm_glass'
    ) then
        return {
            xchips = 1.25
        }
    end

    if context.mod_probability then
        return base()
    end
end

BM.x_antibody_effects.angewomon =
function(card, context, base)
    local e =
        card.ability.extra

    if context.remove_playing_cards
    and not context.blueprint then
        local count = 0

        for _, removed in ipairs(
            context.removed or {}
        ) do
            if BM.has_enhancement(
                removed,
                'm_glass'
            ) then
                count = count + 1
            end
        end

        if count > 0 then
            e.x_angewomon_emult =
                x_angewomon_emult(e)
                + 0.069 * count

            return {
                message =
                    '^'
                    .. tostring(
                        e.x_angewomon_emult
                    )
                    .. ' Mult',
                colour = G.C.MULT
            }
        end
    end

    if context.joker_main then
        BM.emult(
            card,
            x_angewomon_emult(e)
        )
    end
end

BM.x_antibody_effects.magnadramon =
function(card, context, base)
    if context.individual
    and context.cardarea == G.play
    and context.other_card
    and BM.has_enhancement(
        context.other_card,
        'm_glass'
    ) then
        return {
            xmult = 3
        }
    end
end

BM.x_antibody_effects.ladydevimon =
function(card, context, base)
    if context.individual
    and context.cardarea == G.hand
    and not context.end_of_round
    and not context.playing_card_end_of_round
    and context.other_card
    and BM.has_enhancement(
        context.other_card,
        'm_steel'
    ) then
        return {
            dollars = 3
        }
    end
end

BM.x_antibody_effects.myotismon =
function(card, context, base)
    if context.joker_main then
        local count =
            BM.count_deck_enhancement(
                'm_steel'
            )

        BM.emult(
            card,
            1 + 0.05 * count
        )
    end
end

BM.x_antibody_effects.renamon =
function(card, context, base)
    local e =
        card.ability.extra

    e.target_suit = BM.ensure_shared_target(
        'x_renamon_family_suit',
        BM.deck_suits(),
        'x_renamon_suit'
    )

    if context.discard
    and context.other_card
    and BM.card_has_suit(
        context.other_card,
        e.target_suit
    ) then
        return {
            dollars = 6
        }
    end

    if context.end_of_round
    and context.main_eval
    and not context.blueprint then
        e.target_suit = BM.reroll_shared_target(
            'x_renamon_family_suit',
            BM.deck_suits(),
            'x_renamon_suit'
        )

        return BM.target_change_return(
            card,
            'Target: '
                .. tostring(
                    e.target_suit
                ),
            (
                G.C.SUITS
                and G.C.SUITS[
                    e.target_suit
                ]
            )
            or G.C.FILTER
        )
    end
end

BM.x_antibody_effects.sakuyamon =
function(card, context, base)
    local e =
        card.ability.extra

    e.target_suit = BM.ensure_shared_target(
        'x_renamon_family_suit',
        BM.deck_suits(),
        'x_renamon_suit'
    )

    if context.discard
    and context.other_card
    and BM.card_has_suit(
        context.other_card,
        e.target_suit
    ) then
        return {
            dollars = 6
        }
    end

    if context.joker_main then
        BM.emult(
            card,
            x_money_emult()
        )
    end

    if context.end_of_round
    and context.main_eval
    and not context.blueprint then
        e.target_suit = BM.reroll_shared_target(
            'x_renamon_family_suit',
            BM.deck_suits(),
            'x_renamon_suit'
        )

        return BM.target_change_return(
            card,
            'Target: '
                .. tostring(
                    e.target_suit
                ),
            (
                G.C.SUITS
                and G.C.SUITS[
                    e.target_suit
                ]
            )
            or G.C.FILTER
        )
    end
end

local function x_most_played_hand(hand)
    if not hand
    or not G.GAME
    or not G.GAME.hands
    or not G.GAME.hands[hand] then
        return false
    end

    local data = G.GAME.hands[hand]

    if data.visible == false then
        return false
    end

    local most = -math.huge

    for _, other in pairs(G.GAME.hands) do
        if other.visible ~= false then
            most = math.max(
                most,
                other.played or 0
            )
        end
    end

    return (data.played or 0) == most
end

local function x_feed_random_digimon(card, count, seed)
    if not G.jokers then
        return 0
    end

    local pool = {}

    for _, joker in ipairs(G.jokers.cards or {}) do
        if joker ~= card
        and BM.is_digimon(joker) then
            pool[#pool + 1] = joker
        end
    end

    local fed = 0

    for i = 1, math.min(count or 1, #pool) do
        local target = BM.random_element(
            pool,
            (seed or 'x_feed_')
                .. tostring(card.sort_id or 0)
                .. '_'
                .. tostring(i)
        )

        if target then
            BM.feed(target, 1)
            fed = fed + 1

            for j = #pool, 1, -1 do
                if pool[j] == target then
                    table.remove(pool, j)
                    break
                end
            end
        end
    end

    return fed
end

BM.x_antibody_effects.terriermon =
function(card, context, base)
    local played = context.other_card

    if context.individual
    and context.cardarea == G.play
    and played
    and not context.blueprint then
        if BM.card_has_rank(played, 8)
        or BM.card_has_rank(played, 10)
        or BM.is_face(played) then
            if SMODS.pseudorandom_probability(
                card,
                'x_terriermon',
                1,
                2
            ) then
                if BM.add_consumable('Tarot') then
                    return {
                        mult = 10,
                        message = 'Tarot!'
                    }
                end
            end
        end
    end
end

BM.x_antibody_effects.rapidmon =
function(card, context, base)
    local e = card.ability.extra

    if context.setting_blind
    and context.main_eval
    and not context.blueprint then
        e.x_rapidmon_first_discard_seen = false
        e.x_rapidmon_destroy_ids = nil
        e.x_rapidmon_paid = false
    end

    if context.pre_discard
    and context.main_eval
    and not context.blueprint
    and not e.x_rapidmon_first_discard_seen then
        e.x_rapidmon_first_discard_seen = true
        e.x_rapidmon_destroy_ids = nil
        e.x_rapidmon_paid = false

        local highlighted =
            G.hand
            and G.hand.highlighted
            or {}

        if #highlighted == 2 then
            e.x_rapidmon_destroy_ids = {}

            for _, played in ipairs(highlighted) do
                e.x_rapidmon_destroy_ids[
                    x_card_id(played)
                ] = true
            end
        end
    end

    if context.discard
    and context.other_card
    and e.x_rapidmon_destroy_ids
    and not context.blueprint then
        local id =
            x_card_id(context.other_card)

        if e.x_rapidmon_destroy_ids[id] then
            e.x_rapidmon_destroy_ids[id] = nil

            local result = {
                remove = true
            }

            if not e.x_rapidmon_paid then
                e.x_rapidmon_paid = true
                result.dollars = 9
                result.message = '$9'
            end

            return result
        end
    end
end

BM.x_antibody_effects.garudamon =
function(card, context, base)
    if not context.individual
    or context.cardarea ~= G.play
    or not context.other_card then
        return
    end

    local played = context.other_card
    local result = {}
    local triggered = false

    if BM.card_has_suit(played, 'Hearts')
    and SMODS.pseudorandom_probability(
        card,
        'x_garudamon_bloodstone',
        1,
        2
    ) then
        result.xmult = 1.5
        triggered = true
    end

    if BM.card_has_suit(played, 'Spades') then
        result.chips = 50
        triggered = true
    end

    if BM.card_has_suit(played, 'Clubs') then
        result.mult = 7
        triggered = true
    end

    if BM.card_has_suit(played, 'Diamonds') then
        result.dollars = 1
        triggered = true
    end

    if triggered then
        return result
    end
end

BM.x_antibody_effects.phoenixmon =
function(card, context, base)
    if context.blind_defeated
    and BM.is_boss()
    and not context.blueprint
    and G.jokers then
        local pool = {}

        for _, joker in ipairs(
            G.jokers.cards or {}
        ) do
            if joker ~= card then
                pool[#pool + 1] = joker
            end
        end

        if #pool == 0 then
            return
        end

        local target =
            BM.random_element(
                pool,
                'x_phoenixmon_'
                    .. tostring(
                        card.sort_id or 0
                    )
            )

        if not target then
            return
        end

        local copy =
            copy_card(
                target,
                nil
            )

        if not copy then
            return
        end

        copy:set_edition(
            {
                negative = true
            },
            true
        )

        copy:add_to_deck()
        G.jokers:emplace(copy)

        return {
            message = 'Reborn!',
            colour = G.C.DARK_EDITION
        }
    end
end

BM.x_antibody_effects.keramon =
function(card, context, base)
    if context.joker_main then
        local empty =
            BM.empty_joker_slots({
                keramon = true
            })

        return {
            xmult = empty * 2
        }
    end
end

BM.x_antibody_effects.palmon =
function(card, context, base)
    if context.joker_main then
        return {
            xmult =
                1
                + 0.25
                * BM.count_food()
        }
    end

    return BM._run_effect_without_x(
        'tanemon',
        card,
        context
    )
end

BM.x_antibody_effects.togemon =
function(card, context, base)
    if context.joker_main then
        BM.emult(
            card,
            1
                + 0.1
                * BM.count_food()
        )
    end

    return BM._run_effect_without_x(
        'tanemon',
        card,
        context
    )
end

BM.x_antibody_effects.lillymon =
function(card, context, base)
    local inherited =
        BM.x_antibody_effects.togemon(
            card,
            context,
            base
        )

    if context.end_of_round
    and context.main_eval
    and not context.blueprint then
        local fed =
            x_feed_random_digimon(
                card,
                2,
                'x_lillymon_feed_'
            )

        if fed > 0 then
            return {
                message = 'Fed!'
            }
        end
    end

    return inherited
end

BM.x_antibody_effects.rosemon =
function(card, context, base)
    return BM.x_antibody_effects.lillymon(
        card,
        context,
        base
    )
end

BM.x_antibody_effects.kuwagamon =
function(card, context, base)
    if context.before
    and context.main_eval
    and not context.blueprint
    and (
        context.scoring_name == 'Straight Flush'
        or context.scoring_name == 'Flush Five'
    ) then
        local made = 0

        for _ = 1, 2 do
            if BM.add_consumable(
                'Spectral',
                nil,
                'e_negative'
            ) then
                made = made + 1
            end
        end

        if made > 0 then
            return {
                message =
                    made == 2
                    and '2 Negative Spectrals!'
                    or 'Negative Spectral!',
                colour = G.C.PURPLE
            }
        end
    end
end

BM.x_antibody_effects.okuwamon =
function(card, context, base)
    if context.before
    and context.main_eval
    and not context.blueprint
    and x_most_played_hand(
        context.scoring_name
    ) then
        if BM.add_consumable(
            'Spectral',
            nil,
            'e_negative'
        ) then
            return {
                message = 'Negative Spectral!',
                colour = G.C.PURPLE
            }
        end
    end
end

BM.x_antibody_effects.herculeskabuterimon =
function(card, context, base)
    local kuwagamon =
        BM.x_antibody_effects.kuwagamon(
            card,
            context,
            base
        )

    local okuwamon =
        BM.x_antibody_effects.okuwamon(
            card,
            context,
            base
        )

    return okuwamon or kuwagamon
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

    if BM.discover_x_antibody then
        BM.discover_x_antibody(
            BM.get_card_slug(card)
        )
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

    if BM.discover_x_antibody then
        BM.discover_x_antibody(
            BM.get_card_slug(card)
        )
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

tokomon = {
    name = 'Tokomon X',
    stage = 'In-Training',

    text = {
        'All cards played in the',
        '{C:attention}first hand{} of round become',
        '{C:attention}Lucky Cards{}'
    }
},

pegasusmon = {
    name = 'Pegasusmon X',
    stage = 'Champion',

    text = {
        'When a {C:attention}Lucky Card{} successfully triggers,',
        'it gives {X:mult,C:white}X2{} Mult',
        'Also applies {C:attention}Pegasusmon{} effect'
    }
},

salamon = {
    name = 'Salamon X',
    stage = 'Rookie',

    text = {
        'The first {C:attention}2{} cards played in the',
        'first hand of round become',
        '{C:attention}Glass Cards{}'
    }
},

gatomon = {
    name = 'Gatomon X',
    stage = 'Champion',

    text = {
        'All cards played in the',
        '{C:attention}first hand{} of round become',
        '{C:attention}Glass Cards{}'
    }
},

nefertimon = {
    name = 'Nefertimon X',
    stage = 'Champion',

    text = {
        'Scoring {C:attention}Glass Cards{} give',
        '{X:chips,C:white}X1.25{} Chips',
        'Also applies {C:attention}Nefertimon{} effect'
    }
},

angewomon = {
    name = 'Angewomon X',
    stage = 'Ultimate',

    text = {
        'Gain {X:mult,C:white}^0.069{} Mult every time',
        'a {C:attention}Glass Card{} breaks',
        '{C:inactive}(Carries 1/100 of Angewomon growth){}',
        '{C:inactive}(Currently {X:mult,C:white}^#4#{C:inactive} Mult){}'
    }
},

magnadramon = {
    name = 'Magnadramon X',
    stage = 'Mega',

    text = {
        'Scoring {C:attention}Glass Cards{} additionally give',
        '{X:mult,C:white}X3{} Mult'
    }
},

ladydevimon = {
    name = 'LadyDevimon X',
    stage = 'Ultimate',

    text = {
        'Triggered {C:attention}Steel Cards{} give',
        '{C:money}$3{}'
    }
},

myotismon = {
    name = 'Myotismon X',
    stage = 'Ultimate',

    text = {
        'Each {C:attention}Steel Card{} in deck gives',
        '{X:mult,C:white}^0.05{} Mult',
        '{C:inactive}(Currently {X:mult,C:white}^#4#{C:inactive} Mult){}'
    }
},

renamon = {
    name = 'Renamon X',
    stage = 'Rookie',

    text = {
        'Earn {C:money}$6{} for each discarded {V:1}#4#{}',
        '{C:inactive}(suit changes at end of round){}'
    }
},

sakuyamon = {
    name = 'Sakuyamon X',
    stage = 'Mega',

    text = {
        'Gain {X:mult,C:white}^0.1{} Mult for every',
        '{C:money}$10{} owned',
        'Earn {C:money}$6{} for each discarded {V:1}#4#{}',
        '{C:inactive}(suit changes at end of round){}',
        '{C:inactive}(Currently {X:mult,C:white}^#5#{C:inactive} Mult){}'
    }
},

terriermon = {
    name = 'Terriermon X',
    stage = 'Rookie',

    text = {
        '{C:green}1 in 2{} chance for each played',
        '{C:attention}8{}, {C:attention}10{} and {C:attention}face card{}',
        'to create a {C:tarot}Tarot{} card when scored',
        'Successful creation also gives {C:mult}+10{} Mult'
    }
},

rapidmon = {
    name = 'Rapidmon X',
    stage = 'Ultimate',

    text = {
        'If the first discard of round has',
        'exactly {C:attention}2{} cards, destroy both',
        'and earn {C:money}$9{}'
    }
},

garudamon = {
    name = 'Garudamon X',
    stage = 'Ultimate',

    text = {
        'Has the effects of {C:attention}Bloodstone{},',
        '{C:attention}Arrowhead{}, {C:attention}Onyx Agate{} and',
        '{C:attention}Rough Gem{} simultaneously'
    }
},

phoenixmon = {
    name = 'Phoenixmon X',
    stage = 'Mega',

    text = {
        'When a {C:attention}Boss Blind{} is defeated,',
        'create a {C:dark_edition}Negative{} copy',
        'of a random other Joker'
    }
},

keramon = {
    name = 'Keramon X',
    stage = 'Rookie',

    text = {
        '{X:mult,C:white}X2{} Mult for every empty Joker slot',
        '{C:inactive}(Keramon is ignored when counting occupied slots){}'
    }
},

palmon = {
    name = 'Palmon X',
    stage = 'Rookie',

    text = {
        'Each {C:attention}Food{} and {C:attention}Hefty Food{} gives',
        '{X:mult,C:white}X0.25{} Mult',
        'Also applies {C:attention}Tanemon{} effect'
    }
},

togemon = {
    name = 'Togemon X',
    stage = 'Champion',

    text = {
        'Each {C:attention}Food{} and {C:attention}Hefty Food{} gives',
        '{X:mult,C:white}^0.1{} Mult',
        'Also applies {C:attention}Tanemon{} effect'
    }
},

lillymon = {
    name = 'Lillymon X',
    stage = 'Ultimate',

    text = {
        'At the end of round, feed',
        '{C:attention}2{} random other Digimon',
        'Also applies {C:attention}Togemon X{} effect'
    }
},

rosemon = {
    name = 'Rosemon X',
    stage = 'Mega',

    text = {
        'Applies {C:attention}Lillymon X{} effect'
    }
},

kuwagamon = {
    name = 'Kuwagamon X',
    stage = 'Champion',

    text = {
        'If played poker hand is a {C:attention}Straight Flush{}',
        'or {C:attention}Flush Five{}, create',
        '{C:attention}2{} random {C:dark_edition}Negative{}',
        '{C:spectral}Spectral{} cards',
        '{C:inactive}(Must have room){}'
    }
},

okuwamon = {
    name = 'Okuwamon X',
    stage = 'Ultimate',

    text = {
        'If played hand is one of your',
        'most played poker hands, create a',
        '{C:dark_edition}Negative{} {C:spectral}Spectral{} card',
        '{C:inactive}(Must have room){}'
    }
},

herculeskabuterimon = {
    name = 'HerculesKabuterimon X',
    stage = 'Mega',

    text = {
        'Also applies {C:attention}Kuwagamon X{} and',
        '{C:attention}Okuwamon X{} effects'
    }
},
magnamon = {
    name = 'Magnamon X',
    stage = 'Champion',
    text = {
        'Whenever a card is {C:attention}retriggered{},',
        'retrigger it {C:attention}1 additional time{}',
        'Each retrigger gives',
        '{X:mult,C:white}X1.5{} Mult'
    }
},

omegamon = {
    name = 'Omegamon X',
    stage = 'Beyond',
    text = {
        '{C:attention}#4#{} of {V:1}#5#{} gives',
        '{X:mult,C:white}^1.15{} Mult when triggered',
        '{C:inactive}(card changes at end of round){}'
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
                local info_queue_start =
                    info_queue
                    and #info_queue
                    or 0

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

                    elseif slug == 'angewomon' then
                        result.vars[4] =
                            e.x_angewomon_emult
                            or (
                                1
                                + math.max(
                                    0,
                                    (e.xmult or 1) - 1
                                ) / 100
                            )

                    elseif slug == 'myotismon' then
                        result.vars[4] =
                            1
                            + 0.05
                            * BM.count_deck_enhancement(
                                'm_steel'
                            )

                    elseif slug == 'renamon' then
                        local target_suit =
                            BM.ensure_shared_target(
                                'x_renamon_family_suit',
                                BM.deck_suits(),
                                'x_renamon_suit'
                            )

                        result.vars[4] =
                            target_suit

                        result.vars.colours = {
                            (
                                G.C.SUITS
                                and G.C.SUITS[
                                    target_suit
                                ]
                            )
                            or G.C.FILTER
                        }

                    elseif slug == 'sakuyamon' then
                        if info_queue then
                            while #info_queue
                            > info_queue_start do
                                table.remove(
                                    info_queue
                                )
                            end
                        end

                        local target_suit =
                            BM.ensure_shared_target(
                                'x_renamon_family_suit',
                                BM.deck_suits(),
                                'x_renamon_suit'
                            )

                        result.vars[4] =
                            target_suit

                        result.vars[5] =
                            x_money_emult()

                        result.vars.colours = {
                            (
                                G.C.SUITS
                                and G.C.SUITS[
                                    target_suit
                                ]
                            )
                            or G.C.FILTER
                        }
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
    },
    tokomon = {
        pos = {x = 2, y = 2}
    },

    pegasusmon = {
        pos = {x = 3, y = 2}
    },

    salamon = {
        pos = {x = 4, y = 2}
    },

    gatomon = {
        pos = {x = 5, y = 2}
    },

    nefertimon = {
        pos = {x = 6, y = 2}
    },

    angewomon = {
        pos = {x = 7, y = 2}
    },

    magnadramon = {
        pos = {x = 8, y = 2}
    },

    ladydevimon = {
        pos = {x = 9, y = 2}
    },

    myotismon = {
        pos = {x = 0, y = 3}
    },

    renamon = {
        pos = {x = 1, y = 3}
    },

    sakuyamon = {
        pos = {x = 2, y = 3}
    },

    terriermon = {
        pos = {x = 3, y = 3}
    },

    rapidmon = {
        pos = {x = 4, y = 3}
    },

    garudamon = {
        pos = {x = 5, y = 3}
    },

    phoenixmon = {
        pos = {x = 6, y = 3}
    },

    keramon = {
        pos = {x = 7, y = 3}
    },

    palmon = {
        pos = {x = 8, y = 3}
    },

    togemon = {
        pos = {x = 9, y = 3}
    },

    lillymon = {
        pos = {x = 0, y = 4}
    },

    rosemon = {
        pos = {x = 1, y = 4}
    },

    kuwagamon = {
        pos = {x = 2, y = 4}
    },

    okuwamon = {
        pos = {x = 3, y = 4}
    },

    herculeskabuterimon = {
        pos = {x = 4, y = 4}
    },
    magnamon = {
        pos = {x = 0, y = 5}
    },

    omegamon = {
        pos = {x = 1, y = 5}
    },
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

BM.x_antibody_effects.magnamon =
function(card, context, base)
    local base_result =
        base()

    if context.individual
    and (
        context.cardarea == G.play
        or context.cardarea == G.hand
    )
    and context.other_card
    and context.other_card.repetition_trigger then
        return {
            xmult = 1.5
        }
    end

    return base_result
end

BM.x_antibody_effects.omegamon =
function(card, context, base)
    local e = card.ability.extra

    e.target_rank,
    e.target_suit =
        BM.ensure_shared_card_target(
            'omegamon_card',
            'omegamon_card'
        )

    if context.individual
    and context.cardarea == G.play
    and BM.card_matches_target(
        context.other_card,
        e.target_rank,
        e.target_suit
    ) then
        BM.emult(
            card,
            1.15
        )
    end

    if context.end_of_round then
        return base()
    end
end

