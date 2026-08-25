local BM = Balatromon

BM.TAMER_RATE = BM.TAMER_RATE or 0.003
BM.TAMER_MATT_DENOMINATOR = BM.TAMER_MATT_DENOMINATOR or 4
BM.TAMER_PRIMARY_COLOUR = BM.TAMER_PRIMARY_COLOUR or HEX('D8A3FF')
BM.TAMER_SECONDARY_COLOUR = BM.TAMER_SECONDARY_COLOUR or HEX('6E4FB3')

BM.tamer_keys = BM.tamer_keys or {}

local TAMER_SHADER_KEY =
    BM.PREFIX .. '_tamer_prismatic'

SMODS.Shader {
    key = 'tamer_prismatic',
    path = 'tamer_prismatic.fs'
}

SMODS.DrawStep {
    key = 'tamer_prismatic',
    order = 15,
    conditions = {
        facing = 'front'
    },

    func = function(card, layer)
        if not BM.is_tamer(card) then
            return
        end

        if not card.children
        or not card.children.center then
            return
        end

        card.children.center:draw_shader(
            TAMER_SHADER_KEY,
            nil,
            nil
        )
    end
}

SMODS.ConsumableType {
    key = 'Tamer',
    primary_colour = BM.TAMER_PRIMARY_COLOUR,
    secondary_colour = BM.TAMER_SECONDARY_COLOUR,
    loc_txt = {
        name = 'Tamer',
        collection = 'Tamers',
        undiscovered = {
            name = 'Unknown Tamer',
            text = {'Find this card in a Crest Pack'}
        }
    },
    collection_rows = {4, 4},
    shop_rate = 0
}

if SMODS.UndiscoveredSprite then
    SMODS.UndiscoveredSprite {
        key = 'Tamer',
        atlas = 'Tamer',
        pos = {x = 3, y = 1},
        no_overlay = true
    }
end



function BM.is_tamer(card)
    local center =
        card
        and card.config
        and card.config.center

    return center
        and center.balatromon_tamer == true
end

function BM.has_tamer(key)
    for _, card in ipairs(
        G.consumeables
        and G.consumeables.cards
        or {}
    ) do
        local center =
            card.config
            and card.config.center

        if center
        and center.balatromon_tamer
        and center.balatromon_tamer_key == key then
            return true
        end
    end

    return false
end

