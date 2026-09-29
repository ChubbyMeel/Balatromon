local BM = Balatromon
local H = BM.effect_handlers
local attributes = {'Data', 'Vaccine', 'Virus', 'Free'}
local count_fields = {
    Data = 'data_count',
    Vaccine = 'vaccine_count',
    Virus = 'virus_count',
    Free = 'free_count'
}

local function merge_effects(a, b)
    if not a then return b end
    if not b then return a end
    local result = {}
    for key, value in pairs(a) do result[key] = value end
    for key, value in pairs(b) do
        if key == 'mult' or key == 'chips' or key == 'dollars' then
            result[key] = (result[key] or 0) + value
        elseif key == 'xmult' or key == 'xchips' then
            result[key] = (result[key] or 1) * value
        elseif key ~= 'message' or not result.message then
            result[key] = value
        end
    end
    return result
end



local function used_attribute(context, attribute)
    return context.using_consumeable
        and not context.blueprint
        and BM.get_attributed_consumable_attribute(context.consumeable) == attribute
end

local function curimon_effect(card, context)
    if not (context.end_of_round and context.main_eval and not context.blueprint) then return end
    local index = BM.joker_index(card)
    local left = index and index > 1 and G.jokers.cards[index - 1]
    if not BM.is_digimon(left) then return end
    local attribute = BM.get_attribute(left)
    if attribute == 'None' then return end
    if BM.create_attributed_consumable('Planet', attribute, 'curimon_' .. tostring(card.sort_id or 0)) then
        return {message = attribute .. ' Planet!', colour = G.C.SECONDARY_SET.Planet}
    end
end

local function gurimon_effect(card, context)
    if not (context.end_of_round and context.main_eval and not context.blueprint) then return end
    if (G.GAME.dollars or 0) <= (G.GAME.interest_cap or 25) then return end
    if BM.create_attributed_consumable('Tarot', nil, 'gurimon_' .. tostring(card.sort_id or 0)) then
        return {message = 'Attributed Tarot!', colour = G.C.SECONDARY_SET.Tarot}
    end
end

