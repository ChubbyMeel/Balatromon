local BM = Balatromon

local poke_mod =
    SMODS
    and SMODS.Mods
    and SMODS.Mods['Pokermon']

if not (
    poke_mod
    and poke_mod.can_load
    and pokermon_config
) then
    return
end

if BM._pokermon_compat_loaded then
    return
end

BM._pokermon_compat_loaded = true
BM.pokermon_compat = BM.pokermon_compat or {}

local PC = BM.pokermon_compat

PC.digimon_shop_share = 0.5
PC.hunger_source = 'balatromon_pokermon_hunger'
PC.hunger_max = 5
PC.hunger_rounds = 2

local function registered_center(key)
    return (SMODS.Centers and SMODS.Centers[key])
        or (G.P_CENTERS and G.P_CENTERS[key])
end

function PC.is_pokemon_center(center)
    return center
        and center.set == 'Joker'
        and center.stage ~= nil
        and center.stage ~= 'Other'
end

function PC.is_shop_pokemon_center(center)
    return PC.is_pokemon_center(center)
        and not center.aux_poke
        and center.rarity ~= 'poke_mega'
end

function PC.is_pokemon(card)
    local center =
        card
        and card.config
        and card.config.center

    return PC.is_pokemon_center(center)
end

function PC.is_creature(card)
    return BM.is_digimon(card)
        or PC.is_pokemon(card)
end

