local BM = Balatromon

local sleeve_mod =
    SMODS
    and SMODS.Mods
    and SMODS.Mods['CardSleeves']

if not (
    sleeve_mod
    and sleeve_mod.can_load
    and CardSleeves
    and CardSleeves.Sleeve
) then
    return
end

if BM._card_sleeves_compat_loaded then
    return
end

BM._card_sleeves_compat_loaded = true


SMODS.Atlas {
    key = 'Sleeve',
    path = 'DigiMeel_Sleeve.png',
    px = 73,
    py = 95
}


local function back_key(slug)
    return
        'b_'
        .. BM.PREFIX
        .. '_'
        .. slug
end


local function queue_starting_loadout(entries)
    G.E_MANAGER:add_event(
        Event({
            func = function()
                if not G.jokers
                or not G.consumeables then
                    return false
                end

                for _, entry in ipairs(entries) do
                    local args = {}

                    for key, value in pairs(entry) do
                        if key ~= 'target_area' then
                            args[key] = value
                        end
                    end

                    if entry.target_area == 'jokers' then
                        args.area = G.jokers
                    else
                        args.area = G.consumeables
                    end

                    SMODS.add_card(args)
                end

                return true
            end
        })
    )
end


local function current_deck_has_boss()
    local config =
        G.GAME
        and G.GAME.selected_back
        and G.GAME.selected_back.effect
        and G.GAME.selected_back.effect.config

    return
        config
        and config.balatromon_ante_8_boss
end


local function current_sleeve_boss()
    if current_deck_has_boss() then
        return nil
    end

    local key =
        G.GAME
        and G.GAME.selected_sleeve

    local center =
        key
        and G.P_CENTERS
        and G.P_CENTERS[key]

    return
        center
        and center.config
        and center.config.balatromon_ante_8_boss
end


CardSleeves.Sleeve {
    key = 'digidestined',

    name = 'Digidestined Sleeve',

    atlas = 'Sleeve',

    pos = {
        x = 0,
        y = 0
    },

    unlocked = true,
    discovered = true,

    config = {
        hand_size = -1
    },

    loc_txt = {
        name = 'Digidestined Sleeve',

        text = {
            'Start with a {C:spectral}Golden Digitama{}',
            'and {C:attention}2{} {C:dark_edition}Negative{} {C:attention}Hefty Food{}',
            '{C:red}-1{} hand size'
        }
    },

    apply = function(self)
        CardSleeves.Sleeve.apply(self)

        queue_starting_loadout({
            {
                set = 'DigiItem',

                key =
                    'c_'
                    .. BM.PREFIX
                    .. '_hefty_food',

                edition = 'e_negative',

                key_append =
                    'balatromon_sleeve_digidestined_hefty_1',

                target_area = 'consumeables'
            },

            {
                set = 'DigiItem',

                key =
                    'c_'
                    .. BM.PREFIX
                    .. '_hefty_food',

                edition = 'e_negative',

                key_append =
                    'balatromon_sleeve_digidestined_hefty_2',

                target_area = 'consumeables'
            },

            {
                set = 'Spectral',

                key =
                    'c_'
                    .. BM.PREFIX
                    .. '_golden_digitama',

                key_append =
                    'balatromon_sleeve_digidestined_digitama',

                target_area = 'consumeables'
            }
        })
    end
}


local function register_crest_sleeve(args)
    CardSleeves.Sleeve {
        key = args.key,

        name = args.name,

        atlas = 'Sleeve',

        pos = {
            x = args.x,
            y = 0
        },

        unlocked = true,
        discovered = true,

        config = {
            balatromon_ante_8_boss =
                args.boss
        },

        loc_txt = {
            name = args.name,

            text = {
                'Start with {C:attention}'
                    .. args.tamer_name
                    .. '{} and {C:attention}'
                    .. args.digimon_name
                    .. '{}',

                'Face {C:attention}'
                    .. args.boss_name
                    .. '{} on {C:attention}Ante 8{}',

                '{C:inactive}(A Boss forced by your Deck takes priority){}',

                '{C:inactive}(Matching Deck does not duplicate the Tamer){}'
            }
        },

        apply = function(self)
            CardSleeves.Sleeve.apply(self)

            local matching =
                self.get_current_deck_key()
                == back_key(args.key)

            local entries = {}

            if not matching then
                entries[#entries + 1] = {
                    set = 'Tamer',

                    key =
                        'c_'
                        .. BM.PREFIX
                        .. '_'
                        .. args.tamer,

                    force_stickers = {
                        'eternal'
                    },

                    key_append =
                        'balatromon_sleeve_'
                        .. args.key
                        .. '_'
                        .. args.tamer,

                    target_area =
                        'consumeables'
                }
            end

            entries[#entries + 1] = {
                set = 'Joker',

                key =
                    BM.center_key(
                        args.digimon
                    ),

                key_append =
                    'balatromon_sleeve_'
                    .. args.key
                    .. '_'
                    .. args.digimon,

                target_area =
                    'jokers'
            }

            queue_starting_loadout(
                entries
            )
        end
    }
