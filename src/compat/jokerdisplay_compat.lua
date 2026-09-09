local BM = Balatromon

local jd_mod =
    SMODS
    and SMODS.Mods
    and SMODS.Mods['JokerDisplay']

if not (
    jd_mod
    and jd_mod.can_load
    and JokerDisplay
    and JokerDisplay.Definitions
) then
    return
end

if BM._jokerdisplay_compat_loaded then
    return
end

BM._jokerdisplay_compat_loaded = true

local JD = JokerDisplay

local HAND_NAMES = {
    'Flush Five',
    'Flush House',
    'Five of a Kind',
    'Straight Flush',
    'Four of a Kind',
    'Full House',
    'Three of a Kind',
    'Two Pair',
    'Straight',
    'Flush',
    'Pair',
    'High Card',
}

local function fmt(value)
    if type(value) ~= 'number' then
        return tostring(value or '')
    end

    if math.abs(value - math.floor(value)) < 0.000001 then
        return tostring(math.floor(value))
    end

    local text = string.format('%.2f', value)
    text = text:gsub('0+$', '')
    text = text:gsub('%.$', '')
    return text
end


local function is_x_form(card)
    return BM.has_x_antibody
        and BM.has_x_antibody(card)
        or false
end

local function strip_joker_text(text)
    text = tostring(text or '')
    text = text:gsub('{[^}]-}', '')
    text = text:gsub('#%d+#', '[Target]')
    return text
end