local function gammamon_effect(card, context)
    local e = card.ability.extra
    if context.post_trigger and context.other_card ~= card and BM.is_digimon(context.other_card) and not context.blueprint then
        local attribute = BM.get_attribute(context.other_card)
        local field = count_fields[attribute]
        if field then
            e[field] = (e[field] or 0) + 1
            return {message = attribute .. ' +1', colour = G.C.ATTENTION}
        end
    end
    if not (context.end_of_round and context.main_eval and not context.blueprint) then return end
    local highest = 0
    for _, attribute in ipairs(attributes) do
        highest = math.max(highest, e[count_fields[attribute]] or 0)
    end
    if highest == 0 then return end
    local tied = {}
    for _, attribute in ipairs(attributes) do
        if (e[count_fields[attribute]] or 0) == highest then tied[#tied + 1] = attribute end
    end
    local seed = 'gammamon_' .. tostring(card.sort_id or 0) .. '_' .. tostring(G.GAME.round or 0)
    local attribute = BM.random_element(tied, seed .. '_attribute')
    if BM.create_attributed_consumable(nil, attribute, seed) then
        return {message = attribute .. ' Consumable!', colour = G.C.ATTENTION}
    end
end

local function gulusgammamon_effect(card, context)
    local e = card.ability.extra
    if used_attribute(context, 'Virus') then
        e.virus_mult = (e.virus_mult or 0) + 7
        return {message = '+7 Mult', colour = G.C.MULT}
    end
    if context.joker_main and (e.virus_mult or 0) > 0 then return {mult = e.virus_mult} end
end

local function betelgammamon_effect(card, context)
    local e = card.ability.extra
    if used_attribute(context, 'Vaccine') then
        e.vaccine_mult = (e.vaccine_mult or 0) + 3
        return {message = '+3 Mult', colour = G.C.MULT}
    end
    if context.joker_main and (e.vaccine_mult or 0) > 0 then return {mult = e.vaccine_mult} end
end

local function kausgammamon_effect(card, context)
    local e = card.ability.extra
    if used_attribute(context, 'Data') then
        e.data_chips = (e.data_chips or 0) + 15
        return {message = '+15 Chips', colour = G.C.CHIPS}
    end
    if context.joker_main and (e.data_chips or 0) > 0 then return {chips = e.data_chips} end
end

local function wezengammamon_effect(card, context)
    if not used_attribute(context, 'Free') then return end
    local tarot = BM.add_consumable('Tarot')
    if not tarot then return end
    BM.clear_attributed_consumable(tarot)
    return {message = 'Tarot!', colour = G.C.SECONDARY_SET.Tarot}
end

local function canoweissmon_effect(card, context)
    local e = card.ability.extra
    if used_attribute(context, 'Vaccine') then
        e.vaccine_xmult = (e.vaccine_xmult or 1) + 0.25
        return {message = '+X0.25 Mult', colour = G.C.MULT}
    end
    if context.joker_main then return {xmult = e.vaccine_xmult or 1} end
end

local function regulusmon_effect(card, context)
    local e = card.ability.extra
    if used_attribute(context, 'Virus') then
        e.virus_xmult = (e.virus_xmult or 1) + 0.3
        return {message = '+X0.3 Mult', colour = G.C.MULT}
    end
    if context.joker_main then return {xmult = e.virus_xmult or 1} end
end

H.curimon = curimon_effect
H.gurimon = gurimon_effect
H.gammamon = gammamon_effect
H.gulusgammamon = gulusgammamon_effect
H.betelgammamon = betelgammamon_effect
H.kausgammamon = kausgammamon_effect
H.wezengammamon = wezengammamon_effect
H.canoweissmon = canoweissmon_effect
H.regulusmon = regulusmon_effect

H.siriusmon = function(card, context)
    return merge_effects(canoweissmon_effect(card, context), wezengammamon_effect(card, context))
end

H.arcturusmon = function(card, context)
    return merge_effects(regulusmon_effect(card, context), gammamon_effect(card, context))
end

H.proximamon = function(card, context)
    return merge_effects(H.siriusmon(card, context), H.arcturusmon(card, context))
end

local function create_tarot_or_planet(card, seed)
    if not G.consumeables or not BM.has_room(G.consumeables) then return end
    local set = BM.random_element({'Tarot', 'Planet'}, seed .. ':' .. tostring(G.GAME and G.GAME.hands_played or 0) .. ':' .. tostring(card.sort_id or 0))
    if BM.add_consumable(set) then return {message = set .. '!', colour = G.C.SECONDARY_SET[set]} end
end

local function has_attributed_consumable()
    for _, held in ipairs(G.consumeables and G.consumeables.cards or {}) do
        local attribute = BM.get_attribute(held)
        if attribute and attribute ~= 'None' then return true end
    end
    return false
end

H.pyonmon = function(card, context)
    if context.end_of_round and context.main_eval and not context.game_over and not context.blueprint and not context.retrigger_joker and has_attributed_consumable() then
        return create_tarot_or_planet(card, 'pyonmon')
    end
end

H.bosamon = function(card, context)
    if context.after and context.main_eval and not context.blueprint and not context.retrigger_joker and G.GAME.blind and G.GAME.blind.chips and G.GAME.chips >= G.GAME.blind.chips * 0.5 then
        return create_tarot_or_planet(card, 'bosamon')
    end
end

H.angoramon = function(card, context)
    if context.after and context.main_eval and not context.blueprint and not context.retrigger_joker and (G.GAME.dollars or 0) <= 0 then
        return create_tarot_or_planet(card, 'angoramon')
    end
end

H.symbareangoramon = function(card, context)
    if context.after and context.main_eval and not context.blueprint and not context.retrigger_joker and (G.GAME.dollars or 0) <= 4 then
        return create_tarot_or_planet(card, 'symbareangoramon')
    end
end

H.lamortmon = function(card, context)
    local inherited = H.symbareangoramon(card, context)
    if context.end_of_round and context.main_eval and context.game_over and not context.blueprint and not context.retrigger_joker and G.GAME.blind and G.GAME.blind.chips and G.GAME.blind.chips > 0 and G.GAME.chips >= G.GAME.blind.chips * 0.15 then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                if card and not card.REMOVED then card:start_dissolve() end
                return true
            end
        }))
        return {saved = true, message = 'Saved!', colour = G.C.RED}
    end
    return inherited
end

H.diarbbitmon = function(card, context)
    local inherited = H.lamortmon(card, context)
    if inherited then return inherited end
    return H.wezengammamon(card, context)
end

local function left_of(card)
    local i = BM.joker_index(card)
    return i and G.jokers and G.jokers.cards[i - 1]
end

local function boss_active()
    local blind = G.GAME and G.GAME.blind
    return blind and blind.boss and not blind.disabled
end

function BM.care_guarded(target)
    for _, card in ipairs(G.jokers and G.jokers.cards or {}) do
        local slug = BM.get_card_slug(card)
        if (slug == 'teslajellymon' or slug == 'amphimon') and BM.is_active_digimon(card) and left_of(card) == target then
            return true
        end
    end
    return false
