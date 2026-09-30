local BM = Balatromon

SMODS.Atlas {
    key = 'IntermediarySeal',
    path = 'DigiMeel_Upgraded_Seals.png',
    px = 71,
    py = 95
}

local GLITCH_SHADER_KEY =
    BM.PREFIX .. '_glitch'

SMODS.Shader {
    key = 'glitch',
    path = 'glitch.fs',

    send_vars = function(sprite, card)
        return {
            glitch_time = G.TIMERS.REAL,
            glitch_seed = sprite and sprite.ID or 1
        }
    end
}

SMODS.DrawStep {
    key = 'glitch_seal_shader',
    order = 15,

    conditions = {
        facing = 'front'
    },

    func = function(card, layer)
        if card.seal ~= 'DigiMeel_glitch'
        and card.seal ~= 'glitch'
        and card.seal ~= 'DigiMeel_firewall'
        and card.seal ~= 'firewall' then
            return
        end

        if not card.children then
            return
        end

        if card.children.center then
            card.children.center:draw_shader(
                GLITCH_SHADER_KEY,
                nil,
                nil
            )
        end

        if card.children.front
        and not card:should_hide_front() then
            card.children.front:draw_shader(
                GLITCH_SHADER_KEY,
                nil,
                nil
            )
        end
    end
}

local function digi_item_pool()
    return G.P_CENTER_POOLS and G.P_CENTER_POOLS.DigiItem or {}
end


local function create_random_digi_item(negative)
    if not G.consumeables then
        return nil
    end

    local pool = digi_item_pool()

    if not pool or #pool == 0 then
        return nil
    end

    local center = pseudorandom_element(
        pool,
        pseudoseed('balatromon_seal_digi_item')
    )

    if not center then
        return nil
    end

    local new_card = SMODS.create_card {
        set = 'DigiItem',
        area = G.consumeables,
        key = center.key,
    }

    if not new_card then
        return nil
    end

    if negative then
        new_card:set_edition(
            { negative = true },
            true,
            true
        )
    end

    new_card:add_to_deck()
    G.consumeables:emplace(new_card)

    return new_card
end


local function create_food(negative)
    if not G.consumeables then
        return nil
    end

    local new_card = SMODS.create_card {
        set = 'DigiItem',
        area = G.consumeables,
        key = 'c_DigiMeel_food',
    }

    if not new_card then
        return nil
    end

    if negative then
        new_card:set_edition(
            { negative = true },
            true,
            true
        )
    end

    new_card:add_to_deck()
    G.consumeables:emplace(new_card)

    return new_card
end


local function create_random_spectral()
    if not G.consumeables then
        return nil
    end

    local new_card = SMODS.create_card {
        set = 'Spectral',
        area = G.consumeables,
    }

    if new_card then
        new_card:add_to_deck()
        G.consumeables:emplace(new_card)
    end

    return new_card
end


local function create_random_tarot()
    if not G.consumeables or not BM.has_room(G.consumeables) then return nil end
    return SMODS.add_card {set = 'Tarot', area = G.consumeables, key_append = 'balatromon_delivery'}
end

