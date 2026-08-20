local BM = Balatromon

-- Balatromon's custom care-item pool.
-- A positive shop_rate allows Digi Items to naturally occupy consumable shop
-- slots. Individual card weights can be tuned later without changing the API.
SMODS.ConsumableType {
    key = 'DigiItem',
    primary_colour = G.C.ORANGE,
    secondary_colour = G.C.YELLOW,
    loc_txt = {
        name = 'Digi Item',
        collection = 'Digi Items',
        undiscovered = {name = 'Unknown Digi Item', text = {'Find this item in a run'}},
    },
    collection_rows = {4, 4},
    shop_rate = 1.0,
}

local function selected_digimon(max_count)
    local selected = {}
    for _, c in ipairs(G.jokers and G.jokers.highlighted or {}) do
        if BM.is_digimon(c) then
            selected[#selected + 1] = c
            if max_count and #selected >= max_count then break end
        end
    end
    return selected
end

-- Temporarily raise the Joker highlight limit while a multi-target Digi Item
-- is selected. This lets items such as Food target two Digimon at once without
-- permanently changing normal Joker selection behaviour.
local function card_is_highlighted(card)
    if not card then return false end
    if card.highlighted then return true end

    local area = card.area
    for _, highlighted in ipairs(area and area.highlighted or {}) do
        if highlighted == card then return true end
    end

    return false
end

local function clear_extra_joker_highlights()
    if not G.jokers then return end

    -- CardArea supplies this in vanilla Balatro. Keep a fallback so this
    -- remains harmless if another mod replaces the CardArea implementation.
    if G.jokers.unhighlight_all then
        G.jokers:unhighlight_all()
        return
    end

    for i = #(G.jokers.highlighted or {}), 1, -1 do
        local joker = G.jokers.highlighted[i]
        if joker and joker.highlight then joker:highlight(false) end
    end
end

local function stop_multi_joker_targeting(card, clear_highlights)
    if BM._multi_joker_target_card ~= card then return end

    if G.jokers and G.jokers.config then
        G.jokers.config.highlighted_limit = BM._multi_joker_previous_limit or 1
    end

    BM._multi_joker_target_card = nil
    BM._multi_joker_previous_limit = nil
    BM._multi_joker_target_limit = nil

    if clear_highlights then
        clear_extra_joker_highlights()
    end
end

local function update_multi_joker_targeting(card, max_targets)
    if not G.jokers or not G.jokers.config then return end

    if card_is_highlighted(card) then
        if BM._multi_joker_target_card ~= card then
            -- If another multi-target consumable was active, restore its state
            -- before this one takes ownership of Joker selection.
            if BM._multi_joker_target_card then
                local old = BM._multi_joker_target_card
                stop_multi_joker_targeting(old, true)
            end

            BM._multi_joker_target_card = card
            BM._multi_joker_previous_limit = G.jokers.config.highlighted_limit or 1
        end

        BM._multi_joker_target_limit = max_targets
        G.jokers.config.highlighted_limit = max_targets
    elseif BM._multi_joker_target_card == card then
        stop_multi_joker_targeting(card, true)
    end
end

local function change_bond(card, amount)
    if not BM.is_digimon(card) then
        return
    end

    local e = card.ability.extra

    if e.permanently_disabled then
        return
    end

    local max_bond = BM.get_bond_max(card)

    e.bond = math.max(
        0,
        math.min(
            max_bond,
            (e.bond or 0) + (amount or 0)
        )
    )

    if BM.is_bond_full(card) then
        BM.start_bond_shake(card)
    end
end

local function change_care(card, amount)
    if not BM.is_digimon(card) then return end
    local e = card.ability.extra
    e.care_mistakes = math.max(0, math.min(3, (e.care_mistakes or 0) + (amount or 0)))
    if e.care_mistakes < 3 then e.care_crisis = nil end
end

local function stage_cards(stage)
    local out = {}
    for slug, def in pairs(BM.joker_defs or {}) do
        if def.stage == stage then
            local key = BM.center_key(slug)
            if G.P_CENTERS[key] then out[#out + 1] = key end
        end
    end
    return out
end

local function room_for(area, n)
    if not area then return false end
    return #area.cards + (n or 1) <= area.config.card_limit
end

local function create_random_stage(stage, count, seed)
    count = count or 1
    local pool = stage_cards(stage)
    if #pool == 0 then return 0 end
    local made = 0
    for i = 1, count do
        if not BM.has_room(G.jokers) then break end
        local key = BM.random_element(pool, (seed or 'balatromon_stage') .. tostring(i))
        if key then
            SMODS.add_card { set = 'Joker', area = G.jokers, key = key }
            made = made + 1
        end
    end
    return made
end

local function leftmost_stage(stages)
    local wanted = {}
    for _, s in ipairs(stages) do wanted[s] = true end
    for _, c in ipairs(G.jokers and G.jokers.cards or {}) do
        if BM.is_digimon(c) and wanted[c.config.center.balatromon_stage] then return c end
    end
end

local function random_stage_targets(stages, amount, seed)
    local wanted, pool = {}, {}
    for _, s in ipairs(stages) do wanted[s] = true end
    for _, c in ipairs(G.jokers and G.jokers.cards or {}) do
        if BM.is_digimon(c) and wanted[c.config.center.balatromon_stage] then pool[#pool+1] = c end
    end
    local result = {}
    while #pool > 0 and #result < amount do
        local pick = BM.random_element(pool, seed .. tostring(#result + 1))
        if not pick then break end
        result[#result+1] = pick
        for i,c in ipairs(pool) do if c == pick then table.remove(pool,i); break end end
    end
    return result
end

-- Digivices now use the shared evolution engine in src/evolution.lua.
-- If the chosen Digimon has one viable route, it evolves immediately.
-- If it has multiple viable routes, Balatromon opens an interactive panel.
local function has_stage(stages, stage)
    for _, wanted in ipairs(stages) do
        if wanted == stage then return true end
    end
    return false
end

local function eligible_stage_cards(stages, device_key)
    local out = {}
    for _, c in ipairs(G.jokers and G.jokers.cards or {}) do
        if BM.is_digimon(c)
        and has_stage(stages, c.config.center.balatromon_stage)
        and BM.can_digivolve_with(c, device_key) then
            out[#out + 1] = c
        end
    end
    return out
end

local function leftmost_ready_stage(stages, device_key)
    for _, c in ipairs(G.jokers and G.jokers.cards or {}) do
        if BM.is_digimon(c)
        and has_stage(stages, c.config.center.balatromon_stage)
        and BM.can_digivolve_with(c, device_key) then
            return c
        end
    end
end

local function random_ready_stage_targets(stages, amount, seed, device_key)
    local pool = eligible_stage_cards(stages, device_key)
    local result = {}

    while #pool > 0 and #result < amount do
        local pick = BM.random_element(pool, seed .. tostring(#result + 1))
        if not pick then break end
        result[#result + 1] = pick

        for i, c in ipairs(pool) do
            if c == pick then
                table.remove(pool, i)
                break
            end
        end
    end

    return result
end

local function device_can_use(stages, random_count, device_key)
    if random_count then
        return #eligible_stage_cards(stages, device_key) > 0
    end
    return leftmost_ready_stage(stages, device_key) ~= nil
end

local function device_use(stages, random_count, seed, device_key)
    local targets = {}

    if random_count then
        targets = random_ready_stage_targets(stages, random_count, seed, device_key)
    else
        local target = leftmost_ready_stage(stages, device_key)
        if target then targets[1] = target end
    end

    BM.begin_evolution_sequence(targets, device_key)
end

local COMMON_CARD = {
    set = 'DigiItem',
    atlas = 'Joker',
    pos = {x=0,y=0},
    discovered = true,
    unlocked = true,
}

SMODS.Consumable {
    set = COMMON_CARD.set, key = 'food', atlas = 'Consumable', pos = {x=0,y=0},
    discovered = true, unlocked = true, cost = 3,
    loc_txt = {name='Food', text={
        'Reduce {C:attention}Hunger{} by {C:attention}1{}',
        'for up to {C:attention}2{} selected Digimon'
    }},

    -- While Food itself is highlighted, allow two Jokers to be highlighted.
    -- Deselecting Food restores the normal Joker highlight limit.
    update = function(self, card, dt)
        update_multi_joker_targeting(card, 2)
    end,

    can_use = function(self, card)
        local t = selected_digimon(3)
        return #t >= 1 and #t <= 2
    end,
    use = function(self, card, area, copier)
        -- Capture the chosen targets before clearing the temporary selection.
        local targets = selected_digimon(2)

        BM.remember_digi_item(card)
        for _, target in ipairs(targets) do BM.feed(target, 1) end

        -- The consumed card may disappear before its next update tick, so
        -- explicitly restore normal Joker selection here as well.
        stop_multi_joker_targeting(card, true)
    end,
}

SMODS.Consumable {
    set = COMMON_CARD.set, key = 'hefty_food', atlas = 'Consumable', pos = {x=1,y=0},
    discovered = true, unlocked = true, cost = 4,
    loc_txt = {name='Hefty Food', text={
        'Reduce {C:attention}Hunger{} by {C:attention}2{}',
        'for {C:attention}1{} selected Digimon'
    }},
    can_use = function(self, card) return #selected_digimon(2) == 1 end,
    use = function(self, card, area, copier)
        BM.remember_digi_item(card)
        local t = selected_digimon(1)[1]
        if t then BM.feed(t, 2) end
    end,
}

SMODS.Consumable {
    set = COMMON_CARD.set, key = 'playball', atlas = 'Consumable', pos = {x=2,y=0},
    discovered = true, unlocked = true, cost = 3,
    loc_txt = {name='PlayBall', text={
        'Increase {C:green}Bond{} of',
        '{C:attention}1{} selected Digimon by {C:green}1{}'
    }},
    can_use = function(self, card) return #selected_digimon(2) == 1 end,
    use = function(self, card, area, copier)
        BM.remember_digi_item(card)
        local t = selected_digimon(1)[1]
        if t then change_bond(t, 1) end
    end,
}

SMODS.Consumable {
    set = COMMON_CARD.set, key = 'bandaid', atlas = 'Consumable', pos = {x=3,y=0},
    discovered = true, unlocked = true, cost = 3,
    loc_txt = {name='Bandaid', text={
        'Remove {C:red}1 Care Mistake{}',
        'from {C:attention}1{} selected Digimon'
    }},
    can_use = function(self, card)
        local t = selected_digimon(2)
        return #t == 1 and ((t[1].ability.extra.care_mistakes or 0) > 0)
    end,
    use = function(self, card, area, copier)
        BM.remember_digi_item(card)
        local t = selected_digimon(1)[1]
        if t then change_care(t, -1) end
    end,
}

SMODS.Consumable {
    set = COMMON_CARD.set, key = 'digivice', atlas = 'Consumable', pos = {x=4,y=0},
    discovered = true, unlocked = true, cost = 4,
    loc_txt = {name='Digivice', text={
        'Digivolve the leftmost {C:attention}Fresh{},',
        '{C:attention}In-Training{}, or {C:attention}Rookie{} Digimon',
        '{C:inactive}(Choose a form if it branches){}'
    }},
    can_use = function(self, card) return device_can_use({'Fresh','In-Training','Rookie'}, nil, 'digivice') end,
    use = function(self, card, area, copier)
        BM.remember_digi_item(card)
        device_use({'Fresh','In-Training','Rookie'}, nil, 'digivice', 'digivice')
    end,
}

SMODS.Consumable {
    set = COMMON_CARD.set, key = 'd_3', atlas = 'Consumable', pos = {x=0,y=1},
    discovered = true, unlocked = true, cost = 5,
    loc_txt = {name='D-3', text={
        'Digivolve {C:attention}2 random{}',
        '{C:attention}In-Training{} or {C:attention}Rookie{} Digimon',
        '{C:inactive}(Choose a form if it branches){}'
    }},
    can_use = function(self, card) return device_can_use({'In-Training','Rookie'}, 2, 'd3') end,
    use = function(self, card, area, copier)
        BM.remember_digi_item(card)
        device_use({'In-Training','Rookie'}, 2, 'd3', 'd3')
    end,
}

SMODS.Consumable {
    set = COMMON_CARD.set, key = 'd_ark', atlas = 'Consumable', pos = {x=1,y=1},
    discovered = true, unlocked = true, cost = 5,
    loc_txt = {name='D-Ark', text={
        'Digivolve the leftmost {C:attention}Rookie{}',
        'or {C:attention}Champion{} Digimon',
        '{C:inactive}(Choose a form if it branches){}'
    }},
    can_use = function(self, card) return device_can_use({'Rookie','Champion'}, nil, 'd_ark') end,
    use = function(self, card, area, copier)
        BM.remember_digi_item(card)
        device_use({'Rookie','Champion'}, nil, 'd_ark', 'd_ark')
    end,
}

SMODS.Consumable {
    set = COMMON_CARD.set, key = 'digitama', atlas = 'Consumable', pos = {x=2,y=1},
    discovered = true, unlocked = true, cost = 5,
    loc_txt = {name='Digitama', text={
        'Create {C:attention}2 random Rookie{} Digimon',
        '{C:inactive}(Must have room){}'
    }},
    can_use = function(self, card) return room_for(G.jokers, 2) end,
    use = function(self, card, area, copier)
        BM.remember_digi_item(card)
        create_random_stage('Rookie', 2, 'digitama')
    end,
}


SMODS.Consumable {
    set = 'Spectral', key = 'golden_d_ark', atlas = 'Consumable', pos = {x=1,y=2},
    discovered = true, unlocked = true, cost = 4,
    loc_txt = {name='Golden D-Ark', text={
        'Digivolve the leftmost {C:attention}Ultimate{}',
        'or {C:attention}Mega{} Digimon',
        '{C:inactive}(Choose a form if it branches){}'
    }},
    can_use = function(self, card) return device_can_use({'Ultimate','Mega'}, nil, 'golden_d_ark') end,
    use = function(self, card, area, copier) device_use({'Ultimate','Mega'}, nil, 'golden_d_ark', 'golden_d_ark') end,
}

SMODS.Consumable {
    set = 'Spectral', key = 'golden_digitama', atlas = 'Consumable', pos = {x=2,y=2},
    discovered = true, unlocked = true, cost = 4,
    loc_txt = {name='Golden Digitama', text={
        'Create {C:attention}1 random Ultimate{} Digimon',
        '{C:inactive}(Must have room){}'
    }},
    can_use = function(self, card) return BM.has_room(G.jokers) end,
    use = function(self, card, area, copier) create_random_stage('Ultimate', 1, 'golden_digitama') end,
}

SMODS.Consumable {
    key = 'shooting_starmon',
    set = 'Spectral',

    discovered = true,
    unlocked = true,

    -- Placeholder art
    atlas = 'Consumable', pos = {x=3,y=2},

    cost = 4,

    loc_txt = {
        name = 'Shooting Starmon',
        text = {
            'Add a {C:attention}Silver Medal{}',
            'to {C:attention}1{} selected card'
        }
    },

    loc_vars = function(self, info_queue, card)

    info_queue[#info_queue + 1] = {
        key = 'digimeel_silver_medal_seal',
        set = 'Other'
    }

    return {}
    end,

    can_use = function(self, card)
        return G.hand
            and #G.hand.highlighted == 1
    end,

    use = function(self, card, area, copier)

        local target = G.hand.highlighted[1]

        if not target then
            return
        end

        target:juice_up(0.5, 0.5)

        play_sound('tarot1')

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,

            func = function()

                if target and not target.REMOVED then

                    target:set_seal(
                        'DigiMeel_silver_medal',
                        true,
                        false
                    )

                    target:juice_up(0.9, 0.7)

                    card_eval_status_text(
                        target,
                        'extra',
                        nil,
                        nil,
                        nil,
                        {
                            message = 'Silver Medal!',
                            colour = G.C.ATTENTION
                        }
                    )

                end

                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.35,

            func = function()

                if G.hand then
                    G.hand:unhighlight_all()
                end

                return true
            end
        }))

    end,
}



SMODS.Consumable {
    key = 'error404',
    set = 'Spectral',

    discovered = true,
    unlocked = true,

    atlas = 'Consumable', pos = {x=4,y=2},

    cost = 4,

    loc_txt = {
        name = 'Error404',
        text = {
            'Add a {C:attention}Glitch Seal{}',
            'to {C:attention}1{} selected card'
        }
    },

    loc_vars = function(self, info_queue, card)

    info_queue[#info_queue + 1] = {
        key = 'digimeel_glitch_seal',
        set = 'Other'
    }

    return {}
    end,

    can_use = function(self, card)
        return G.hand
            and #G.hand.highlighted == 1
    end,

    use = function(self, card, area, copier)

        local target = G.hand.highlighted[1]

        if not target then
            return
        end

        target:juice_up(0.5, 0.5)

        play_sound('tarot1')

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,

            func = function()

                if target and not target.REMOVED then

                    target:set_seal(
                        'DigiMeel_glitch',
                        true,
                        false
                    )

                    target:juice_up(1.0, 0.8)

                    card_eval_status_text(
                        target,
                        'extra',
                        nil,
                        nil,
                        nil,
                        {
                            message = 'ERROR404',
                            colour = G.C.PURPLE
                        }
                    )

                end

                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.35,

            func = function()

                if G.hand then
                    G.hand:unhighlight_all()
                end

                return true
            end
        }))

    end,
}


-- ============================================================
-- DIGI SENSES
-- Turn up to 2 selected playing cards into Calumon Cards
-- ============================================================

SMODS.Consumable {
    set = COMMON_CARD.set,
    key = 'digi_senses',

    atlas = 'Consumable', pos = {x=3,y=1},

    discovered = true,
    unlocked = true,

    cost = 4,

    loc_txt = {
        name = 'Digi Senses',
        text = {
            'Enhances up to {C:attention}2{} selected cards',
            'into {C:attention}Calumon Cards{}'
        }
    },

    config = {
        max_highlighted = 2
    },

    can_use = function(self, card)
        if not G.hand then
            return false
        end

        local selected = #G.hand.highlighted

        return selected >= 1
            and selected <= 2
    end,

    use = function(self, card, area, copier)
        BM.remember_digi_item(card)

        local targets = {}

        for _, playing_card in ipairs(G.hand.highlighted) do
            targets[#targets + 1] = playing_card
        end

        for i, playing_card in ipairs(targets) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15 * (i - 1),

                func = function()
                    if playing_card and not playing_card.REMOVED then

                        playing_card:juice_up(0.5, 0.5)
                        play_sound('tarot1')

                        playing_card:set_ability(
                            G.P_CENTERS['m_DigiMeel_calumon'],
                            nil,
                            true
                        )

                        playing_card:juice_up(0.8, 0.6)

                        card_eval_status_text(
                            playing_card,
                            'extra',
                            nil,
                            nil,
                            nil,
                            {
                                message = 'Calumon!',
                                colour = G.C.ATTENTION
                            }
                        )
                    end

                    return true
                end
            }))
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,

            func = function()
                if G.hand then
                    G.hand:unhighlight_all()
                end

                return true
            end
        }))
    end,
}


