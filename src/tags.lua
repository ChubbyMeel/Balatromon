local BM = Balatromon

-- ============================================================
-- HELPERS
-- ============================================================

local function get_digimon_jokers()
    local result = {}
    if not (G.jokers and G.jokers.cards) then return result end

    for _, card in ipairs(G.jokers.cards) do
        if BM.is_digimon(card) then
            result[#result + 1] = card
        end
    end

    return result
end

local function get_fresh_digimon_pool()
    local result = {}
    if not (G.P_CENTER_POOLS and G.P_CENTER_POOLS.Joker) then return result end

    local fresh_rarity = BM.stage_rarity('Fresh')
    for _, center in ipairs(G.P_CENTER_POOLS.Joker) do
        if center.balatromon == true and center.rarity == fresh_rarity then
            result[#result + 1] = center
        end
    end

    return result
end

-- ============================================================
-- MEAL TAG
-- Immediate: fully feeds all Digimon. If there are none, it still consumes.
-- ============================================================

SMODS.Tag {
    key = 'meal',
    atlas = 'Tag',
    pos = {x = 0, y = 0},
    discovered = true,
    config = {type = 'immediate'},

    loc_txt = {
        name = 'Meal Tag',
        text = {
            'Immediately reset the',
            '{C:attention}Hunger{} of all Digimon',
        },
    },

    apply = function(self, tag, context)
        if context.type ~= 'immediate' or tag.triggered then return end

        local lock = tag.ID
        G.CONTROLLER.locks[lock] = true

        tag:yep('Meal Time!', G.C.GREEN, function()
            for _, joker in ipairs(get_digimon_jokers()) do
                BM.feed(joker, 99)
                joker:juice_up(0.5, 0.5)
            end
            G.CONTROLLER.locks[lock] = nil
            return true
        end)

        tag.triggered = true
        return true
    end,
}



SMODS.Tag {
    key = 'digitag',
    atlas = 'Tag',
    pos = {x = 1, y = 0},
    discovered = true,
    config = {type = 'new_blind_choice'},

    loc_txt = {
        name = 'Digitag',
        text = {
            'Gives a {C:attention}Mega Digital Pack{}',
        },
    },

    apply = function(self, tag, context)
        if context.type ~= 'new_blind_choice'
        or tag.triggered then
            return
        end

        local key = BM.random_digital_pack_key(
            'mega',
            'balatromon_digitag'
                .. tostring(G.GAME.round_resets.ante or 0)
        )

        if not key then
            print('[Balatromon] Digitag: no Mega Digital Pack found')
            return
        end

        local center = G.P_CENTERS[key]

        if not center then
            print('[Balatromon] Digitag: missing booster center ' .. tostring(key))
            return
        end

        local lock = tag.ID
        G.CONTROLLER.locks[lock] = true

        tag:yep('Mega Pack!', G.C.BLUE, function()
            local card = Card(
                G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
                G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
                G.CARD_W * 1.27,
                G.CARD_H * 1.27,
                G.P_CARDS.empty,
                center,
                {
                    bypass_discovery_center = true,
                    bypass_discovery_ui = true
                }
            )

            card.cost = 0
            card.from_tag = true

            G.FUNCS.use_card({
                config = {
                    ref_table = card
                }
            })

            card:start_materialize()

            G.CONTROLLER.locks[lock] = nil
            return true
        end)

        tag.triggered = true
        return true
    end,
}


SMODS.Tag {
    key = 'evolution_tag',
    atlas = 'Tag',
    pos = {x = 2, y = 0},
    discovered = true,

    loc_txt = {
        name = 'Evolution Tag',
        text = {
            'At the start of the next Blind,',
            'create a {C:attention}Calumon Card{}',
            'and draw it to hand',
        },
    },

    apply = function(self, tag, context)
    end,
}



SMODS.Tag {
    key = 'cute',
    atlas = 'Tag',
    pos = {x = 3, y = 0},
    discovered = true,
    config = {type = 'immediate'},

    loc_txt = {
        name = 'Cute Tag',
        text = {
            'Create {C:attention}4{} random',
            '{C:attention}Fresh{} Digimon',
            '{C:inactive}(Must have room)',
        },
    },

    apply = function(self, tag, context)
        if context.type ~= 'immediate' or tag.triggered then return end
        if not G.jokers then return end

        local free_slots = (G.jokers.config.card_limit or 0) - #G.jokers.cards
        if free_slots < 4 then return end

        local pool = get_fresh_digimon_pool()
        if #pool == 0 then
            print('[Balatromon] Cute Tag: Fresh Digimon pool is empty')
            return
        end

        local lock = tag.ID
        G.CONTROLLER.locks[lock] = true
        tag.triggered = true -- set BEFORE events so it cannot queue twice

        tag:yep('So Cute!', G.C.GREEN, function()
            for i = 1, 4 do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.12 * i,
                    func = function()
                        local center = BM.random_element(
                            pool,
                            'balatromon_cute_tag_spawn_' .. tostring(i)
                        )
                        if center then
                            local joker = SMODS.add_card {
                                set = 'Joker',
                                area = G.jokers,
                                key = center.key,
                            }
                            if joker then joker:juice_up(0.7, 0.5) end
                        end
                        return true
                    end,
                }))
            end

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.55,
                func = function()
                    G.CONTROLLER.locks[lock] = nil
                    return true
                end,
            }))
            return true
        end)

        return true
    end,
}

