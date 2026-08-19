local BM = Balatromon

local function has_joker_room()
    return G.jokers and (#G.jokers.cards < G.jokers.config.card_limit)
end

local function create_negative_food()
    if not G.consumeables then return nil end
    local key = 'c_' .. BM.PREFIX .. '_food'
    if not G.P_CENTERS[key] then return nil end
    return SMODS.add_card {
        set = 'DigiItem',
        area = G.consumeables,
        key = key,
        edition = 'e_negative',
        key_append = 'balatromon_judgement_food',
    }
end

-- JUDGEMENT: keep the spirit of vanilla Judgement, but add a Negative Food.
SMODS.Consumable:take_ownership('judgement', {
    loc_txt = {
        name = 'Judgement',
        text = {
            'Creates a random {C:attention}Joker{}',
            'and a {C:dark_edition}Negative{} {C:attention}Food{}',
        },
    },
    can_use = function(self, card)
        return has_joker_room() and G.consumeables ~= nil
    end,
    use = function(self, card, area, copier)
        SMODS.add_card {
            set = 'Joker',
            area = G.jokers,
            key_append = 'balatromon_judgement',
        }
        create_negative_food()
    end,
}, true)

-- THE EMPEROR: each generated card independently rolls between Tarot/DigiItem.
SMODS.Consumable:take_ownership('emperor', {
    loc_txt = {
        name = 'The Emperor',
        text = {
            'Creates up to {C:attention}2{} random',
            '{C:tarot}Tarot{} or {C:attention}Digi Item{} cards',
            '{C:inactive}(Must have room){}',
        },
    },
    can_use = function(self, card)
        return BM.has_room(G.consumeables)
    end,
    use = function(self, card, area, copier)
        for i = 1, 2 do
            if not BM.has_room(G.consumeables) then break end
            local set = BM.random_element({'Tarot', 'DigiItem'}, 'balatromon_emperor_' .. tostring(i))
            SMODS.add_card {
                set = set or 'Tarot',
                area = G.consumeables,
                key_append = 'balatromon_emperor_' .. tostring(i),
            }
        end
    end,
}, true)

local function fool_target_key()
    local key = G.GAME and G.GAME.last_tarot_planet
    if not key or key == 'c_fool' then return nil end
    local center = G.P_CENTERS[key]
    if not center then return nil end
    if center.set == 'Tarot' or center.set == 'Planet' or center.set == 'DigiItem' then
        return key
    end
    return nil
end

-- THE FOOL: vanilla already remembers Tarot/Planet; Digi Items update the same
-- tracker in BM.remember_digi_item when used.
SMODS.Consumable:take_ownership('fool', {
    loc_txt = {
        name = 'The Fool',
        text = {
            'Creates the last {C:tarot}Tarot{}, {C:planet}Planet{},',
            'or {C:attention}Digi Item{} used during this run',
            '{C:inactive}(The Fool excluded){}',
            '{C:inactive}(Currently: {C:attention}#1#{C:inactive}){}',
        },
    },
    loc_vars = function(self, info_queue, card)
        local key = fool_target_key()
        local center = key and G.P_CENTERS[key]
        local name = 'None'
        if center then
            local ok, localized = pcall(localize, {type = 'name_text', set = center.set, key = key})
            if ok and localized then name = localized end
        end
        return {vars = {name}}
    end,
    can_use = function(self, card)
        return BM.has_room(G.consumeables) and fool_target_key() ~= nil
    end,
    use = function(self, card, area, copier)
        local key = fool_target_key()
        if key then
            SMODS.add_card {
                set = G.P_CENTERS[key].set,
                area = G.consumeables,
                key = key,
                key_append = 'balatromon_fool',
            }
        end
    end,
}, true)
