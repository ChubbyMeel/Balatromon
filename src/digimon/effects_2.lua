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