end


register_crest_sleeve({
    key = 'courage',
    name = 'Courage Sleeve',

    x = 1,

    tamer = 'tai',
    tamer_name = 'Tai',

    digimon = 'koromon',
    digimon_name = 'Koromon',

    boss = 'cowardice',
    boss_name = 'Cowardice'
})


register_crest_sleeve({
    key = 'friendship',
    name = 'Friendship Sleeve',

    x = 2,

    tamer = 'matt',
    tamer_name = 'Matt',

    digimon = 'tsunomon',
    digimon_name = 'Tsunomon',

    boss = 'hostility',
    boss_name = 'Hostility'
})


register_crest_sleeve({
    key = 'sincerity',
    name = 'Sincerity Sleeve',

    x = 3,

    tamer = 'mimi',
    tamer_name = 'Mimi',

    digimon = 'tanemon',
    digimon_name = 'Tanemon',

    boss = 'two_faced',
    boss_name = 'Two-Faced'
})


local function apply_mutable_vouchers()
    for _, key in ipairs({'v_overstock_norm', 'v_magic_trick'}) do
        if not G.GAME.used_vouchers[key] then
            G.GAME.used_vouchers[key] = true
            G.GAME.starting_voucher_count = (G.GAME.starting_voucher_count or 0) + 1

            G.E_MANAGER:add_event(Event({
                func = function()
                    Card.apply_to_run(nil, G.P_CENTERS[key])
                    return true
                end
            }))
        end
    end
end

CardSleeves.Sleeve {
    key = 'mutable',
    name = 'Mutable Sleeve',

    atlas = 'Sleeve',
    pos = {
        x = 4,
        y = 0
    },

    unlocked = false,
    discovered = true,

    config = {
        balatromon_mutable = true
    },

    loc_txt = {
        name = 'Mutable Sleeve',

        text = {
            'Booster Packs can contain {C:attention}any type{} of card',
            'All Digimon can appear in the shop',
            'regardless of {C:attention}stage{} or {C:attention}rarity{}',
            'Start with {C:attention}Overstock{} and {C:attention}Magic Trick{}'
        },

        unlock = {
            'Use an {C:attention}X-Antibody{} on',
            '{C:attention}8 different Digimon{} in one run',
            '{C:inactive}(#1#/#2#){}'
        }
    },

    locked_loc_vars = function(self, info_queue, card)
        return {vars = {BM.mutable_x_count(), 8}}
    end,

    check_for_unlock = function(self, args)
        return args
            and args.type == 'balatromon_mutable_x'
            and BM.mutable_x_count() >= 8
    end,

    apply = function(self)
        CardSleeves.Sleeve.apply(self)
        apply_mutable_vouchers()
    end
}


if get_new_boss
and not BM._sleeve_boss_wrapped then
    BM._sleeve_boss_wrapped = true

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

        local forced =
            current_sleeve_boss()

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


if end_round
and not BM._sleeve_boss_tag_wrapped then
    BM._sleeve_boss_tag_wrapped = true

    local old_end_round =
        end_round

    end_round =
    function(...)
        local give_boss_tag =
            G.GAME
            and G.GAME.round_resets
            and G.GAME.round_resets.ante == 7
            and G.GAME.blind
            and G.GAME.blind.boss
            and current_sleeve_boss()

        if give_boss_tag then
            add_tag(
                Tag('tag_boss')
            )
        end

        return
            old_end_round(...)
    end
end