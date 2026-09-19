local BM = Balatromon

BM.ATTRIBUTE_CLIP_LEVELS = {
    {name = 'Normal', cost = 1, x = 3},
    {name = 'Bronze', cost = 2, x = 4},
    {name = 'Silver', cost = 3, x = 5},
    {name = 'Gold', cost = 5, x = 6},
    {name = 'Gold+', cost = 7, x = 7},
    {name = 'Platinum', cost = 9, x = 8},
    {name = 'Platinum+', cost = 12, x = 9},
    {name = 'Platinum++', cost = 15, x = 10},
}

local attribute_pos = {data = 0, vaccine = 1, virus = 2, free = 11}
local clip_sprites = {}

local function attribute_key(card)
    local attribute = BM.get_attribute(card)
    return attribute and BM.slug(attribute)
end

local function matching_clips(card, attribute)
    if not G.jokers then return 0 end
    local count = 0
    for _, other in ipairs(G.jokers.cards) do
        if other ~= card and BM.is_active_digimon(other) and BM.is_attribute_clip_active(other) and BM.has_attribute(other, attribute) then
            count = count + 1
        end
    end
    return count
end

local function matching_x_gain(level)
    return 0.15 + 0.1 * (level - 4)
end

local function virus_gain(level)
    if level < 4 then return 2 + 3 * (level - 1), 3 + 3 * (level - 1) end
    return 0.2 + 0.3 * (level - 4), 0.1 + 0.3 * (level - 4)
end

local function free_scale(level)
    return level < 3 and level / 4 or 2 ^ (level - 3)
end

function BM.get_attribute_clip(card)
    return BM.is_digimon(card) and card.ability.extra.attribute_clip or nil
end

function BM.get_attribute_clip_level(card)
    local clip = BM.get_attribute_clip(card)
    return clip and clip.level or 0
end

function BM.has_attribute_clip(card)
    return BM.get_attribute_clip_level(card) > 0
end

function BM.can_have_attribute_clip(card)
    if not BM.is_digimon(card) then return false end
    local stage = BM.get_stage(card)
    return stage ~= 'Fresh' and stage ~= 'In-Training' and attribute_pos[attribute_key(card)] ~= nil
end

function BM.is_attribute_clip_active(card)
    return BM.has_attribute_clip(card) and BM.can_have_attribute_clip(card)
end

function BM.attribute_clip_level_name(level)
    if level <= 0 then return nil end
    if BM.ATTRIBUTE_CLIP_LEVELS[level] then return BM.ATTRIBUTE_CLIP_LEVELS[level].name end
    return 'Platinum' .. string.rep('+', level - 6)
end

function BM.get_attribute_clip_name(card)
    return BM.attribute_clip_level_name(BM.get_attribute_clip_level(card))
end

function BM.attribute_clip_cost(level)
    if level <= 0 then return 0 end
    if BM.ATTRIBUTE_CLIP_LEVELS[level] then return BM.ATTRIBUTE_CLIP_LEVELS[level].cost end
    return 15 + (level - 8) * 3
end

function BM.set_attribute_clip_level(card, level, silent)
    level = math.max(0, math.floor(level or 0))
    if level > 0 and not BM.can_have_attribute_clip(card) then return false end

    if level == 0 then
        card.ability.extra.attribute_clip = nil
    else
        local clip = card.ability.extra.attribute_clip or {}
        clip.level = level
        card.ability.extra.attribute_clip = clip
    end

    if not silent then card:set_cost() end
    return true
end

function BM.can_upgrade_attribute_clip(card, max_level)
    local level = BM.get_attribute_clip_level(card)
    return BM.can_have_attribute_clip(card) and (not max_level or level < max_level)
end

function BM.upgrade_attribute_clip(card, max_level)
    if not BM.can_upgrade_attribute_clip(card, max_level) then return false end
    return BM.set_attribute_clip_level(card, BM.get_attribute_clip_level(card) + 1)
end

function BM.roll_attribute_clip(card)
    if not BM.can_have_attribute_clip(card) or BM.has_attribute_clip(card) then return end
    local roll = pseudorandom('balatromon_attribute_clip')
    if roll < 0.005 then return BM.set_attribute_clip_level(card, 3, true) end
    if roll < 0.02 then return BM.set_attribute_clip_level(card, 2, true) end
    if roll < 0.06 then return BM.set_attribute_clip_level(card, 1, true) end
