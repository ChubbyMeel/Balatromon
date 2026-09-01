local BM = Balatromon

function BM.emult(card, amount)
    if not amount or amount == 1 then
        return
    end

    local mult_param =
        SMODS.Scoring_Parameters
        and SMODS.Scoring_Parameters.mult

    if mult_param then
        local current =
            mult_param.current
            or mult
            or 0

        local target =
            current ^ amount

        mult_param:modify(
            target - current
        )
    else
        mult =
            mod_mult(
                mult ^ amount
            )

        update_hand_text(
            {delay = 0},
            {mult = mult}
        )
    end

    if card
    and card.juice_up then
        card:juice_up(
            0.8,
            0.5
        )
    end

    card_eval_status_text(
        card,
        'extra',
        nil,
        percent,
        nil,
        {
            message =
                '^'
                .. tostring(amount)
                .. ' Mult',

            colour =
                G.C.MULT,

            sound =
                'multhit2',

            volume =
                0.7
        }
    )
end


function BM.echips(card, amount)
    if not amount
    or amount == 1 then
        return
    end

    local chips_param =
        SMODS.Scoring_Parameters
        and SMODS.Scoring_Parameters.chips

    if chips_param then
        local current =
            chips_param.current
            or hand_chips
            or 0

        local target =
            current ^ amount

        chips_param:modify(
            target - current
        )
    else
        hand_chips =
            mod_chips(
                hand_chips ^ amount
            )

        update_hand_text(
            {
                delay = 0
            },
            {
                chips =
                    hand_chips
            }
        )
    end

    if card
    and card.juice_up then
        card:juice_up(
            0.8,
            0.5
        )
    end

    card_eval_status_text(
        card,
        'extra',
        nil,
        percent,
        nil,
        {
            message =
                '^'
                .. tostring(amount)
                .. ' Chips',

            colour =
                G.C.CHIPS,

            sound =
                'xchips',

            volume =
                0.7
        }
    )
end

BM.joker_defs = BM.joker_defs or {}
BM.shop_joker_keys = BM.shop_joker_keys or {}
BM.last_sold_joker_key = BM.last_sold_joker_key or nil

BM.RANKS = {2,3,4,5,6,7,8,9,10,11,12,13,14}
BM.SUITS = {'Hearts','Diamonds','Clubs','Spades'}
BM.HANDS = {'High Card','Pair','Two Pair','Three of a Kind','Straight','Flush','Full House','Four of a Kind','Straight Flush'}


function BM.slug(name)
    return string.lower(name)
        :gsub('[^%w]+', '_')
        :gsub('^_+', '')
        :gsub('_+$', '')
end