end

function BM.prevent_boss_debuff(target)
    if not boss_active() then return false end

    if target.playing_card then
        local guarded = false
        for _, card in ipairs(G.jokers and G.jokers.cards or {}) do
            if BM.is_active_digimon(card) then
                local slug = BM.get_card_slug(card)
                if slug == 'jellymon_hidden' then
                    card.ability.extra.protected = true
                    guarded = true
                elseif slug == 'puyomon' and card.ability.extra.guard_id == target.playing_card then
                    guarded = true
                end
            end
        end
        return guarded
    end

    if not BM.is_digimon(target) then return false end

    for _, card in ipairs(G.jokers and G.jokers.cards or {}) do
        if BM.is_active_digimon(card) then
            local slug = BM.get_card_slug(card)
            local left = left_of(card)
            if slug == 'jellymon_unfurl' and (target == card or target == left) then return true end
            if (slug == 'teslajellymon' or slug == 'amphimon') and target == left then return true end
        end
    end
    return false
end

local function swap_jelly(card)
    local center = G.P_CENTERS[BM.center_key('jellymon_unfurl')]
    if not center then return end

    local old = copy_table(card.ability.extra or {})
    local value = card.ability.extra_value or 0
    old.protected = nil

    BM.on_remove(card, 'jellymon_hidden')
    card:set_ability(center, nil, true)
    card.ability.extra_value = value
    for k, v in pairs(old) do card.ability.extra[k] = v end
    BM.on_add(card, 'jellymon_unfurl')
    card:set_cost()
    card:juice_up(1.2, 0.8)
end

H.puyomon = function(card, context)
    if not ((context.hand_drawn or context.first_hand_drawn) and context.main_eval and not context.blueprint) then return end
    local e = card.ability.extra
    e.guard_id = nil
    if not boss_active() or not G.hand or #G.hand.cards == 0 then return end

    local round = G.GAME.current_round or {}
    local target = BM.random_element(G.hand.cards, 'puyomon_' .. tostring(card.sort_id or 0) .. '_' .. tostring(round.hands_played or 0) .. '_' .. tostring(round.discards_used or 0))
    if not target then return end

    e.guard_id = target.playing_card
    SMODS.recalc_debuff(target)
    return {message = 'Protected!', colour = G.C.GREEN}
end

H.puyoyomon = function(card, context)
    if not (context.selling_self and not context.blueprint) then return end
    local changed = false
    for _, target in ipairs(G.playing_cards or {}) do
        if target.debuff then
            target:set_debuff(false)
            changed = true
        end
    end
    if changed then return {message = 'Enabled!', colour = G.C.GREEN} end
end

H.jellymon_hidden = function(card, context)
    local e = card.ability.extra
    if context.end_of_round and context.main_eval and not context.blueprint and e.protected then
        e.protected = false
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
            if card and not card.REMOVED and BM.get_card_slug(card) == 'jellymon_hidden' then swap_jelly(card) end
            return true
        end}))
        return {message = 'Unfurl!', colour = G.C.ATTENTION}
    end
end

H.jellymon_unfurl = function() end
H.teslajellymon = function() end

H.thetismon = function(card, context)
    if not (context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker) then return end
    if not SMODS.pseudorandom_probability(card, 'thetismon_reset', 1, 10) then return end

    local options = {}
    for _, target in ipairs(G.jokers and G.jokers.cards or {}) do
        if BM.is_digimon(target) and target.ability and target.ability.extra and not target.ability.extra.permanently_disabled then
            local e = target.ability.extra
            if (e.care_mistakes or 0) > 0 then options[#options + 1] = {card = target, kind = 'care'} end
            if (e.hunger or 1) > 1 then options[#options + 1] = {card = target, kind = 'hunger'} end
        end
    end

    if #options == 0 then return end
    local pick = BM.random_element(options, 'thetismon_pick_' .. tostring(card.sort_id or 0) .. '_' .. tostring(G.GAME.round or 0))
    if not pick then return end

    local e = pick.card.ability.extra
    if pick.kind == 'care' then
        e.care_mistakes = 0
        e.care_crisis = nil
        BM.care_animation(pick.card, 'Care Reset!', G.C.GREEN)
        return {message = 'Care Reset!', colour = G.C.GREEN}
    end

    e.hunger = 1
    BM.care_animation(pick.card, 'Hunger Reset!', G.C.GREEN)
    return {message = 'Hunger Reset!', colour = G.C.GREEN}
end

H.amphimon = function(card, context)
    return merge_effects(H.thetismon(card, context), H.teslajellymon(card, context))
end
