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

local function line_source(root)
    return
        'balatromon_blind_line_'
        .. BM.slug(root)
end

local function apply_line_debuff(
    card,
    root
)
    if not digimon_in_line(
        card,
        root
    ) then
        return
    end

    SMODS.debuff_card(
        card,
        true,
        line_source(root)
    )
end

local function apply_line_to_all(root)
    for _, card in ipairs(
        G.jokers
        and G.jokers.cards
        or {}
    ) do
        apply_line_debuff(
            card,
            root
        )
    end
end

local function clear_line(root)
    local source =
        line_source(root)

    for _, card in ipairs(
        G.jokers
        and G.jokers.cards
        or {}
    ) do
        SMODS.debuff_card(
            card,
            false,
            source
        )
    end
end

local function line_set_blind(root)
    return function(self)
        apply_line_to_all(root)
    end
end

local function line_disable(root)
    return function(self)
        clear_line(root)
    end
end

local function line_defeat(root)
    return function(self)
        clear_line(root)
    end
end

local function line_recalc(root)
    return function(
        self,
        card,
        from_blind
    )
        if digimon_in_line(
            card,
            root
        ) then
            return true
        end
    end
end

local function line_calculate(root)
    return function(
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
        and context.card then
            apply_line_debuff(
                context.card,
                root
            )
        end
    end
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
            'becomes permanently {C:attention}Pinned{}'
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

    set_blind =
        line_set_blind(
            'botamon'
        ),

    calculate =
        line_calculate(
            'botamon'
        ),

    recalc_debuff =
        line_recalc(
            'botamon'
        ),

    disable =
        line_disable(
            'botamon'
        ),

    defeat =
        line_defeat(
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

    set_blind =
        line_set_blind(
            'punimon'
        ),

    calculate =
        line_calculate(
            'punimon'
        ),

    recalc_debuff =
        line_recalc(
            'punimon'
        ),

    disable =
        line_disable(
            'punimon'
        ),

    defeat =
        line_defeat(
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

    set_blind =
        line_set_blind(
            'yuramon'
        ),

    calculate =
        line_calculate(
            'yuramon'
        ),

    recalc_debuff =
        line_recalc(
            'yuramon'
        ),

    disable =
        line_disable(
            'yuramon'
        ),

    defeat =
        line_defeat(
            'yuramon'
        )
}