function BM.get_card_slug(card)
    if not (card and card.config and card.config.center) then
        return nil
    end

    local key = card.config.center.key or ''
    local prefix = 'j_' .. BM.PREFIX .. '_'

    if type(key) == 'string' and key:sub(1, #prefix) == prefix then
        return key:sub(#prefix + 1)
    end

    return key
end

function BM.has_passive_deck_effect(slug)
    return slug == 'pururumon'
        or slug == 'poromon'
        or slug == 'hawkmon'
        or slug == 'aquilamon'
        or slug == 'halsemon'
        or slug == 'herculeskabuterimon'
end

function BM.apply_passive_deck_effect(card, slug)
    local e = card and card.ability and card.ability.extra
    if not e then return end

    if e._bm_passive_applied and not e._bm_passive_removed then
        return
    end

    e._bm_passive_applied = true
    e._bm_passive_removed = nil
    e._bm_passive_slug = slug

    if slug == 'pururumon' then
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1

    elseif slug == 'poromon' then
        SMODS.change_discard_limit(1)

    elseif slug == 'hawkmon' then
        SMODS.change_discard_limit(1)
        e.hawk_hand_size = e.hawk_hand_size or 0
        local gained = e.hawk_hand_size or 0
        if gained ~= 0 then
            G.hand:change_size(-gained)
            e.hawk_hand_size = 0
        end

    elseif slug == 'aquilamon' then
        G.hand:change_size(2)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1

    elseif slug == 'halsemon' then
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + 3
        G.hand:change_size(-1)

    elseif slug == 'herculeskabuterimon' then
        e.hercules_spectral_rate =
            e.hercules_spectral_rate or 6

        G.GAME.spectral_rate =
            (G.GAME.spectral_rate or 0)
            + e.hercules_spectral_rate
    end
end

function BM.remove_passive_deck_effect(card, slug)
    local e = card and card.ability and card.ability.extra
    if not e then return end
    if e._bm_passive_removed then return end

    local applied_slug = e._bm_passive_slug or slug

    if applied_slug == 'pururumon' then
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1

    elseif applied_slug == 'poromon' then
        SMODS.change_discard_limit(-1)

    elseif applied_slug == 'hawkmon' then
        SMODS.change_discard_limit(-1)

        local gained = e.hawk_hand_size or 0
        if gained ~= 0 then
            G.hand:change_size(-gained)
            e.hawk_hand_size = 0
        end

    elseif applied_slug == 'aquilamon' then
        G.hand:change_size(-2)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1

    elseif applied_slug == 'halsemon' then
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - 3
        G.hand:change_size(1)

    elseif applied_slug == 'herculeskabuterimon' then
        local rate =
            e.hercules_spectral_rate or 6

        G.GAME.spectral_rate =
            math.max(
                0,
                (G.GAME.spectral_rate or 0)
                - rate
            )
    end

    e._bm_passive_applied = nil
    e._bm_passive_removed = true
    e._bm_passive_slug = nil
end

function BM.center_key(slug)
    return 'j_' .. BM.PREFIX .. '_' .. slug
end


function BM.is_digimon(card)
    local center =
        card
        and card.config
        and card.config.center

    return center
        and center.balatromon == true
end



function BM.get_card_slug(card)
    if not card then
        return nil
    end

    local center =
        card.config
        and card.config.center

    if not center or not center.key then
        return nil
    end

    local key = center.key



    local prefix =
        '^j_' .. BM.PREFIX .. '_'

    key = key:gsub(prefix, '')

    return key
end



function BM.is_digimon_display_card(card)

    if not card or not BM.is_digimon(card) then
        return false
    end

    if G.jokers and card.area == G.jokers then
        return true
    end

    if card.area
    and card.area.config
    and card.area.config.collection then
        return true
    end

    return false
end


function BM.deck_ranks()
    local found = {}
    local ranks = {}

    for _, card in ipairs(
        G.playing_cards or {}
    ) do
        for _, identity in ipairs(
            BM.card_identities(card)
        ) do
            local rank =
                identity.rank

            if rank
            and not found[rank] then
                found[rank] = true
                ranks[#ranks + 1] =
                    rank
            end
        end
    end

    table.sort(ranks)

    return ranks
end

function BM.deck_suits()
    local found = {}
    local suits = {}

    for _, card in ipairs(
        G.playing_cards or {}
    ) do
        for _, identity in ipairs(
            BM.card_identities(card)
        ) do
            if identity.suit then
                found[identity.suit] =
                    true
            end
        end
    end

    for _, suit in ipairs(
        BM.SUITS
    ) do
        if found[suit] then
            suits[#suits + 1] =
                suit
        end
    end

    return suits
end

function BM.deck_card_targets()
    local found = {}
    local targets = {}

    for _, card in ipairs(
        G.playing_cards or {}
    ) do
        for _, identity in ipairs(
            BM.card_identities(card)
        ) do
            local rank =
                identity.rank

            local suit =
                identity.suit

            if rank and suit then
                local key =
                    tostring(rank)
                    .. ':'
                    .. suit

                if not found[key] then
                    found[key] = true

                    targets[
                        #targets + 1
                    ] = {
                        rank = rank,
                        suit = suit
                    }
                end
            end
        end
    end

    return targets
end

function BM.card_target_exists(rank, suit)
    if not rank
    or not suit then
        return false
    end

    for _, card in ipairs(
        G.playing_cards or {}
    ) do
        if BM.card_matches_target(
            card,
            rank,
            suit
        ) then
            return true
        end
    end

    return false
end

function BM.ensure_card_target(card, seed)
    local e = card.ability.extra

    if BM.card_target_exists(
        e.target_rank,
        e.target_suit
    ) then
        return e.target_rank, e.target_suit
    end

    local targets = BM.deck_card_targets()

    if #targets == 0 then
        e.target_rank = nil
        e.target_suit = nil
        return nil, nil
    end

    local target = BM.random_element(
        targets,
        seed .. tostring(card.sort_id or '')
    )

    e.target_rank = target.rank
    e.target_suit = target.suit

    return e.target_rank, e.target_suit
end

function BM.reroll_card_target(card, seed)
    local e = card.ability.extra
    local targets = BM.deck_card_targets()

    local old_rank = e.target_rank
    local old_suit = e.target_suit

    if #targets == 0 then
        e.target_rank = nil
        e.target_suit = nil
        return nil, nil
    end

    e._target_rerolls = e._target_rerolls or {}
    e._target_rerolls.target_card =
        (e._target_rerolls.target_card or 0) + 1

    local roll_seed =
        seed
        .. ':'
        .. tostring(e._target_rerolls.target_card)
        .. ':'
        .. tostring(card.sort_id or '')

    local target = BM.random_element(
        targets,
        roll_seed
    )

    if #targets > 1
    and target.rank == old_rank
    and target.suit == old_suit then
        for i, value in ipairs(targets) do
            if value.rank == old_rank
            and value.suit == old_suit then
                target = targets[(i % #targets) + 1]
                break
            end
        end
    end

    e.target_rank = target.rank
    e.target_suit = target.suit

    return e.target_rank, e.target_suit
end

if not BM._digimon_double_click_hooked then
    BM._digimon_double_click_hooked = true

    local original_card_click = Card.click

    BM._last_digimon_click = nil
    BM._last_digimon_click_time = 0

    Card.click = function(self, ...)

        local result = original_card_click(self, ...)

        if not BM.is_digimon_display_card(self) then
            BM._last_digimon_click = nil
            BM._last_digimon_click_time = 0
            return result
        end

        local now = love.timer.getTime()

        local same_card =
            BM._last_digimon_click == self

        local elapsed =
            now - (BM._last_digimon_click_time or 0)

        -- Balatro itself has a ~0.3 second click timeout.
        -- Give the player a comfortable window beyond that.
        local double_click =
            same_card
            and elapsed <= 0.45

        if double_click then

            BM._last_digimon_click = nil
            BM._last_digimon_click_time = 0

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.05,

                func = function()

                    if not self or self.REMOVED then
                        return true
                    end

                    if BM.open_evolution_display then
                        BM.open_evolution_display(self)
                    else
                        print(
                            '[Balatromon] ERROR: '
                            .. 'BM.open_evolution_display is missing'
                        )
                    end

                    return true
                end
            }))

        else

            BM._last_digimon_click = self
            BM._last_digimon_click_time = now

        end

        return result
    end
end


function BM.get_stage(card)
    if not BM.is_digimon(card) then
        return nil
    end

    return card.config.center.balatromon_stage
end

function BM.slug(name)
    return string.lower(name):gsub('[^%w]+','_'):gsub('^_+',''):gsub('_+$','')
end

function BM.center_key(slug)
    return 'j_' .. BM.PREFIX .. '_' .. slug
end

function BM.is_digimon(card)
    local c = card and card.config and card.config.center
    return c and c.balatromon == true
end

function BM.get_stage(card)
    if not BM.is_digimon(card) then return nil end
    return card.config.center.balatromon_stage
end

function BM.bond_max_for_stage(stage)
    if BM.get_mode_bond_max then
        return BM.get_mode_bond_max(stage)
    end

    if stage == 'Fresh'
    or stage == 'In-Training' then
        return 1
    end

    if stage == 'Rookie' then
        return 3
    end

    return 5
end

function BM.get_bond_max(card)
    return BM.bond_max_for_stage(BM.get_stage(card))
end

function BM.care_bar_segment(colour, active)
    return {
        n = G.UIT.C,
        config = {
            align = 'cm',
            minw = 0.26,
            maxw = 0.26,
            minh = 0.16,
            maxh = 0.16,
            r = 0.03,
            colour = active and colour or HEX('30343B')
        }
    }
end

function BM.care_bar_row(label, value, max_value, bar_type)
    value = math.max(0, math.min(max_value, value or 0))

    local segments = {}

    local hunger_colours = {
        HEX('67C95B'),
        HEX('A7CF4A'),
        HEX('E4C83E'),
        HEX('E99038'),
        HEX('D94A42')
    }

    if max_value > 5 then
        hunger_colours = {
            HEX('67C95B'),
            HEX('92CE50'),
            HEX('BFD047'),
            HEX('E4C83E'),
            HEX('E9A43A'),
            HEX('E97A38'),
            HEX('D94A42')
        }
    end

    local bar_width = math.max(
        1.55,
        (max_value * 0.26)
            + (math.max(0, max_value - 1) * 0.015)
            + 0.12
    )

    local care_colours = {
        HEX('E4C83E'),
        HEX('E99038'),
        HEX('D94A42')
    }

    for i = 1, max_value do
        local colour = G.C.GREEN

        if bar_type == 'hunger' then
            colour = hunger_colours[i]
                or hunger_colours[#hunger_colours]
        elseif bar_type == 'care' then
            colour = care_colours[i]
                or care_colours[#care_colours]
        elseif bar_type == 'bond' then
            colour = HEX('55BDF2')
        end

        segments[#segments + 1] =
            BM.care_bar_segment(
                colour,
                i <= value
            )
    end

    local label_colour = G.C.UI.TEXT_LIGHT

    if bar_type == 'hunger' then
        label_colour = HEX('E99038')
    elseif bar_type == 'bond' then
        label_colour = HEX('55BDF2')
    elseif bar_type == 'care' then
        label_colour = HEX('D94A42')
    end

    return {
        n = G.UIT.R,
        config = {
            align = 'cm',
            padding = 0.025
        },
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    align = 'cl',
                    minw = 1.15,
                    maxw = 1.15
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = label,
                            colour = label_colour,
                            scale = 0.30,
                            shadow = true
                        }
                    }
                }
            },
            {
                n = G.UIT.C,
                config = {
                    align = 'cm',
                    minw = bar_width,
                    maxw = bar_width,
                    padding = 0.015
                },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = {
                            align = 'cm',
                            padding = 0.015
                        },
                        nodes = segments
                    }
                }
            },
            {
                n = G.UIT.C,
                config = {
                    align = 'cr',
                    minw = 0.58,
                    maxw = 0.58
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = tostring(value)
                                .. '/'
                                .. tostring(max_value),
                            colour = G.C.UI.TEXT_LIGHT,
                            scale = 0.27,
                            shadow = true
                        }
                    }
                }
            }
        }
    }
