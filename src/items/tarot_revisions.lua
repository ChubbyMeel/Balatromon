local BM = Balatromon

SMODS.Atlas {
    key = 'Tarot',
    path = 'DigiMeel_Tarot.png',
    px = 71,
    py = 95,
}

local tarot_data = {
    c_fool = {attribute = 'Data', pos = {x = 0, y = 0}},
    c_magician = {attribute = 'Vaccine', pos = {x = 1, y = 0}},
    c_high_priestess = {attribute = 'Data', pos = {x = 2, y = 0}},
    c_empress = {attribute = 'Virus', pos = {x = 3, y = 0}},
    c_emperor = {attribute = 'Data', pos = {x = 4, y = 0}},
    c_heirophant = {attribute = 'Data', pos = {x = 5, y = 0}},
    c_lovers = {attribute = 'Free', pos = {x = 6, y = 0}},
    c_chariot = {attribute = 'Virus', pos = {x = 7, y = 0}},
    c_justice = {attribute = 'Vaccine', pos = {x = 8, y = 0}},
    c_hermit = {attribute = 'Data', pos = {x = 9, y = 0}},
    c_wheel_of_fortune = {attribute = 'Free', pos = {x = 0, y = 1}},
    c_strength = {attribute = 'Vaccine', pos = {x = 1, y = 1}},
    c_hanged_man = {attribute = 'Virus', pos = {x = 2, y = 1}},
    c_death = {attribute = 'Free', pos = {x = 3, y = 1}},
    c_temperance = {attribute = 'Data', pos = {x = 4, y = 1}},
    c_devil = {attribute = 'Vaccine', pos = {x = 5, y = 1}},
    c_tower = {attribute = 'Data', pos = {x = 6, y = 1}},
    c_star = {attribute = 'Free', pos = {x = 7, y = 1}},
    c_moon = {attribute = 'Data', pos = {x = 8, y = 1}},
    c_sun = {attribute = 'Virus', pos = {x = 9, y = 1}},
    c_world = {attribute = 'Vaccine', pos = {x = 1, y = 2}},
}

local judgement_pos = {
    Free = {x = 0, y = 2},
    Data = {x = 2, y = 2},
    Vaccine = {x = 3, y = 2},
    Virus = {x = 4, y = 2},
}

local judgement_attributes = {'Free', 'Data', 'Vaccine', 'Virus'}

local collection_tarots = {
    {'c_fool', 'Data'}, {'c_magician', 'Vaccine'}, {'c_high_priestess', 'Data'}, {'c_empress', 'Virus'},
    {'c_emperor', 'Data'}, {'c_heirophant', 'Data'}, {'c_lovers', 'Free'}, {'c_chariot', 'Virus'},
    {'c_justice', 'Vaccine'}, {'c_hermit', 'Data'}, {'c_wheel_of_fortune', 'Free'}, {'c_strength', 'Vaccine'},
    {'c_hanged_man', 'Virus'}, {'c_death', 'Free'}, {'c_temperance', 'Data'}, {'c_devil', 'Vaccine'},
    {'c_tower', 'Data'}, {'c_star', 'Free'}, {'c_moon', 'Data'}, {'c_sun', 'Virus'},
    {'c_judgement', 'Free'}, {'c_world', 'Vaccine'}, {'c_judgement', 'Data'}, {'c_judgement', 'Vaccine'}, {'c_judgement', 'Virus'},
}

local function tarot_pos(key, attribute)
    return key == 'c_judgement' and judgement_pos[attribute] or tarot_data[key] and tarot_data[key].pos
end

function BM.get_attributed_tarot_attribute(card)
    if not card then return nil end
    return card.ability and card.ability.balatromon_tarot_attribute
        or card.config and card.config.center and card.config.center.balatromon_tarot_attribute
end

function BM.set_attributed_tarot(card, attribute)
    local key = card.config and card.config.center and card.config.center.key
    local pos = tarot_pos(key, attribute)
    if not pos then return false end
    card.ability.balatromon_tarot_attribute = attribute
    BM.set_attribute(card, attribute)
    if card.children and card.children.center then
        card.children.center.atlas = G.ASSET_ATLAS[BM.PREFIX .. '_Tarot']
        card.children.center:set_sprite_pos(pos)
    end
    return true
end

function BM.clear_attributed_tarot(card)
    card.ability.balatromon_tarot_attribute = nil
    BM.clear_attribute(card)
    if card.config and card.config.center then card:set_sprites(card.config.center) end
end

function BM.roll_attributed_tarot(card)
    local key = card.config and card.config.center and card.config.center.key
    if key ~= 'c_judgement' and not tarot_data[key] then return end
    if not SMODS.pseudorandom_probability(card, 'balatromon_attributed_tarot', 1, 6) then return end
    local attribute = key == 'c_judgement'
        and BM.random_element(judgement_attributes, 'balatromon_judgement_attribute')
        or tarot_data[key].attribute
    BM.set_attributed_tarot(card, attribute)
end

