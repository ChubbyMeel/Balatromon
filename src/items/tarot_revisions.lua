local BM = Balatromon

SMODS.Atlas {
    key = 'Tarot',
    path = 'DigiMeel_Tarot.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'SpecPlanet',
    path = 'DigiMeel_SpecPlanet.png',
    px = 71,
    py = 95,
}

local attributes = {'Data', 'Vaccine', 'Virus', 'Free'}
local function mod_key(key) return 'c_' .. BM.PREFIX .. '_' .. key end

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

local planet_data = {
    c_eris = {attribute = 'Vaccine', pos = {x = 7, y = 0}},
    c_ceres = {attribute = 'Virus', pos = {x = 8, y = 0}},
    c_planet_x = {attribute = 'Data', pos = {x = 9, y = 0}},
    c_mercury = {attribute = 'Free', pos = {x = 0, y = 1}},
    c_venus = {attribute = 'Data', pos = {x = 1, y = 1}},
    c_earth = {attribute = 'Vaccine', pos = {x = 2, y = 1}},
    c_mars = {attribute = 'Virus', pos = {x = 3, y = 1}},
    c_jupiter = {attribute = 'Vaccine', pos = {x = 4, y = 1}},
    c_saturn = {attribute = 'Free', pos = {x = 5, y = 1}},
    c_uranus = {attribute = 'Free', pos = {x = 6, y = 1}},
    c_neptune = {attribute = 'Data', pos = {x = 7, y = 1}},
    c_pluto = {any = true, pos = {x = 8, y = 1}},
}

local spectral_data = {
    c_familiar = {attribute = 'Vaccine', pos = {x = 0, y = 2}},
    c_grim = {attribute = 'Data', pos = {x = 1, y = 2}},
    c_incantation = {attribute = 'Data', pos = {x = 2, y = 2}},
    c_talisman = {attribute = 'Vaccine', pos = {x = 3, y = 2}},
    c_aura = {attribute = 'Free', pos = {x = 4, y = 2}},
    c_sigil = {attribute = 'Free', pos = {x = 6, y = 2}},
    c_ouija = {attribute = 'Virus', pos = {x = 7, y = 2}},
    c_ectoplasm = {attribute = 'Virus', pos = {x = 8, y = 2}},
    c_immolate = {attribute = 'Virus', pos = {x = 9, y = 2}},
    c_ankh = {attribute = 'Free', pos = {x = 0, y = 3}},
    c_deja_vu = {attribute = 'Virus', pos = {x = 1, y = 3}},
    c_hex = {attribute = 'Vaccine', pos = {x = 2, y = 3}},
    c_trance = {attribute = 'Data', pos = {x = 3, y = 3}},
    c_medium = {attribute = 'Free', pos = {x = 4, y = 3}},
    c_cryptid = {attribute = 'Virus', pos = {x = 5, y = 3}},
    [mod_key('golden_d_ark')] = {attribute = 'Vaccine', pos = {x = 6, y = 3}},
    [mod_key('gilded_coat')] = {attribute = 'Vaccine', pos = {x = 7, y = 3}},
    [mod_key('error404')] = {any = true, pos = {x = 9, y = 3}},
    [mod_key('graveyard')] = {attribute = 'Virus', pos = {x = 4, y = 4}},
    [mod_key('digivice_ic')] = {attribute = 'Data', pos = {x = 5, y = 4}},
    [mod_key('golden_digivice')] = {attribute = 'Vaccine', pos = {x = 7, y = 4}},
}

local soul_pos = {
    Data = {x = 0, y = 0}, Vaccine = {x = 1, y = 0},
    Virus = {x = 2, y = 0}, Free = {x = 3, y = 0},
}

local digitama_pos = {
    Data = {x = 0, y = 4}, Vaccine = {x = 1, y = 4},
    Virus = {x = 2, y = 4}, Free = {x = 3, y = 4},
}

local function card_key(card)
    return card and card.config and card.config.center and card.config.center.key
end

local function card_data(card)
    local key = card_key(card)
    if key == 'c_judgement' then return {any = true, tarot = true} end
    if key == 'c_soul' then return {any = true, soul = true} end
    if key == mod_key('golden_digitama') then return {any = true, digitama = true} end
    return tarot_data[key] or planet_data[key] or spectral_data[key]
end

local function attributed_pos(card, attribute)
    local key = card_key(card)
    if key == 'c_judgement' then return judgement_pos[attribute], 'Tarot' end
    if key == 'c_soul' then return soul_pos[attribute], 'SpecPlanet' end
    if key == mod_key('golden_digitama') then return digitama_pos[attribute], 'SpecPlanet' end
    local data = tarot_data[key]
    if data then return data.pos, 'Tarot' end
    data = planet_data[key] or spectral_data[key]
    if data then return data.pos, 'SpecPlanet' end
end