end

function BM.care_bars(e, stage)
    e = e or {}

    local hunger_max = BM.get_hunger_max
        and BM.get_hunger_max()
        or 5

    local hunger = math.max(
        1,
        math.min(hunger_max, e.hunger or 1)
    )

    local bond_max =
        BM.bond_max_for_stage(stage)

    local bond = math.max(
        0,
        math.min(
            bond_max,
            e.bond or 0
        )
    )

    local mistakes = math.max(
        0,
        math.min(
            3,
            e.care_mistakes or 0
        )
    )

    local widest_bar = math.max(
        hunger_max,
        bond_max,
        3
    )

    local panel_width = 3.45

    if widest_bar > 5 then
        panel_width = math.max(
            panel_width,
            2.05
                + (widest_bar * 0.26)
                + (math.max(0, widest_bar - 1) * 0.015)
                + 0.22
        )
    end

    return {
        n = G.UIT.C,
        config = {
            align = 'cm'
        },
        nodes = {
            {
                n = G.UIT.R,
                config = {
                    minh = 0.10
                }
            },
            {
                n = G.UIT.C,
                config = {
                    align = 'cm',
                    padding = 0.06,
                    r = 0.10,
                    minw = panel_width,
                    colour = lighten(G.C.BLACK, 0.15)
                },
                nodes = {
                    BM.care_bar_row(
                        'HUNGER',
                        hunger,
                        hunger_max,
                        'hunger'
                    ),
                    BM.care_bar_row(
                        'BOND',
                        bond,
                        bond_max,
                        'bond'
                    ),
                    BM.care_bar_row(
                        'CARE MISTAKE',
                        mistakes,
                        3,
                        'care'
                    )
                }
            },
            {
                n = G.UIT.R,
                config = {
                    minh = 0.10
                }
            }
        }
    }
end

function BM.care_status_text(stage)
    return '{element:1} '
end

function BM.is_boss()
    return G and G.GAME and G.GAME.blind and G.GAME.blind.boss
end

