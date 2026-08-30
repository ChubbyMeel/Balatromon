local BM = Balatromon

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
        and card.seal ~= 'glitch' then
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


-- Move a card currently held in hand into discard.
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



-- ============================================================
-- FARM SEAL
-- Creates 2 Negative Food if held at end of round
-- ============================================================

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



-- ============================================================
-- DIGITAL SEAL
-- If played but NOT part of scoring hand:
-- create 1 random Digi Item
-- ============================================================

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

        -- "before" gives us both full_hand and scoring_hand.
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



-- ============================================================
-- SILVER MEDAL
--
-- When this card scores:
-- every same-rank card currently held in hand gives +13 Mult.
--
-- Example:
-- scoring 8 with Silver Medal
-- hand contains three other 8s
-- -> +39 Mult
-- ============================================================

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

        -- ====================================================
        -- WHEN SCORED
        -- ====================================================

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


        -- ====================================================
        -- WHEN HELD IN HAND
        -- ====================================================

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


                    -- This hand defeated the Blind.
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