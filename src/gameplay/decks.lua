local BM = Balatromon

local lineage_cache = {}

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

local function get_lineage(root)
    root = BM.slug(root)

    if lineage_cache[root] then
        return lineage_cache[root]
    end

    local found = {}
    local visiting = {}

    local function walk(slug)
        slug = BM.slug(slug)

        if not slug
        or visiting[slug] then
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
    end

    walk(root)

    lineage_cache[root] =
        found

    return found
end

local function lineage_progress(root)
    local discovered = 0
    local total = 0

    for slug in pairs(
        get_lineage(root)
    ) do
        local center =
            G.P_CENTERS
            and G.P_CENTERS[
                BM.center_key(slug)
            ]

        if center then
            total = total + 1

            if center.discovered then
                discovered =
                    discovered + 1
            end
        end
    end

    return discovered, total
end

local function half_line_discovered(root)
    local discovered,
        total =
        lineage_progress(root)

    return total > 0
        and discovered
        >= math.ceil(total / 2)
end

local function owned_mega_count()
    local count = 0

    for _, card in ipairs(
        G.jokers
        and G.jokers.cards
        or {}
    ) do
        if BM.is_digimon(card) then
            local slug =
                BM.get_card_slug(card)

            local def =
                slug
                and BM.joker_defs
                and BM.joker_defs[slug]

            if def
            and def.stage == 'Mega' then
                count = count + 1
            end
        end
    end

    return count
end

local function queue_starting_loadout(entries)
    G.E_MANAGER:add_event(
        Event({
            func = function()
                if not G.jokers
                or not G.consumeables then
                    return false
                end

                for _, entry in ipairs(
                    entries
                ) do
                    local args = {}

                    for key, value in pairs(
                        entry
                    ) do
                        if key ~= 'target_area' then
                            args[key] =
                                value
                        end
                    end

                    if entry.target_area
                        == 'jokers' then
                        args.area =
                            G.jokers
                    else
                        args.area =
                            G.consumeables
                    end

                    SMODS.add_card(args)
                end

                return true
            end
        })
    )
end

local function line_locked_loc_vars(root)
    return function(
        self,
        info_queue,
        card
    )
        local discovered,
            total =
            lineage_progress(root)

        return {
            vars = {
                discovered,
                total
            }
        }
    end
end

local function line_check_for_unlock(root)
    return function(
        self,
        args
    )
        return
            half_line_discovered(root)
    end
end

SMODS.Back {
    key = 'digidestined',

    atlas = 'Deck',
    pos = {
        x = 0,
        y = 0
    },

    unlocked = false,
    discovered = true,

    config = {
        hand_size = -1
    },

    loc_txt = {
        name = 'Digidestined Deck',

        text = {
            'Start with a {C:spectral}Golden Digitama{}',
            'and {C:attention}2{} {C:dark_edition}Negative{} {C:attention}Hefty Food{}',
            '{C:red}-1{} hand size'
        },

        unlock = {
            'Own {C:attention}2 Mega{} Digimon',
            'at the same time during a run'
        }
    },

    check_for_unlock =
    function(self, args)
        return
            owned_mega_count()
            >= 2
    end,

    apply =
    function(self, back)
        queue_starting_loadout({
            {
                set = 'DigiItem',

                key =
                    'c_'
                    .. BM.PREFIX
                    .. '_hefty_food',

                edition =
                    'e_negative',

                key_append =
                    'balatromon_digidestined_hefty_1',

                target_area =
                    'consumeables'
            },

            {
                set = 'DigiItem',

                key =
                    'c_'
                    .. BM.PREFIX
                    .. '_hefty_food',

                edition =
                    'e_negative',

                key_append =
                    'balatromon_digidestined_hefty_2',

                target_area =
                    'consumeables'
            },

            {
                set = 'Spectral',

                key =
                    'c_'
                    .. BM.PREFIX
                    .. '_golden_digitama',

                key_append =
                    'balatromon_digidestined_golden_digitama',

                target_area =
                    'consumeables'
            }
        })
    end
}

SMODS.Back {
    key = 'courage',

    atlas = 'Deck',
    pos = {
        x = 1,
        y = 0
    },

    unlocked = false,
    discovered = true,

    config = {
        balatromon_ante_8_boss =
            'cowardice'
    },

    loc_txt = {
        name = 'Courage Deck',

        text = {
            'Start with {C:attention}Tai{} and {C:attention}Koromon{}',
            'Face {C:attention}Cowardice{} on {C:attention}Ante 8{}'
        },

        unlock = {
            'Discover {C:attention}50%{} of the',
            '{C:attention}Botamon Line{}',
            '{C:inactive}(#1#/#2# discovered){}'
        }
    },

    locked_loc_vars =
        line_locked_loc_vars(
            'botamon'
        ),

    check_for_unlock =
        line_check_for_unlock(
            'botamon'
        ),

    apply =
    function(self, back)
        queue_starting_loadout({
            {
                set = 'Tamer',

                key =
                    'c_'
                    .. BM.PREFIX
                    .. '_tai',

                force_stickers  = {'eternal'},

                key_append =
                    'balatromon_courage_tai',

                target_area =
                    'consumeables'
            },

            {
                set = 'Joker',

                key =
                    BM.center_key(
                        'koromon'
                    ),

                key_append =
                    'balatromon_courage_koromon',

                target_area =
                    'jokers'
            }
        })
    end
}

