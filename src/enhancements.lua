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


                    -- Make sure it is still a Calumon Card.
                    if not SMODS.has_enhancement(
                        card,
                        'm_DigiMeel_calumon'
                    ) then

                        return true
                    end


                    card:juice_up(0.8, 0.7)

                    play_sound('generic1')


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



                    card:set_ability(
                        G.P_CENTERS[
                            'm_DigiMeel_evolution'
                        ],
                        nil,
                        false
                    )


                    card:juice_up(1.1, 0.8)

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