local function get_stage_digimon_pool(stage)
    local pool = {}

    for _, center in ipairs(
        G.P_CENTER_POOLS
        and G.P_CENTER_POOLS.Joker
        or {}
    ) do
        if center.balatromon == true
        and center.balatromon_stage == stage then
            pool[#pool + 1] = center
        end
    end

    return pool
end

local function apply_stage_shop_tag(tag, context, stage, seed, colour)
    if context.type ~= 'store_joker_create'
    or tag.triggered then
        return
    end

    local pool = get_stage_digimon_pool(stage)

    if #pool == 0 then
        tag:nope()
        tag.triggered = true
        return
    end

    local center = BM.random_element(
        pool,
        seed .. '_' .. tostring(G.GAME.round_resets.ante or 0)
    )

    if not center then
        tag:nope()
        tag.triggered = true
        return
    end

    local card = create_card(
        'Joker',
        context.area,
        nil,
        nil,
        nil,
        nil,
        center.key,
        seed
    )

    create_shop_card_ui(
        card,
        'Joker',
        context.area
    )

    card.states.visible = false

    tag:yep('+', colour, function()
        card:start_materialize()
        card.ability.couponed = true
        card:set_cost()
        return true
    end)

    tag.triggered = true

    return card
end


SMODS.Tag:take_ownership('uncommon', {
    loc_txt = {
        name = 'Champion Tag',
        text = {
            'Shop has a free',
            '{C:attention}Champion Digimon{}',
        },
    },

    apply = function(self, tag, context)
        return apply_stage_shop_tag(
            tag,
            context,
            'Champion',
            'balatromon_champion_tag',
            G.C.GREEN
        )
    end,
}, true)


SMODS.Tag:take_ownership('rare', {
    loc_txt = {
        name = 'Ultimate Tag',
        text = {
            'Shop has a free',
            '{C:attention}Ultimate Digimon{}',
        },
    },

    apply = function(self, tag, context)
        return apply_stage_shop_tag(
            tag,
            context,
            'Ultimate',
            'balatromon_ultimate_tag',
            G.C.RED
        )
    end,
}, true)


SMODS.Tag:take_ownership('top_up', {
    in_pool = function(self, args)
        return false
    end,

    no_collection = true,
}, true)


SMODS.Tag:take_ownership(
    'buffoon',
    {
        loc_txt = {
            name = 'Crest Tag',
            text = {
                'Gives a free {C:attention}Mega Crest Pack{}',
            },
        },

        apply = function(self, tag, context)
            if context.type ~= 'new_blind_choice'
            or tag.triggered then
                return
            end

            local center =
                G.P_CENTERS['p_buffoon_mega_1']

            if not center then
                print(
                    '[Balatromon] Crest Tag: '
                    .. 'Mega Crest Pack center missing'
                )
                return
            end

            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true

            tag:yep(
                'Crest Pack!',
                G.C.BLUE,
                function()
                    local card = Card(
                        G.play.T.x
                            + G.play.T.w / 2
                            - G.CARD_W * 1.27 / 2,

                        G.play.T.y
                            + G.play.T.h / 2
                            - G.CARD_H * 1.27 / 2,

                        G.CARD_W * 1.27,
                        G.CARD_H * 1.27,

                        G.P_CARDS.empty,
                        center,

                        {
                            bypass_discovery_center = true,
                            bypass_discovery_ui = true
                        }
                    )

                    card.cost = 0
                    card.from_tag = true

                    G.FUNCS.use_card({
                        config = {
                            ref_table = card
                        }
                    })

                    card:start_materialize()

                    G.CONTROLLER.locks[lock] = nil

                    return true
                end
            )

            tag.triggered = true

            return true
        end,
    },
    true
)