local function display_effect_text(slug, card, fallback)
    if is_x_form(card)
    and BM.x_antibody_tooltips
    and BM.x_antibody_tooltips[slug]
    and type(BM.x_antibody_tooltips[slug].text) == 'table' then
        local parts = {}

        for _, line in ipairs(
            BM.x_antibody_tooltips[slug].text
        ) do
            parts[#parts + 1] =
                strip_joker_text(line)
        end

        return table.concat(parts, ' ')
    end

    return fallback or ''
end

local function safe_extra(card)
    return card
        and card.ability
        and type(card.ability.extra) == 'table'
        and card.ability.extra
        or {}
end

local function rank_name(rank)
    if rank == nil then
        return nil
    end

    if BM.rank_name then
        return BM.rank_name(rank)
    end

    return tostring(rank)
end

local function rank_of(card)
    if not card then
        return nil
    end

    if SMODS.has_no_rank
    and SMODS.has_no_rank(card) then
        return nil
    end

    if BM.get_rank then
        return BM.get_rank(card)
    end

    if card.get_id then
        return card:get_id()
    end
end

local function hand_contains(poker_hands, hand)
    return poker_hands
        and poker_hands[hand]
        and next(poker_hands[hand]) ~= nil
end

local function card_has_rank(card, rank)
    if BM.card_has_rank then
        return BM.card_has_rank(card, rank)
    end

    return rank_of(card) == rank
end

local function card_has_suit(card, suit)
    if BM.card_has_suit then
        return BM.card_has_suit(card, suit)
    end

    return card
        and card.is_suit
        and card:is_suit(suit)
end

local function card_matches_target(card, rank, suit)
    if BM.card_matches_target then
        return BM.card_matches_target(card, rank, suit)
    end

    return card_has_rank(card, rank)
        and card_has_suit(card, suit)
end

local function is_face(card)
    if BM.is_face then
        return BM.is_face(card)
    end

    return card
        and card.is_face
        and card:is_face()
end

local function has_enhancement(card, key)
    if BM.has_enhancement then
        return BM.has_enhancement(card, key)
    end

    return card
        and card.config
        and card.config.center
        and card.config.center.key == key
end

local function count_cards(cards, predicate, held)
    local count = 0

    for _, playing_card in ipairs(cards or {}) do
        if not playing_card.debuff
        and predicate(playing_card) then
            local triggers = 1

            if JD.calculate_card_triggers then
                triggers = JD.calculate_card_triggers(
                    playing_card,
                    held and nil or cards,
                    held == true
                )
            end

            count = count + triggers
        end
    end

    return count
end

local function count_held_planets()
    local count = 0

    for _, held in ipairs(
        G.consumeables
        and G.consumeables.cards
        or {}
    ) do
        local center =
            held
            and held.config
            and held.config.center

        if center and center.set == 'Planet' then
            count = count + 1
        end
    end

    return count
end

local function current_hand()
    local text, poker_hands, scoring_hand =
        JD.evaluate_hand()

    return text,
        poker_hands or {},
        scoring_hand or {}
end

local function output()
    return {
        mult = 0,
        chips = 0,
        xmult = 1,
        xchips = 1,
        emult = 1,
        emult_chips = 1,
        dollars = 0,
    }
end

local function static_condition_active(
    effect,
    e,
    poker_hands,
    scoring_hand
)
    if not effect or effect == '' then
        return true
    end

    local lower = effect:lower()

    if effect:find('[Rank]', 1, true)
    and (
        lower:find('played hand contains', 1, true)
        or lower:find('hand played contains', 1, true)
    ) then
        if not e.target_rank then
            return false
        end

        local found = false

        for _, playing_card in ipairs(scoring_hand) do
            if card_has_rank(
                playing_card,
                e.target_rank
            ) then
                found = true
                break
            end
        end

        if not found then
            return false
        end
    end

    if effect:find('[Suit]', 1, true)
    and lower:find('played hand contains', 1, true) then
        if not e.target_suit then
            return false
        end

        local found = false

        for _, playing_card in ipairs(scoring_hand) do
            if card_has_suit(
                playing_card,
                e.target_suit
            ) then
                found = true
                break
            end
        end

        if not found then
            return false
        end
    end

    if effect:find('[poker hand]', 1, true)
    and (
        lower:find('played hand contains', 1, true)
        or lower:find('if played hand', 1, true)
    ) then
        if not e.target_hand
        or not hand_contains(
            poker_hands,
            e.target_hand
        ) then
            return false
        end
    end

    if (
        lower:find('if played hand contains', 1, true)
        or lower:find('if hand played contains', 1, true)
    )
    and effect:find('[Target]', 1, true) then
        if e.target_hand then
            if not hand_contains(
                poker_hands,
                e.target_hand
            ) then
                return false
            end

        elseif e.target_rank
        and e.target_suit then
            local found = false

            for _, playing_card
                in ipairs(scoring_hand) do
                if card_matches_target(
                    playing_card,
                    e.target_rank,
                    e.target_suit
                ) then
                    found = true
                    break
                end
            end

            if not found then
                return false
            end

        elseif e.target_rank then
            local found = false

            for _, playing_card
                in ipairs(scoring_hand) do
                if card_has_rank(
                    playing_card,
                    e.target_rank
                ) then
                    found = true
                    break
                end
            end

            if not found then
                return false
            end

        elseif e.target_suit then
            local found = false

            for _, playing_card
                in ipairs(scoring_hand) do
                if card_has_suit(
                    playing_card,
                    e.target_suit
                ) then
                    found = true
                    break
                end
            end

            if not found then
                return false
            end
        end
    end

    if lower:find('if played hand contains', 1, true)
    or lower:find('if hand played contains', 1, true) then
        for _, hand in ipairs(HAND_NAMES) do
            if effect:find(hand, 1, true) then
                return hand_contains(
                    poker_hands,
                    hand
                )
            end
        end
    end

    return true
end

local function apply_static_effect(
    effect,
    e,
    poker_hands,
    scoring_hand,
    out
)
    if not static_condition_active(
        effect,
        e,
        poker_hands,
        scoring_hand
    ) then
        return
    end

    local n

    n = effect:match('^%+(%d+%.?%d*) Mult')
    if n then
        out.mult = tonumber(n) or 0
    end

    n = effect:match('^%+(%d+%.?%d*) Chips')
    if n then
        out.chips = tonumber(n) or 0
    end

    n = effect:match('^X(%d+%.?%d*) Mult')
    if n then
        out.xmult = tonumber(n) or 1
    end

    n = effect:match('^X(%d+%.?%d*) Chips')
    if n then
        out.xchips = tonumber(n) or 1
    end

    n = effect:match('^%^(%d+%.?%d*) Mult')
    if n then
        out.emult = tonumber(n) or 1
    end

    n = effect:match('^Earn %$(%d+%.?%d*)')
        or effect:match('^%$(%d+%.?%d*)')

    if n then
        out.dollars = tonumber(n) or 0
    end
end

local function apply_stored_values(
    slug,
    e,
    out,
    x_form
)
    if type(e.mult) == 'number' then
        out.mult = e.mult
    end

    if type(e.chips) == 'number' then
        out.chips = e.chips
    end

    if x_form then
        if slug == 'wargreymon'
        or slug == 'blackwargreymon' then
            if type(e.xmult) == 'number' then
                out.emult = e.xmult
            end

        elseif slug == 'metalgarurumon' then
            if type(e.xchips) == 'number' then
                out.xchips = 1
                out.emult_chips = e.xchips
            end

        else
            if type(e.xmult) == 'number' then
                out.xmult = e.xmult
            end

            if type(e.xchips) == 'number' then
                out.xchips = e.xchips
            end
        end

        if type(e.x_antibody_wargrowl_xmult)
            == 'number' then
            out.xmult =
                e.x_antibody_wargrowl_xmult
        end

        if type(e.x_gabumon_chips)
            == 'number' then
            out.xchips = e.x_gabumon_chips
        end

        if type(e.x_garurumon_chips)
            == 'number' then
            out.xchips = e.x_garurumon_chips
        end

        if type(e.x_leomon_chips)
            == 'number' then
            out.xchips = e.x_leomon_chips
        end

        if type(e.x_weregarurumon_chips)
            == 'number' then
            out.xchips = e.x_weregarurumon_chips
        end

        if type(e.x_angewomon_emult)
            == 'number' then
            out.emult = e.x_angewomon_emult
        end

    else
        if type(e.xmult) == 'number' then
            out.xmult = e.xmult
        elseif type(e.round_xmult) == 'number' then
            out.xmult = e.round_xmult
        end

        if type(e.xchips) == 'number' then
            out.xchips = e.xchips
        end

        if type(e.previous_form_value)
            == 'number' then
            out.xmult =
                e.previous_form_value / 3
        end
    end

    if type(e.emult) == 'number' then
        out.emult = e.emult
    end

    if type(e.payout) == 'number' then
        out.dollars = e.payout
    end
end

local function per_card_predicate(effect, e)
    local lower = (effect or ''):lower()

    if lower:find('heart and spade', 1, true) then
        return function(c)
            return card_has_suit(c, 'Hearts')
                or card_has_suit(c, 'Spades')
        end
    end

    if lower:find('diamond and club', 1, true) then
        return function(c)
            return card_has_suit(c, 'Diamonds')
                or card_has_suit(c, 'Clubs')
        end
    end

    if lower:find('kings and queens', 1, true) then
        return function(c)
            return card_has_rank(c, 13)
                or card_has_rank(c, 12)
        end
    end

    if lower:find('face card', 1, true)
    and lower:find("ace", 1, true)
    and lower:find("2", 1, true) then
        return function(c)
            return is_face(c)
                or card_has_rank(c, 14)
                or card_has_rank(c, 2)
        end
    end

    if lower:find('face card', 1, true) then
        return is_face
    end

    if lower:find('stone card', 1, true) then
        return function(c)
            return has_enhancement(c, 'm_stone')
        end
    end

    if lower:find('lucky card', 1, true) then
        return function(c)
            return has_enhancement(c, 'm_lucky')
        end
    end

    if lower:find('gold card', 1, true) then
        return function(c)
            return has_enhancement(c, 'm_gold')
        end
    end

    if effect:find('[rank] of [suit]', 1, true)
    or effect:find('[Rank] of [Suit]', 1, true) then
        return function(c)
            return e.target_rank
                and e.target_suit
                and card_matches_target(
                    c,
                    e.target_rank,
                    e.target_suit
                )
        end
    end

    if effect:find('[suit]', 1, true)
    or effect:find('[Suit]', 1, true) then
        return function(c)
            return e.target_suit
                and card_has_suit(
                    c,
                    e.target_suit
                )
        end
    end
end

local function apply_per_card_effect(
    effect,
    e,
    scoring_hand,
    out
)
    local lower = (effect or ''):lower()

    if not (
        lower:find('each played', 1, true)
        or lower:find('every face', 1, true)
        or lower:find('played card with', 1, true)
        or lower:find('played face cards', 1, true)
        or lower:find('played kings and queens', 1, true)
    ) then
        return
    end

    local predicate =
        per_card_predicate(effect, e)

    if not predicate then
        return
    end

    local count =
        count_cards(
            scoring_hand,
            predicate,
            false
        )

    local n = effect:match('[Gg]ives? %+(%d+%.?%d*) Mult')
    if n then
        out.mult = count * (tonumber(n) or 0)
    end

    n = effect:match('[Gg]ives? %+(%d+%.?%d*) Chips')
    if n then
        out.chips = count * (tonumber(n) or 0)
    end

    n = effect:match('[Gg]ives? %$(%d+%.?%d*)')
    if n then
        out.dollars = count * (tonumber(n) or 0)
    end

    n = effect:match('[Gg]ives? X(%d+%.?%d*) Mult')
    if n then
        out.xmult = (tonumber(n) or 1) ^ count
    end
end

local SPECIAL = {}
local SPECIAL_X = {}

SPECIAL.monochromon = function(card, e, scoring, out)
    local highest = nil

    for _, playing_card in ipairs(scoring) do
        local rank = rank_of(playing_card)
        if rank and (not highest or rank > highest) then
            highest = rank
        end
    end

    out.mult = highest or 0
end

SPECIAL.gigadramon = function(card, e, scoring, out)
    local lowest = nil

    for _, held in ipairs(
        G.hand and G.hand.cards or {}
    ) do
        local rank = rank_of(held)
        if rank and (not lowest or rank < lowest) then
            lowest = rank
        end
    end

    out.mult = lowest and lowest * 2 or 0
end

SPECIAL.mammothmon = function(card, e, scoring, out)
    if BM.all_four_suits
    and BM.all_four_suits(scoring) then
        out.chips = 50
        out.xmult = 2
        out.dollars = 20
    else
        out.chips = 0
        out.xmult = 1
        out.dollars = 0
    end
end

SPECIAL.tsunomon = function(card, e, scoring, out)
    out.chips = 90 - 5 * (e.discards or 0)
end

SPECIAL.madleomon =
function(card, e, scoring, out)
    out.chips =
        1000
        - 100 * (
            G.hand
            and G.hand.config
            and G.hand.config.card_limit
            or 0
        )
        + (
            e.bancho_burst_chips
            or 0
        )
end

SPECIAL.ikkakumon = function(card, e, scoring, out)
    local count = count_cards(
        scoring,
        function(c)
            return BM.is_unenhanced
                and BM.is_unenhanced(c)
        end,
        false
    )

    out.chips = 20 * count
end

SPECIAL.seadramon = function(card, e, scoring, out)
    out.chips = 30 * count_cards(
        scoring,
        is_face,
        false
    )
end

SPECIAL.hydramon = function(card, e, scoring, out)
    out.mult = 20 * count_cards(
        scoring,
        function(c)
            return has_enhancement(c, 'm_stone')
        end,
        false
    )
end

SPECIAL.poyomon = function(card, e, scoring, out)
    out.mult = 2 * count_cards(
        scoring,
        function(c)
            return has_enhancement(c, 'm_lucky')
        end,
        false
    )
end

SPECIAL.gargomon = function(card, e, scoring, out)
    out.mult = 5 * count_cards(
        scoring,
        function(c)
            return is_face(c)
                or card_has_rank(c, 14)
                or card_has_rank(c, 2)
        end,
        false
    )
end

SPECIAL.aoibotamamon = function(card, e, scoring, out)
    out.mult = 3 * count_cards(
        scoring,
        function(c)
            return card_has_suit(c, 'Hearts')
                or card_has_suit(c, 'Spades')
        end,
        false
    )
end

SPECIAL.wanyamon = function(card, e, scoring, out)
    out.mult = 3 * count_cards(
        scoring,
        function(c)
            return card_has_suit(c, 'Diamonds')
                or card_has_suit(c, 'Clubs')
        end,
        false
    )
end

SPECIAL.bearmon = function(card, e, scoring, out)
    local total = 0

    for i = 2, #scoring do
        local rank = rank_of(scoring[i])

        if rank and not scoring[i].debuff then
            local gained = 0

            for j = 1, i - 1 do
                local left_rank = rank_of(scoring[j])

                if left_rank then
                    gained = gained
                        + math.abs(rank - left_rank)
                end
            end

            if gained > 0 then
                local triggers = 1

                if JD.calculate_card_triggers then
                    triggers = JD.calculate_card_triggers(
                        scoring[i],
                        scoring,
                        false
                    )
                end

                total = total + gained * triggers
            end
        end
    end

    out.mult = total
end

SPECIAL.greatgrizzlymon = SPECIAL.bearmon
SPECIAL.callismon = SPECIAL.bearmon

SPECIAL.taomon = function(card, e, scoring, out)
    out.xmult = math.max(
        1,
        math.floor(
            tonumber(
                G.GAME
                and G.GAME.dollars
                or 0
            ) or 0
        ) / 10
    )
end

SPECIAL.sakuyamon = SPECIAL.taomon

SPECIAL.kuramon = function(card, e, scoring, out)
    out.mult = BM.count_owned_jokers
        and BM.count_owned_jokers() * 3
        or 0
end

SPECIAL.tsumemon = function(card, e, scoring, out)
    out.mult = BM.sum_other_joker_sell_value
        and BM.sum_other_joker_sell_value(card)
        or 0
end

SPECIAL.keramon = function(card, e, scoring, out)
    local empty = BM.empty_joker_slots
        and BM.empty_joker_slots({keramon = true})
        or 0

    out.mult = empty * 8
end

SPECIAL.raremon = function(card, e, scoring, out)
    out.xmult = BM.raremon_xmult
        and BM.raremon_xmult()
        or 1
end

local function nightmare_empty()
    return BM.empty_joker_slots
        and BM.empty_joker_slots({
            raremon = true,
            phantomon = true,
            pumpkinmon = true,
        })
        or 0
end

SPECIAL.bakemon = function(card, e, scoring, out)
    out.xmult = nightmare_empty() * 0.5
end

SPECIAL.phantomon = function(card, e, scoring, out)
    out.xmult = nightmare_empty()
end

SPECIAL.pumpkinmon = SPECIAL.phantomon

SPECIAL.palmon = function(card, e, scoring, out)
    out.mult = 3 * (
        BM.count_food and BM.count_food() or 0
    )
end

SPECIAL.lalamon = function(card, e, scoring, out)
    out.chips = 30 * (
        BM.count_food and BM.count_food() or 0
    )
end

SPECIAL.sunflowmon = SPECIAL.lalamon
SPECIAL.lilamon = SPECIAL.lalamon

SPECIAL.togemon = function(card, e, scoring, out)
    out.xmult = 1 + 0.5 * (
        BM.count_food and BM.count_food() or 0
    )
end

SPECIAL.lillymon = SPECIAL.togemon

SPECIAL.mushroomon = function(card, e, scoring, out)
    out.dollars = 2 * (
        BM.count_food and BM.count_food() or 0
    )
end

SPECIAL.solarmon = function(card, e, scoring, out)
    out.mult = 4 * (
        BM.unique_planets_used
        and BM.unique_planets_used()
        or 0
    )
end

SPECIAL.hagurumon = function(card, e, scoring, out)
    out.dollars = BM.unique_planets_used
        and BM.unique_planets_used()
        or 0
end

SPECIAL.flarerizamon = function(card, e, scoring, out)
    local count = BM.unique_planets_used
        and BM.unique_planets_used()
        or 0

    out.mult = 4 * count
    out.dollars = count
end

SPECIAL.lavogaritamon = function(card, e, scoring, out)
    out.xmult = 1.2 ^ count_held_planets()
end

SPECIAL.tortomon = function(card, e, scoring, out)
    local count = 0

    for _, playing_card in ipairs(scoring) do
        if playing_card.seal then
            count = count
                + (
                    JD.calculate_card_triggers
                    and JD.calculate_card_triggers(
                        playing_card,
                        scoring,
                        false
                    )
                    or 1
                )
        end
    end

    for _, held in ipairs(
        G.hand and G.hand.cards or {}
    ) do
        if held.seal
        and not held.highlighted then
            count = count
                + (
                    JD.calculate_card_triggers
                    and JD.calculate_card_triggers(
                        held,
                        nil,
                        true
                    )
                    or 1
                )
        end
    end

    out.xmult = 1.25 ^ count
end


SPECIAL_X.monochromon =
function(card, e, scoring, out)
    local highest = nil

    for _, playing_card in ipairs(scoring) do
        local rank = rank_of(playing_card)

        if rank
        and (
            not highest
            or rank > highest
        ) then
            highest = rank
        end
    end

    out.mult = highest and highest * 2 or 0
end

SPECIAL_X.gallantmon =
function(card, e, scoring, out)
    local previous =
        type(e.previous_form_value) == 'number'
        and e.previous_form_value
        or 3

    out.xmult = 1
    out.emult = previous / 3
end

SPECIAL_X.magnadramon =
function(card, e, scoring, out)
    local count = count_cards(
        scoring,
        function(c)
            return has_enhancement(c, 'm_glass')
        end,
        false
    )

    out.xmult = 3 ^ count
end


local function target_detail(e)
    local parts = {}

    if e.target_rank and e.target_suit then
        parts[#parts + 1] =
            'Target: '
            .. tostring(rank_name(e.target_rank))
            .. ' of '
            .. tostring(e.target_suit)
    elseif e.target_rank then
        parts[#parts + 1] =
            'Target: '
            .. tostring(rank_name(e.target_rank))
    elseif e.target_suit then
        parts[#parts + 1] =
            'Target: '
            .. tostring(e.target_suit)
    end

    if e.target_hand then
        parts[#parts + 1] =
            'Hand: '
            .. tostring(e.target_hand)
    end

    if type(e.stored_chips) == 'number'
    and e.stored_chips ~= 0 then
        parts[#parts + 1] =
            'Stored: +'
            .. fmt(e.stored_chips)
            .. ' Chips'
    end

    if type(e.stored_xchips) == 'number'
    and e.stored_xchips ~= 1
    and e.stored_xchips ~= 0 then
        parts[#parts + 1] =
            'Stored: X'
            .. fmt(e.stored_xchips)
            .. ' Chips'
    end

    if type(e.sell_rounds) == 'number'
    and e.sell_rounds > 0 then
        parts[#parts + 1] =
            'Sell timer: '
            .. tostring(e.sell_rounds)
            .. ' rounds'
    end

    if type(e.suit_count) == 'number'
    and e.suit_count > 0 then
        parts[#parts + 1] =
            'Progress: '
            .. tostring(e.suit_count)
            .. '/7'
    end

    return table.concat(parts, ' | ')
end

local function care_text(card, e)
    local hunger_max = BM.get_hunger_max
        and BM.get_hunger_max()
        or 5

    local bond_max = BM.get_bond_max
        and BM.get_bond_max(card)
        or 5

    local text =
        'H '
        .. tostring(e.hunger or 1)
        .. '/'
        .. tostring(hunger_max)
        .. '  B '
        .. tostring(e.bond or 0)
        .. '/'
        .. tostring(bond_max)
        .. '  C '
        .. tostring(e.care_mistakes or 0)
        .. '/3'

    if e.permanently_disabled then
        text = text .. '  STARVED'
    end

    return text
end

local function render_values(card, out)
    local values = card.joker_display_values

    values.bm_chips_text =
        out.chips ~= 0
        and ('+' .. fmt(out.chips) .. ' Chips  ')
        or ''

    values.bm_mult_text =
        out.mult ~= 0
        and ('+' .. fmt(out.mult) .. ' Mult  ')
        or ''

    values.bm_xmult_text =
        out.xmult ~= 1
        and ('X' .. fmt(out.xmult) .. ' Mult  ')
        or ''

    values.bm_xchips_text =
        out.xchips ~= 1
        and ('X' .. fmt(out.xchips) .. ' Chips  ')
        or ''

    values.bm_emult_text =
        out.emult ~= 1
        and ('^' .. fmt(out.emult) .. ' Mult  ')
        or ''

    values.bm_emult_chips_text =
        out.emult_chips ~= 1
        and ('^' .. fmt(out.emult_chips) .. ' Chips  ')
        or ''

    values.bm_money_text =
        out.dollars ~= 0
        and ('$' .. fmt(out.dollars))
        or ''
end

local function calculate_display(slug, card)
    local e = safe_extra(card)
    local def = BM.joker_defs
        and BM.joker_defs[slug]
        or {}

    local x_form = is_x_form(card)

    local effect = display_effect_text(
        slug,
        card,
        def.effect or ''
    )

    local _, poker_hands, scoring_hand =
        current_hand()

    local out = output()

    apply_static_effect(
        effect,
        e,
        poker_hands,
        scoring_hand,
        out
    )

    apply_stored_values(
        slug,
        e,
        out,
        x_form
    )

    apply_per_card_effect(
        effect,
        e,
        scoring_hand,
        out
    )

    local special

    if x_form then
        special = SPECIAL_X[slug]
    else
        special = SPECIAL[slug]
    end

    if special then
        special(
            card,
            e,
            scoring_hand,
            out,
            poker_hands
        )
    end

    render_values(card, out)

    card.joker_display_values.bm_detail =
        target_detail(e)

    card.joker_display_values.bm_care =
        care_text(card, e)
end

local RETRIGGER = {}

local function joker_triggers(card)
    return JD.calculate_joker_triggers
        and JD.calculate_joker_triggers(card)
        or 1
end

RETRIGGER.chibomon = function(
    playing_card,
    scoring_hand,
    held_in_hand,
    joker_card
)
    if held_in_hand
    or not scoring_hand
    or #scoring_hand == 0 then
        return 0
    end

    return playing_card == scoring_hand[#scoring_hand]
        and joker_triggers(joker_card)
        or 0
end

RETRIGGER.demiveemon = function(
    playing_card,
    scoring_hand,
    held_in_hand,
    joker_card
)
    if held_in_hand
    or not scoring_hand
    or #scoring_hand == 0 then
        return 0
    end

    return playing_card == scoring_hand[1]
        and joker_triggers(joker_card)
        or 0
end

RETRIGGER.veemon = function(
    playing_card,
    scoring_hand,
    held_in_hand,
    joker_card
)
    if held_in_hand
    or not scoring_hand
    or #scoring_hand == 0 then
        return 0
    end

    return playing_card == scoring_hand[1]
        and 2 * joker_triggers(joker_card)
        or 0
end

RETRIGGER.exveemon = function(
    playing_card,
    scoring_hand,
    held_in_hand,
    joker_card
)
    if held_in_hand then
        return 0
    end

    return is_face(playing_card)
        and joker_triggers(joker_card)
        or 0
end

RETRIGGER.paildramon = function(
    playing_card,
    scoring_hand,
    held_in_hand,
    joker_card
)
    if held_in_hand then
        return 0
    end

    return (
        G.GAME
        and G.GAME.current_round
        and (G.GAME.current_round.hands_left or 0) == 0
    )
        and 2 * joker_triggers(joker_card)
        or 0
end

RETRIGGER.imperialdramon_dragon_mode = function(
    playing_card,
    scoring_hand,
    held_in_hand,
    joker_card
)
    return held_in_hand
        and joker_triggers(joker_card)
        or 0
end

RETRIGGER.imperialdramon_fighter_mode = function(
    playing_card,
    scoring_hand,
    held_in_hand,
    joker_card
)
    return not held_in_hand
        and 2 * joker_triggers(joker_card)
        or 0
end

local function rank_retrigger(ranks, repetitions)
    return function(
        playing_card,
        scoring_hand,
        held_in_hand,
        joker_card
    )
        if held_in_hand then
            return 0
        end

        for _, rank in ipairs(ranks) do
            if card_has_rank(
                playing_card,
                rank
            ) then
                return repetitions
                    * joker_triggers(joker_card)
            end
        end

        return 0
    end
end

RETRIGGER.leafmon = rank_retrigger({9}, 1)
RETRIGGER.minomon = rank_retrigger({7, 4}, 1)
RETRIGGER.wormmon = rank_retrigger({3, 4, 5}, 1)
RETRIGGER.stingmon = rank_retrigger({2, 3, 4, 5, 10}, 2)

RETRIGGER.dinobeemon = function(
    playing_card,
    scoring_hand,
    held_in_hand,
    joker_card
)
    if held_in_hand then
        return 0
    end

    return (
        G.GAME
        and G.GAME.current_round
        and (G.GAME.current_round.hands_played or 0) == 0
    )
        and joker_triggers(joker_card)
        or 0
end

local BLUEPRINT = {}

BLUEPRINT.gekkomon = function(card)
    if not G.jokers then
        return nil
    end

    for i, joker in ipairs(G.jokers.cards or {}) do
        if joker == card then
            return G.jokers.cards[i + 1]
        end
    end
end

BLUEPRINT.troopmon = function(card)
    local first =
        G.jokers
        and G.jokers.cards
        and G.jokers.cards[1]

    if first ~= card then
        return first
    end
end

local function digitamamon_retrigger(
    triggered_card,
    joker_card
)
    local last =
        G.jokers
        and G.jokers.cards
        and G.jokers.cards[#G.jokers.cards]

    if triggered_card
    and triggered_card == last
    and triggered_card ~= joker_card then
        return 2 * joker_triggers(joker_card)
    end

    return 0
end

local function make_definition(slug)
    local definition = {
        text = {
            {
                ref_table = 'card.joker_display_values',
                ref_value = 'bm_chips_text',
                colour = G.C.CHIPS,
            },
            {
                ref_table = 'card.joker_display_values',
                ref_value = 'bm_mult_text',
                colour = G.C.MULT,
            },
            {
                ref_table = 'card.joker_display_values',
                ref_value = 'bm_xmult_text',
                colour = G.C.MULT,
            },
            {
                ref_table = 'card.joker_display_values',
                ref_value = 'bm_xchips_text',
                colour = G.C.CHIPS,
            },
            {
                ref_table = 'card.joker_display_values',
                ref_value = 'bm_emult_text',
                colour = G.C.PURPLE,
            },
            {
                ref_table = 'card.joker_display_values',
                ref_value = 'bm_emult_chips_text',
                colour = G.C.CHIPS,
            },
            {
                ref_table = 'card.joker_display_values',
                ref_value = 'bm_money_text',
                colour = G.C.GOLD,
            },
        },

        reminder_text = {
            {
                ref_table = 'card.joker_display_values',
                ref_value = 'bm_care',
                colour = G.C.UI.TEXT_INACTIVE,
                scale = 0.3,
            },
        },

        extra = {
            {
                {
                    ref_table = 'card.joker_display_values',
                    ref_value = 'bm_detail',
                },
            },
        },

        extra_config = {
            colour = G.C.UI.TEXT_INACTIVE,
            scale = 0.3,
        },

        calc_function = function(card)
            calculate_display(slug, card)
        end,
    }

    if RETRIGGER[slug] then
        definition.retrigger_function =
            RETRIGGER[slug]
    end

    if BLUEPRINT[slug] then
        definition.get_blueprint_joker =
            BLUEPRINT[slug]
    end

    if slug == 'digitamamon' then
        definition.retrigger_joker_function =
            digitamamon_retrigger
    end

    return definition
end

for slug in pairs(BM.joker_defs or {}) do
    local key = BM.center_key(slug)

    if key then
        JD.Definitions[key] =
            make_definition(slug)
    end
end