function BM.track_last_tarot(card)
    if not G.GAME or not card.config or not card.config.center then return end
    local center = card.config.center
    if center.key == 'c_fool' then return end
    if center.set == 'Tarot' then
        G.GAME.balatromon_last_tarot_attribute = BM.get_attributed_tarot_attribute(card) or false
    elseif center.set == 'Planet' or center.set == 'DigiItem' then
        G.GAME.balatromon_last_tarot_attribute = nil
    end
end

local function has_joker_room()
    return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
end

local function create_negative_food()
    if not G.consumeables then return end
    local key = 'c_' .. BM.PREFIX .. '_food'
    if not G.P_CENTERS[key] then return end
    return SMODS.add_card {
        set = 'DigiItem', area = G.consumeables, key = key,
        edition = 'e_negative', key_append = 'balatromon_judgement_food'
    }
end

local function get_digimon_pool(attribute)
    local pool = {}
    for _, center in ipairs(G.P_CENTER_POOLS and G.P_CENTER_POOLS.Joker or {}) do
        if center.balatromon == true and (not attribute or BM.has_attribute(center, attribute)) then
            pool[#pool + 1] = center
        end
    end
    return pool
end

SMODS.Consumable:take_ownership('judgement', {
    loc_txt = {
        name = 'Judgement',
        text = {
            'Creates a random {C:attention}#1#Digimon{}',
            'and a {C:dark_edition}Negative{} {C:attention}Food{}',
        },
    },
    loc_vars = function(self, info_queue, card)
        local attribute = BM.get_attributed_tarot_attribute(card)
        return {vars = {attribute and attribute .. ' ' or ''}}
    end,
    can_use = function(self, card)
        return has_joker_room() and G.consumeables ~= nil
    end,
    use = function(self, card, area, copier)
        local attribute = BM.get_attributed_tarot_attribute(card)
        local pool = get_digimon_pool(attribute)
        if #pool > 0 then
            local center = BM.random_element(pool, 'balatromon_judgement_digimon' .. tostring(G.GAME.round_resets.ante or 0))
            if center then
                SMODS.add_card {
                    set = 'Joker', area = G.jokers, key = center.key,
                    key_append = 'balatromon_judgement'
                }
            end
        end
        create_negative_food()
    end,
}, true)

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
                set = set or 'Tarot', area = G.consumeables,
                key_append = 'balatromon_emperor_' .. tostring(i)
            }
        end
    end,
}, true)

local function fool_target_key()
    local key = G.GAME and G.GAME.last_tarot_planet
    if not key or key == 'c_fool' then return end
    local center = G.P_CENTERS[key]
    if center and (center.set == 'Tarot' or center.set == 'Planet' or center.set == 'DigiItem') then return key end
end

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
        if not fool_target_key() or not G.consumeables then return false end
        if #G.consumeables.cards < G.consumeables.config.card_limit then return true end
        return card and card.area == G.consumeables
    end,
    use = function(self, card, area, copier)
        local key = fool_target_key()
        if not key then return end
        local center = G.P_CENTERS[key]
        local created = SMODS.add_card {
            set = center.set, area = G.consumeables, key = key,
            key_append = 'balatromon_fool'
        }
        if center.set == 'Tarot' and created then
            local attribute = G.GAME.balatromon_last_tarot_attribute
            if attribute then BM.set_attributed_tarot(created, attribute) else BM.clear_attributed_tarot(created) end
        end
    end,
}, true)

local function tarot_loc(base)
    return copy_table(base.loc_txt or G.localization.descriptions.Tarot[base.key])
end

for _, variant in ipairs(collection_tarots) do
    local base_key, attribute = variant[1], variant[2]
    local base = G.P_CENTERS[base_key]
    local slug = base_key:sub(3)
    SMODS.Consumable {
        key = 'attributed_' .. slug .. '_' .. string.lower(attribute),
        set = 'Tarot', atlas = 'Tarot', pos = tarot_pos(base_key, attribute),
        config = copy_table(base.config or {}), cost = base.cost,
        unlocked = true, discovered = true, no_mod_badges = true,
        balatromon_attribute = attribute,
        balatromon_tarot_attribute = attribute,
        balatromon_base_tarot = base_key,
        loc_txt = tarot_loc(base),
        loc_vars = function(self, info_queue, card)
            local original = G.P_CENTERS[self.balatromon_base_tarot]
            if original and original.loc_vars then return original.loc_vars(original, info_queue, card) end
        end,
        in_pool = function() return false end,
    }
end

local create_card_ref = create_card
function create_card(...)
    local card = create_card_ref(...)
    if G.STAGE == G.STAGES.RUN and not G.SETTINGS.paused then BM.roll_attributed_tarot(card) end
    return card
end

local load = Card.load
function Card:load(card_table, other_card)
    local result = load(self, card_table, other_card)
    local key = self.config and self.config.center and self.config.center.key
    if key == 'c_judgement' or tarot_data[key] then
        local attribute = self.ability and self.ability.balatromon_tarot_attribute
        if attribute then BM.set_attributed_tarot(self, attribute) else BM.clear_attributed_tarot(self) end
    end
    return result
end