function BM.has_room(area)
    return area and (#area.cards < area.config.card_limit)
end

function BM.get_rank(card)
    if not card then return nil end
    if card.get_id then return card:get_id() end
    return nil
end

function BM.is_jogress_card(card)
    return card
        and card.config
        and card.config.center
        and card.config.center.key
            == 'm_' .. BM.PREFIX .. '_jogress'
end

function BM.native_card_identity(card)
    if not card then
        return nil
    end

    if SMODS.has_no_rank
    and SMODS.has_no_rank(card) then
        return nil
    end

    if SMODS.has_no_suit
    and SMODS.has_no_suit(card) then
        return nil
    end

    local rank = BM.get_rank(card)
    local suit = card.base and card.base.suit

    if not rank or not suit then
        return nil
    end

    return {
        rank = rank,
        suit = suit
    }
end

function BM.card_identities(card)
    local identities = {}

    if BM.is_jogress_card(card) then
        local extra =
            card.ability
            and card.ability.extra

        local sources =
            type(extra) == 'table'
            and extra.jogress_sources

        if type(sources) == 'table' then
            for i = 1, math.min(2, #sources) do
                local source = sources[i]

                if source
                and source.rank
                and source.suit then
                    identities[#identities + 1] = {
                        rank = source.rank,
                        suit = source.suit
                    }
                end
            end
        end
    end

    if #identities == 0 then
        local identity =
            BM.native_card_identity(card)

        if identity then
            identities[1] = identity
        end
    end

    return identities
end

function BM.card_has_rank(card, rank)
    if not card or not rank then
        return false
    end

    for _, identity in ipairs(
        BM.card_identities(card)
    ) do
        if identity.rank == rank then
            return true
        end
    end

    return false
end

function BM.card_has_suit(card, suit)
    if not card or not suit then
        return false
    end

    if card.is_suit
    and card:is_suit(suit) then
        return true
    end

    if BM.is_jogress_card(card) then
        for _, identity in ipairs(
            BM.card_identities(card)
        ) do
            if identity.suit == suit then
                return true
            end
        end
    end

    return false
end

function BM.card_matches_target(card, rank, suit)
    if not card
    or not rank
    or not suit then
        return false
    end

    if BM.is_jogress_card(card) then
        for _, identity in ipairs(
            BM.card_identities(card)
        ) do
            if identity.rank == rank
            and identity.suit == suit then
                return true
            end
        end

        return false
    end

    return BM.get_rank(card) == rank
        and card.is_suit
        and card:is_suit(suit)
end

function BM.card_identity_name(identity)
    if not identity then
        return 'Unknown card'
    end

    return BM.rank_name(identity.rank)
        .. ' of '
        .. tostring(identity.suit)
end

function BM.rank_name(rank)
    local names = {[11]='Jack', [12]='Queen', [13]='King', [14]='Ace'}
    return names[rank] or tostring(rank or '?')
end

function BM.is_face(card)
    if not card then
        return false
    end

    if BM.is_jogress_card(card) then
        for _, identity in ipairs(
            BM.card_identities(card)
        ) do
            local is_face = false

            for _, rank_key in ipairs(
                SMODS.Rank
                and SMODS.Rank.obj_buffer
                or {}
            ) do
                local rank_data =
                    SMODS.Ranks
                    and SMODS.Ranks[rank_key]

                if rank_data
                and rank_data.id == identity.rank then
                    is_face = rank_data.face == true
                    break
                end
            end

            if is_face
            or identity.rank == 11
            or identity.rank == 12
            or identity.rank == 13 then
                return true
            end
        end

        return false
    end

    return card.is_face
        and card:is_face()
        or false
end

function BM.has_enhancement(card, key)
    return card and SMODS.has_enhancement and SMODS.has_enhancement(card, key)
end

function BM.is_unenhanced(card)
    if not card then return false end
    if not card.config or not card.config.center then return true end
    return card.config.center == G.P_CENTERS.c_base or card.config.center.key == 'c_base'
end

function BM.set_enhancement(card, key, skip_juice)
    if card and G.P_CENTERS[key] then
        local changed = not BM.has_enhancement(card, key)
        card:set_ability(G.P_CENTERS[key], nil, true)

        -- Enhancement-changing Digimon should visibly affect the playing card,
        -- not only change its center silently. Centralising the juice here means
        -- Patamon, Salamon, DemiDevimon, Sakumon, Zubamon, Megadramon, etc.
        -- all get the same feedback automatically.
        if changed and card.juice_up and not skip_juice then
            card:juice_up(0.8, 0.5)
        end

        return true
    end
    return false
end

function BM.animate_enhancement_changes(changes, opts)
    opts = opts or {}

    local valid = {}

    for _, change in ipairs(changes or {}) do
        if change
        and change.card
        and not change.card.REMOVED then
            valid[#valid + 1] = change
        end
    end

    if #valid == 0 then
        return false
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = opts.start_delay or 0.15,

        func = function()
            if opts.play_tarot1 ~= false then
                play_sound('tarot1')
            end

            return true
        end
    }))

    for i, change in ipairs(valid) do
        local target = change.card
        local percent =
            1.15
            - (i - 0.999)
            / (#valid - 0.998)
            * 0.3

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = opts.flip_delay or 0.12,

            func = function()
                if target
                and not target.REMOVED then
                    target:flip()
                    play_sound('card1', percent)
                    target:juice_up(0.3, 0.3)
                end

                return true
            end
        }))
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = opts.change_delay or 0.20,

        func = function()
            for _, change in ipairs(valid) do
                local target = change.card

                if target
                and not target.REMOVED then
                    if change.key then
                        BM.set_enhancement(
                            target,
                            change.key,
                            true
                        )
                    end

                    if change.after_set then
                        change.after_set(target)
                    end
                end
            end

            return true
        end
    }))

    for i, change in ipairs(valid) do
        local target = change.card
        local message = change.message
        local colour = change.colour
        local after_flip = change.after_flip
        local percent =
            0.85
            + (i - 0.999)
            / (#valid - 0.998)
            * 0.3

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = opts.flip_back_delay or 0.12,

            func = function()
                if target
                and not target.REMOVED then
                    target:flip()
                    play_sound(
                        'tarot2',
                        percent,
                        0.6
                    )
                    target:juice_up(0.3, 0.3)

                    if message then
                        card_eval_status_text(
                            target,
                            'extra',
                            nil,
                            nil,
                            nil,
                            {
                                message = message,
                                colour = colour
                                    or G.C.ATTENTION
                            }
                        )
                    end

                    if after_flip then
                        after_flip(target)
                    end
                end

                return true
            end
        }))
    end

    if opts.on_complete then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = opts.complete_delay or 0.10,

            func = function()
                opts.on_complete()
                return true
            end
        }))
    end

    return true
end

function BM.animate_enhancement_change(card, key, opts)
    opts = opts or {}

    return BM.animate_enhancement_changes(
        {
            {
                card = card,
                key = key,
                message = opts.message,
                colour = opts.colour,
                after_set = opts.after_set,
                after_flip = opts.after_flip
            }
        },
        opts
    )
end

function BM.remember_digi_item(card)
    if not G
    or not G.GAME
    or not card
    or not card.config
    or not card.config.center then
        return
    end

    if card.config.center.set ~= 'DigiItem' then
        return
    end

    G.GAME.last_tarot_planet =
        card.config.center.key

    if G.GAME.seeded
    or G.GAME.challenge then
        return
    end

    local profile =
        G.PROFILES
        and G.SETTINGS
        and G.PROFILES[G.SETTINGS.profile]

    if not profile then
        return
    end

    profile.career_stats =
        profile.career_stats or {}

    profile.career_stats.balatromon_digi_items_used =
        (
            profile.career_stats.balatromon_digi_items_used
            or 0
        )
        + 1

    if G.save_progress then
        G:save_progress()
    end

    if check_for_unlock then
        check_for_unlock({
            type = 'balatromon_digi_item_used'
        })
    end
end

function BM.contains_hand(context, hand)
    return context and context.poker_hands and context.poker_hands[hand] and next(context.poker_hands[hand]) ~= nil
end

function BM.contains_rank(cards, rank)
    if not cards then
        return false
    end

    for _, card in ipairs(cards) do
        if BM.card_has_rank(
            card,
            rank
        ) then
            return true
        end
    end

    return false
end

function BM.contains_suit(cards, suit)
    if not cards then
        return false
    end

    for _, card in ipairs(cards) do
        if BM.card_has_suit(
            card,
            suit
        ) then
            return true
        end
    end

    return false
end

function BM.all_four_suits(cards)
    for _, s in ipairs(BM.SUITS) do if not BM.contains_suit(cards, s) then return false end end
    return true
end

function BM.highest_card(cards, only_unenhanced)
    local best, best_rank = nil, -math.huge
    for _, c in ipairs(cards or {}) do
        local r = BM.get_rank(c) or -1
        if r > best_rank and (not only_unenhanced or BM.is_unenhanced(c)) then
            best, best_rank = c, r
        end
    end
    return best, best_rank
end