local function care_pick(card)
    local kinds = {}
    local pools = {care = {}, bond = {}, food = {}}
    for _, digimon in ipairs(G.jokers and G.jokers.cards or {}) do
        if BM.is_digimon(digimon) and digimon.ability and type(digimon.ability.extra) == 'table' then
            local e = digimon.ability.extra
            if (e.care_mistakes or 0) > 0 then pools.care[#pools.care + 1] = digimon end
            if not e.permanently_disabled and (e.bond or 0) < BM.get_bond_max(digimon) then pools.bond[#pools.bond + 1] = digimon end
            if (e.hunger or 1) > 1 then pools.food[#pools.food + 1] = digimon end
        end
    end
    for _, kind in ipairs({'care', 'bond', 'food'}) do
        if #pools[kind] > 0 then kinds[#kinds + 1] = kind end
    end
    local kind = BM.random_element(kinds, 'balatromon_seasonal_kind_' .. tostring(card.sort_id or 0))
    local target = kind and BM.random_element(pools[kind], 'balatromon_seasonal_target_' .. tostring(card.sort_id or 0))
    if not target then return end
    local e = target.ability.extra
    if kind == 'care' then
        e.care_mistakes = math.max(0, (e.care_mistakes or 0) - 1)
        if e.care_mistakes < 3 then e.care_crisis = nil end
        BM.care_animation(target, 'Care -1!', G.C.GREEN)
    elseif kind == 'bond' then
        e.bond = math.min(BM.get_bond_max(target), (e.bond or 0) + 1)
        BM.care_animation(target, 'Bond Up!', G.C.GREEN)
        if BM.is_bond_full(target) then BM.start_bond_shake(target) end
    else
        BM.feed(target, 1)
    end
end

local seal_upgrades = {
    Red = BM.PREFIX .. '_corrupted',
    Blue = BM.PREFIX .. '_spacious',
    Purple = BM.PREFIX .. '_delivery',
    Gold = BM.PREFIX .. '_tampered_gold',
    [BM.PREFIX .. '_farm'] = BM.PREFIX .. '_seasonal',
    [BM.PREFIX .. '_digital'] = BM.PREFIX .. '_machine',
    [BM.PREFIX .. '_silver_medal'] = BM.PREFIX .. '_tied_first_medal',
    [BM.PREFIX .. '_glitch'] = BM.PREFIX .. '_firewall',
    farm = BM.PREFIX .. '_seasonal',
    digital = BM.PREFIX .. '_machine',
    silver_medal = BM.PREFIX .. '_tied_first_medal',
    glitch = BM.PREFIX .. '_firewall'
}

function BM.intermediary_for(seal)
    return seal_upgrades[seal]
end

function BM.make_intermediary(card, seal)
    local next_seal = seal_upgrades[seal]
    if not next_seal then return end
    card:set_seal(next_seal, true)
    return next_seal
end

local function same_rank_in_hand(card)
    local count = 0

    if not (G.hand and G.hand.cards) then
        return count
    end

    local id = card:get_id()

    for _, held_card in ipairs(G.hand.cards) do
        if held_card ~= card
        and held_card:get_id() == id then
            count = count + 1
        end
    end

    return count
end


local function blind_is_beaten()
    if not (
        G.GAME
        and G.GAME.blind
        and G.GAME.blind.chips
        and G.GAME.chips
    ) then
        return false
    end

    return G.GAME.chips >= G.GAME.blind.chips
end


local function discard_held_card(card)
    if not (
        card
        and not card.REMOVED
        and card.area == G.hand
        and G.discard
    ) then
        return
    end

    G.hand:remove_card(card)
    G.discard:emplace(card)

    card:juice_up(0.4, 0.4)

    card_eval_status_text(
        card,
        'extra',
        nil,
        nil,
        nil,
        {
            message = 'Discarded!',
            colour = G.C.RED
        }
    )
end




SMODS.Seal {
    key = 'farm',

    atlas = 'Seal',
    pos = { x = 0, y = 0 },

    discovered = false,
    badge_colour = HEX('C97A40'),

    loc_txt = {
        name = 'Farm Seal',
        label = 'Farm Seal',
        text = {
            'If held in hand at',
            'the end of the round,',
            'create {C:attention}2{} {C:dark_edition}Negative{}',
            '{C:attention}Food{} cards'
        }
    },

    calculate = function(self, card, context)

        if context.playing_card_end_of_round
        and context.cardarea == G.hand
        and not context.repetition then

            card:juice_up(0.6, 0.5)

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,

                func = function()
                    create_food(true)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.30,

                func = function()
                    create_food(true)
                    return true
                end
            }))

            return {
                message = 'Harvest!',
                colour = G.C.GREEN
            }
        end
    end
}



