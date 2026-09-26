local BM = Balatromon

SMODS.Atlas {
    key = 'AttributedPlaying',
    path = 'Attributed_Playing.png',
    px = 71,
    py = 95,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 6,
    fps = 8
}

local rows = {Virus = 0, Vaccine = 1, Data = 2, Free = 3}
local names = {Virus = 'Infected', Vaccine = 'Protected', Data = 'Exposed', Free = 'Liberated'}

function BM.set_playing_attribute(card, attribute)
    if not card or not card.ability or rows[attribute] == nil then return end
    if card.ability.set ~= 'Default' and card.ability.set ~= 'Enhanced' then return end
    card.ability.balatromon_playing_attribute = attribute
end

function BM.get_playing_attribute(card)
    return card and card.ability and card.ability.balatromon_playing_attribute
end

function BM.clear_playing_attribute(card)
    if not card or not card.ability then return end
    card.ability.balatromon_playing_attribute = nil
    if card.children and card.children.bm_attribute then
        card.children.bm_attribute:remove()
        card.children.bm_attribute = nil
    end
end

local seals = {
    c_talisman = true,
    c_aura = true,
    c_deja_vu = true,
    c_trance = true,
    c_medium = true
}

local creates = {
    c_familiar = true,
    c_grim = true,
    c_incantation = true,
    c_cryptid = true
}

local function mark(card)
    local targets = BM._playing_attribute_targets
    local attribute = targets and targets[card]
    if not attribute then return end
    BM.set_playing_attribute(card, attribute)
    targets[card] = nil
end

local function hook(name)
    local old = Card[name]
    Card[name] = function(self, ...)
        local result = old(self, ...)
        mark(self)
        return result
    end
end

hook('set_ability')
hook('set_seal')
hook('set_base')
hook('set_edition')

local copy = copy_card
function copy_card(other, new_card, ...)
    local targets = BM._playing_attribute_targets
    local attribute = targets and new_card and targets[new_card]
    local card = copy(other, new_card, ...)
    if attribute then
        BM.set_playing_attribute(card, attribute)
        targets[new_card] = nil
    end
    return card
end

local add_to_deck = Card.add_to_deck
function Card:add_to_deck(...)
    local result = add_to_deck(self, ...)
    local pending = BM._playing_attribute_new
    if pending and self.playing_card then
        BM.set_playing_attribute(self, pending.attribute)
        pending.left = pending.left - 1
        if pending.left <= 0 then BM._playing_attribute_new = nil end
    end
    return result
end

local function targets(card, attribute)
    local key = card.config.center.key
    local out = {}
    if key == 'c_death' then
        local right = G.hand.highlighted[1]
        for _, other in ipairs(G.hand.highlighted) do
            if other.T.x > right.T.x then right = other end
        end
        for _, other in ipairs(G.hand.highlighted) do
            if other ~= right then out[other] = attribute end
        end
    elseif key == 'c_sigil' or key == 'c_ouija' then
        for _, other in ipairs(G.hand.cards) do out[other] = attribute end
    elseif card.ability.consumeable.mod_conv or card.ability.consumeable.suit_conv or seals[key] then
        for _, other in ipairs(G.hand.highlighted) do out[other] = attribute end
    end
    return out
end

local use = Card.use_consumeable
function Card:use_consumeable(area, copier)
    BM._playing_attribute_targets = nil
    BM._playing_attribute_new = nil
    local attribute = BM.get_attributed_consumable_attribute(self)
    if attribute then
        local affected = targets(self, attribute)
        if next(affected) then BM._playing_attribute_targets = affected end
        local key = self.config.center.key
        if creates[key] then
            BM._playing_attribute_new = {attribute = attribute, left = self.ability.extra}
        end
    end
    return use(self, area, copier)
end

local load = Card.load
function Card:load(card_table, other_card)
    local result = load(self, card_table, other_card)
    if card_table and card_table.ability and card_table.ability.balatromon_playing_attribute then
        self.ability.balatromon_playing_attribute = card_table.ability.balatromon_playing_attribute
    end
    return result
end

local function draw_attribute(card, attribute)
    local row = rows[attribute]
    if row == nil then return end
    local sprite = card.children.bm_attribute
    if not sprite then
        sprite = SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h, BM.PREFIX .. '_AttributedPlaying', {x = 0, y = row})
        sprite.states.hover.can = false
        sprite.states.click.can = false
        sprite.states.drag.can = false
        sprite.states.collide.can = false
        sprite.custom_draw = true
        sprite:set_role({major = card, role_type = 'Glued', draw_major = card})
        card.children.bm_attribute = sprite
    elseif sprite.animation.y ~= row then
        sprite:set_sprite_pos({x = 0, y = row})
    end
    sprite.custom_draw = true
    sprite:draw_shader('dissolve', nil, nil, nil, card.children.center)