SMODS.Consumable {
    key = 'rosemons_blessing',
    set = 'DigiItem',

    discovered = true,
    unlocked = true,

    atlas = 'Consumable', pos = {x=4,y=1},

    cost = 4,

    loc_txt = {
        name = "Rosemon's Blessing",
        text = {
            'Add a {C:attention}Farm Seal{}',
            'to {C:attention}1{} selected card'
        }
    },

    loc_vars = function(self, info_queue, card)

    info_queue[#info_queue + 1] = {
        key = 'digimeel_farm_seal',
        set = 'Other'
    }

    return {}
    end,

    can_use = function(self, card)
        return G.hand
            and #G.hand.highlighted == 1
    end,

    use = function(self, card, area, copier)
        BM.remember_digi_item(card)

        local target = G.hand.highlighted[1]

        if not target then
            return
        end

        target:juice_up(0.5, 0.5)

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,

            func = function()
                if target and not target.REMOVED then

                    target:set_seal(
                        'DigiMeel_farm',
                        true,
                        false
                    )

                    target:juice_up(0.8, 0.6)

                    card_eval_status_text(
                        target,
                        'extra',
                        nil,
                        nil,
                        nil,
                        {
                            message = 'Farm Seal!',
                            colour = G.C.GREEN
                        }
                    )
                end

                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.35,

            func = function()
                if G.hand then
                    G.hand:unhighlight_all()
                end

                return true
            end
        }))
    end,
}



