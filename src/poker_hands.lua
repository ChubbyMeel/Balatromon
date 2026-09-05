local BM = Balatromon

if BM._poker_hands_loaded then return end
BM._poker_hands_loaded = true

local function straight_name()
    local name = localize('Straight', 'poker_hands')
    return name == 'ERROR' and 'Straight' or name
end

local function ensure_custom_hand_states()
    if not G or not G.GAME or not G.GAME.hands then return end

    for _, key in pairs(BM.JOGRESS_HANDS or {}) do
        if not G.GAME.hands[key] then
            local def = SMODS.PokerHands and SMODS.PokerHands[key]
            if def then
                local state = {}
                for k, v in pairs(def) do
                    if type(v) == 'number' or type(v) == 'boolean' or k == 'example' or k == 'key' then
                        state[k] = v
                    end
                end
                G.GAME.hands[key] = state
            end
        end
    end
end

local function has_jogress(hand)
    for _, card in ipairs(hand or {}) do
        if BM.is_jogress_card(card) then return true end
    end
    return false
end

local function build_rank_buckets(hand)
    local buckets = {}
    for _, key in ipairs(SMODS.Rank.obj_buffer or {}) do buckets[key] = {} end

    for _, card in ipairs(hand or {}) do
        local seen = {}
        for _, identity in ipairs(BM.card_identities(card) or {}) do
            for _, key in ipairs(SMODS.Rank.obj_buffer or {}) do
                local rank = SMODS.Ranks[key]
                if rank and rank.id == identity.rank and not seen[key] then
                    seen[key] = true
                    buckets[key] = buckets[key] or {}
                    buckets[key][#buckets[key] + 1] = card
                end
            end
        end
    end

    return buckets
end

local function assign_distinct_cards(tuple, buckets)
    local used = {}
    local chosen = {}

    local function walk(i)
        if i > #tuple then return true end
        for _, card in ipairs(buckets[tuple[i]] or {}) do
            if not used[card] then
                used[card] = true
                chosen[i] = card
                if walk(i + 1) then return true end
                chosen[i] = nil
                used[card] = nil
            end
        end
        return false
    end

    return walk(1) and chosen or nil
end

local function tuple_contains(tuple, key)
    for _, value in ipairs(tuple) do
        if value == key then return true end
    end
    return false
end

local function next_rank_keys(key, start, skip, wrap)
    local rank = SMODS.Ranks[key]
    if not rank then return {} end
    if not start and not wrap and rank.straight_edge then return {} end

    local out = {}
    local seen = {}

    local function add(next_key)
        if next_key and not seen[next_key] then
            seen[next_key] = true
            out[#out + 1] = next_key
        end
    end

    for _, next_key in ipairs(rank.next or {}) do
        add(next_key)
        local next_rank = SMODS.Ranks[next_key]
        if skip and next_rank and (wrap or not next_rank.straight_edge) then
            for _, skipped_key in ipairs(next_rank.next or {}) do add(skipped_key) end
        end
    end

    return out
end

local function jogress_straight(hand)
    if not has_jogress(hand) then return {} end

    local needed = SMODS.four_fingers and SMODS.four_fingers('straight') or 5
    local skip = SMODS.shortcut and SMODS.shortcut() or false
    local wrap = SMODS.wrap_around_straight and SMODS.wrap_around_straight() or false
    if #(hand or {}) < needed then return {} end

    local buckets = build_rank_buckets(hand)
    local tuples = {}
    local best = nil

    for _, key in ipairs(SMODS.Rank.obj_buffer or {}) do
        if buckets[key] and #buckets[key] > 0 then tuples[#tuples + 1] = {key} end
    end

    for length = 2, #(hand or {}) do
        local new_tuples = {}

        for _, tuple in ipairs(tuples) do
            for _, next_key in ipairs(next_rank_keys(tuple[#tuple], length == 2, skip, wrap)) do
                if buckets[next_key] and #buckets[next_key] > 0 and not tuple_contains(tuple, next_key) then
                    local new_tuple = {}
                    for i, value in ipairs(tuple) do new_tuple[i] = value end
                    new_tuple[#new_tuple + 1] = next_key

                    local chosen = assign_distinct_cards(new_tuple, buckets)
                    if chosen then
                        new_tuples[#new_tuples + 1] = new_tuple
                        if #new_tuple >= needed and (not best or #new_tuple > #best) then best = chosen end
                    end
                end
            end
        end

        tuples = new_tuples
        if #tuples == 0 then break end
    end

    return best and {best} or {}
end

local function jogress_same_rank(hand, amount)
    if not has_jogress(hand) then return {} end

    local buckets = build_rank_buckets(hand)
    local groups = {}

    for _, key in ipairs(SMODS.Rank.obj_buffer or {}) do
        local cards = buckets[key] or {}
        if #cards >= amount then groups[#groups + 1] = cards end
    end

    return groups
end

local function card_counts_as_suit(card, suit)
    if card and card.is_suit and card:is_suit(suit, true, true) then return true end
    if BM.is_jogress_card(card) then
        for _, identity in ipairs(BM.card_identities(card) or {}) do
            if identity.suit == suit then return true end
        end
    end
    return false
end

local function jogress_flush(hand)
    if not has_jogress(hand) then return {} end

    local needed = SMODS.four_fingers and SMODS.four_fingers('flush') or 5
    if #(hand or {}) < needed then return {} end

    for _, suit in ipairs(BM.SUITS or {'Hearts', 'Diamonds', 'Clubs', 'Spades'}) do
        local cards = {}
        for _, card in ipairs(hand or {}) do
            if card_counts_as_suit(card, suit) then cards[#cards + 1] = card end
        end
        if #cards >= needed then return {cards} end
    end

    return {}
end

local function extend_part(key, fallback)
    local part = SMODS.PokerHandParts and SMODS.PokerHandParts[key]
    if not part or not part.func then return end

    local old_func = part.func
    SMODS.PokerHandPart:take_ownership(key, {
        func = function(hand)
            local normal = old_func(hand) or {}
            if next(normal) then return normal end
            return fallback(hand)
        end
    }, true)
end

extend_part('_straight', jogress_straight)
extend_part('_flush', jogress_flush)
for _, amount in ipairs({2, 3, 4, 5}) do
    extend_part('_' .. amount, function(hand) return jogress_same_rank(hand, amount) end)
end

local four_straight = SMODS.PokerHand {
    key = 'four_of_a_straight',
    chips = 80,
    mult = 8,
    l_chips = 40,
    l_mult = 4,
    visible = false,
    above_hand = 'Four of a Kind',
    example = {
        {'S_6', true}, {'H_6', true}, {'D_6', true}, {'C_6', true}, {'S_7', true}
    },
    evaluate = function(parts, hand)
        ensure_custom_hand_states()
        if not next(parts._4) or not next(parts._straight) then return {} end
        return {SMODS.merge_lists(parts._4, parts._straight)}
    end,
    loc_txt = {
        name = 'Four of a ' .. straight_name(),
        description = {
            'Contains a {C:attention}Four of a Kind{} and a {C:attention}' .. straight_name() .. '{}',
            '{C:planet}Mars{} also levels this hand'
        }
    }
}

local five_straight = SMODS.PokerHand {
    key = 'five_of_a_straight',
    chips = 150,
    mult = 14,
    l_chips = 50,
    l_mult = 4,
    visible = false,
    above_hand = 'Five of a Kind',
    example = {
        {'S_6', true}, {'H_6', true}, {'D_6', true}, {'C_6', true}, {'S_6', true}
    },
    evaluate = function(parts, hand)
        ensure_custom_hand_states()
        if not next(parts._5) or not next(parts._straight) then return {} end
        return {SMODS.merge_lists(parts._5, parts._straight)}
    end,
    loc_txt = {
        name = 'Five of a ' .. straight_name(),
        description = {
            'Contains a {C:attention}Five of a Kind{} and a {C:attention}' .. straight_name() .. '{}',
            '{C:planet}Planet X{} also levels this hand'
        }
    }
}

local five_straight_flush = SMODS.PokerHand {
    key = 'five_straight_flush',
    chips = 200,
    mult = 18,
    l_chips = 65,
    l_mult = 5,
    visible = false,
    above_hand = 'Flush Five',
    example = {
        {'S_6', true}, {'S_6', true}, {'S_6', true}, {'S_6', true}, {'S_6', true}
    },
    evaluate = function(parts, hand)
        ensure_custom_hand_states()
        if not next(parts._5) or not next(parts._straight) or not next(parts._flush) then return {} end
        return {SMODS.merge_lists(parts._5, parts._straight, parts._flush)}
    end,
    loc_txt = {
        name = 'Five ' .. straight_name() .. ' Flush',
        description = {
            'Contains a {C:attention}Flush Five{} and a {C:attention}' .. straight_name() .. '{}',
            '{C:planet}Eris{} also levels this hand'
        }
    }
}

BM.JOGRESS_HANDS = {
    four_of_a_straight = four_straight.key,
    five_of_a_straight = five_straight.key,
    five_straight_flush = five_straight_flush.key
}

local base_for_custom = {
    [four_straight.key] = 'Four of a Kind',
    [five_straight.key] = 'Five of a Kind',
    [five_straight_flush.key] = 'Flush Five'
}

local custom_for_base = {
    ['Four of a Kind'] = four_straight.key,
    ['Five of a Kind'] = five_straight.key,
    ['Flush Five'] = five_straight_flush.key
}

if BM.planet_key_for_hand and not BM._jogress_planet_lookup_patched then
    BM._jogress_planet_lookup_patched = true
    local old_planet_key_for_hand = BM.planet_key_for_hand
    BM.planet_key_for_hand = function(hand_name)
        return old_planet_key_for_hand(base_for_custom[hand_name] or hand_name)
    end
end

if SMODS.upgrade_poker_hands and not BM._jogress_planet_level_patched then
    BM._jogress_planet_level_patched = true
    local old_upgrade_poker_hands = SMODS.upgrade_poker_hands

    local function contains_hand(hands, target)
        if type(hands) == 'string' then return hands == target end
        if type(hands) == 'table' then
            for _, hand_name in ipairs(hands) do
                if hand_name == target then return true end
            end
        end
        return false
    end

    SMODS.upgrade_poker_hands = function(args)
        args = args or {}

        local source = args.from
        local center = source and source.config and source.config.center or (source and source.set == 'Planet' and source)
        local is_planet = center and center.set == 'Planet'
        local planet_hand = is_planet and ((source.ability and source.ability.consumeable and source.ability.consumeable.hand_type) or (center.config and center.config.hand_type)) or nil
        local custom_hand = planet_hand and custom_for_base[planet_hand] or nil

        if custom_hand and contains_hand(args.hands, planet_hand) then
            local copy = {}
            for key, value in pairs(args) do copy[key] = value end

            local hands = {}
            if type(args.hands) == 'string' then
                hands[1] = args.hands
            else
                for _, hand_name in ipairs(args.hands or {}) do hands[#hands + 1] = hand_name end
            end

            local found = false
            for _, hand_name in ipairs(hands) do
                if hand_name == custom_hand then found = true break end
            end
            if not found then hands[#hands + 1] = custom_hand end

            copy.hands = hands
            return old_upgrade_poker_hands(copy)
        end

        return old_upgrade_poker_hands(args)
    end
end