end

function BM.grow_virus_clips(count)
    if not G.jokers or count <= 0 then return end
    for _, card in ipairs(G.jokers.cards) do
        if BM.is_active_digimon(card) and BM.is_attribute_clip_active(card) and BM.has_attribute(card, 'Virus') then
            local clip = BM.get_attribute_clip(card)
            local first, second = virus_gain(clip.level)
            if clip.level < 4 then
                clip.mult = (clip.mult or 0) + first * count
                clip.chips = (clip.chips or 0) + second * count
            else
                clip.xmult = (clip.xmult or 1) + first * count
                clip.xchips = (clip.xchips or 1) + second * count
            end
        end
    end
end

function BM.calculate_attribute_clip_context(context)
    if context.playing_card_added then
        BM.grow_virus_clips(type(context.cards) == 'table' and #context.cards or 1)
    elseif context.remove_playing_cards then
        BM.grow_virus_clips(#(context.removed or {}))
    end
end

function BM.attribute_clip_score(card)
    if not BM.is_active_digimon(card) or not BM.is_attribute_clip_active(card) then return end
    local attribute = attribute_key(card)
    local level = BM.get_attribute_clip_level(card)

    if attribute == 'data' then
        local count = matching_clips(card, 'Data')
        if count == 0 then return end
        if level < 4 then return {chips = 10 * level * count} end
        return {xchips = 1 + matching_x_gain(level) * count}
    end

    if attribute == 'vaccine' then
        local count = matching_clips(card, 'Vaccine')
        if count == 0 then return end
        if level < 4 then return {mult = 5 * level * count} end
        return {xmult = 1 + matching_x_gain(level) * count}
    end

    if attribute == 'virus' then
        local clip = BM.get_attribute_clip(card)
        local score = {}
        if clip.chips and clip.chips > 0 then score.chips = clip.chips end
        if clip.mult and clip.mult > 0 then score.mult = clip.mult end
        if clip.xchips and clip.xchips > 1 then score.xchips = clip.xchips end
        if clip.xmult and clip.xmult > 1 then score.xmult = clip.xmult end
        if next(score) then return score end
    end

    if attribute == 'free' then
        local scale = free_scale(level)
        local score = {}
        for _, other in ipairs(G.jokers.cards) do
            if other ~= card and BM.is_active_digimon(other) and BM.is_attribute_clip_active(other) and attribute_key(other) ~= 'free' then
                local other_score = BM.attribute_clip_score(other)
                if other_score then
                    if other_score.chips then score.chips = (score.chips or 0) + other_score.chips * scale end
                    if other_score.mult then score.mult = (score.mult or 0) + other_score.mult * scale end
                    if other_score.xchips then score.xchips = (score.xchips or 1) * (1 + (other_score.xchips - 1) * scale) end
                    if other_score.xmult then score.xmult = (score.xmult or 1) * (1 + (other_score.xmult - 1) * scale) end
                end
            end
        end
        if next(score) then return score end
    end
end

function BM.apply_attribute_clip_score(card, context, result)
    if not context.joker_main or context.blueprint then return result end
    local clip = BM.attribute_clip_score(card)
    if not clip then return result end
    result = result or {}
    if clip.chips then result.chips = (result.chips or 0) + clip.chips end
    if clip.mult then result.mult = (result.mult or 0) + clip.mult end
    if clip.xchips then result.xchips = (result.xchips or 1) * clip.xchips end
    if clip.xmult then result.xmult = (result.xmult or 1) * clip.xmult end
    return result
end

function BM.apply_attribute_clip_cost(card)
    if not BM.is_attribute_clip_active(card) then return end
    card.extra_cost = (card.extra_cost or 0) + BM.attribute_clip_cost(BM.get_attribute_clip_level(card))
    if not card.ability.rental then card.cost = math.max(1, math.floor((card.base_cost + card.extra_cost + 0.5) * (100 - G.GAME.discount_percent) / 100)) end
    card.sell_cost = math.max(1, math.floor(card.cost / 2)) + (card.ability.extra_value or 0)
    if card.ability.couponed and (card.area == G.shop_jokers or card.area == G.shop_booster) then card.cost = 0 end
    card.sell_cost_label = card.facing == 'back' and '?' or card.sell_cost
end

local tooltip_defs = {
    data_add = {
        name = 'Data Clip',
        text = {
            '{C:attention}#1#{}',
            'Gives {C:chips}+#2#{} Chips for each other {C:chips}Data Clip{}',
            '{C:inactive}(#3# other, currently +#4# Chips){}'
        }
    },
    data_x = {
        name = 'Data Clip',
        text = {
            '{C:attention}#1#{}',
            'Each other {C:chips}Data Clip{} adds {C:chips}+#2#{} to XChips',
            '{C:inactive}(#3# other, currently {X:chips,C:white}X#4#{C:inactive} Chips){}'
        }
    },
    vaccine_add = {
        name = 'Vaccine Clip',
        text = {
            '{C:attention}#1#{}',
            'Gives {C:mult}+#2#{} Mult for each other {C:mult}Vaccine Clip{}',
            '{C:inactive}(#3# other, currently +#4# Mult){}'
        }
    },
    vaccine_x = {
        name = 'Vaccine Clip',
        text = {
            '{C:attention}#1#{}',
            'Each other {C:mult}Vaccine Clip{} adds {C:mult}+#2#{} to XMult',
            '{C:inactive}(#3# other, currently {X:mult,C:white}X#4#{C:inactive} Mult){}'
        }
    },
    virus_add = {
        name = 'Virus Clip',
        text = {
            '{C:attention}#1#{}',
            'Each modified playing card permanently gains',
            '{C:mult}+#2#{} Mult and {C:chips}+#3#{} Chips',
            '{C:inactive}(Stored +#4# Mult, +#5# Chips){}'
        }
    },
    virus_x = {
        name = 'Virus Clip',
        text = {
            '{C:attention}#1#{}',
            'Each modified playing card adds {C:mult}+#2#{} XMult',
            'and {C:chips}+#3#{} XChips',
            '{C:inactive}(Stored +#4# Mult, +#5# Chips){}',
            '{C:inactive}(Currently {X:mult,C:white}X#6#{C:inactive} Mult / {X:chips,C:white}X#7#{C:inactive} Chips){}'
        }
    },
    free = {
        name = 'Free Clip',
        text = {
            '{C:attention}#1#{}',
            'Reactivates all other Attribute Clip scoring effects',
            'at {C:attention}#2#x{} value',
            '{C:inactive}(Free Clips do not reactivate other Free Clips){}'
        }
    }
}

function BM.install_attribute_clip_localization()
    if not G.localization or not G.localization.descriptions then return end
    G.localization.descriptions.Other = G.localization.descriptions.Other or {}
    for key, def in pairs(tooltip_defs) do
        SMODS.process_loc_text(G.localization.descriptions.Other, BM.PREFIX .. '_clip_' .. key, def)
    end
end

function BM.add_attribute_clip_tooltip(info_queue, card)
    if not info_queue or not BM.is_attribute_clip_active(card) then return end
    local attribute = attribute_key(card)
    local level = BM.get_attribute_clip_level(card)
    local name = BM.attribute_clip_level_name(level)

    if attribute == 'data' then
        local count = matching_clips(card, 'Data')
        if level < 4 then
            local gain = 10 * level
            info_queue[#info_queue + 1] = {set = 'Other', key = BM.PREFIX .. '_clip_data_add', vars = {name, gain, count, gain * count}}
        else
            local gain = matching_x_gain(level)
            info_queue[#info_queue + 1] = {set = 'Other', key = BM.PREFIX .. '_clip_data_x', vars = {name, gain, count, 1 + gain * count}}
        end
        return
    end

    if attribute == 'vaccine' then
        local count = matching_clips(card, 'Vaccine')
        if level < 4 then
            local gain = 5 * level
            info_queue[#info_queue + 1] = {set = 'Other', key = BM.PREFIX .. '_clip_vaccine_add', vars = {name, gain, count, gain * count}}
        else
            local gain = matching_x_gain(level)
            info_queue[#info_queue + 1] = {set = 'Other', key = BM.PREFIX .. '_clip_vaccine_x', vars = {name, gain, count, 1 + gain * count}}
        end
        return
    end

    if attribute == 'virus' then
        local clip = BM.get_attribute_clip(card)
        local first, second = virus_gain(level)
        if level < 4 then
            info_queue[#info_queue + 1] = {set = 'Other', key = BM.PREFIX .. '_clip_virus_add', vars = {name, first, second, clip.mult or 0, clip.chips or 0}}
        else
            info_queue[#info_queue + 1] = {set = 'Other', key = BM.PREFIX .. '_clip_virus_x', vars = {name, first, second, clip.mult or 0, clip.chips or 0, clip.xmult or 1, clip.xchips or 1}}
        end
        return
    end

    if attribute == 'free' then
        info_queue[#info_queue + 1] = {set = 'Other', key = BM.PREFIX .. '_clip_free', vars = {name, free_scale(level)}}
    end
end

function BM.install_attribute_clip_tooltips()
    for _, center in pairs(SMODS.Centers or {}) do
        if center.balatromon and not center._bm_attribute_clip_tooltip then
            local old_loc_vars = center.loc_vars
            center.loc_vars = function(self, info_queue, card)
                local result = old_loc_vars and old_loc_vars(self, info_queue, card) or {vars = {}}
                BM.add_attribute_clip_tooltip(info_queue, card)
                return result
            end
            center._bm_attribute_clip_tooltip = true
        end
    end
end

local function draw_clip(card, x, shader)
    if not clip_sprites[x] then clip_sprites[x] = SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, BM.PREFIX .. '_Clipping', {x = x, y = 0}) end
    local sprite = clip_sprites[x]
    sprite.role.draw_major = card
    sprite:draw_shader('dissolve', nil, nil, nil, card.children.center)
    if shader then sprite:draw_shader(shader, nil, card.ARGS.send_to_shader, nil, card.children.center) end
end

SMODS.DrawStep {
    key = 'attribute_clipping',
    order = 38,
    func = function(card)
        if not BM.is_attribute_clip_active(card) then return end
        local level = math.min(BM.get_attribute_clip_level(card), 8)
        local shader = level >= 6 and 'polychrome' or level >= 2 and 'foil' or nil
        draw_clip(card, attribute_pos[attribute_key(card)])
        draw_clip(card, BM.ATTRIBUTE_CLIP_LEVELS[level].x, shader)
    end,
    conditions = {vortex = false, facing = 'front'}
}

local set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    local clip = self.ability and self.ability.extra and self.ability.extra.attribute_clip
    local changed = self.playing_card and self.added_to_deck and not initial and self.config.center ~= center
    local result = set_ability(self, center, initial, delay_sprites)
    if clip and BM.is_digimon(self) then
        self.ability.extra.attribute_clip = clip
    elseif initial and G.STAGE == G.STAGES.RUN and not G.SETTINGS.paused then
        BM.roll_attribute_clip(self)
    end
    if changed then BM.grow_virus_clips(1) end
    return result
end

local set_base = Card.set_base
function Card:set_base(card, initial)
    local old_suit = self.base and self.base.suit
    local old_value = self.base and self.base.value
    local track = self.playing_card and self.added_to_deck and not initial
    local result = set_base(self, card, initial)
    if track and (old_suit ~= self.base.suit or old_value ~= self.base.value) then BM.grow_virus_clips(1) end
    return result
end

local set_seal = Card.set_seal
function Card:set_seal(seal, silent, immediate)
    local old_seal = self.seal
    local track = self.playing_card and self.added_to_deck
    local result = set_seal(self, seal, silent, immediate)
    if track and old_seal ~= self.seal then BM.grow_virus_clips(1) end
    return result
end

local set_edition = Card.set_edition
function Card:set_edition(edition, immediate, silent)
    local old_edition = self.edition and self.edition.type
    local track = self.playing_card and self.added_to_deck
    local result = set_edition(self, edition, immediate, silent)
    if track and old_edition ~= (self.edition and self.edition.type) then BM.grow_virus_clips(1) end
    return result
end

local run_effect = BM.run_effect
function BM.run_effect(slug, card, context)
    return BM.apply_attribute_clip_score(card, context, run_effect(slug, card, context))
end

BM.install_attribute_clip_localization()
BM.install_attribute_clip_tooltips()
