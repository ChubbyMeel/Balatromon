local BM = Balatromon



SMODS.Enhancement {
    key = 'calumon',

    atlas = 'Enhancement',
    pos = {
        x = 0,
        y = 0
    },


    replace_base_card = true,

    no_rank = true,
    no_suit = true,

    always_scores = true,

    config = {
        extra = {
            scores = 0
        }
    },

    loc_txt = {
        name = 'Calumon Card',

        text = {
            'Has no {C:attention}rank{} or {C:attention}suit{}',
            'After this card scores {C:attention}3{} times,',
            'transform it into an {C:attention}Evolution Card{}',
            'Cannot be retriggered',
            '{C:inactive}(Currently {C:attention}#1#{C:inactive}/3)'
        }
    },

    in_pool = function(self, args)
        return true
    end,

    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra = card.ability.extra or {}

        if card.ability.extra.scores == nil then
            card.ability.extra.scores = 0
        end
    end,

    loc_vars = function(self, info_queue, card)

        local scores = 0

        if card
        and card.ability
        and card.ability.extra then

            scores = card.ability.extra.scores or 0

        end

        return {
            vars = {
                scores
            }
        }
    end,

    calculate = function(self, card, context)

        -- This runs when this playing card actually scores.
        -- Retriggers therefore also count as another score.
        if context.cardarea == G.play
        and context.main_scoring then

            card.ability.extra =
                card.ability.extra or {}

            local extra = card.ability.extra

            -- Already waiting for the transformation event.
            if extra.transforming then
                return
            end

            extra.scores =
                (extra.scores or 0) + 1


            -- Show progress.
            card:juice_up(0.25, 0.25)

            card_eval_status_text(
                card,
                'extra',
                nil,
                nil,
                nil,
                {
                    message =
                        tostring(extra.scores) .. '/3',
                    colour = G.C.ATTENTION
                }
            )


            -- Not ready yet.
            if extra.scores < 3 then
                return
            end


            -- Prevent a retrigger from scheduling
            -- several transformations simultaneously.
            extra.transforming = true


            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.20,

                func = function()

                    if not card
                    or card.REMOVED then
                        return true
                    end


                    if not SMODS.has_enhancement(
                        card,
                        'm_DigiMeel_calumon'
                    ) then
                        return true
                    end


                    card_eval_status_text(
                        card,
                        'extra',
                        nil,
                        nil,
                        nil,
                        {
                            message = 'Evolve!',
                            colour = G.C.GREEN
                        }
                    )


                    BM.animate_enhancement_change(
                        card,
                        'm_DigiMeel_evolution'
                    )

                    return true
                end,
            }))

        end
    end,
}


SMODS.Enhancement {
    key = 'evolution',

    atlas = 'Enhancement',
    pos = {
        x = 1,
        y = 0
    },

    replace_base_card = true,

    no_rank = true,
    no_suit = true,

    always_scores = true,

    -- Makes the playing card visually shatter when destroyed.
    shatters = true,

    loc_txt = {
        name = 'Evolution Card',

        text = {
            'Has no {C:attention}rank{} or {C:attention}suit{}',
            'When scored, {C:green}#1# in #2#{} chance',
            'to Digivolve a random eligible Digimon',
            'regardless of {C:green}Bond{}',
            'Cannot be retriggered',
            '{C:red}Destroys itself{} after activating'
        }
    },


    in_pool = function(self, args)
        return false
    end,

    loc_vars = function(self, info_queue, card)

        local numerator, denominator =
            SMODS.get_probability_vars(
                card,
                1,
                3,
                'balatromon_evolution_card'
            )

        return {
            vars = {
                numerator,
                denominator
            }
        }
    end,

    calculate = function(self, card, context)

        if context.cardarea ~= G.play
        or not context.main_scoring then
            return
        end


        card.ability.extra =
            card.ability.extra or {}

        local extra = card.ability.extra


        -- A successful activation is already waiting
        -- to resolve.
        if extra.evolution_triggering then
            return
        end


        -- Don't roll the chance when there isn't even
        -- a valid Digimon to evolve.
        local candidates =
            BM.get_evolution_card_candidates()

        if #candidates == 0 then
            return
        end


        -- 1 in 3, using Balatro/SMODS seeded probability.
        local success =
            SMODS.pseudorandom_probability(
                card,
                'balatromon_evolution_card_roll',
                1,
                3,
                'balatromon_evolution_card'
            )


        -- Failed roll:
        -- card survives and can try again next score/retrigger.
        if not success then
            return
        end


        extra.evolution_triggering = true


        card:juice_up(0.8, 0.7)

        play_sound('generic1')


        card_eval_status_text(
            card,
            'extra',
            nil,
            nil,
            nil,
            {
                message = 'Digivolve!',
                colour = G.C.GREEN
            }
        )


        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.20,

            func = function()

                if not card
                or card.REMOVED then
                    return true
                end


                -- Randomly evolve a valid Digimon.
                local evolved =
                    BM.trigger_evolution_card(card)


                -- Something changed before the event resolved
                -- and there is no longer a valid target.
                if not evolved then

                    if card.ability
                    and card.ability.extra then

                        card.ability.extra
                            .evolution_triggering = nil

                    end

                    return true
                end


                -- Let the Digivolution animation happen
                -- before the Evolution Card breaks.
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.55,

                    func = function()

                        if card
                        and not card.REMOVED then

                            SMODS.destroy_cards(card)

                        end

                        return true
                    end,
                }))


                return true
            end,
        }))

    end,
}