SMODS.Seal {
    key = 'digital',

    atlas = 'Seal',
    pos = { x = 1, y = 0 },

    discovered = false,

    badge_colour = HEX('42C9FF'),

    loc_txt = {
        name = 'Digital Seal',
        label = 'Digital Seal',
        text = {
            'If played without scoring,',
            'create {C:attention}1{} random',
            '{C:attention}Digi Item{}'
        }
    },

    calculate = function(self, card, context)

        if context.before
        and context.full_hand
        and context.scoring_hand then

            local was_played = false
            local did_score = false

            for _, played_card in ipairs(context.full_hand) do
                if played_card == card then
                    was_played = true
                    break
                end
            end

            for _, scoring_card in ipairs(context.scoring_hand) do
                if scoring_card == card then
                    did_score = true
                    break
                end
            end

            if was_played and not did_score then

                card:juice_up(0.6, 0.5)

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,

                    func = function()
                        create_random_digi_item(false)
                        return true
                    end
                }))

                return {
                    message = 'Downloaded!',
                    colour = G.C.BLUE
                }
            end
        end
    end
}




SMODS.Seal {
    key = 'silver_medal',

    atlas = 'Seal',
    pos = { x = 2, y = 0 },

    discovered = false,

    badge_colour = HEX('C8CDD5'),

    loc_txt = {
        name = 'Silver Medal',
        label = 'Silver Medal',
        text = {
            'When this card scores,',
            'each card held in hand',
            'with the same {C:attention}rank{}',
            'gives {C:mult}+13{} Mult'
        }
    },

    calculate = function(self, card, context)

        if context.main_scoring
        and context.cardarea == G.play
        and G.hand
        and G.hand.cards then

            local scoring_id = card:get_id()

            for _, held_card in ipairs(G.hand.cards) do
                if held_card:get_id() == scoring_id then

                    SMODS.calculate_effect(
                        {
                            mult = 13,
                        },
                        held_card
                    )

                end
            end
        end
    end
}



SMODS.Seal {
    key = 'glitch',

    atlas = 'Seal',
    pos = { x = 3, y = 0 },

    discovered = false,

    badge_colour = HEX('8F67FF'),

    loc_txt = {
        name = 'Glitch Seal',
        label = 'Glitch Seal',
        text = {
            'When scored, gives',
            '{C:mult}+1{} to {C:mult}+24{} Mult',
            'and {C:chips}+3{} to {C:chips}+20{} Chips',
            'If held in hand on the',
            '{C:attention}winning hand{}, create',
            'a {C:spectral}Spectral{} card',
            'Otherwise, discard itself'
        }
    },

    calculate = function(self, card, context)

        if context.main_scoring
        and context.cardarea == G.play then

            local mult =
                math.floor(
                    pseudorandom(
                        pseudoseed(
                            'balatromon_glitch_mult_'
                            .. tostring(card.sort_id or 0)
                        )
                    ) * 24
                ) + 1

            local chips =
                math.floor(
                    pseudorandom(
                        pseudoseed(
                            'balatromon_glitch_chips_'
                            .. tostring(card.sort_id or 0)
                        )
                    ) * 18
                ) + 3

            return {
                mult = mult,
                chips = chips,
            }
        end



        if context.after
        and card.area == G.hand then

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.10,

                func = function()

                    if not card
                    or card.REMOVED then
                        return true
                    end


                    if SMODS.last_hand_oneshot then

                        card:juice_up(0.8, 0.6)

                        card_eval_status_text(
                            card,
                            'extra',
                            nil,
                            nil,
                            nil,
                            {
                                message = 'Spectral!',
                                colour = G.C.PURPLE
                            }
                        )

                        create_random_spectral()

                    else

                        discard_held_card(card)

                    end

                    return true
                end
            }))
        end
    end
}

SMODS.Seal {
    key = 'seasonal',
    weight = 0,
    atlas = 'IntermediarySeal',
    pos = {x = 0, y = 0},
    discovered = false,
    badge_colour = HEX('F08A39'),
    loc_txt = {
        name = 'Seasonal Seal',
        label = 'Seasonal Seal',
        text = {
            'If held in hand at the end of the round,',
            'create {C:attention}2{} {C:dark_edition}Negative{} {C:attention}Food{} cards',
            '{C:green}1 in 2{} chance to cure a Care Mistake,',
            'increase Bond, or feed a random Digimon'
        }
    },
    calculate = function(self, card, context)
        if context.playing_card_end_of_round and context.cardarea == G.hand and not context.repetition then
            card:juice_up(0.6, 0.5)
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
                create_food(true)
                return true
            end}))
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.30, func = function()
                create_food(true)
                return true
            end}))
            if SMODS.pseudorandom_probability(card, 'balatromon_seasonal_care', 1, 2) then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.45, func = function()
                    care_pick(card)
                    return true
                end}))
            end
            return {message = 'Seasonal!', colour = G.C.GREEN}
        end
    end
}