function BM.lowest_card(cards)
    local best, best_rank = nil, math.huge
    for _, c in ipairs(cards or {}) do
        local r = BM.get_rank(c) or math.huge
        if r < best_rank then best, best_rank = c, r end
    end
    return best, best_rank
end

function BM.random_element(list, seed)
    return pseudorandom_element(list, pseudoseed(seed))
end

local function bm_shared_target_store()
    if not G or not G.GAME then
        return nil
    end

    G.GAME.current_round = G.GAME.current_round or {}
    G.GAME.current_round.balatromon_shared_targets =
        G.GAME.current_round.balatromon_shared_targets or {}

    return G.GAME.current_round.balatromon_shared_targets
end

local function bm_value_in_list(value, list)
    if value == nil then
        return false
    end

    for _, candidate in ipairs(list or {}) do
        if candidate == value then
            return true
        end
    end

    return false
end

function BM.ensure_shared_target(key, list, seed)
    list = list or {}

    local store = bm_shared_target_store()
    if not store then
        return #list > 0 and BM.random_element(list, seed or key) or nil
    end

    local entry = store[key] or {}
    store[key] = entry

    if not bm_value_in_list(entry.value, list) then
        entry.value = #list > 0 and BM.random_element(
            list,
            (seed or key) .. ':round:' .. tostring(G.GAME.round or 0)
        ) or nil
    end

    return entry.value
end