SMODS.Consumable {
    key = 'digital_armor',
    set = 'DigiItem',

    discovered = true,
    unlocked = true,

    atlas = 'Consumable', pos = {x=0,y=2},

    cost = 4,

    loc_txt = {
        name = 'Digital Armor',
        text = {
            'Add a {C:attention}Digital Seal{}',
            'to {C:attention}1{} selected card'
        }
    },

    loc_vars = function(self, info_queue, card)

    info_queue[#info_queue + 1] = {
        key = 'digimeel_digital_seal',
        set = 'Other'
    }

    return {}
    end,

    can_use = function(self, card)
        return G.hand
            and #G.hand.highlighted == 1
    end,

    use = function(self, card, area, copier)
        BM.remember_digi_item(card)

        local target = G.hand.highlighted[1]

        if not target then
            return
        end

        target:juice_up(0.5, 0.5)

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,

            func = function()
                if target and not target.REMOVED then

                    target:set_seal(
                        'DigiMeel_digital',
                        true,
                        false
                    )

                    target:juice_up(0.8, 0.6)

                    card_eval_status_text(
                        target,
                        'extra',
                        nil,
                        nil,
                        nil,
                        {
                            message = 'Digital Seal!',
                            colour = G.C.BLUE
                        }
                    )
                end

                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.35,

            func = function()
                if G.hand then
                    G.hand:unhighlight_all()
                end

                return true
            end
        }))
    end,
}

