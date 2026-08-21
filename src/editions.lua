local BM = Balatromon

local function bloom_feed(source)
    if not G.jokers then
        return false
    end

    local candidates = {}

    for _, joker in ipairs(G.jokers.cards or {}) do
        if BM.is_digimon(joker) then
            local e =
                joker.ability
                and joker.ability.extra

            if e
            and not e.permanently_disabled
            and (e.hunger or 1) > 1 then
                candidates[#candidates + 1] =
                    joker
            end
        end
    end

    if #candidates == 0 then
        return false
    end

    G.GAME.balatromon_bloom_triggers =
        (G.GAME.balatromon_bloom_triggers or 0)
        + 1

    local target = BM.random_element(
        candidates,
        'balatromon_bloom_'
        .. tostring(
            G.GAME.balatromon_bloom_triggers
        )
        .. '_'
        .. tostring(
            source
            and source.sort_id
            or 0
        )
    )

    if not target then
        return false
    end

    BM.feed(target, 1)

    target:juice_up(0.8, 0.5)

    card_eval_status_text(
        target,
        'extra',
        nil,
        nil,
        nil,
        {
            message = 'Fed!',
            colour = G.C.GREEN
        }
    )

    return true
end

SMODS.Shader {
    key = 'bloom',
    path = 'bloom.fs',

    send_vars = function(sprite, card)
        return {
            bloom_time =
                love.timer.getTime()
        }
    end,
}

SMODS.Edition {
    key = 'bloom',
    shader = 'bloom',

    discovered = true,
    unlocked = true,

    in_shop = true,
    weight = 10,

    badge_colour = HEX('E86DB5'),
    text_colour = G.C.WHITE,

    loc_txt = {
        name = 'Bloom',
        label = 'Bloom',

        text = {
            'When this card activates,',
            'reduce the {C:attention}Hunger{} of',
            'a random hungry {C:attention}Digimon{} by {C:attention}1{}'
        }
    },

    get_weight = function(self)
        return
            G.GAME.edition_rate
            * self.weight
    end,

    calculate = function(self, card, context)
        local activated = false

        if context.main_scoring
        and context.cardarea == G.play then
            activated = true

        elseif context.pre_joker
        and context.cardarea == G.jokers then
            activated = true
        end

        if not activated then
            return
        end

        if bloom_feed(card) then
            return {
                message = 'Bloom!',
                colour = HEX('E86DB5')
            }
        end
    end,
}