function BM.reroll_shared_target(key, list, seed)
    list = list or {}

    local store = bm_shared_target_store()
    if not store then
        return #list > 0 and BM.random_element(list, seed or key) or nil, nil, true
    end

    local entry = store[key] or {}
    store[key] = entry

    local round = G.GAME.round or 0
    local old_value = entry.value

    if entry.last_reroll_round == round then
        return entry.value, old_value, false
    end

    if #list == 0 then
        entry.value = nil
        entry.last_reroll_round = round
        return nil, old_value, true
    end

    local new_value = BM.random_element(
        list,
        (seed or key) .. ':next_round:' .. tostring(round)
    )

    if old_value ~= nil
    and #list > 1
    and new_value == old_value then
        for i, value in ipairs(list) do
            if value == old_value then
                new_value = list[(i % #list) + 1]
                break
            end
        end
    end

    entry.value = new_value
    entry.last_reroll_round = round

    return new_value, old_value, true
end

function BM.ensure_shared_card_target(key, seed)
    local targets = BM.deck_card_targets()
    local store = bm_shared_target_store()

    if not store then
        local target = #targets > 0 and BM.random_element(targets, seed or key) or nil
        return target and target.rank or nil, target and target.suit or nil
    end

    local entry = store[key] or {}
    store[key] = entry

    if not BM.card_target_exists(entry.rank, entry.suit) then
        local target = #targets > 0 and BM.random_element(
            targets,
            (seed or key) .. ':round:' .. tostring(G.GAME.round or 0)
        ) or nil

        entry.rank = target and target.rank or nil
        entry.suit = target and target.suit or nil
    end

    return entry.rank, entry.suit
end

function BM.reroll_shared_card_target(key, seed)
    local targets = BM.deck_card_targets()
    local store = bm_shared_target_store()

    if not store then
        local target = #targets > 0 and BM.random_element(targets, seed or key) or nil
        return target and target.rank or nil, target and target.suit or nil, true
    end

    local entry = store[key] or {}
    store[key] = entry

    local round = G.GAME.round or 0
    local old_rank = entry.rank
    local old_suit = entry.suit

    if entry.last_reroll_round == round then
        return entry.rank, entry.suit, false
    end

    if #targets == 0 then
        entry.rank = nil
        entry.suit = nil
        entry.last_reroll_round = round
        return nil, nil, true
    end

    local target = BM.random_element(
        targets,
        (seed or key) .. ':next_round:' .. tostring(round)
    )

    if #targets > 1
    and target.rank == old_rank
    and target.suit == old_suit then
        for i, value in ipairs(targets) do
            if value.rank == old_rank
            and value.suit == old_suit then
                target = targets[(i % #targets) + 1]
                break
            end
        end
    end

    entry.rank = target.rank
    entry.suit = target.suit
    entry.last_reroll_round = round

    return entry.rank, entry.suit, true
end

function BM.ensure_target(card, field, list, seed)
    local e = card.ability.extra
    list = list or {}

    local current = e[field]
    local valid = false

    if current ~= nil then
        for _, value in ipairs(list) do
            if value == current then
                valid = true
                break
            end
        end
    end

    if not valid then
        if #list > 0 then
            e[field] = BM.random_element(
                list,
                seed .. tostring(card.sort_id or '')
            )
        else
            e[field] = nil
        end
    end

    return e[field]
end

function BM.reroll_target(card, field, list, seed)
    local e = card.ability.extra
    list = list or {}

    e._target_rerolls = e._target_rerolls or {}
    e._target_rerolls[field] =
        (e._target_rerolls[field] or 0) + 1

    local old_value = e[field]

    if #list == 0 then
        e[field] = nil
        return nil, old_value
    end

    local roll_seed =
        seed
        .. ':'
        .. tostring(e._target_rerolls[field])
        .. ':'
        .. tostring(card.sort_id or '')

    local new_value = BM.random_element(
        list,
        roll_seed
    )

    if old_value ~= nil
    and #list > 1
    and new_value == old_value then
        for i, value in ipairs(list) do
            if value == old_value then
                new_value = list[(i % #list) + 1]
                break
            end
        end
    end

    e[field] = new_value

    return new_value, old_value
end

function BM.target_change_return(card, message, colour)
    if card and card.juice_up then
        card:juice_up(0.8, 0.5)
    end

    return {
        message = message or 'Changed!',
        colour = colour or (G and G.C and G.C.FILTER),
    }
end

function BM.get_poker_hand_name(cards)
    if not cards or #cards == 0 then return nil end
    if G.FUNCS and G.FUNCS.get_poker_hand_info then
        local text = G.FUNCS.get_poker_hand_info(cards)
        return text
    end
    return nil
end

function BM.count_deck_enhancement(key)
    local n = 0
    for _, c in ipairs(G.playing_cards or {}) do if BM.has_enhancement(c, key) then n = n + 1 end end
    return n
end

function BM.add_consumable(set, key, edition)
    if not G.consumeables or not BM.has_room(G.consumeables) then return nil end
    local args = {set = set, area = G.consumeables, key_append = 'balatromon'}
    if key and G.P_CENTERS[key] then args.key = key end
    if edition then args.edition = edition end
    return SMODS.add_card(args)
end

function BM.add_food(count)
    count = count or 1
    local made = 0
    for _ = 1, count do
        if not BM.has_room(G.consumeables) then break end
        if G.P_CENTERS['c_' .. BM.PREFIX .. '_food'] then
            SMODS.add_card{set='DigiItem', area=G.consumeables, key='c_' .. BM.PREFIX .. '_food'}
            made = made + 1
        end
    end
    return made
end

function BM.add_playing_card(args)
    args = args or {}
    args.set = args.set or 'Playing Card'
    args.area = args.area or G.deck
    return SMODS.add_card(args)
end

function BM.care_animation(card, message, colour)
    if not card or card.REMOVED then return end

    if card.juice_up then
        card:juice_up(0.8, 0.5)
    end

    card_eval_status_text(
        card,
        'extra',
        nil,
        nil,
        nil,
        {
            message = message,
            colour = colour
        }
    )
end

function BM.bad_care_animation(card, message)
    if not card or card.REMOVED then return end

    if card.juice_up then
        card:juice_up(1.4, 1.0)
    end

    card_eval_status_text(
        card,
        'extra',
        nil,
        nil,
        nil,
        {
            message = message,
            colour = G.C.RED
        }
    )
end

function BM.feed(card, amount)
    if not BM.is_digimon(card) then return end

    local e = card.ability.extra
    local was_starved = e.permanently_disabled == true

    if was_starved
    and not (
        BM.can_revive_starved
        and BM.can_revive_starved()
    ) then
        return
    end

    e.hunger = math.max(
        1,
        (e.hunger or 1) - (amount or 1)
    )

    local hunger_max = BM.get_hunger_max
        and BM.get_hunger_max()
        or 5

    if was_starved
    and e.hunger < hunger_max then
        e.permanently_disabled = nil

        SMODS.debuff_card(
            card,
            false,
            'balatromon_hunger'
        )

        if SMODS.recalc_debuff then
            SMODS.recalc_debuff(card)
        end

        local slug = BM.get_card_slug(card)
        if slug
        and BM.has_passive_deck_effect(slug)
        and BM.on_add then
            BM.on_add(card, slug)
        end

        BM.care_animation(
            card,
            'Revived!',
            G.C.GREEN
        )

        return
    end

    BM.care_animation(
        card,
        'Fed!',
        G.C.GREEN
    )
end

function BM.is_active_digimon(card, slug)
    if not BM.is_digimon(card) then return false end
    if slug and BM.get_card_slug(card) ~= BM.slug(slug) then return false end
    if card.debuff then return false end
    local e = card.ability and card.ability.extra or {}
    return not e.permanently_disabled
end

function BM.active_digimon(slug)
    local out = {}
    for _, card in ipairs(G.jokers and G.jokers.cards or {}) do
        if BM.is_active_digimon(card, slug) then
            out[#out + 1] = card
        end
    end
    return out
end

function BM.has_active_digimon(slug)
    return #BM.active_digimon(slug) > 0
end

function BM.is_food_card(card)
    local center = card and card.config and card.config.center
    local key = center and center.key
    return key == 'c_' .. BM.PREFIX .. '_food'
        or key == 'c_' .. BM.PREFIX .. '_hefty_food'
end

function BM.count_food()
    local count = 0
    for _, card in ipairs(G.consumeables and G.consumeables.cards or {}) do
        if BM.is_food_card(card) then
            count = count + 1
        end
    end
    return count
end

function BM.add_random_food(seed)
    if not G.consumeables or not BM.has_room(G.consumeables) then return nil end

    local slug = BM.random_element(
        {'food', 'hefty_food'},
        seed or 'balatromon_random_food'
    )

    if not slug then return nil end

    return SMODS.add_card{
        set = 'DigiItem',
        area = G.consumeables,
        key = 'c_' .. BM.PREFIX .. '_' .. slug,
        key_append = 'balatromon_random_food'
    }
end

function BM.add_digimon_tooltip(info_queue, slug)
    if not info_queue then return end

    slug = BM.slug(slug)

    local def = BM.joker_defs
        and BM.joker_defs[slug]

    if not def then return end

    info_queue[#info_queue + 1] = {
        set = 'Other',
        key = BM.PREFIX .. '_digimon_ref_' .. slug,
        vars = {}
    }
end

function BM.add_seal_tooltip(info_queue, key)
    if not info_queue or not key then
        return
    end

    local vanilla = {
        Gold = true,
        Blue = true,
        Purple = true,
        Red = true
    }

    if vanilla[key] then
        info_queue[#info_queue + 1] = {
            set = 'Other',
            key = string.lower(key) .. '_seal'
        }

        return
    end

    local seal_key =
        key:find(BM.PREFIX .. '_', 1, true)
        and key
        or BM.PREFIX .. '_' .. BM.slug(key)

    local seal =
        G.P_SEALS
        and G.P_SEALS[seal_key]

    if seal then
        info_queue[#info_queue + 1] =
            seal
    end
end



function BM.get_hunger_rounds(card)
    if not card or not card.ability then
        return 2
    end

    if card.ability[
        BM.PREFIX .. '_famined'
    ] then
        return 1
    end

    if card.ability[
        BM.PREFIX .. '_fasting'
    ] then
        return 4
    end

    return 2
end

function BM.care_tick(card, context)
    if BM.should_bond_shake
    and BM.should_bond_shake(card) then
        BM.start_bond_shake(card)
    end

    if not (context.end_of_round and context.main_eval and not context.blueprint) then return end
    local e = card.ability.extra
    local center = card.config and card.config.center
    if center and center.balatromon_self_feed then
        BM.feed(card, 1)
    end
    if e._care_ticked_this_round then return end
    e._care_ticked_this_round = true
    G.E_MANAGER:add_event(Event({trigger='after', delay=0, func=function()
        e._care_ticked_this_round = nil
        return true
    end}))

    if e.permanently_disabled then return end

    local hunger_max = BM.get_hunger_max
        and BM.get_hunger_max()
        or 5

    local bond_hunger_limit = BM.get_bond_gain_max_hunger
        and BM.get_bond_gain_max_hunger()
        or 3

    e.care_rounds = (e.care_rounds or 0) + 1

    if e.care_rounds % BM.get_hunger_rounds(card) == 0 then
        local old_hunger = e.hunger or 1

        e.hunger = math.min(
            hunger_max,
            old_hunger + 1
        )

        if e.hunger > old_hunger then
            BM.care_animation(
                card,
                'Hungry',
                G.C.RED
            )
        end
    end

    if (e.hunger or 1) > bond_hunger_limit then
        local old_mistakes = e.care_mistakes or 0

        e.care_mistakes = math.min(
            3,
            old_mistakes + 1
        )

        if e.care_mistakes > old_mistakes then
            BM.bad_care_animation(
                card,
                ':('
            )
        end

        if old_mistakes < 3
        and e.care_mistakes >= 3 then
            e.care_crisis = true

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    if card
                    and not card.REMOVED
                    and BM.queue_care_crisis then
                        BM.queue_care_crisis(card)
                    end

                    return true
                end
            }))
        end
    else
        local max_bond = BM.get_bond_max(card)

        e.bond = math.min(
            max_bond,
            (e.bond or 0) + 1
        )
    end

    if BM.should_bond_shake(card) then
        BM.start_bond_shake(card)
    end

    if (e.hunger or 1) >= hunger_max then
        local slug = BM.get_card_slug(card)

        e.permanently_disabled = true

        if slug and BM.has_passive_deck_effect(slug) then
            BM.on_remove(card, slug)
        end

        SMODS.debuff_card(card, true, 'balatromon_hunger')
    end
end

function BM.is_bond_full(card)
    if not BM.is_digimon(card) then
        return false
    end

    local e = card.ability.extra

    if e.permanently_disabled then
        return false
    end

    local max_bond = BM.get_bond_max(card)

    return (e.bond or 0) >= max_bond
end

function BM.should_bond_shake(card)
    if not BM.is_bond_full(card) then
        return false
    end

    if not BM.get_display_evolutions then
        return false
    end

    for _, option in ipairs(BM.get_display_evolutions(card)) do
        if not option.bad_path then
            return true
        end
    end

    return false
end

function BM.start_bond_shake(card)
    if not BM.is_bond_full(card) then return end

    local e = card.ability.extra
    if e._bond_shaking then return end

    e._bond_shaking = true

    -- Pokermon uses this same pattern for Pokemon that are ready to evolve:
    -- keep juicing the card while the condition remains true.
    local eval = function(c)
        local extra = c and c.ability and c.ability.extra
        local keep_shaking = c and not c.REMOVED and BM.is_bond_full(c)
            and extra and extra._bond_shaking

        if not keep_shaking and extra then
            extra._bond_shaking = nil
        end

        return keep_shaking or false
    end

    juice_card_until(card, eval, true)
end

function BM.card_ready_for_digivolution(card, device_key)
    if not BM.is_digimon(card) then
        return false
    end

    if card.ability.extra.permanently_disabled then
        return false
    end

    local required_bond = BM.get_digivolution_bond_requirement
        and BM.get_digivolution_bond_requirement(card, device_key)
        or BM.get_bond_max(card)

    return (card.ability.extra.bond or 0) >= required_bond
end

function BM.joker_index(card)
    if not G.jokers then return nil end
    for i,c in ipairs(G.jokers.cards) do if c == card then return i end end
end

function BM.leftmost_digimon(exclude)
    for _,c in ipairs(G.jokers and G.jokers.cards or {}) do if c ~= exclude and BM.is_digimon(c) then return c end end
end

function BM.random_other_joker(card, seed)
    local t = {}
    for _,c in ipairs(G.jokers and G.jokers.cards or {}) do if c ~= card then t[#t+1] = c end end
    if #t == 0 then return nil end
    return BM.random_element(t, seed)
end

function BM.copy_joker(target, strip_negative)
    if not target or not BM.has_room(G.jokers) then return nil end
    local should_strip = strip_negative and target.edition and target.edition.negative
    return SMODS.copy_card(target, {
        area = G.jokers,
        strip_edition = should_strip
    })
end

function BM.apply_blind_reduction(card, context, amount, bosses)
    if not (context.setting_blind and context.main_eval and not context.blueprint) then return end
    if BM.is_boss() and not bosses then return end
    if not G.GAME.blind or not G.GAME.blind.chips then return end
    local mark = tostring(G.GAME.round_resets.ante) .. ':' .. tostring(G.GAME.blind.name)
    if card.ability.extra.last_reduced_blind == mark then return end
    card.ability.extra.last_reduced_blind = mark
    G.GAME.blind.chips = math.max(1, math.floor(G.GAME.blind.chips * (1 - amount)))
    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    SMODS.juice_up_blind()
end

function BM.add_sell_value_to_all(amount)
    for _, area in ipairs({G.jokers, G.consumeables}) do
        if area then
            for _, c in ipairs(area.cards) do
                c.ability.extra_value = (c.ability.extra_value or 0) + amount
                c:set_cost()
            end
        end
    end
end

function BM.is_least_played_hand(hand)
    if not hand
    or not G.GAME
    or not G.GAME.hands
    or not G.GAME.hands[hand] then
        return false
    end

    local hand_data = G.GAME.hands[hand]

    if hand_data.visible == false then
        return false
    end

    local least = math.huge

    for _, data in pairs(G.GAME.hands) do
        if data.visible ~= false then
            least = math.min(
                least,
                data.played or 0
            )
        end
    end

    return (hand_data.played or 0) == least
end

function BM.is_most_played_hand(hand)
    if not hand
    or not G.GAME
    or not G.GAME.hands
    or not G.GAME.hands[hand] then
        return false
    end

    local hand_data =
        G.GAME.hands[hand]

    if hand_data.visible == false then
        return false
    end

    local most =
        -math.huge

    for _, data in pairs(
        G.GAME.hands
    ) do
        if data.visible ~= false then
            most =
                math.max(
                    most,
                    data.played or 0
                )
        end
    end

    return
        (hand_data.played or 0)
        == most
end

function BM.is_most_played_hand_before_play(hand)
    if not hand
    or not G.GAME
    or not G.GAME.hands
    or not G.GAME.hands[hand] then
        return false
    end

    local hand_data =
        G.GAME.hands[hand]

    if hand_data.visible == false then
        return false
    end

    local current =
        math.max(
            0,
            (hand_data.played or 0) - 1
        )

    local most =
        -math.huge

    for hand_name, data in pairs(
        G.GAME.hands
    ) do
        if data.visible ~= false then
            local played =
                data.played or 0

            if hand_name == hand then
                played =
                    math.max(
                        0,
                        played - 1
                    )
            end

            most =
                math.max(
                    most,
                    played
                )
        end
    end

    return current == most
end


function BM.is_least_played_hand_before_play(hand)
    if not hand
    or not G.GAME
    or not G.GAME.hands
    or not G.GAME.hands[hand] then
        return false
    end

    local hand_data =
        G.GAME.hands[hand]

    if hand_data.visible == false then
        return false
    end

    local current =
        math.max(
            0,
            (hand_data.played or 0) - 1
        )

    local least =
        math.huge

    for hand_name, data in pairs(
        G.GAME.hands
    ) do
        if data.visible ~= false then
            local played =
                data.played or 0

            if hand_name == hand then
                played =
                    math.max(
                        0,
                        played - 1
                    )
            end

            least =
                math.min(
                    least,
                    played
                )
        end
    end

    return current == least
end

function BM.stage_shop_weight(stage)
    if stage == 'Fresh' then return 12 end
    if stage == 'In-Training' then return 12 end
    if stage == 'Rookie' then return 10 end
    if stage == 'Champion' then return 1 end
    if stage == 'Rare' then return 1 end

    if stage == 'Ultimate' then return 1 end

    return 0
end

function BM.stage_rarity(stage)
    return (BM.stage_rarity_keys and BM.stage_rarity_keys[stage]) or 1
end

function BM.on_add(card, slug)
    if card
    and card._bm_suppress_on_add then
        return
    end

    if BM.has_passive_deck_effect(slug) then
        BM.apply_passive_deck_effect(card, slug)
    end

    if slug == 'digitamamon' then
        card.ability.rental = true
    end

    if (slug == 'polarbearmon' or slug == 'skadimon')
    and BM.refresh_planet_shop_costs then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0,

            func = function()
                BM.refresh_planet_shop_costs()
                return true
            end
        }))
    end
    if slug == 'redvegiemon'
    and BM.refresh_redvegiemon_shop_costs then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0,
            func = function()
                BM.refresh_redvegiemon_shop_costs()
                return true
            end
        }))
    end

    if (slug == 'sunflowmon' or slug == 'lilamon')
    and BM.refresh_sunflowmon_shop_packs then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0,
            func = function()
                BM.refresh_sunflowmon_shop_packs()
                return true
            end
        }))
    end

    if slug == 'imperialdramon_paladin_mode'
    and G.hand
    and card
    and card.ability
    and card.ability.extra
    and not card.ability.extra._paladin_hand_size then
        G.hand:change_size(3)

        card.ability.extra._paladin_hand_size =
            true
    end