function BM.get_copyable_consumables()
    local out = {}

    for _, card in ipairs(
        G.consumeables
        and G.consumeables.cards
        or {}
    ) do
        if not BM.is_tamer(card) then
            out[#out + 1] = card
        end
    end

    return out
end

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

local lineage_graph_cache = {}

local lineage_root_cache = {
    normal = {},
    x = {}
}

local function build_reverse_graph(include_x)
    local cache_key =
        include_x and 'x' or 'normal'

    if lineage_graph_cache[cache_key] then
        return lineage_graph_cache[cache_key]
    end

    local reverse = {}

    local function add_edge(source, target)
        if not source
        or not target then
            return
        end

        reverse[target] =
            reverse[target] or {}

        for _, existing in ipairs(
            reverse[target]
        ) do
            if existing == source then
                return
            end
        end

        reverse[target][
            #reverse[target] + 1
        ] = source
    end

    for source, def in pairs(
        BM.joker_defs or {}
    ) do
        for _, target in ipairs(
            split_targets(
                def.evolves_to
            )
        ) do
            add_edge(
                source,
                target
            )
        end
    end

    if include_x then
        for source, targets in pairs(
            BM.x_antibody_extra_evolutions
            or {}
        ) do
            for _, target in ipairs(
                targets or {}
            ) do
                add_edge(
                    BM.slug(source),
                    BM.slug(target)
                )
            end
        end
    end

    lineage_graph_cache[cache_key] =
        reverse

    return reverse
end

local function possible_fresh_roots(
    slug,
    include_x
)
    slug =
        BM.slug(slug or '')

    local cache_key =
        include_x and 'x' or 'normal'

    local cache =
        lineage_root_cache[cache_key]

    if cache[slug] then
        return cache[slug]
    end

    local reverse =
        build_reverse_graph(include_x)

    local found = {}
    local seen = {}

    local function walk(current)
        if seen[current] then
            return
        end

        seen[current] = true

        local def =
            BM.joker_defs
            and BM.joker_defs[current]

        if def
        and def.stage == 'Fresh' then
            found[current] = true
            return
        end

        for _, parent in ipairs(
            reverse[current]
            or {}
        ) do
            walk(parent)
        end
    end

    walk(slug)

    local roots = {}

    for root in pairs(found) do
        roots[#roots + 1] = root
    end

    table.sort(roots)

    cache[slug] = roots

    return roots
end

function BM.get_tamer_lineages(card)
    if not BM.is_digimon(card) then
        return {}
    end

    local slug =
        BM.get_card_slug(card)

    if not slug then
        return {}
    end

    local include_x =
        BM.has_x_antibody
        and BM.has_x_antibody(card)
        or false

    return possible_fresh_roots(
        slug,
        include_x
    )
end

function BM.tamer_card_in_lineage(
    card,
    root
)
    root = BM.slug(root)

    for _, lineage in ipairs(
        BM.get_tamer_lineages(card)
    ) do
        if lineage == root then
            return true
        end
    end

    return false
end
local function retriggerable_digimon_context(
    context
)
    if not context
    or context.retrigger_joker then
        return false
    end

    if context.end_of_round
    or context.setting_blind
    or context.ending_shop
    or context.using_consumeable
    or context.discard
    or context.pre_discard
    or context.first_hand_drawn
    or context.selling_card
    or context.selling_self
    or context.buying_card
    or context.open_booster
    or context.skipping_booster
    or context.reroll_shop then
        return false
    end

    return
        context.joker_main
        or context.before
        or context.after
        or context.individual
        or context.repetition
        or context.remove_playing_cards
        or context.destroying_card
end

local function tamer_calculate(
    root,
    effect
)
    return function(
        self,
        card,
        context
    )
        if context.retrigger_joker_check
        and context.other_card
        and BM.is_digimon(
            context.other_card
        )
        and BM.tamer_card_in_lineage(
            context.other_card,
            root
        )
        and retriggerable_digimon_context(
            context.other_context
        ) then
            return {
                repetitions = 1,
                message = 'Go!'
            }
        end

        if effect then
            return effect(
                card,
                context
            )
        end
    end
end



local function tai_effect(
    card,
    context
)
    if context.before
    and context.main_eval
    and not context.retrigger_joker
    and (
        G.GAME.current_round
        .hands_played
        or 0
    ) == 0
    and context.scoring_name
        == 'Pair'
    and context.full_hand
    and #context.full_hand >= 2 then

        local leftmost =
            context.full_hand[1]

        local rightmost =
            context.full_hand[
                #context.full_hand
            ]

        if leftmost
        and rightmost
        and leftmost ~= rightmost then
            copy_card(
                rightmost,
                leftmost
            )

            leftmost:juice_up(
                0.8,
                0.5
            )

            return {
                message = 'Copied!'
            }
        end
    end
end

local function matt_effect(
    card,
    context
)
    if context.discard
    and context.other_card
    and not context.retrigger_joker
    and not context.other_card.edition
    and SMODS.pseudorandom_probability(
        card,
        'balatromon_tamer_matt_'
        .. tostring(
            context.other_card.sort_id
            or 0
        ),
        1,
        BM.TAMER_MATT_DENOMINATOR
    ) then

        local edition =
            BM.random_element(
                {
                    'e_foil',
                    'e_holo'
                },
                'balatromon_tamer_matt_edition_'
                .. tostring(
                    context.other_card.sort_id
                    or 0
                )
            )

        context.other_card:set_edition(
            edition,
            true
        )

        return {
            message =
                edition == 'e_foil'
                and 'Foil!'
                or 'Holographic!'
        }
    end
end

local function consumable_set(card)
    if not card then
        return nil
    end

    if card.ability
    and card.ability.set then
        return card.ability.set
    end

    local center =
        card.config
        and card.config.center

    return
        center
        and center.set
        or nil
end

local function izzy_effect(
    card,
    context
)
    if not context.using_consumeable
    or not context.consumeable
    or context.retrigger_joker then
        return
    end

    local target =
        context.consumeable

    local set =
        consumable_set(target)

    if set == 'Spectral'
    or set == 'Tamer'
    or BM.is_tamer(target)
    or (
        target.edition
        and target.edition.negative
    ) then
        return
    end

    if not G.consumeables then
        return
    end

    G.E_MANAGER:add_event(
        Event({
            trigger = 'after',
            delay = 0.1,

            func = function()
                local copy =
                    copy_card(
                        target,
                        nil
                    )

                if not copy then
                    return true
                end

                copy:set_edition(
                    {
                        negative = true
                    },
                    true
                )

                copy:add_to_deck()

                G.consumeables:emplace(
                    copy
                )

                return true
            end
        })
    )

    return {
        message = 'Copied!'
    }
end

local function sora_effect(
    card,
    context
)
    if context.setting_blind
    and context.main_eval
    and not context.retrigger_joker then

        ease_hands_played(4)

        local discards =
            G.GAME.current_round
            .discards_left
            or 0

        if discards > 0 then
            ease_discard(
                -discards
            )
        end

        return {
            message = '+4 Hands'
        }
    end
end

local function joe_effect(
    card,
    context
)
    if context.setting_blind
    and context.main_eval
    and not context.retrigger_joker then
        G.GAME.balatromon_joe_hand = nil
        return
    end

    if context.before
    and context.main_eval
    and not context.retrigger_joker
    and (
        G.GAME.current_round
        .hands_played
        or 0
    ) == 0
    and context.scoring_name then
        G.GAME.balatromon_joe_hand =
            context.scoring_name

        return {
            message =
                context.scoring_name
        }
    end

    if context.evaluate_poker_hand
    and G.GAME.balatromon_joe_hand
    and (
        G.GAME.current_round
        .hands_played
        or 0
    ) > 0 then
        return {
            replace_scoring_name =
                G.GAME.balatromon_joe_hand,

            replace_display_name =
                G.GAME.balatromon_joe_hand
        }
    end
end

local function hungry_digimon_count()
    local count = 0

    for _, joker in ipairs(
        G.jokers
        and G.jokers.cards
        or {}
    ) do
        if BM.is_digimon(joker)
        and joker.ability
        and joker.ability.extra
        and (
            joker.ability.extra.hunger
            or 1
        ) == 1 then
            count = count + 1
        end
    end

    return count
end

local function mimi_effect(
    card,
    context
)
    if context.joker_main
    and not context.retrigger_joker then

        local count =
            hungry_digimon_count()

        if count > 0 then
            return {
                xmult =
                    1 + count
            }
        end
    end
end

local RANDOM_ENHANCEMENTS = {
    'm_bonus',
    'm_mult',
    'm_wild',
    'm_glass',
    'm_steel',
    'm_stone',
    'm_gold',
    'm_lucky'
}

local function tk_effect(
    card,
    context
)
    if context.before
    and context.main_eval
    and not context.retrigger_joker
    and (
        G.GAME.current_round
        .hands_left
        or 0
    ) == 0 then

        local changed = false

        for _, played in ipairs(
            context.full_hand or {}
        ) do
            local enhancement =
                BM.random_element(
                    RANDOM_ENHANCEMENTS,
                    'balatromon_tamer_tk_'
                    .. tostring(
                        played.sort_id
                        or 0
                    )
                    .. '_'
                    .. tostring(
                        G.GAME.round_resets
                        .ante
                        or 0
                    )
                )

            if enhancement then
                BM.set_enhancement(
                    played,
                    enhancement
                )

                changed = true
            end
        end

        if changed then
            return {
                message =
                    'Enhanced!'
            }
        end
    end
end

local function kari_effect(
    card,
    context
)
    if context.before
    and context.main_eval
    and not context.retrigger_joker
    and (
        G.GAME.current_round
        .hands_left
        or 0
    ) == 0 then

        local protected = false

        for _, played in ipairs(
            context.full_hand or {}
        ) do
            local center =
                played.config
                and played.config.center

            if center
            and center.key == 'm_glass'
            and played.ability
            and played.ability
                ._balatromon_kari_glass_extra
                == nil then

                played.ability
                    ._balatromon_kari_glass_extra =
                    played.ability.extra

                played.ability.extra =
                    math.huge

                protected = true
            end
        end

        if protected then
            return {
                message =
                    'Protected!'
            }
        end
    end

    if context.after
    and context.main_eval
    and not context.retrigger_joker then

        for _, played in ipairs(
            context.full_hand or {}
        ) do
            if played.ability
            and played.ability
                ._balatromon_kari_glass_extra
                ~= nil then

                played.ability.extra =
                    played.ability
                    ._balatromon_kari_glass_extra

                played.ability
                    ._balatromon_kari_glass_extra =
                    nil
            end
        end
    end
end

local TAMERS = {
    {
        key = 'tai',
        name = 'Tai',
        pos = {
            x = 0,
            y = 0
        },
        root = 'botamon',
        effect = tai_effect,

        text = {
            {
                'If the {C:attention}first hand{} of the round is a {C:attention}Pair{},',
                'turn the {C:attention}leftmost{} played card',
                'into the {C:attention}rightmost{} played card'
            },
            {
                '{C:inactive}Passive:{} Retrigger all Digimon',
                'in the {C:attention}Botamon Line{} once'
            }
        }
    },

    {
        key = 'matt',
        name = 'Matt',
        pos = {
            x = 1,
            y = 0
        },
        root = 'punimon',
        effect = matt_effect,

        loc_vars = function(
            self,
            info_queue,
            card
        )
            return {
                vars = {
                    BM.TAMER_MATT_DENOMINATOR
                }
            }
        end,

        text = {
            {
                'Each discarded card has a {C:green}1 in #1#{} chance',
                'to become {C:attention}Foil{} or {C:attention}Holographic{}'
            },
            {
                '{C:inactive}Passive:{} Retrigger all Digimon',
                'in the {C:attention}Punimon Line{} once'
            }
        }
    },

    {
        key = 'izzy',
        name = 'Izzy',
        pos = {
            x = 2,
            y = 0
        },
        root = 'twins',
        effect = izzy_effect,

        text = {
            {
                'When a non-{C:dark_edition}Negative{} consumable is used,',
                'create a {C:dark_edition}Negative{} copy of it',
                '{C:inactive}(Does not work on Spectral or Tamer cards){}'
            },
            {
                '{C:inactive}Passive:{} Retrigger all Digimon in the',
                '{C:attention}Tsubumon & Pabumon Line{} once'
            }
        }
    },

    {
        key = 'sora',
        name = 'Sora',
        pos = {
            x = 3,
            y = 0
        },
        root = 'pururumon',
        effect = sora_effect,

        text = {
            {
                'At the start of the round,',
                'gain {C:blue}+4{} Hands and',
                'lose {C:red}all Discards{}'
            },
            {
                '{C:inactive}Passive:{} Retrigger all Digimon',
                'in the {C:attention}Pururumon Line{} once'
            }
        }
    },

    {
        key = 'joe',
        name = 'Joe',
        pos = {
            x = 4,
            y = 0
        },
        root = 'pichimon',
        effect = joe_effect,

        text = {
            {
                'All hands count as the',
                '{C:attention}first hand type{} played this round'
            },
            {
                '{C:inactive}Passive:{} Retrigger all Digimon',
                'in the {C:attention}Pichimon Line{} once'
            }
        }
    },

    {
        key = 'mimi',
        name = 'Mimi',
        pos = {
            x = 0,
            y = 1
        },
        root = 'yuramon',
        effect = mimi_effect,

        loc_vars = function(
            self,
            info_queue,
            card
        )
            return {
                vars = {
                    1
                    + hungry_digimon_count()
                }
            }
        end,

        text = {
            {
                'Gain {X:mult,C:white}X1{} Mult for every Digimon',
                'whose {C:attention}Hunger{} is at {C:attention}1/5{}',
                '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}'
            },
            {
                '{C:inactive}Passive:{} Retrigger all Digimon',
                'in the {C:attention}Yuramon Line{} once'
            }
        }
    },

    {
        key = 'tk',
        name = 'T.K.',
        pos = {
            x = 1,
            y = 1
        },
        root = 'poyomon',
        effect = tk_effect,

        text = {
            {
                'On the {C:attention}last hand{} of the round,',
                'apply a random {C:attention}Enhancement{}',
                'to every played card'
            },
            {
                '{C:inactive}Passive:{} Retrigger all Digimon',
                'in the {C:attention}Poyomon Line{} once'
            }
        }
    },

    {
        key = 'kari',
        name = 'Kari',
        pos = {
            x = 2,
            y = 1
        },
        root = 'yukimibotamon',
        effect = kari_effect,

        text = {
            {
                '{C:attention}Glass Cards{} are guaranteed',
                'to not break on the {C:attention}last hand{}'
            },
            {
                '{C:inactive}Passive:{} Retrigger all Digimon',
                'in the {C:attention}YukimiBotamon Line{} once'
            }
        }
    }
}

for _, def in ipairs(TAMERS) do
    SMODS.Consumable {
        set = 'Tamer',
        key = def.key,
        atlas = 'Tamer',
        pos = def.pos,

        discovered = false,
        unlocked = true,
        cost = 12,

        config = {
            extra = {}
        },

        select_card =
            'consumeables',

        can_repeat_soul =
            false,

        balatromon_tamer =
            true,

        balatromon_tamer_key =
            def.key,

        balatromon_tamer_root =
            def.root,

        balatromon_no_copy =
            true,

        loc_txt = {
            name = def.name,
            text = def.text
        },

        loc_vars =
            def.loc_vars,

        can_use = function(
            self,
            card
        )
            return false
        end,

        calculate =
            tamer_calculate(
                def.root,
                def.effect
            )
    }

    BM.tamer_keys[
        #BM.tamer_keys + 1
    ] =
        'c_'
        .. BM.PREFIX
        .. '_'
        .. def.key
end

function BM.get_available_tamer_keys()
    local blocked = {}

    for _, area in ipairs({
        G.consumeables,
        G.pack_cards
    }) do
        for _, card in ipairs(
            area
            and area.cards
            or {}
        ) do
            if BM.is_tamer(card) then
                local center =
                    card.config
                    and card.config.center

                if center
                and center.key then
                    blocked[
                        center.key
                    ] = true
                end
            end
        end
    end

    local out = {}

    for _, key in ipairs(
        BM.tamer_keys or {}
    ) do
        if not blocked[key] then
            out[#out + 1] = key
        end
    end

    return out
end

function BM.roll_crest_tamer(seed)
    local available =
        BM.get_available_tamer_keys()

    if #available == 0 then
        return nil
    end

    if pseudorandom(
        pseudoseed(
            seed .. '_roll'
        )
    ) >= BM.TAMER_RATE then
        return nil
    end

    return BM.random_element(
        available,
        seed .. '_pick'
    )
end

SMODS.Joker:take_ownership(
    'perkeo',
    {
        calculate =
        function(
            self,
            card,
            context
        )
            if context.ending_shop then
                local candidates =
                    BM.get_copyable_consumables()

                if #candidates == 0 then
                    return
                end

                local target =
                    pseudorandom_element(
                        candidates,
                        pseudoseed(
                            'perkeo'
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

                G.consumeables:emplace(
                    copy
                )

                return {
                    message =
                        'Copied!'
                }
            end
        end
    },
    true
)