local function selected_creatures(max_count)
    local selected = {}

    for _, card in ipairs(
        G.jokers
        and G.jokers.highlighted
        or {}
    ) do
        if PC.is_creature(card) then
            selected[#selected + 1] = card

            if max_count
            and #selected >= max_count then
                break
            end
        end
    end

    return selected
end

local function selected_pokemon(max_count)
    local selected = {}

    for _, card in ipairs(
        G.jokers
        and G.jokers.highlighted
        or {}
    ) do
        if PC.is_pokemon(card) then
            selected[#selected + 1] = card

            if max_count
            and #selected >= max_count then
                break
            end
        end
    end

    return selected
end

function PC.get_hunger(card)
    if not card or not card.ability then
        return 1
    end

    if card.ability.balatromon_hunger == nil then
        card.ability.balatromon_hunger = 1
    end

    return math.max(
        1,
        math.min(
            PC.hunger_max,
            card.ability.balatromon_hunger
        )
    )
end

function PC.sync_hunger_debuff(card)
    if not PC.is_pokemon(card)
    or not card.ability then
        return
    end

    local starving =
        PC.get_hunger(card) >= PC.hunger_max

    local was_starving =
        card.ability.balatromon_starving == true

    card.ability.balatromon_starving = starving

    SMODS.debuff_card(
        card,
        starving,
        PC.hunger_source
    )

    if SMODS.recalc_debuff then
        SMODS.recalc_debuff(card)
    end

    if starving
    and not was_starving
    and BM.care_animation then
        BM.care_animation(
            card,
            'Starving!',
            G.C.RED
        )
    end
end

function PC.feed(card, amount)
    if not PC.is_pokemon(card)
    or not card.ability then
        return
    end

    local old_hunger = PC.get_hunger(card)

    card.ability.balatromon_hunger =
        math.max(
            1,
            old_hunger - (amount or 1)
        )

    PC.sync_hunger_debuff(card)

    if BM.care_animation then
        BM.care_animation(
            card,
            'Fed!',
            G.C.GREEN
        )
    end
end

function PC.tick_hunger(card)
    if not PC.is_pokemon(card)
    or not card.ability then
        return
    end

    local rounds =
        card.ability.balatromon_hunger_rounds
        or 0

    rounds = rounds + 1
    card.ability.balatromon_hunger_rounds = rounds

    if rounds % PC.hunger_rounds == 0 then
        local old_hunger = PC.get_hunger(card)
        local new_hunger = math.min(
            PC.hunger_max,
            old_hunger + 1
        )

        card.ability.balatromon_hunger = new_hunger

        if new_hunger > old_hunger
        and new_hunger < PC.hunger_max
        and BM.care_animation then
            BM.care_animation(
                card,
                'Hungry',
                G.C.RED
            )
        end
    end

    PC.sync_hunger_debuff(card)
end

function PC.tick_all_hunger()
    for _, card in ipairs(
        G.jokers
        and G.jokers.cards
        or {}
    ) do
        if PC.is_pokemon(card) then
            PC.tick_hunger(card)
        end
    end
end

function PC.sync_all_hunger()
    for _, card in ipairs(
        G.jokers
        and G.jokers.cards
        or {}
    ) do
        if PC.is_pokemon(card) then
            PC.sync_hunger_debuff(card)
        end
    end
end

local old_mod_calculate =
    SMODS.current_mod.calculate

SMODS.current_mod.calculate = function(self, context)
    local ret

    if old_mod_calculate then
        ret = old_mod_calculate(self, context)
    end

    if context.setting_blind then
        PC.sync_all_hunger()
    end

    if context.end_of_round
    and context.main_eval
    and not context.blueprint then
        PC.tick_all_hunger()
    end

    return ret
end

if poke_backend_evolve
and not PC._evolution_wrapped then
    PC._evolution_wrapped = true

    local old_poke_backend_evolve =
        poke_backend_evolve

    poke_backend_evolve = function(
        card,
        to_key,
        energize_amount
    )
        local hunger =
            card
            and card.ability
            and card.ability.balatromon_hunger
            or 1

        local hunger_rounds =
            card
            and card.ability
            and card.ability.balatromon_hunger_rounds
            or 0

        local ret = old_poke_backend_evolve(
            card,
            to_key,
            energize_amount
        )

        if card and card.ability then
            card.ability.balatromon_hunger = hunger
            card.ability.balatromon_hunger_rounds = hunger_rounds
            PC.sync_hunger_debuff(card)
        end

        return ret
    end
end

local function normalize_pool(pool, target_size)
    local out = {}

    if type(pool) ~= 'table'
    or #pool == 0
    or target_size <= 0 then
        return out
    end

    for i = 1, target_size do
        out[#out + 1] =
            pool[((i - 1) % #pool) + 1]
    end

    return out
end

local function filter_pokemon_pool(pool)
    local out = {}

    for _, key in ipairs(pool or {}) do
        local center =
            G.P_CENTERS
            and G.P_CENTERS[key]

        if PC.is_shop_pokemon_center(center) then
            out[#out + 1] = key
        end
    end

    return out
end

if get_current_pool
and not PC._shop_pool_wrapped then
    PC._shop_pool_wrapped = true

    local old_get_current_pool =
        get_current_pool

    get_current_pool = function(
        _type,
        _rarity,
        _legendary,
        _append
    )
        if _type == 'Joker'
        and (_append == 'sho' or _append == 'shop') then
            local digimon_pool =
                select(
                    1,
                    old_get_current_pool(
                        _type,
                        _rarity,
                        _legendary,
                        _append
                    )
                )
                or {}

            local pokemon_probe =
                select(
                    1,
                    old_get_current_pool(
                        _type,
                        _rarity,
                        _legendary,
                        'balatromon_pokermon_probe'
                    )
                )
                or {}

            local pokemon_pool =
                filter_pokemon_pool(
                    pokemon_probe
                )

            if #digimon_pool == 0 then
                if #pokemon_pool > 0 then
                    return pokemon_pool,
                        'BalatromonPokermonShop'
                end

                return old_get_current_pool(
                    _type,
                    _rarity,
                    _legendary,
                    _append
                )
            end

            if #pokemon_pool == 0 then
                return digimon_pool,
                    'BalatromonPokermonShop'
            end

            local largest_pool =
                math.max(
                    #digimon_pool,
                    #pokemon_pool
                )

            local total_target =
                largest_pool * 2

            local digimon_target =
                math.max(
                    1,
                    math.floor(
                        total_target
                        * PC.digimon_shop_share
                        + 0.5
                    )
                )

            local pokemon_target =
                math.max(
                    1,
                    total_target - digimon_target
                )

            local mixed = {}

            for _, key in ipairs(
                normalize_pool(
                    digimon_pool,
                    digimon_target
                )
            ) do
                mixed[#mixed + 1] = key
            end

            for _, key in ipairs(
                normalize_pool(
                    pokemon_pool,
                    pokemon_target
                )
            ) do
                mixed[#mixed + 1] = key
            end

            return mixed,
                'BalatromonPokermonShop'
        end

        return old_get_current_pool(
            _type,
            _rarity,
            _legendary,
            _append
        )
    end
end

local function weighted_digimon_key(seed)
    local pool = {}

    for _, entry in ipairs(
        BM.shop_joker_keys or {}
    ) do
        local center =
            G.P_CENTERS
            and G.P_CENTERS[entry.key]

        if center
        and center.balatromon == true then
            local allowed = true

            if center.in_pool then
                local ok = center:in_pool({
                    source = 'crest_pack'
                })

                allowed = ok ~= false
            end

            if allowed then
                local weight = math.max(
                    1,
                    math.floor(
                        entry.weight or 1
                    )
                )

                for _ = 1, weight do
                    pool[#pool + 1] = entry.key
                end
            end
        end
    end

    if #pool == 0 then
        return BM.center_key('botamon')
    end

    return BM.random_element(
        pool,
        seed
    )
end

local function pokemon_center_available(center)
    if not PC.is_shop_pokemon_center(center) then
        return false
    end

    if type(get_gen_allowed) == 'function'
    and not get_gen_allowed(center) then
        return false
    end

    if pokermon_config
    and not pokermon_config.hazards_on
    and center.hazard_poke then
        return false
    end

    if type(poke_family_present) == 'function'
    and poke_family_present(center) then
        return false
    end

    if center.in_pool
    and center:in_pool() == false then
        return false
    end

    if G.GAME
    and G.GAME.banned_keys
    and G.GAME.banned_keys[center.key] then
        return false
    end

    if G.GAME
    and G.GAME.used_jokers
    and G.GAME.used_jokers[center.key]
    and not SMODS.showman(center.key) then
        return false
    end

    if center.enhancement_gate then
        local found = false

        for _, playing_card in ipairs(
            G.playing_cards or {}
        ) do
            if SMODS.has_enhancement(
                playing_card,
                center.enhancement_gate
            ) then
                found = true
                break
            end
        end

        if not found then
            return false
        end
    end

    return true
end

local function random_pokemon_key(seed)
    local pool = {}

    for _, center in ipairs(
        G.P_CENTER_POOLS
        and G.P_CENTER_POOLS.Joker
        or {}
    ) do
        if pokemon_center_available(center) then
            pool[#pool + 1] = center.key
        end
    end

    table.sort(pool)

    if #pool == 0 then
        return nil
    end

    return BM.random_element(
        pool,
        seed
    )
end

local function crest_create_card(
    self,
    card,
    i
)
    local index = i or 1
    local base_seed =
        'balatromon_pokermon_crest_'
        .. tostring(self.key)
        .. '_'
        .. tostring(index)

    local tamer_key =
        BM.roll_crest_tamer
        and BM.roll_crest_tamer(
            'balatromon_crest_tamer_'
            .. tostring(self.key)
            .. '_'
            .. tostring(index)
        )

    if tamer_key then
        return {
            set = 'Tamer',
            area = G.pack_cards,
            key = tamer_key,
            skip_materialize = true,
            soulable = false,
            key_append =
                'balatromon_crest_tamer_'
                .. tostring(index)
        }
    end

    local pokemon =
        pseudorandom(
            pseudoseed(
                base_seed .. '_ecosystem'
            )
        ) >= PC.digimon_shop_share

    local key

    if pokemon then
        key = random_pokemon_key(
            base_seed .. '_pokemon'
        )
    end

    if not key then
        key = weighted_digimon_key(
            base_seed .. '_digimon'
        )
    end

    return {
        set = 'Joker',
        area = G.pack_cards,
        key = key,
        skip_materialize = true,
        soulable = false,
        key_append =
            'balatromon_pokermon_crest_'
            .. tostring(index)
    }
end

local crest_keys = {
    'p_buffoon_normal_1',
    'p_buffoon_normal_2',
    'p_buffoon_jumbo_1',
    'p_buffoon_mega_1'
}

for _, key in ipairs(crest_keys) do
    local center = registered_center(key)

    if center then
        center.create_card = crest_create_card

        if center.loc_txt then
            center.loc_txt.text = {
                'Choose {C:attention}#1#{} of up to',
                '{C:attention}#2#{} {C:attention}Digimon or Pokemon{}',
            }
        end
    end
end

local food = registered_center(
    'c_' .. BM.PREFIX .. '_food'
)

if food
and not PC._food_wrapped then
    PC._food_wrapped = true

    local old_can_use = food.can_use
    local old_use = food.use

    food.can_use = function(self, card)
        local targets = selected_creatures(3)

        if #targets >= 1
        and #targets <= 2 then
            return true
        end

        if old_can_use then
            return old_can_use(self, card)
        end

        return false
    end

    food.use = function(self, card, area, copier)
        local pokemon_targets =
            selected_pokemon(2)

        if old_use then
            old_use(self, card, area, copier)
        end

        for _, target in ipairs(
            pokemon_targets
        ) do
            PC.feed(target, 1)
        end
    end

    if food.loc_txt then
        food.loc_txt.text = {
            'Reduce {C:attention}Hunger{} by {C:attention}1{}',
            'for up to {C:attention}2{} selected Digimon or Pokemon',
            '{C:inactive}Spoils in {C:attention}#1#{C:inactive} turns{}'
        }
    end
end

local hefty_food = registered_center(
    'c_' .. BM.PREFIX .. '_hefty_food'
)

if hefty_food
and not PC._hefty_food_wrapped then
    PC._hefty_food_wrapped = true

    local old_can_use = hefty_food.can_use
    local old_use = hefty_food.use

    hefty_food.can_use = function(self, card)
        local targets = selected_creatures(2)

        if #targets == 1 then
            return true
        end

        if old_can_use then
            return old_can_use(self, card)
        end

        return false
    end

    hefty_food.use = function(self, card, area, copier)
        local pokemon_targets =
            selected_pokemon(1)

        if old_use then
            old_use(self, card, area, copier)
        end

        for _, target in ipairs(
            pokemon_targets
        ) do
            PC.feed(target, 2)
        end
    end

    if hefty_food.loc_txt then
        hefty_food.loc_txt.text = {
            'Reduce {C:attention}Hunger{} by {C:attention}2{}',
            'for {C:attention}1{} selected Digimon or Pokemon',
            '{C:inactive}Spoils in {C:attention}#1#{C:inactive} turns{}'
        }
    end
end

local function random_digimon_center(seed)
    local pool = {}

    for _, center in ipairs(
        G.P_CENTER_POOLS
        and G.P_CENTER_POOLS.Joker
        or {}
    ) do
        if center.balatromon == true then
            pool[#pool + 1] = center
        end
    end

    table.sort(
        pool,
        function(a, b)
            return tostring(a.key)
                < tostring(b.key)
        end
    )

    if #pool == 0 then
        return nil
    end

    return BM.random_element(
        pool,
        seed
    )
end

local function create_negative_food()
    if not G.consumeables then
        return nil
    end

    local key =
        'c_' .. BM.PREFIX .. '_food'

    if not G.P_CENTERS[key] then
        return nil
    end

    return SMODS.add_card {
        set = 'DigiItem',
        area = G.consumeables,
        key = key,
        edition = 'e_negative',
        key_append =
            'balatromon_pokermon_judgement_food'
    }
end

local judgement = registered_center('c_judgement')

if judgement
and not PC._judgement_wrapped then
    PC._judgement_wrapped = true

    judgement.can_use = function(self, card)
        return G.jokers
            and #G.jokers.cards
                < G.jokers.config.card_limit
            and G.consumeables ~= nil
    end

    judgement.use = function(self, card, area, copier)
        local ante =
            G.GAME
            and G.GAME.round_resets
            and G.GAME.round_resets.ante
            or 0

        local seed =
            'balatromon_pokermon_judgement_'
            .. tostring(ante)

        local pokemon =
            pseudorandom(
                pseudoseed(
                    seed .. '_ecosystem'
                )
            ) >= PC.digimon_shop_share

        local key

        if pokemon then
            key = random_pokemon_key(
                seed .. '_pokemon'
            )
        end

        if not key then
            local center =
                random_digimon_center(
                    seed .. '_digimon'
                )

            key = center and center.key
        end

        if key then
            SMODS.add_card {
                set = 'Joker',
                area = G.jokers,
                key = key,
                key_append =
                    'balatromon_pokermon_judgement'
            }
        end

        create_negative_food()
    end

    if judgement.loc_txt then
        judgement.loc_txt.text = {
            'Creates a random {C:attention}Digimon or Pokemon{}',
            'and a {C:dark_edition}Negative{} {C:attention}Food{}',
        }
    end
end

local function pokemon_hunger_bar(card)
    local hunger = PC.get_hunger(card)

    return {
        n = G.UIT.C,
        config = {
            align = 'cm'
        },
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    align = 'cm',
                    padding = 0.06,
                    r = 0.10,
                    minw = 3.45,
                    colour = lighten(G.C.BLACK, 0.15)
                },
                nodes = {
                    BM.care_bar_row(
                        'HUNGER',
                        hunger,
                        PC.hunger_max,
                        'hunger'
                    )
                }
            }
        }
    }
end

local function install_hunger_localization()
    if not G
    or not G.localization
    or not G.localization.descriptions then
        return
    end

    G.localization.descriptions.Other =
        G.localization.descriptions.Other or {}

    SMODS.process_loc_text(
        G.localization.descriptions.Other,
        'balatromon_pokemon_hunger',
        {
            name = 'Hunger',
            text = {
                '{element:1}',
                'At {C:red}5/5{}, this Pokemon is',
                '{C:red}disabled{} until it is fed.'
            }
        }
    )
end

if type(type_tooltip) == 'function'
and not PC._type_tooltip_wrapped then
    PC._type_tooltip_wrapped = true

    local old_type_tooltip = type_tooltip

    type_tooltip = function(self, info_queue, card)
        local ret = old_type_tooltip(
            self,
            info_queue,
            card
        )

        if info_queue
        and card
        and PC.is_pokemon(card)
        and not info_queue._balatromon_hunger_added then
            info_queue._balatromon_hunger_added = true

            local vars = {}
            vars.elements = {
                pokemon_hunger_bar(card)
            }

            info_queue[#info_queue + 1] = {
                set = 'Other',
                key = 'balatromon_pokemon_hunger',
                vars = vars
            }
        end

        return ret
    end
end

local old_process_loc_text =
    SMODS.current_mod.process_loc_text

SMODS.current_mod.process_loc_text = function(self)
    if old_process_loc_text then
        old_process_loc_text(self)
    end

    install_hunger_localization()

    local function refresh_center_loc(key)
        local center =
            G.P_CENTERS
            and G.P_CENTERS[key]

        if not center
        or not center.loc_txt
        or not center.set then
            return
        end

        G.localization.descriptions[center.set] =
            G.localization.descriptions[center.set]
            or {}

        SMODS.process_loc_text(
            G.localization.descriptions[center.set],
            key,
            center.loc_txt
        )
    end

    for _, key in ipairs(crest_keys) do
        refresh_center_loc(key)
    end

    refresh_center_loc(
        'c_' .. BM.PREFIX .. '_food'
    )

    refresh_center_loc(
        'c_' .. BM.PREFIX .. '_hefty_food'
    )

    refresh_center_loc('c_judgement')
end


install_hunger_localization()
