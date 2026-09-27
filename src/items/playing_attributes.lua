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
    if card.ability.balatromon_playing_attribute ~= attribute then
        card.ability.balatromon_exposed_triggers = nil
        card.ability.balatromon_liberated_plays = nil
    end
    card.ability.balatromon_playing_attribute = attribute
end

function BM.get_playing_attribute(card)
    return card and card.ability and card.ability.balatromon_playing_attribute
end

function BM.clear_playing_attribute(card)
    if not card or not card.ability then return end
    card.ability.balatromon_playing_attribute = nil
    card.ability.balatromon_exposed_triggers = nil
    card.ability.balatromon_liberated_plays = nil
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

local spreading

local function adjacent(card)
    local cards = card.area and card.area.cards
    if not cards then return {} end
    for i, other in ipairs(cards) do
        if other == card then
            local out = {}
            if cards[i - 1] then out[#out + 1] = cards[i - 1] end
            if cards[i + 1] then out[#out + 1] = cards[i + 1] end
            return out
        end
    end
    return {}
end

local function spread(card, kind, value, infected, ...)
    if spreading or not infected or value == nil then return end
    spreading = true
    for _, other in ipairs(adjacent(card)) do
        if kind == 'ability' then other:set_ability(value, ...)
        elseif kind == 'seal' then other:set_seal(value, ...)
        else other:set_edition(value, ...) end
    end
    spreading = nil
end

local function protect(card)
    if BM.get_playing_attribute(card) ~= 'Vaccine' then return false end
    if BM._playing_attribute_targets then BM._playing_attribute_targets[card] = nil end
    BM.clear_playing_attribute(card)
    if card.juice_up then card:juice_up(0.3, 0.3) end
    return true
end

local set_ability = Card.set_ability
function Card:set_ability(center, ...)
    local attribute = BM.get_playing_attribute(self)
    if attribute == 'Vaccine' and center ~= self.config.center and self.playing_card then
        protect(self)
        return
    end
    local old = self.config.center
    local triggers = self.ability and self.ability.balatromon_exposed_triggers
    local plays = self.ability and self.ability.balatromon_liberated_plays
    local result = set_ability(self, center, ...)
    if attribute then
        self.ability.balatromon_playing_attribute = attribute
        self.ability.balatromon_exposed_triggers = triggers
        self.ability.balatromon_liberated_plays = plays
    end
    if old ~= self.config.center and self.config.center and self.config.center.set == 'Enhanced' then
        spread(self, 'ability', self.config.center, attribute == 'Virus', ...)
    end
    mark(self)
    return result
end

local set_seal = Card.set_seal
function Card:set_seal(seal, ...)
    local old = self.seal
    local infected = BM.get_playing_attribute(self) == 'Virus'
    local result = set_seal(self, seal, ...)
    if old ~= self.seal then spread(self, 'seal', self.seal, infected, ...) end
    mark(self)
    return result
end

local set_base = Card.set_base
function Card:set_base(base, ...)
    if BM.get_playing_attribute(self) == 'Vaccine' and base ~= self.config.card and self.playing_card then
        protect(self)
        return
    end
    local result = set_base(self, base, ...)
    mark(self)
    return result
end

local set_edition = Card.set_edition
function Card:set_edition(edition, ...)
    local old = self.edition and self.edition.type
    local infected = BM.get_playing_attribute(self) == 'Virus'
    local result = set_edition(self, edition, ...)
    local current = self.edition and self.edition.type
    if old ~= current and self.edition then spread(self, 'edition', edition, infected, ...) end
    mark(self)
    return result
end

local set_debuff = Card.set_debuff
function Card:set_debuff(value)
    if value and not self.debuff and protect(self) then return end
    return set_debuff(self, value)
end

local start_dissolve = Card.start_dissolve
function Card:start_dissolve(...)
    if self.playing_card and protect(self) then return end
    return start_dissolve(self, ...)
end

local shatter = Card.shatter
function Card:shatter(...)
    if self.playing_card and protect(self) then return end
    return shatter(self, ...)
end

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

local is_suit = Card.is_suit
function Card:is_suit(suit, ...)
    if BM.get_playing_attribute(self) == 'Free' and not self.debuff then return true end
    return is_suit(self, suit, ...)
end

local get_chip_bonus = Card.get_chip_bonus
function Card:get_chip_bonus(...)
    if BM.get_playing_attribute(self) == 'Free' and not self.debuff then
        return (self.base and self.base.nominal or 0) + (self.ability.perma_bonus or 0)
    end
    return get_chip_bonus(self, ...)
end

local get_chip_mult = Card.get_chip_mult
function Card:get_chip_mult(...)
    if BM.get_playing_attribute(self) == 'Free' and not self.debuff then return 0 end
    return get_chip_mult(self, ...)
end

local get_chip_x_mult = Card.get_chip_x_mult
function Card:get_chip_x_mult(...)
    if BM.get_playing_attribute(self) == 'Free' and not self.debuff then return 0 end
    return get_chip_x_mult(self, ...)
end

if Card.get_p_dollars then
    local get_p_dollars = Card.get_p_dollars
    function Card:get_p_dollars(...)
        if BM.get_playing_attribute(self) == 'Free' and not self.debuff then return 0 end
        return get_p_dollars(self, ...)
    end
end

local get_x_same = get_X_same
function get_X_same(num, hand, or_more)
    local wild, groups, order = {}, {}, {}
    for _, card in ipairs(hand) do
        if BM.get_playing_attribute(card) == 'Free' and not card.debuff then
            wild[#wild + 1] = card
        else
            local id = card:get_id()
            if id and id > 0 then
                if not groups[id] then groups[id] = {}; order[#order + 1] = id end
                groups[id][#groups[id] + 1] = card
            end
        end
    end
    if #wild == 0 then return get_x_same(num, hand, or_more) end
    local out = {}
    for _, id in ipairs(order) do
        local group = groups[id]
        if #group + #wild >= num then
            local cards = {}
            for _, card in ipairs(group) do cards[#cards + 1] = card end
            local need = or_more and #wild or math.min(#wild, num - #group)
            for i = 1, need do cards[#cards + 1] = wild[i] end
            if or_more or #cards == num then out[#out + 1] = cards end
        end
    end
    if #order == 0 and #wild >= num then
        local cards = {}
        local count = or_more and #wild or num
        for i = 1, count do cards[#cards + 1] = wild[i] end
        out[#out + 1] = cards
    end
    return out
end

local get_straight_ref = get_straight
function get_straight(hand, min_length, skip, wrap)
    local wild = {}
    local ranks = {}
    min_length = min_length or 5
    if min_length < 2 then min_length = 2 end
    if #hand < min_length then return {} end
    for key in pairs(SMODS.Ranks) do ranks[key] = {} end
    for _, card in ipairs(hand) do
        if BM.get_playing_attribute(card) == 'Free' and not card.debuff then
            wild[#wild + 1] = card
        else
            local id = card:get_id()
            if id and id > 0 then
                for key, rank in pairs(SMODS.Ranks) do
                    if rank.id == id then ranks[key][#ranks[key] + 1] = card; break end
                end
            end
        end
    end
    if #wild == 0 then return get_straight_ref(hand, min_length, skip, wrap) end
    local function next_ranks(key, start)
        local rank = SMODS.Ranks[key]
        local out = {}
        if not start and not wrap and rank.straight_edge then return out end
        for _, next_key in ipairs(rank.next) do
            out[#out + 1] = next_key
            if skip and (wrap or not SMODS.Ranks[next_key].straight_edge) then
                for _, skipped in ipairs(SMODS.Ranks[next_key].next) do out[#out + 1] = skipped end
            end
        end
        return out
    end
    local paths = {}
    for _, key in ipairs(SMODS.Rank.obj_buffer) do
        local used = next(ranks[key]) and 0 or 1
        if used <= #wild then paths[#paths + 1] = {keys = {key}, wild = used} end
    end
    local ret = {}
    for len = 2, #hand + 1 do
        local new_paths = {}
        for _, path in ipairs(paths) do
            local found
            if len ~= #hand + 1 then
                for _, key in ipairs(next_ranks(path.keys[#path.keys], len == 2)) do
                    local used = path.wild + (next(ranks[key]) and 0 or 1)
                    if used <= #wild then
                        local keys = {}
                        for _, old in ipairs(path.keys) do keys[#keys + 1] = old end
                        keys[#keys + 1] = key
                        new_paths[#new_paths + 1] = {keys = keys, wild = used}
                        found = true
                    end
                end
            end
            if len > min_length and not found then
                local straight, wi = {}, 1
                for _, key in ipairs(path.keys) do
                    if next(ranks[key]) then
                        for _, card in ipairs(ranks[key]) do straight[#straight + 1] = card end
                    else
                        straight[#straight + 1] = wild[wi]
                        wi = wi + 1
                    end
                end
                ret[#ret + 1] = straight
            end
        end
        paths = new_paths
    end
    table.sort(ret, function(a, b) return #a > #b end)
    return ret
end

local get_highest_ref = get_highest
function get_highest(hand)
    for _, card in ipairs(hand) do
        if BM.get_playing_attribute(card) == 'Free' and not card.debuff then return {card} end
    end
    return get_highest_ref(hand)
end

local function active(attribute)
    for _, card in ipairs(G.jokers and G.jokers.cards or {}) do
        if not card.debuff and BM.is_digimon(card) and BM.get_attribute(card) == attribute then return true end
    end
end

local function run_center(card, context, area)
    local center = card.config.center
    if not center.calculate then return false end
    local fake = {}
    for k, v in pairs(context) do fake[k] = v end
    fake.cardarea = area
    fake.main_scoring = true
    fake.individual = nil
    fake.other_card = nil
    local extra = card.ability.extra
    local scores = type(extra) == 'table' and extra.scores
    local evolving = type(extra) == 'table' and extra.evolution_triggering
    local effect = center:calculate(card, fake)
    if effect then SMODS.calculate_effect(effect, card) end
    extra = card.ability.extra
    return effect ~= nil
        or type(extra) == 'table' and extra.scores ~= scores
        or type(extra) == 'table' and extra.evolution_triggering ~= evolving
end

local function played_exposed(card, context)
    local effect = {}
    local triggered
    if card.config.center.key == 'm_lucky' then
        local mult = card:get_chip_mult()
        local dollars = card:get_p_dollars()
        if card.seal == 'Gold' then dollars = dollars - G.P_SEALS.Gold.config.extra end
        if mult ~= 0 then effect.mult = mult end
        if dollars ~= 0 then effect.dollars = dollars end
    else
        if card.ability.bonus and card.ability.bonus ~= 0 then effect.chips = card.ability.bonus end
        if card.ability.mult and card.ability.mult ~= 0 then effect.mult = card.ability.mult end
        if card.ability.x_mult and card.ability.x_mult > 1 then effect.xmult = card.ability.x_mult end
        if card.ability.p_dollars and card.ability.p_dollars ~= 0 then effect.dollars = card.ability.p_dollars end
    end
    if next(effect) then
        SMODS.calculate_effect(effect, card)
        triggered = true
    end
    return run_center(card, context, G.play) or triggered
end

local function held_exposed(card, context)
    local effect = {}
    local mult = card.get_chip_h_mult and card:get_chip_h_mult() or card.ability.h_mult
    local xmult = card.get_chip_h_x_mult and card:get_chip_h_x_mult() or card.ability.h_x_mult
    if mult and mult ~= 0 then effect.mult = mult end
    if xmult and xmult > 1 then effect.xmult = xmult end
    if card.ability.h_dollars and card.ability.h_dollars ~= 0 then effect.dollars = card.ability.h_dollars end
    local triggered
    if next(effect) then
        SMODS.calculate_effect(effect, card)
        triggered = true
    end
    return run_center(card, context, G.hand) or triggered
end

local function trigger_exposed(card)
    card.ability.balatromon_exposed_triggers = (card.ability.balatromon_exposed_triggers or 0) + 1
    if card.ability.balatromon_exposed_triggers < 6 then return end
    card.ability.balatromon_exposed_triggers = 0
    G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
        if card and not card.REMOVED and card.ability.set == 'Enhanced' then card:set_ability(G.P_CENTERS.c_base, nil, true) end
        return true
    end}))
end

function BM.calculate_playing_attribute_context(context)
    if context.before and context.main_eval and active('Virus') then
        for _, card in ipairs(G.playing_cards or {}) do
            if BM.get_playing_attribute(card) == 'Data' then BM.set_playing_attribute(card, 'Virus') end
        end
    end
    if context.individual and context.other_card then
        local card = context.other_card
        if BM.get_playing_attribute(card) == 'Data' and card.ability.set == 'Enhanced' then
            local triggered
            if context.cardarea == G.hand then triggered = played_exposed(card, context)
            elseif context.cardarea == G.play then triggered = held_exposed(card, context) end
            if triggered then trigger_exposed(card) end
        end
    end
    if context.after and context.main_eval then
        local vaccine = active('Vaccine')
        local protected
        for _, card in ipairs(context.full_hand or {}) do
            if BM.get_playing_attribute(card) == 'Vaccine' then protected = true; break end
        end
        for _, card in ipairs(context.full_hand or {}) do
            local attribute = BM.get_playing_attribute(card)
            if attribute == 'Virus' and (vaccine or protected) then
                BM.clear_playing_attribute(card)
            elseif attribute == 'Free' then
                card.ability.balatromon_liberated_plays = (card.ability.balatromon_liberated_plays or 0) + 1
                if card.ability.balatromon_liberated_plays >= 5 then BM.clear_playing_attribute(card) end
            end
        end
    end
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
        text = {
            'When this card gains an {C:attention}Enhancement{}, {C:attention}Seal{},',
            'or {C:attention}Edition{}, adjacent cards gain it too.',
            'Loses Infected when played with a {C:attention}Vaccine{} Digimon',
            'or a {C:attention}Protected{} card.'
        }
    }
    G.localization.descriptions.Other[BM.PREFIX .. '_playing_vaccine'] = {
        name = 'Protected',
        text = {
            'Cannot be {C:red}debuffed{}, transformed, or destroyed.',
            'Loses Protected after preventing one effect.'
        }
    }
    G.localization.descriptions.Other[BM.PREFIX .. '_playing_data'] = {
        name = 'Exposed',
        text = {
            'Its Enhancement works while {C:attention}played{} or {C:attention}held in hand{}.',
            'Becomes {C:attention}Infected{} while a Virus Digimon is active.',
            'Loses its Enhancement after {C:attention}6{} triggers.'
        }
    }
    G.localization.descriptions.Other[BM.PREFIX .. '_playing_free'] = {
        name = 'Liberated',
        text = {
            'Can count as {C:attention}any rank and suit{}, but its played',
            'Enhancement effect is disabled.',
            'Loses Liberated after being played {C:attention}5{} times.'
        }
    }
end