function BM.get_attributed_consumable_attribute(card)
    return card and card.ability and card.ability.balatromon_consumable_attribute
        or card and card.config and card.config.center and card.config.center.balatromon_consumable_attribute
end

function BM.set_attributed_consumable(card, attribute)
    local pos, atlas = attributed_pos(card, attribute)
    if not pos then return false end
    card.ability.balatromon_consumable_attribute = attribute
    card.ability.balatromon_attributed = true
    BM.set_attribute(card, attribute)
    if card.children and card.children.center then
        card.children.center.atlas = G.ASSET_ATLAS[BM.PREFIX .. '_' .. atlas]
        card.children.center:set_sprite_pos(pos)
    end
    return true
end

function BM.clear_attributed_consumable(card)
    if not card or not card.ability then return end
    card.ability.balatromon_consumable_attribute = nil
    card.ability.balatromon_attributed = nil
    BM.clear_attribute(card)
    if card.config and card.config.center then card:set_sprites(card.config.center) end
end

local function roll_attribute(card, data, seed, chance)
    if not data or not SMODS.pseudorandom_probability(card, seed, 1, chance) then return end
    local attribute = data.any and BM.random_element(attributes, seed .. '_attribute') or data.attribute
    if attribute then BM.set_attributed_consumable(card, attribute) end
end

function BM.roll_attributed_consumable(card)
    local key = card_key(card)
    local center = card and card.config and card.config.center
    if not key or not center then return end
    if center.set == 'Tarot' then
        roll_attribute(card, card_data(card), 'balatromon_attributed_tarot', 6)
    elseif center.set == 'Planet' then
        roll_attribute(card, planet_data[key], 'balatromon_attributed_planet', 6)
    elseif center.set == 'Spectral' then
        roll_attribute(card, card_data(card), 'balatromon_attributed_spectral', 10)
    end
end

local function digimon_pool(stage, attribute)
    local pool = {}
    for _, center in ipairs(G.P_CENTER_POOLS and G.P_CENTER_POOLS.Joker or {}) do
        if center.balatromon == true
        and (not stage or center.balatromon_stage == stage)
        and (not attribute or BM.has_attribute(center, attribute)) then
            pool[#pool + 1] = center
        end
    end
    return pool
end

local function create_attribute_digimon(stage, attribute, seed)
    if not BM.has_room(G.jokers) then return end
    local pool = digimon_pool(stage, attribute)
    local center = BM.random_element(pool, seed)
    if center then
        return SMODS.add_card {set = 'Joker', area = G.jokers, key = center.key, key_append = seed}
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

SMODS.Consumable:take_ownership('judgement', {
    loc_txt = {
        name = 'Judgement',
        text = {
            'Creates a random {C:attention}#1#Digimon{}',
            'and a {C:dark_edition}Negative{} {C:attention}Food{}',
        },
    },
    loc_vars = function(self, info_queue, card)
        local attribute = BM.get_attributed_consumable_attribute(card)
        return {vars = {attribute and attribute .. ' ' or ''}}
    end,
    can_use = function(self, card)
        return has_joker_room() and G.consumeables ~= nil
    end,
    use = function(self, card, area, copier)
        local attribute = BM.get_attributed_consumable_attribute(card)
        local pool = digimon_pool(nil, attribute)
        local center = BM.random_element(pool, 'balatromon_judgement_digimon' .. tostring(G.GAME.round_resets.ante or 0))
        if center then
            SMODS.add_card {set = 'Joker', area = G.jokers, key = center.key, key_append = 'balatromon_judgement'}
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
    can_use = function(self, card) return BM.has_room(G.consumeables) end,
    use = function(self, card, area, copier)
        for i = 1, 2 do
            if not BM.has_room(G.consumeables) then break end
            local set = BM.random_element({'Tarot', 'DigiItem'}, 'balatromon_emperor_' .. tostring(i))
            SMODS.add_card {set = set or 'Tarot', area = G.consumeables, key_append = 'balatromon_emperor_' .. tostring(i)}
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
        local created = SMODS.add_card {set = center.set, area = G.consumeables, key = key, key_append = 'balatromon_fool'}
        local attribute = G.GAME.balatromon_last_consumable_attribute
        if created and attribute and (center.set == 'Tarot' or center.set == 'Planet') then
            BM.set_attributed_consumable(created, attribute)
        end
    end,
}, true)

SMODS.Consumable {
    key = 'white_hole',
    set = 'Spectral',
    atlas = 'SpecPlanet',
    pos = {x = 9, y = 1},
    hidden = true,
    soul_set = 'Planet',
    soul_rate = 0.001,
    cost = 4,
    unlocked = true,
    discovered = false,
    loc_txt = {
        name = 'White Hole',
        text = {'Upgrade every {C:attention}poker hand{} by {C:attention}2{} levels'}
    },
    can_use = function() return true end,
    use = function(self, card)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname = localize('k_all_hands'), chips = '...', mult = '...', level = ''})
        for hand in pairs(G.GAME.hands) do level_up_hand(card, hand, true, 2) end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,
}