SMODS.Seal {
    key = 'machine',
    weight = 0,
    atlas = 'IntermediarySeal',
    pos = {x = 1, y = 0},
    discovered = false,
    badge_colour = HEX('9BCB32'),
    loc_txt = {
        name = 'Machine Seal',
        label = 'Machine Seal',
        text = {
            'If played without scoring,',
            'create {C:attention}1{} random {C:attention}Digi Item{}',
            '{C:green}1 in 3{} chance for it to be {C:dark_edition}Negative{}'
        }
    },
    calculate = function(self, card, context)
        if context.before and context.full_hand and context.scoring_hand then
            local played, scored
            for _, other in ipairs(context.full_hand) do
                if other == card then played = true break end
            end
            for _, other in ipairs(context.scoring_hand) do
                if other == card then scored = true break end
            end
            if played and not scored then
                local negative = SMODS.pseudorandom_probability(card, 'balatromon_machine_negative', 1, 3)
                card:juice_up(0.6, 0.5)
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
                    create_random_digi_item(negative)
                    return true
                end}))
                return {message = negative and 'Negative!' or 'Downloaded!', colour = G.C.BLUE}
            end
        end
    end
}

SMODS.Seal {
    key = 'tied_first_medal',
    weight = 0,
    atlas = 'IntermediarySeal',
    pos = {x = 2, y = 0},
    discovered = false,
    badge_colour = HEX('73C96D'),
    loc_txt = {
        name = 'Tied First Medal',
        label = 'Tied First Medal',
        text = {
            'When this card scores, each card held in hand',
            'with the same {C:attention}rank{} randomly gives',
            '{C:mult}+13{} Mult, {X:chips,C:white}X1.5{} Chips, or {X:mult,C:white}X1.5{} Mult'
        }
    },
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play and G.hand and G.hand.cards then
            local id = card:get_id()
            for _, held in ipairs(G.hand.cards) do
                if held:get_id() == id then
                    local seed = 'balatromon_tied_first_' .. tostring(card.sort_id or 0) .. '_' .. tostring(held.sort_id or 0)
                    if SMODS.pseudorandom_probability(card, seed, 1, 2) then
                        SMODS.calculate_effect({mult = 13}, held)
                    elseif SMODS.pseudorandom_probability(card, seed .. '_x', 1, 2) then
                        SMODS.calculate_effect({xchips = 1.5}, held)
                    else
                        SMODS.calculate_effect({xmult = 1.5}, held)
                    end
                end
            end
        end
    end
}

SMODS.Seal {
    key = 'firewall',
    weight = 0,
    atlas = 'IntermediarySeal',
    pos = {x = 3, y = 0},
    discovered = false,
    badge_colour = HEX('E94C9A'),
    loc_txt = {
        name = 'Firewall Seal',
        label = 'Firewall Seal',
        text = {
            'When scored, gives {C:mult}+1{} to {C:mult}+24{} Mult',
            'and {C:chips}+3{} to {C:chips}+20{} Chips',
            'If held in hand on the {C:attention}winning hand{},',
            'create a {C:spectral}Spectral{} card',
            'Otherwise, {C:green}1 in 2{} chance to avoid being discarded'
        }
    },
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local mult = math.floor(pseudorandom(pseudoseed('balatromon_firewall_mult_' .. tostring(card.sort_id or 0))) * 24) + 1
            local chips = math.floor(pseudorandom(pseudoseed('balatromon_firewall_chips_' .. tostring(card.sort_id or 0))) * 18) + 3
            return {mult = mult, chips = chips}
        end
        if context.after and card.area == G.hand then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.10, func = function()
                if not card or card.REMOVED then return true end
                if SMODS.last_hand_oneshot then
                    card:juice_up(0.8, 0.6)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Spectral!', colour = G.C.PURPLE})
                    create_random_spectral()
                elseif SMODS.pseudorandom_probability(card, 'balatromon_firewall_keep', 1, 2) then
                    card:juice_up(0.5, 0.4)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Blocked!', colour = G.C.GREEN})
                else
                    discard_held_card(card)
                end
                return true
            end}))
        end
    end
}