SMODS.Back {
    key = 'friendship',

    atlas = 'Deck',
    pos = {
        x = 2,
        y = 0
    },

    unlocked = false,
    discovered = true,

    config = {
        balatromon_ante_8_boss =
            'hostility'
    },

    loc_txt = {
        name = 'Friendship Deck',

        text = {
            'Start with {C:attention}Matt{} and {C:attention}Tsunomon{}',
            'Face {C:attention}Hostility{} on {C:attention}Ante 8{}'
        },

        unlock = {
            'Discover {C:attention}50%{} of the',
            '{C:attention}Punimon Line{}',
            '{C:inactive}(#1#/#2# discovered){}'
        }
    },

    locked_loc_vars =
        line_locked_loc_vars(
            'punimon'
        ),

    check_for_unlock =
        line_check_for_unlock(
            'punimon'
        ),

    apply =
    function(self, back)
        queue_starting_loadout({
            {
                set = 'Tamer',

                key =
                    'c_'
                    .. BM.PREFIX
                    .. '_matt',

                force_stickers  = {'eternal'},

                key_append =
                    'balatromon_friendship_matt',

                target_area =
                    'consumeables'
            },

            {
                set = 'Joker',

                key =
                    BM.center_key(
                        'tsunomon'
                    ),

                key_append =
                    'balatromon_friendship_tsunomon',

                target_area =
                    'jokers'
            }
        })
    end
}

SMODS.Back {
    key = 'sincerity',

    atlas = 'Deck',
    pos = {
        x = 3,
        y = 0
    },

    unlocked = false,
    discovered = true,

    config = {
        balatromon_ante_8_boss =
            'two_faced'
    },

    loc_txt = {
        name = 'Sincerity Deck',

        text = {
            'Start with {C:attention}Mimi{} and {C:attention}Tanemon{}',
            'Face {C:attention}Two-Faced{} on {C:attention}Ante 8{}'
        },

        unlock = {
            'Discover {C:attention}50%{} of the',
            '{C:attention}Yuramon Line{}',
            '{C:inactive}(#1#/#2# discovered){}'
        }
    },

    locked_loc_vars =
        line_locked_loc_vars(
            'yuramon'
        ),

    check_for_unlock =
        line_check_for_unlock(
            'yuramon'
        ),

    apply =
    function(self, back)
        queue_starting_loadout({
            {
                set = 'Tamer',

                key =
                    'c_'
                    .. BM.PREFIX
                    .. '_mimi',

                force_stickers  = {'eternal'},

                key_append =
                    'balatromon_sincerity_mimi',

                target_area =
                    'consumeables'
            },

            {
                set = 'Joker',

                key =
                    BM.center_key(
                        'tanemon'
                    ),

                key_append =
                    'balatromon_sincerity_tanemon',

                target_area =
                    'jokers'
            }
        })
    end
}

if get_new_boss
and not BM._custom_deck_boss_wrapped then
    BM._custom_deck_boss_wrapped =
        true

    local old_get_new_boss =
        get_new_boss

    get_new_boss =
    function(...)
        local blind_type =
            select(
                1,
                ...
            )

        if blind_type ~= nil
        and tostring(
            blind_type
        ):lower() ~= 'boss' then
            return
                old_get_new_boss(...)
        end

        local config =
            G.GAME
            and G.GAME.selected_back
            and G.GAME.selected_back.effect
            and G.GAME.selected_back.effect.config

        local forced =
            config
            and config.balatromon_ante_8_boss

        if forced
        and G.GAME
        and G.GAME.round_resets
        and G.GAME.round_resets.ante == 8 then
            local key =
                'bl_'
                .. BM.PREFIX
                .. '_'
                .. forced

            if G.P_BLINDS
            and G.P_BLINDS[key] then
                if SMODS.add_boss_to_used_table then
                    SMODS.add_boss_to_used_table(
                        key,
                        'boss'
                    )

                elseif G.GAME.bosses_used then
                    if type(
                        G.GAME.bosses_used.boss
                    ) == 'table' then

                        G.GAME.bosses_used
                            .boss[key] =
                            (
                                G.GAME.bosses_used
                                    .boss[key]
                                or 0
                            )
                            + 1

                    else
                        G.GAME.bosses_used[key] =
                            (
                                G.GAME.bosses_used[key]
                                or 0
                            )
                            + 1
                    end
                end

                return key
            end
        end

        return
            old_get_new_boss(...)
    end
end

if end_round and not BM._crest_deck_ante7_boss_tag_wrapped then
    BM._crest_deck_ante7_boss_tag_wrapped = true

    local old_end_round = end_round

    end_round = function(...)
        local give_boss_tag = false

        if G.GAME
        and G.GAME.round_resets
        and G.GAME.round_resets.ante == 7
        and G.GAME.blind
        and G.GAME.blind.boss then

            local config =
                G.GAME.selected_back
                and G.GAME.selected_back.effect
                and G.GAME.selected_back.effect.config

            if config
            and config.balatromon_ante_8_boss then
                give_boss_tag = true
            end
        end

        if give_boss_tag then
            add_tag(Tag('tag_boss'))
        end

        return old_end_round(...)
    end
end