SMODS.Enhancement {
    key = 'jogress',
    atlas = 'Enhancement',
    pos = {x = 2, y = 0},

    config = {
        extra = {
            jogress_sources = {}
        }
    },

    loc_txt = {
        name = 'Jogress Card',
        text = {
            'Counts as either of its {C:attention}2 source cards{}',
            '{C:inactive}Jogress of {V:1}#1#{} {C:inactive}+ {V:2}#2#{}'
        }
    },

    in_pool = function(self, args)
        return false
    end,

    set_ability = function(
        self,
        card,
        initial,
        delay_sprites
    )
        card.ability.extra =
            card.ability.extra or {}

        card.ability.extra
            .jogress_sources =
            card.ability.extra
                .jogress_sources
            or {}
    end,

    loc_vars = function(
        self,
        info_queue,
        card
    )
        local sources =
            card
            and card.ability
            and card.ability.extra
            and card.ability.extra
                .jogress_sources
            or {}

        local first =
            BM.native_card_identity(card)

        if not first then
            first =
                sources[1]
        end

        local second =
            sources[2]

        local first_name =
            first
            and BM.card_identity_name(
                first
            )
            or 'First card'

        local second_name =
            second
            and BM.card_identity_name(
                second
            )
            or 'Second card'

        local first_colour =
            first
            and G.C.SUITS
            and G.C.SUITS[
                first.suit
            ]
            or G.C.FILTER

        local second_colour =
            second
            and G.C.SUITS
            and G.C.SUITS[
                second.suit
            ]
            or G.C.FILTER

        return {
            vars = {
                first_name,
                second_name,

                colours = {
                    first_colour,
                    second_colour
                }
            }
        }
    end,
}


SMODS.Enhancement {
    key = 'signal',
    atlas = 'Enhancement',
    pos = {x = 3, y = 0},

    loc_txt = {
        name = 'Signal Card',
        text = {
            'When scored, pull up to {C:attention}2{} cards',
            'of the same {C:attention}rank{} from your deck',
            'into your hand'
        }
    },

    in_pool = function(self, args)
        return false
    end,

    calculate = function(
        self,
        card,
        context
    )
        if context.cardarea ~= G.play
        or not context.main_scoring
        or card.debuff then
            return
        end

        if not G.deck
        or not G.hand then
            return
        end

        local rank =
            BM.get_rank(card)

        if not rank then
            return
        end

        local pending =
            BM._signal_pending_draws
            or 0

        local room =
            math.max(
                0,
                (G.hand.config.card_limit or 0)
                - #G.hand.cards
                - pending
            )

        local wanted =
            math.min(
                2,
                room
            )

        if wanted <= 0 then
            return
        end

        local pulls = {}

        for i = #G.deck.cards, 1, -1 do
            local candidate =
                G.deck.cards[i]

            if candidate
            and not candidate
                ._bm_signal_reserved
            and BM.card_has_rank(
                candidate,
                rank
            ) then
                candidate
                    ._bm_signal_reserved =
                    true

                pulls[
                    #pulls + 1
                ] =
                    candidate

                if #pulls >= wanted then
                    break
                end
            end
        end

        if #pulls == 0 then
            return
        end

        BM._signal_pending_draws =
            pending + #pulls

        for i, target in ipairs(
            pulls
        ) do
            draw_card(
                G.deck,
                G.hand,
                i * 100 / #pulls,
                'up',
                true,
                target,
                0.08
            )
        end

        G.E_MANAGER:add_event(
            Event({
                trigger = 'after',
                delay = 0.25,

                func = function()
                    for _, target in ipairs(
                        pulls
                    ) do
                        if target then
                            target
                                ._bm_signal_reserved =
                                nil
                        end
                    end

                    BM._signal_pending_draws =
                        math.max(
                            0,
                            (
                                BM._signal_pending_draws
                                or 0
                            )
                            - #pulls
                        )

                    return true
                end
            })
        )

        return {
            message = 'Signal!',
            colour = G.C.BLUE
        }
    end,
}