end

function BM.on_remove(card, slug)
    if BM.has_passive_deck_effect(slug) then
        BM.remove_passive_deck_effect(card, slug)
    end

    if (slug == 'polarbearmon' or slug == 'skadimon')
    and BM.refresh_planet_shop_costs then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0,

            func = function()
                BM.refresh_planet_shop_costs()
                return true
            end
        }))
    end

    if slug == 'redvegiemon'
    and BM.refresh_redvegiemon_shop_costs then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0,
            func = function()
                BM.refresh_redvegiemon_shop_costs()
                return true
            end
        }))
    end

    if slug == 'imperialdramon_paladin_mode'
    and G.hand
    and card
    and card.ability
    and card.ability.extra
    and card.ability.extra._paladin_hand_size then
        G.hand:change_size(-3)

        card.ability.extra._paladin_hand_size =
            nil
    end

end

function BM.can_sell(card, slug)
    if slug == 'espimon' then return (card.ability.extra.sell_rounds or 0) >= 2 end
    if slug == 'hoverespimon' then return (card.ability.extra.sell_rounds or 0) >= 3 end
    return true
end

local function getEnhancements()
    -- Rebuild every time so enhancements registered
    -- by other mods are always included.
    local enhancements = {"c_base"}

    local pool = {}

    for _, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
        table.insert(pool, v)
    end

    -- Keep approximately the normal enhancement order.
    table.sort(pool, function(a, b)
        return (a.order or 0) < (b.order or 0)
    end)

    local blocked = {
        ['m_' .. BM.PREFIX .. '_jogress'] = true,
        ['m_' .. BM.PREFIX .. '_signal'] = true,
    }

    -- IMPORTANT:
    -- table.insert makes the array contiguous,
    -- so ipairs will not stop at an order gap.
    for _, v in ipairs(pool) do
        if not blocked[v.key] then
            table.insert(enhancements, v.key)
        end
    end

    return enhancements