end

SMODS.DrawStep {
    key = 'playing_attribute',
    order = -5,
    func = function(card)
        draw_attribute(card, BM.get_playing_attribute(card))
    end,
    conditions = {vortex = false, facing = 'front'}
}

BM.PLAYING_ATTRIBUTE_NAMES = names

local tips = {}
for attribute in pairs(rows) do
    tips[attribute] = {set = 'Other', key = BM.PREFIX .. '_playing_' .. string.lower(attribute)}
end

local function add_badge(card, badges)
    local attribute = BM.get_playing_attribute(card)
    if not attribute then return end
    local def = BM.get_attribute_definition(attribute)
    badges[#badges + 1] = create_badge(names[attribute], def.badge_colour, def.text_colour, def.badge_scale)
end

function BM.install_playing_attribute_tooltips()
    local old = Card.generate_UIBox_ability_table
    Card.generate_UIBox_ability_table = function(self)
        local attribute = BM.get_playing_attribute(self)
        if not attribute then return old(self) end
        if self.ability.balatromon_attribute_collection then
            return generate_card_ui(tips[attribute], nil, nil, 'Other', nil, nil, nil, nil, self)
        end
        return generate_card_ui(tips[attribute], old(self), nil, 'Other', nil, nil, nil, nil, self)
    end

    local popup = G.UIDEF.card_h_popup
    G.UIDEF.card_h_popup = function(card, ...)
        local attribute = BM.get_playing_attribute(card)
        local center = card.config and card.config.center
        if not attribute or not center then return popup(card, ...) end

        local direct = rawget(center, 'set_badges')
        local old_badges = center.set_badges
        center.set_badges = function(self, target, badges)
            if old_badges then old_badges(self, target, badges) end
            add_badge(target, badges)
        end

        local result = popup(card, ...)
        center.set_badges = direct
        return result
    end
end

local collection_attributes = {'Virus', 'Vaccine', 'Data', 'Free'}

local function make_collection_card(area, attribute)
    local card = Card(area.T.x + area.T.w / 2, area.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS.c_base)
    BM.set_playing_attribute(card, attribute)
    card.ability.balatromon_attribute_collection = true
    return card
end

function create_UIBox_your_collection_balatromon_playing_attributes()
    G.your_collection = CardArea(
        G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
        G.ROOM.T.h,
        4.25 * G.CARD_W,
        1.03 * G.CARD_H,
        {card_limit = 4, type = 'title', highlight_limit = 0}
    )
    for _, attribute in ipairs(collection_attributes) do
        G.your_collection:emplace(make_collection_card(G.your_collection, attribute))
    end
    return create_UIBox_generic_options({
        back_func = 'your_collection',
        snap_back = true,
        contents = {{
            n = G.UIT.R,
            config = {align = 'cm', minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05},
            nodes = {{
                n = G.UIT.R,
                config = {align = 'cm', padding = 0, no_fill = true},
                nodes = {{n = G.UIT.O, config = {object = G.your_collection}}}
            }}
        }}
    })
end

G.FUNCS.your_collection_balatromon_playing_attributes = function()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu({definition = create_UIBox_your_collection_balatromon_playing_attributes()})
end

function BM.add_playing_attribute_collection_tab(tabs)
    if G.ACTIVE_MOD_UI then return end
    tabs[#tabs + 1] = UIBox_button({
        button = 'your_collection_balatromon_playing_attributes',
        id = 'your_collection_balatromon_playing_attributes',
        label = {'Attributed Cards'},
        minw = 5
    })
end

function BM.install_playing_attribute_localization()
    G.localization.descriptions.Other[BM.PREFIX .. '_playing_virus'] = {
        name = 'Infected',
        text = {'Effect and removal condition to be added.'}
    }
    G.localization.descriptions.Other[BM.PREFIX .. '_playing_vaccine'] = {
        name = 'Protected',
        text = {'Effect and removal condition to be added.'}
    }
    G.localization.descriptions.Other[BM.PREFIX .. '_playing_data'] = {
        name = 'Exposed',
        text = {'Effect and removal condition to be added.'}
    }
    G.localization.descriptions.Other[BM.PREFIX .. '_playing_free'] = {
        name = 'Liberated',
        text = {'Effect and removal condition to be added.'}
    }
end