SMODS.Seal {
    key = 'tampered_gold',
    weight = 0,
    atlas = 'IntermediarySeal',
    pos = {x = 2, y = 1},
    discovered = false,
    badge_colour = HEX('D9A83E'),
    loc_txt = {
        name = 'Tampered Gold Seal',
        label = 'Tampered Gold Seal',
        text = {
            'Gives {C:money}$2{} when scored',
            '{C:green}1 in 3{} chance to give {C:money}$7{} instead'
        }
    },
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local dollars = SMODS.pseudorandom_probability(card, 'balatromon_tampered_gold', 1, 3) and 7 or 2
            return {dollars = dollars}
        end
    end,
    draw = function(self, card, layer)
        local seal = G.shared_seals[card.seal]
        seal.role.draw_major = card
        seal:draw_shader('dissolve', nil, nil, nil, card.children.center)
        seal:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
    end
}

SMODS.Seal {
    key = 'delivery',
    weight = 0,
    atlas = 'IntermediarySeal',
    pos = {x = 3, y = 1},
    discovered = false,
    badge_colour = HEX('9B73D9'),
    loc_txt = {
        name = 'Delivery Seal',
        label = 'Delivery Seal',
        text = {
            'When discarded, can create up to',
            '{C:attention}2{} {C:tarot}Tarot{} cards',
            'Each has a {C:green}1 in 4{} chance to be created'
        }
    },
    calculate = function(self, card, context)
        if context.discard and context.other_card == card then
            local made = 0
            for i = 1, 2 do
                if SMODS.pseudorandom_probability(card, 'balatromon_delivery_' .. i, 1, 4) and BM.has_room(G.consumeables) then
                    create_random_tarot()
                    made = made + 1
                end
            end
            if made > 0 then return {message = made == 2 and '2 Tarots!' or 'Tarot!', colour = G.C.PURPLE} end
        end
    end
}

SMODS.Seal {
    key = 'corrupted',
    weight = 0,
    atlas = 'IntermediarySeal',
    pos = {x = 4, y = 1},
    discovered = false,
    badge_colour = HEX('D24A42'),
    loc_txt = {
        name = 'Corrupted Seal',
        label = 'Corrupted Seal',
        text = {
            'Retriggers this card up to',
            '{C:attention}2{} additional times',
            'Each retrigger has a {C:green}1 in 2{} chance'
        }
    },
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            local reps = 0
            for i = 1, 2 do
                if SMODS.pseudorandom_probability(card, 'balatromon_corrupted_' .. i, 1, 2) then reps = reps + 1 end
            end
            if reps > 0 then return {repetitions = reps} end
        end
    end
}

SMODS.Seal {
    key = 'spacious',
    weight = 0,
    atlas = 'IntermediarySeal',
    pos = {x = 5, y = 1},
    discovered = false,
    badge_colour = HEX('5D91D8'),
    loc_txt = {
        name = 'Spacious Seal',
        label = 'Spacious Seal',
        text = {
            'If held in hand at end of round, create the',
            '{C:planet}Planet{} card for the final played poker hand',
            '{C:green}1 in 3{} chance for it to be {C:dark_edition}Negative{}'
        }
    },
    calculate = function(self, card, context)
        if context.playing_card_end_of_round and context.cardarea == G.hand and not context.repetition then
            local negative = SMODS.pseudorandom_probability(card, 'balatromon_spacious_negative', 1, 3)
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
                local planet = BM.add_planet_for_hand(G.GAME.last_hand_played, 'balatromon_spacious')
                if planet and negative then planet:set_edition({negative = true}, true, true) end
                return true
            end}))
            return {message = negative and 'Negative!' or 'Planet!', colour = G.C.BLUE}
        end
    end
}