end


local function balatromon_find_evolution_tag()
    local wanted = 'tag_' .. BM.PREFIX .. '_evolution_tag'
    for _, tag in ipairs((G.GAME and G.GAME.tags) or {}) do
        if tag.key == wanted and not tag.triggered then
            return tag
        end
    end
    return nil
end

SMODS.current_mod.calculate = function(self, context)
    if not (context.first_hand_drawn and context.main_eval) then return end

    local tag = balatromon_find_evolution_tag()
    if not tag then return end

    local enhancement = 'm_' .. BM.PREFIX .. '_calumon'
    if not G.P_CENTERS[enhancement] then
        print('[Balatromon] Evolution Tag: Calumon enhancement center is missing: ' .. enhancement)
        return
    end

    tag.triggered = true

    local lock = tag.ID
    G.CONTROLLER.locks[lock] = true

    tag:yep('Calumon!', G.C.GREEN, function()
        local card = SMODS.add_card {
            set = 'Playing Card',
            area = G.hand,
            enhancement = enhancement,
            key_append = 'balatromon_evolution_tag',
        }

        if card then
            card:juice_up(0.8, 0.6)
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = 'Calumon!',
                colour = G.C.GREEN,
            })
        else
            print('[Balatromon] Evolution Tag: failed to create Calumon playing card')
        end

        G.CONTROLLER.locks[lock] = nil
        return true
    end)
end

function BM.count_owned_jokers()
    return G.jokers
        and #(G.jokers.cards or {})
        or 0
end

function BM.sum_other_joker_sell_value(card)
    local total = 0

    for _, joker in ipairs(
        G.jokers
        and G.jokers.cards
        or {}
    ) do
        if joker ~= card then
            total = total + (joker.sell_cost or 0)
        end
    end

    return total
end

function BM.empty_joker_slots(excluded_slugs)
    if not G.jokers then
        return 0
    end

    local occupied = 0

    for _, joker in ipairs(G.jokers.cards or {}) do
        local slug = BM.get_card_slug(joker)

        if not (
            excluded_slugs
            and excluded_slugs[slug]
        ) then
            occupied = occupied + 1
        end
    end

    return math.max(
        0,
        (G.jokers.config.card_limit or 0) - occupied
    )
end

function BM.raremon_xmult()
    local count = BM.count_owned_jokers()

    if count <= 4 then
        return 5 - count
    end

    return 1 - 0.01 * (count - 4)
end
