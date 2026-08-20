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

-- ============================================================
-- DIGITAG
-- Mirrors vanilla Charm/Meteor/Ethereal tags: after choosing the next Blind,
-- directly open the Jumbo Digital Pack.
-- ============================================================

SMODS.Tag {
    key = 'digitag',
    atlas = 'Tag',
    pos = {x = 1, y = 0},
    discovered = true,
    config = {type = 'new_blind_choice'},

    loc_txt = {
        name = 'Digitag',
        text = {
            'After selecting the next Blind,',
            'open a {C:attention}Jumbo Digital Pack{}',
        },
    },

    apply = function(self, tag, context)
        if context.type ~= 'new_blind_choice' or tag.triggered then return end

        local key = 'p_' .. BM.PREFIX .. '_jumbo_digital_pack'
        local center = G.P_CENTERS[key]
        if not center then
            print('[Balatromon] Digitag: missing booster center ' .. key)
            return
        end

        local lock = tag.ID
        G.CONTROLLER.locks[lock] = true

        tag:yep('Digital Pack!', G.C.BLUE, function()
            -- This is intentionally the same opening pattern used by vanilla
            -- Charm/Meteor/Ethereal/Standard/Buffoon tags.
            local card = Card(
                G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
                G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
                G.CARD_W * 1.27,
                G.CARD_H * 1.27,
                G.P_CARDS.empty,
                center,
                {bypass_discovery_center = true, bypass_discovery_ui = true}
            )
            card.cost = 0
            card.from_tag = true
            G.FUNCS.use_card({config = {ref_table = card}})
            card:start_materialize()
            G.CONTROLLER.locks[lock] = nil
            return true
        end)

        tag.triggered = true
        return true
    end,
}

-- ============================================================
-- EVOLUTION TAG
-- IMPORTANT: this Tag does NOT trigger in Tag:apply at all.
-- It stays visible through Blind selection. core.lua consumes it only when
-- the first hand is actually drawn INSIDE the next Blind.
-- ============================================================

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
        -- Deliberately empty. We do NOT consume on new_blind_choice.
        -- core.lua handles this tag on context.first_hand_drawn.
    end,
}

-- ============================================================
-- CUTE TAG
-- Immediate: create exactly 4 random Fresh Digimon, but only if all 4 fit.
-- ============================================================

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