spectral_data[mod_key('white_hole')] = {any = true, pos = {x = 9, y = 1}}

SMODS.DrawStep {
    key = 'attributed_consumable_sheen',
    order = 37,
    func = function(card)
        local center = card.config and card.config.center
        if not ((card.ability and card.ability.balatromon_attributed) or (center and center.balatromon_attributed)) then return end
        if center and (center.set == 'Tarot' or center.set == 'Planet') then
            card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
        end
    end,
    conditions = {vortex = false, facing = 'front'}
}

local function loc_for(base)
    return copy_table(base.loc_txt or G.localization.descriptions[base.set] and G.localization.descriptions[base.set][base.key])
end

local function register_collection_variant(base_key, attribute, pos, atlas)
    local base = G.P_CENTERS[base_key]
    if not base then return end
    local slug = base_key:sub(3):gsub('^' .. BM.PREFIX .. '_', '')
    local args = {
        key = 'attributed_' .. slug .. (attribute and '_' .. string.lower(attribute) or ''),
        set = base.set, atlas = atlas, pos = pos,
        name = base.name, effect = base.effect,
        config = copy_table(base.config or {}), cost = base.cost,
        unlocked = true, discovered = true, no_mod_badges = true,
        balatromon_attribute = attribute,
        balatromon_consumable_attribute = attribute,
        balatromon_attributed = true,
        loc_txt = loc_for(base),
        in_pool = function() return false end,
    }
    if type(base.generate_ui) == 'function' then
        args.generate_ui = function(self, ...) return base.generate_ui(base, ...) end
    elseif type(base.loc_vars) == 'function' then
        args.loc_vars = function(self, ...) return base.loc_vars(base, ...) end
    else
        args.generate_ui = false
    end
    if base_key == 'c_soul' then
        args.atlas = BM.PREFIX .. '_' .. atlas
        args.soul_pos = copy_table(G.P_CENTERS.soul.pos)
        args.soul_atlas = 'centers'
        args.prefix_config = {atlas = false}
    end
    SMODS.Consumable(args)
end

for key, data in pairs(tarot_data) do register_collection_variant(key, data.attribute, data.pos, 'Tarot') end
for _, attribute in ipairs(attributes) do register_collection_variant('c_judgement', attribute, judgement_pos[attribute], 'Tarot') end
for key, data in pairs(planet_data) do
    if key == 'c_pluto' then
        register_collection_variant(key, nil, data.pos, 'SpecPlanet')
    elseif data.any then
        for _, attribute in ipairs(attributes) do register_collection_variant(key, attribute, data.pos, 'SpecPlanet') end
    else
        register_collection_variant(key, data.attribute, data.pos, 'SpecPlanet')
    end
end
for key, data in pairs(spectral_data) do
    if data.any then
        for _, attribute in ipairs(attributes) do register_collection_variant(key, attribute, data.pos, 'SpecPlanet') end
    else
        register_collection_variant(key, data.attribute, data.pos, 'SpecPlanet')
    end
end
for _, attribute in ipairs(attributes) do
    register_collection_variant('c_soul', attribute, soul_pos[attribute], 'SpecPlanet')
    register_collection_variant(mod_key('golden_digitama'), attribute, digitama_pos[attribute], 'SpecPlanet')
end

local create_card_ref = create_card
function create_card(...)
    local card = create_card_ref(...)
    if G.STAGE == G.STAGES.RUN and not G.SETTINGS.paused then BM.roll_attributed_consumable(card) end
    return card
end

local load = Card.load
function Card:load(card_table, other_card)
    local result = load(self, card_table, other_card)
    local attribute = self.ability and self.ability.balatromon_consumable_attribute
    if attribute then BM.set_attributed_consumable(self, attribute) end
    return result
end

local use_consumeable = Card.use_consumeable
function Card:use_consumeable(area, copier)
    local key = card_key(self)
    local attribute = BM.get_attributed_consumable_attribute(self)
    if G.GAME and self.config and self.config.center
    and (self.config.center.set == 'Tarot' or self.config.center.set == 'Planet') then
        G.GAME.balatromon_last_consumable_attribute = attribute or false
    end
    local stage
    if attribute and key == 'c_soul' then stage = 'Mega' end
    if attribute and key == mod_key('golden_digitama') then stage = 'Ultimate' end
    if stage then
        local center = self.config.center
        local old_use = center.use
        center.use = function()
            create_attribute_digimon(stage, attribute, 'balatromon_' .. string.lower(stage) .. '_' .. string.lower(attribute))
        end
        local result = use_consumeable(self, area, copier)
        center.use = old_use
        return result
    end
    return use_consumeable(self, area, copier)
end
