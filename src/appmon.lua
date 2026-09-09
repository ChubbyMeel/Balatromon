local BM = Balatromon

local appmon_save_safe_copy

local function install_appmon_tooltips()
    if not G
    or not G.localization
    or not G.localization.descriptions then
        return
    end

    G.localization.descriptions.Other =
        G.localization.descriptions.Other or {}

    SMODS.process_loc_text(
        G.localization.descriptions.Other,
        'balatromon_linked',
        {
            name = 'Linked',
            text = {
                'The {C:attention}Right Appmon{} is used',
                'to restore the uses of the',
                '{C:attention}Left Appmon{}',
                'Compatible Appmon {C:attention}combine{} instead'
            }
        }
    )
end

function BM.add_linked_tooltip(info_queue)
    if not info_queue then
        return
    end

    info_queue[#info_queue + 1] = {
        set = 'Other',
        key = 'balatromon_linked'
    }
end

local old_appmon_process_loc_text =
    SMODS.current_mod.process_loc_text

SMODS.current_mod.process_loc_text = function(self)
    if old_appmon_process_loc_text then
        old_appmon_process_loc_text(self)
    end

    install_appmon_tooltips()
end

install_appmon_tooltips()

BM.APPMON_LOADER_SLOTS = BM.APPMON_LOADER_SLOTS or 2
BM.APPMON_USE_COUNT = BM.APPMON_USE_COUNT or 3
BM.APPMON_SHOP_RATE = BM.APPMON_SHOP_RATE or 0.7
BM.APPMON_BABY_COST = BM.APPMON_BABY_COST or 3
BM.APPMON_STANDARD_COST = BM.APPMON_STANDARD_COST or 4

BM.APPMON_STAGES = BM.APPMON_STAGES or {
    'Baby',
    'Standard',
    'Super',
    'Ultimate',
    'God'
}

BM.APPMON_NEXT_STAGE = BM.APPMON_NEXT_STAGE or {
    Baby = 'Standard',
    Standard = 'Super',
    Super = 'Ultimate',
    Ultimate = 'God'
}

BM.APPMON_SHOP_ATTRIBUTES = BM.APPMON_SHOP_ATTRIBUTES or {
    Social = true,
    Navi = true,
    Game = true,
    Tool = true,
    System = false,
    Entertainment = false,
    Life = false
}

BM.APPMON_BASE_BY_ATTRIBUTE = BM.APPMON_BASE_BY_ATTRIBUTE or {
    Social = {'gatchmon'},
    Navi = {'navimon'},
    Game = {'onmon'},
    Tool = {'timemon', 'craftmon'},
    System = {},
    Entertainment = {},
    Life = {}
}

BM.appmon_combinations = BM.appmon_combinations or {}

BM.APPMON_SUPER_COST = BM.APPMON_SUPER_COST or 5

function BM.ensure_appmon_shop_rate()
    if not G or not G.GAME then
        return
    end

    local rate = tonumber(G.GAME.appmon_rate)
    if rate == nil then
        G.GAME.appmon_rate = BM.APPMON_SHOP_RATE
    else
        G.GAME.appmon_rate = rate
    end
end

appmon_save_safe_copy = function(value, path, active, removed)
    local value_type = type(value)

    if value_type == 'nil'
    or value_type == 'boolean'
    or value_type == 'number'
    or value_type == 'string' then
        return value, true
    end

    if value_type ~= 'table' then
        removed[#removed + 1] = tostring(path) .. ' [' .. value_type .. ']'
        return nil, false
    end

    active = active or {}
    if active[value] then
        removed[#removed + 1] = tostring(path) .. ' [cycle]'
        return nil, false
    end

    active[value] = true
    local clean = {}

    for key, child in pairs(value) do
        local key_type = type(key)
        if key_type == 'string' or key_type == 'number' or key_type == 'boolean' then
            local child_path = tostring(path) .. '[' .. tostring(key) .. ']'
            local clean_child, keep = appmon_save_safe_copy(child, child_path, active, removed)
            if keep then
                clean[key] = clean_child
            end
        else
            removed[#removed + 1] = tostring(path) .. '[<key:' .. key_type .. '>]'
        end
    end

    active[value] = nil
    return clean, true
end

function BM.sanitize_pending_run_save()
    if not G
    or not G.ARGS
    or type(G.ARGS.save_run) ~= 'table' then
        return 0
    end

    local removed = {}
    local clean = appmon_save_safe_copy(G.ARGS.save_run, '$', {}, removed)

    G.ARGS.save_run = clean
    G.culled_table = clean
    BM.last_save_sanitized_paths = removed

    if #removed > 0 then
        print('[Balatromon/Appmon] Removed ' .. tostring(#removed) .. ' unsupported value(s) from the run save payload:')
        for i = 1, math.min(#removed, 20) do
            print('[Balatromon/Appmon]   ' .. tostring(removed[i]))
        end
        if #removed > 20 then
            print('[Balatromon/Appmon]   ... and ' .. tostring(#removed - 20) .. ' more')
        end
    end

    return #removed
end

local function merge_legacy_appmon_loader_save(args)
    if not args or not args.savetext or not args.savetext.cardAreas then
        return
    end

    local card_areas = args.savetext.cardAreas
    local legacy_loader = card_areas.appmon_loader
    if not legacy_loader then
        return
    end

    local joker_save = card_areas.jokers
    if joker_save and type(legacy_loader.cards) == 'table' then
        joker_save.cards = joker_save.cards or {}
        for _, saved_card in ipairs(legacy_loader.cards) do
            joker_save.cards[#joker_save.cards + 1] = saved_card
        end
    end

    card_areas.appmon_loader = nil
end

if not BM._appmon_v12_save_run_guard_installed and type(save_run) == 'function' then
    local old_save_run = save_run
    save_run = function(...)
        local result = old_save_run(...)

        if G and G.ARGS and type(G.ARGS.save_run) == 'table' and G.ARGS.save_run.cardAreas then
            G.ARGS.save_run.cardAreas.appmon_loader = nil
        end

        if G and G.FILE_HANDLER and G.FILE_HANDLER.run then
            BM.sanitize_pending_run_save()
        end
        return result
    end
    BM._appmon_v12_save_run_guard_installed = true
end

if not BM._appmon_v12_game_update_save_guard_installed and Game and type(Game.update) == 'function' then
    local old_game_update = Game.update
    Game.update = function(self, dt, ...)
        BM.ensure_appmon_shop_rate()

        if G and G.FILE_HANDLER and G.FILE_HANDLER.run then
            if G.ARGS and type(G.ARGS.save_run) == 'table' and G.ARGS.save_run.cardAreas then
                G.ARGS.save_run.cardAreas.appmon_loader = nil
            end
            BM.sanitize_pending_run_save()
        end

        local result = old_game_update(self, dt, ...)
        if BM.update_onmon_state then
            BM.update_onmon_state()
        end

        if BM.cleanup_exhausted_appmon and not (G and G.OVERLAY_MENU) then
            BM.cleanup_exhausted_appmon()
        end

        return result
    end
    BM._appmon_v12_game_update_save_guard_installed = true
end

if not BM._appmon_v12_start_run_rate_guard_installed and Game and type(Game.start_run) == 'function' then
    local old_appmon_start_run = Game.start_run
    Game.start_run = function(self, args, ...)
        args = args or {}
        merge_legacy_appmon_loader_save(args)

        local result = old_appmon_start_run(self, args, ...)

        BM.ensure_appmon_shop_rate()



        if G and G.appmon_loader then
            if not G.appmon_loader.REMOVED and G.appmon_loader.remove then
                G.appmon_loader:remove()
            end
            G.appmon_loader = nil
        end

        if BM.rebalance_appmon_loader then
            BM.rebalance_appmon_loader()
        end

        if G and G.E_MANAGER and Event then
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.05,
                func = function()
                    if BM.rebalance_appmon_loader then
                        BM.rebalance_appmon_loader()
                    end
                    if BM.cleanup_exhausted_appmon and not (G and G.OVERLAY_MENU) then
                        BM.cleanup_exhausted_appmon()
                    end
                    return true
                end
            })
        end

        return result
    end
    BM._appmon_v12_start_run_rate_guard_installed = true
end

local ATTRIBUTE_DEFS = {
    Social = HEX('27C7E6'),
    Navi = HEX('39B54A'),
    Game = HEX('F47A37'),
    Tool = HEX('8D3FD1'),
    System = HEX('F2D62E'),
    Entertainment = HEX('E43B31'),
    Life = HEX('E25AC8')
}

for attribute, colour in pairs(ATTRIBUTE_DEFS) do
    BM.register_attribute(attribute, {
        badge_colour = colour
    })
end

SMODS.ConsumableType {
    key = 'Appmon',
    primary_colour = HEX('27C7E6'),
    secondary_colour = HEX('243447'),
    loc_txt = {
        name = 'Appmon',
        collection = 'Appmon',
        undiscovered = {
            name = 'Unknown Appmon',
            text = {'Discover this Appmon during a run'}
        }
    },
    collection_rows = {5, 5, 5},
    shop_rate = BM.APPMON_SHOP_RATE,
    default = 'c_' .. BM.PREFIX .. '_tapmon_social'
}

local function center_from_source(source)
    if not source then
        return nil
    end

    if source.config and source.config.center then
        return source.config.center
    end

    return source
end

function BM.is_appmon(source)
    local center = center_from_source(source)
    return center and center.balatromon_appmon == true or false
end

function BM.get_appmon_stage(source)
    local center = center_from_source(source)
    return center and center.appmon_stage or nil
end

function BM.get_appmon_attribute(source)
    return BM.get_attribute(source)
end

function BM.is_base_appmon(source)
    local center = center_from_source(source)
    return center and center.appmon_base == true or false
end

function BM.appmon_center_key(slug)
    return 'c_' .. BM.PREFIX .. '_' .. tostring(slug)
end

local function combination_key(left, right)
    local a = type(left) == 'table' and center_from_source(left) and center_from_source(left).key or tostring(left or '')
    local b = type(right) == 'table' and center_from_source(right) and center_from_source(right).key or tostring(right or '')

    if a > b then
        a, b = b, a
    end

    return a .. '|' .. b
end

function BM.register_appmon_combination(left, right, result, args)
    if not left or not right or not result then
        return nil
    end

    local route = {
        left = left,
        right = right,
        result = result,
        args = args or {}
    }

    BM.appmon_combinations[combination_key(left, right)] = route
    return route
end

function BM.get_appmon_combination(left, right)
    return BM.appmon_combinations[combination_key(left, right)]
end

function BM.can_appmon_combine(left, right)
    return BM.get_appmon_combination(left, right) ~= nil
end

local function count_appmon_in_area(area)
    local count = 0

    for _, card in ipairs(area and area.cards or {}) do
        if BM.is_appmon(card) then
            count = count + 1
        end
    end

    return count
end

local function appmon_count()
    return count_appmon_in_area(G and G.jokers)
end

function BM.count_appmon_in_jokers()
    return count_appmon_in_area(G and G.jokers)
end

function BM.get_loader_limit()
    return BM.APPMON_LOADER_SLOTS
end

function BM.get_loader_slots_used()
    return math.min(appmon_count(), BM.get_loader_limit())
end

local function applied_loader_bonus_total()
    local total = 0

    for _, card in ipairs(G and G.jokers and G.jokers.cards or {}) do
        if BM.is_appmon(card) and card.ability then
            total = total + (tonumber(card.ability.balatromon_loader_bonus) or 0)
        end
    end

    return total
end

function BM.get_regular_joker_limit()
    if not G or not G.jokers or not G.jokers.config then
        return 0
    end

    return math.max(
        0,
        (tonumber(G.jokers.config.card_limit) or 0) - applied_loader_bonus_total()
    )
end

function BM.get_regular_joker_slots_used()
    local physical = #(G and G.jokers and G.jokers.cards or {})
    return math.max(0, physical - BM.get_loader_slots_used())
end

local function refresh_loader_ui()
    BM.loader_ui_state = BM.loader_ui_state or {}
    BM.loader_ui_state.text = tostring(BM.get_loader_slots_used()) .. '/' .. tostring(BM.get_loader_limit())
end

function BM.sync_loader_slots()
    if BM.rebalance_appmon_loader then
        BM.rebalance_appmon_loader()
    else
        refresh_loader_ui()
    end
end

local function remove_legacy_loader_area()
    if G and G.appmon_loader then
        if not G.appmon_loader.REMOVED and G.appmon_loader.remove then
            G.appmon_loader:remove()
        end
        G.appmon_loader = nil
    end
end

function BM.position_appmon_loader()
    remove_legacy_loader_area()
end

function BM.ensure_appmon_loader()
    remove_legacy_loader_area()
    return G and G.jokers or nil
end

function BM.attach_appmon_loader_to_pending_save()
    if G
    and G.ARGS
    and type(G.ARGS.save_run) == 'table'
    and G.ARGS.save_run.cardAreas then
        G.ARGS.save_run.cardAreas.appmon_loader = nil
    end
end

local function strip_loader_bonus(card)
    if not card or not card.ability then
        return
    end

    local old_bonus = tonumber(card.ability.balatromon_loader_bonus) or 0
    if old_bonus ~= 0 then
        card.ability.card_limit = (tonumber(card.ability.card_limit) or 0) - old_bonus
    end
    card.ability.balatromon_loader_bonus = 0
end

local function set_loader_bonus(card, desired_bonus)
    if not card or not card.ability then
        return false
    end

    desired_bonus = tonumber(desired_bonus) or 0

    local old_bonus = tonumber(card.ability.balatromon_loader_bonus) or 0
    if old_bonus == desired_bonus then
        return false
    end

    local current_limit = tonumber(card.ability.card_limit) or 0
    card.ability.card_limit = current_limit - old_bonus + desired_bonus
    card.ability.balatromon_loader_bonus = desired_bonus
    return true
end

function BM.rebalance_appmon_loader()
    if BM._appmon_loader_rebalancing
    or not G
    or not G.jokers
    or not G.jokers.cards then
        return
    end

    remove_legacy_loader_area()
    BM._appmon_loader_rebalancing = true

    local loader_index = 0
    local changed = false

    for _, card in ipairs(G.jokers.cards) do
        if BM.is_appmon(card) then
            loader_index = loader_index + 1
            local desired_bonus = loader_index <= BM.get_loader_limit() and 1 or 0
            if set_loader_bonus(card, desired_bonus) then
                changed = true
            end
        end
    end

    if G.jokers.handle_card_limit then
        G.jokers:handle_card_limit()
    elseif changed and G.jokers.config then
        print('[Balatromon/Appmon] Steamodded CardArea:handle_card_limit is unavailable; Loader slots require a newer Steamodded build.')
    end

    BM._appmon_loader_rebalancing = false
    refresh_loader_ui()
end

local function incoming_native_card_limit(card)
    if not card or not card.ability then
        return 0
    end

    local value = (tonumber(card.ability.card_limit) or 0)
        - (tonumber(card.ability.balatromon_loader_bonus) or 0)

    if value == 0
    and card.edition
    and card.edition.negative then
        value = 1
    end

    return value
end

function BM.can_add_appmon(card)
    if not G or not G.jokers or not G.jokers.config then
        return false
    end

    BM.rebalance_appmon_loader()

    local loader_bonus = appmon_count() < BM.get_loader_limit() and 1 or 0
    local incoming_limit = incoming_native_card_limit(card) + loader_bonus

    return #G.jokers.cards < (tonumber(G.jokers.config.card_limit) or 0) + incoming_limit
end

local function ensure_loader_counter()
    if not G or not G.jokers or not UIBox then
        return
    end

    refresh_loader_ui()

    if BM._loader_counter_area ~= G.jokers then
        if BM.loader_counter_box and BM.loader_counter_box.remove then
            BM.loader_counter_box:remove()
        end

        BM.loader_counter_box = nil
        BM._loader_counter_area = G.jokers
    end

    if BM.loader_counter_box and not BM.loader_counter_box.REMOVED then
        return
    end

    BM.loader_counter_box = UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = {
                align = 'cm',
                colour = G.C.CLEAR
            },
            nodes = {
                {
                    n = G.UIT.R,
                    config = {
                        align = 'cm',
                        r = 0.08,
                        padding = 0.04,
                        colour = G.C.UI.TRANSPARENT_DARK
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = 'Loader ',
                                scale = 0.27,
                                colour = G.C.UI.TEXT_INACTIVE,
                                shadow = true
                            }
                        },
                        {
                            n = G.UIT.T,
                            config = {
                                ref_table = BM.loader_ui_state,
                                ref_value = 'text',
                                scale = 0.31,
                                colour = G.C.UI.TEXT_LIGHT,
                                shadow = true
                            }
                        }
                    }
                }
            }
        },
        config = {
            align = 'bri',
            offset = {x = 0.18, y = 0.48},
            major = G.jokers,
            bond = 'Weak'
        }
    }
end

local function discard_failed_appmon_spawn(card)
    if not card then
        return nil
    end

    if card.area and card.area.remove_card and card.area.cards then
        for i = #card.area.cards, 1, -1 do
            if card.area.cards[i] == card then
                card.area:remove_card(card)
                break
            end
        end
    end

    strip_loader_bonus(card)
    card.area = nil

    if card.remove then
        card:remove()
    else
        card.REMOVED = true
    end

    return nil
end

local function finish_appmon_emplace(card)
    if card and BM.is_appmon(card) and BM.get_appmon_stage(card) == 'Baby' then
        BM.appmon_digivolve_baby(card)
    end

    BM.rebalance_appmon_loader()
    return card
end

local base_cardarea_emplace = CardArea.emplace
local base_cardarea_remove_card = CardArea.remove_card

local function area_contains(area, card)
    for _, candidate in ipairs(area and area.cards or {}) do
        if candidate == card then
            return true
        end
    end
    return false
end

function CardArea:emplace(card, location, stay_flipped)
    local is_appmon = BM.is_appmon(card)

    if not BM._appmon_loader_rebalancing
    and G
    and G.jokers
    and is_appmon
    and (self == G.consumeables or self == G.jokers) then
        local already_in_jokers = area_contains(G.jokers, card)

        if not already_in_jokers and not BM.can_add_appmon(card) then
            if alert_no_space then
                alert_no_space(card, G.jokers)
            end
            return discard_failed_appmon_spawn(card)
        end

        local result = base_cardarea_emplace(G.jokers, card, location, stay_flipped)
        finish_appmon_emplace(card)
        return result
    end

    local result = base_cardarea_emplace(self, card, location, stay_flipped)

    if G and self == G.jokers then
        refresh_loader_ui()
    end

    return result
end

function CardArea:remove_card(card, discarded_only)
    local was_appmon = G and self == G.jokers and BM.is_appmon(card)
    local result = base_cardarea_remove_card(self, card, discarded_only)

    if was_appmon then
        strip_loader_bonus(card)

        if not BM._appmon_loader_rebalancing then
            BM.rebalance_appmon_loader()
        end
    elseif G and self == G.jokers then
        refresh_loader_ui()
    end

    return result
end

local base_cardarea_draw = CardArea.draw
function CardArea:draw(...)
    local result = base_cardarea_draw(self, ...)

    if G and self == G.jokers then
        refresh_loader_ui()
        ensure_loader_counter()

        if BM.loader_counter_box
        and not BM.loader_counter_box.REMOVED
        and BM.loader_counter_box.draw then
            BM.loader_counter_box:draw()
        end
    end

    return result
end

if Card and type(Card.set_ability) == 'function' and not BM._appmon_v12_set_ability_hook then
    local old_card_set_ability = Card.set_ability

    function Card:set_ability(...)
        local in_jokers = G and self.area == G.jokers
        local was_appmon = BM.is_appmon(self)

        if in_jokers and was_appmon then
            strip_loader_bonus(self)
        end

        local result = old_card_set_ability(self, ...)

        if in_jokers and BM.is_appmon(self) and not BM._appmon_loader_rebalancing then
            BM.rebalance_appmon_loader()
        end

        return result
    end

    BM._appmon_v12_set_ability_hook = true
end

if Card and type(Card.set_edition) == 'function' and not BM._appmon_v12_set_edition_hook then
    local old_card_set_edition = Card.set_edition

    function Card:set_edition(...)
        local in_jokers = G and self.area == G.jokers
        local is_appmon = BM.is_appmon(self)

        if in_jokers and is_appmon then
            strip_loader_bonus(self)
        end

        local result = old_card_set_edition(self, ...)

        if in_jokers and BM.is_appmon(self) and not BM._appmon_loader_rebalancing then
            BM.rebalance_appmon_loader()
        end

        return result
    end

    BM._appmon_v12_set_edition_hook = true
end

local old_check_for_buy_space = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card, ...)
    if BM.is_appmon(card) then
        if BM.can_add_appmon(card) then
            return true
        end

        alert_no_space(card, G.jokers)
        return false
    end

    return old_check_for_buy_space(card, ...)
end

local function initialise_appmon_uses(card)
    if not card or not BM.is_appmon(card) then
        return
    end

    if BM.get_appmon_stage(card) == 'Baby' then
        return
    end

    card.ability.extra = card.ability.extra or {}
    card.ability.extra.max_uses = card.ability.extra.max_uses or BM.APPMON_USE_COUNT
    card.ability.extra.uses = card.ability.extra.uses or card.ability.extra.max_uses

end


function BM.can_timemon_undo()
    if not BM.timemon_last_action then
        return false
    end

    if G.STATE ~= G.STATES.SELECTING_HAND then
        return false
    end

    if BM.timemon_last_action == 'play' then
        return G.GAME.current_round.hands_left >= 0
    end

    if BM.timemon_last_action == 'discard' then
        return G.GAME.current_round.discards_left >= 0
    end

    return false
end

function BM.use_timemon(card)
    local action = BM.timemon_last_action

    if action ~= 'play'
    and action ~= 'discard' then
        return false
    end

    initialise_appmon_uses(card)

    BM.timemon_last_action = nil

    card.ability.extra.uses = math.max(
        0,
        (card.ability.extra.uses or BM.APPMON_USE_COUNT) - 1
    )

    if card.ability.extra.uses <= 0 then
        card._bm_appmon_remove_at =
            (G.TIMERS.REAL or 0) + 0.6
    end

    if action == 'play' then
        ease_hands_played(1)

        card_eval_status_text(
            card,
            'extra',
            nil,
            nil,
            nil,
            {
                message = '+1 Hand',
                colour = G.C.BLUE
            }
        )

    elseif action == 'discard' then
        ease_discard(1)

        card_eval_status_text(
            card,
            'extra',
            nil,
            nil,
            nil,
            {
                message = '+1 Discard',
                colour = G.C.RED
            }
        )
    end

    card:juice_up(0.8, 0.5)

    return true
end

function BM.appmon_digivolve_baby(card)
    if not card
    or not BM.is_appmon(card)
    or BM.get_appmon_stage(card) ~= 'Baby' then
        return false
    end

    local attribute = BM.get_attribute(card)
    local candidates = attribute and BM.APPMON_BASE_BY_ATTRIBUTE[attribute] or {}

    local valid = {}

    for _, slug in ipairs(candidates or {}) do
        local key = BM.appmon_center_key(slug)

        if G.P_CENTERS[key] then
            valid[#valid + 1] = slug
        end
    end

    if #valid == 0 then
        return false
    end

    local target_slug = BM.random_element(
        valid,
        'appmon_base_'
            .. tostring(attribute)
            .. '_'
            .. tostring(card.sort_id or 0)
    )

    local target_key = BM.appmon_center_key(target_slug)
    local target = G.P_CENTERS[target_key]

    if not target then
        return false
    end

    card:juice_up(0.8, 0.5)
    card:set_ability(target, nil, true)

    initialise_appmon_uses(card)

    card:set_cost()

    if card_eval_status_text then
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = target.name or target_slug
        })
    end

    BM.sync_loader_slots()

    return true
end

local old_buy_from_shop = G.FUNCS.buy_from_shop
G.FUNCS.buy_from_shop = function(e, ...)
    local card = e and e.config and e.config.ref_table

    if not BM.is_appmon(card) then
        return old_buy_from_shop(e, ...)
    end

    if e.config.id == 'buy_and_use' then
        return false
    end

    if not BM.can_add_appmon(card) then
        alert_no_space(card, G.jokers)
        e.disable_button = nil
        return false
    end

    local was_consumeable = card.ability.consumeable
    card.ability.consumeable = false

    local result = old_buy_from_shop(e, ...)

    G.E_MANAGER:add_event(Event {
        trigger = 'after',
        delay = 0.12,
        func = function()
            if card and not card.REMOVED then
                card.ability.consumeable = was_consumeable
                BM.appmon_digivolve_baby(card)
                initialise_appmon_uses(card)
                BM.sync_loader_slots()
            end
            return true
        end
    })

    return result
end

local old_card_focus_ui = G.UIDEF.card_focus_ui
G.UIDEF.card_focus_ui = function(card, ...)
    local ui = old_card_focus_ui(card, ...)

    if BM.is_appmon(card)
    and card.area == G.jokers
    and card.ability.consumeable
    and ui
    and ui.get_UIE_by_ID then
        local attach = ui:get_UIE_by_ID('ATTACH_TO_ME')

        if attach and not attach.children.use then
            attach.children.use = G.UIDEF.card_focus_button {
                card = card,
                parent = attach,
                type = 'use',
                func = 'can_use_consumeable',
                button = 'use_card',
                card_width = card.T.w - 0.1
            }
        end
    end

    return ui
end

local function appmon_stage_badge(self, card, badges)
    badges[#badges + 1] = create_badge(
        self.appmon_stage or 'Appmon',
        G.C.SECONDARY_SET and G.C.SECONDARY_SET.Appmon or HEX('243447'),
        G.C.WHITE,
        1
    )
end

local function baby_in_pool(self)
    local attribute = self.attribute

    if BM.APPMON_SHOP_ATTRIBUTES[attribute] ~= true then
        return false
    end

    for _, slug in ipairs(BM.APPMON_BASE_BY_ATTRIBUTE[attribute] or {}) do
        if G.P_CENTERS[BM.appmon_center_key(slug)] then
            return true
        end
    end

    return false
end

local function baby_loc_vars(self)
    return {
        vars = {
            self.attribute or 'Unknown'
        }
    }
end

local baby_names = {
    {name = 'Tapmon', slug = 'tapmon', y = 0},
    {name = 'Flickmon', slug = 'flickmon', y = 1},
    {name = 'Swipemon', slug = 'swipemon', y = 2}
}

local attribute_order = {
    'Social',
    'Navi',
    'Game',
    'Tool',
    'System',
    'Entertainment',
    'Life'
}

for _, baby in ipairs(baby_names) do
    for index, attribute in ipairs(attribute_order) do
        SMODS.Consumable {
            set = 'Appmon',
            key = baby.slug .. '_' .. string.lower(attribute),
            atlas = 'Appmon',
            pos = {x = (index - 1) * 2, y = baby.y},
            soul_atlas = 'Appmon',
            soul_pos = {x = (index - 1) * 2 + 1, y = baby.y},
            discovered = false,
            unlocked = true,
            cost = BM.APPMON_BABY_COST,
            attribute = attribute,
            balatromon_appmon = true,
            appmon_stage = 'Baby',
            in_pool = baby_in_pool,
            set_badges = appmon_stage_badge,
            loc_txt = {
                name = baby.name,
                text = {
                    'When bought, digivolves into',
                    'a {C:attention}Base{} Appmon with',
                    'the {C:attention}#1#{} Attribute'
                }
            },
            loc_vars = baby_loc_vars,
            can_use = function()
                return false
            end
        }
    end
end

local function uses_remaining(card)
    if not card then
        return BM.APPMON_USE_COUNT
    end

    initialise_appmon_uses(card)
    return card.ability
        and card.ability.extra
        and card.ability.extra.uses
        or BM.APPMON_USE_COUNT
end

function BM.get_appmon_uses(card)
    return uses_remaining(card)
end

function BM.get_appmon_max_uses(card)
    initialise_appmon_uses(card)

    return card
        and card.ability
        and card.ability.extra
        and card.ability.extra.max_uses
        or BM.APPMON_USE_COUNT
end

function BM.refill_appmon_uses(card)
    if not card or not BM.is_appmon(card) then
        return false
    end

    initialise_appmon_uses(card)

    card.ability.extra.uses =
        card.ability.extra.max_uses
        or BM.APPMON_USE_COUNT

    card:juice_up(0.5, 0.5)

    return true
end

local function remove_exhausted_appmon(card)
    if not card or card.REMOVED or not BM.is_appmon(card) then
        return false
    end

    if card._bm_appmon_remove_at
    and (G.TIMERS.REAL or 0) < card._bm_appmon_remove_at then
        return false
    end

    if not card.ability
    or not card.ability.extra
    or tonumber(card.ability.extra.uses) == nil
    or tonumber(card.ability.extra.uses) > 0 then
        return false
    end

    local area = card.area

    if area and area.remove_from_highlighted then
        area:remove_from_highlighted(card)
    end

    if area and area.remove_card and area_contains(area, card) then
        area:remove_card(card)
    end

    if card.start_dissolve then
        card:start_dissolve()
    elseif card.remove then
        card:remove()
    else
        card.REMOVED = true
    end

    return true
end

function BM.cleanup_exhausted_appmon()
    if BM._appmon_exhausted_cleanup_busy
    or not G
    or not G.jokers
    or not G.jokers.cards then
        return
    end

    BM._appmon_exhausted_cleanup_busy = true

    local exhausted = {}
    for _, candidate in ipairs(G.jokers.cards) do
        if BM.is_appmon(candidate)
        and BM.get_appmon_stage(candidate) ~= 'Baby'
        and candidate.ability
        and candidate.ability.extra
        and tonumber(candidate.ability.extra.uses) ~= nil
        and tonumber(candidate.ability.extra.uses) <= 0 then
            exhausted[#exhausted + 1] = candidate
        end
    end

    for _, candidate in ipairs(exhausted) do
        remove_exhausted_appmon(candidate)
    end

    BM._appmon_exhausted_cleanup_busy = false
end

local function consume_appmon_use(card)
    initialise_appmon_uses(card)

    card.ability.extra.uses = math.max(
        0,
        (card.ability.extra.uses or BM.APPMON_USE_COUNT) - 1
    )

    if card.ability.extra.uses <= 0 then
        card._bm_appmon_remove_at =
            (G.TIMERS.REAL or 0) + 0.6
    end
end

local function keep_appmon_on_use(self, card)
    return true
end

function BM.combine_appmon(left, right)
    if not left
    or not right
    or not BM.is_appmon(left)
    or not BM.is_appmon(right) then
        return false
    end

    local route = BM.get_appmon_combination(left, right)

    if not route then
        return false
    end

    local target_key = route.result

    if not G.P_CENTERS[target_key] then
        target_key = BM.appmon_center_key(route.result)
    end

    local target = G.P_CENTERS[target_key]

    if not target then
        return false
    end

    left:juice_up(0.8, 0.5)
    right:juice_up(0.8, 0.5)

    left:set_ability(target, nil, true)

    initialise_appmon_uses(left)

    left.ability.extra.uses =
        left.ability.extra.max_uses
        or BM.APPMON_USE_COUNT

    left:set_cost()

    if right.area == G.jokers then
        G.jokers:remove_card(right)
    end

    right:start_dissolve()

    BM.rebalance_appmon_loader()

    if card_eval_status_text then
        card_eval_status_text(left, 'extra', nil, nil, nil, {
            message = target.name or 'Combined!'
        })
    end

    return true
end

local function appmon_card_name(card)
    if not card then
        return 'Unknown card'
    end

    local rank = card.base and card.base.value or '?'
    local suit = card.base and card.base.suit or '?'
    local center = card.config and card.config.center
    local enhancement = center and center.name

    if center and G.P_CENTERS and center ~= G.P_CENTERS.c_base
    and enhancement and enhancement ~= 'Base' and enhancement ~= 'Default Base' then
        return tostring(rank) .. ' of ' .. tostring(suit) .. ' (' .. tostring(enhancement) .. ')'
    end

    return tostring(rank) .. ' of ' .. tostring(suit)
end

local function open_text_overlay(title, subtitle, rows)
    local contents = {
        {
            n = G.UIT.R,
            config = {align = 'cm', padding = 0.05},
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        text = title,
                        scale = 0.58,
                        colour = G.C.UI.TEXT_LIGHT,
                        shadow = true
                    }
                }
            }
        },
        {
            n = G.UIT.R,
            config = {align = 'cm', padding = 0.03},
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        text = subtitle,
                        scale = 0.3,
                        colour = G.C.UI.TEXT_INACTIVE
                    }
                }
            }
        }
    }

    for _, row in ipairs(rows) do
        contents[#contents + 1] = row
    end

    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu {
        definition = create_UIBox_generic_options {
            back_func = 'exit_overlay_menu',
            contents = contents
        }
    }
end

local AppmonPreviewSprite = Sprite:extend()

local GatchmonCardPreview = Moveable:extend()

function GatchmonCardPreview:init(source)
    local w = G.CARD_W * 0.82
    local h = G.CARD_H * 0.82

    Moveable.init(self, 0, 0, w, h)

    self.source = source
    self.children = {}
    self.states.drag.can = false
    self.states.click.can = false
    self.states.hover.can = false
    self.states.collide.can = false
    self.created_on_pause = true
    self.hover_tilt = 0
    self.tilt_var = {mx = 0, my = 0, dx = 0, dy = 0, amt = 0}
    self.dissolve = 0

    local source_center = source and source.children and source.children.center
    local source_front = source and source.children and source.children.front

    if source_center and source_center.atlas and source_center.sprite_pos then
        self.children.center = AppmonPreviewSprite(
            0,
            0,
            w,
            h,
            source_center.atlas,
            {x = source_center.sprite_pos.x, y = source_center.sprite_pos.y}
        )
    else
        local center = source and source.config and source.config.center or G.P_CENTERS.c_base
        local atlas = G.ASSET_ATLAS[(center and center.atlas) or 'centers'] or G.ASSET_ATLAS.centers
        local pos = center and center.pos or {x = 0, y = 0}
        self.children.center = AppmonPreviewSprite(0, 0, w, h, atlas, pos)
    end

    if source_front and source_front.atlas and source_front.sprite_pos then
        self.children.front = AppmonPreviewSprite(
            0,
            0,
            w,
            h,
            source_front.atlas,
            {x = source_front.sprite_pos.x, y = source_front.sprite_pos.y}
        )
    end

    for _, child in pairs(self.children) do
        child.states.drag.can = false
        child.states.click.can = false
        child.states.hover.can = false
        child.states.collide.can = false
        child.states.visible = true
        child.role.draw_major = self
        child.created_on_pause = true
    end

    self:hard_set_T(0, 0, w, h)
end

function GatchmonCardPreview:hard_set_T(x, y, w, h)
    x = x or self.T.x
    y = y or self.T.y
    w = w or self.T.w
    h = h or self.T.h

    Moveable.hard_set_T(self, x, y, w, h)

    for _, child in pairs(self.children or {}) do
        child:hard_set_T(x, y, w, h)
        child:hard_set_VT()
    end
end

function GatchmonCardPreview:draw()
    if not self.states.visible then
        return
    end

    self:hard_set_T(self.VT.x, self.VT.y, self.VT.w, self.VT.h)

    local center = self.children and self.children.center
    local front = self.children and self.children.front
    local source = self.source
    local edition = source and source.edition

    if center then
        if edition and edition.negative then
            center:draw_shader('negative', nil, nil, true)
        else
            center:draw_shader('dissolve', nil, nil, true)
        end
    end

    if front and not (source and source.ability and source.ability.effect == 'Stone Card') then
        if edition and edition.negative then
            front:draw_shader('negative', nil, nil, true)
        else
            front:draw_shader('dissolve', nil, nil, true)
        end
    end

    if edition then
        local shader = edition.holo and 'holo'
            or edition.foil and 'foil'
            or edition.polychrome and 'polychrome'

        if shader then
            if center then
                center:draw_shader(shader, nil, nil, true)
            end
            if front and not (source and source.ability and source.ability.effect == 'Stone Card') then
                front:draw_shader(shader, nil, nil, true)
            end
        end
    end

    if source and source.seal and G.shared_seals and G.shared_seals[source.seal] and center then
        local seal = G.shared_seals[source.seal]
        seal.role.draw_major = self
        seal:draw_shader('dissolve', nil, nil, true, center)
    end
end

function GatchmonCardPreview:remove()
    for _, child in pairs(self.children or {}) do
        if child and child.remove and not child.REMOVED then
            child:remove()
        end
    end
    self.children = {}
    Moveable.remove(self)
end

local function gatchmon_preview_column(label, source)
    local preview = GatchmonCardPreview(source)

    return {
        n = G.UIT.C,
        config = {align = 'cm', padding = 0.10, minw = 1.8},
        nodes = {
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.03},
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = label,
                            scale = 0.3,
                            colour = G.C.UI.TEXT_INACTIVE
                        }
                    }
                }
            },
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.04},
                nodes = {
                    {
                        n = G.UIT.O,
                        config = {
                            object = preview,
                            can_collide = false
                        }
                    }
                }
            },
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.02},
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = appmon_card_name(source),
                            scale = 0.26,
                            colour = G.C.UI.TEXT_LIGHT
                        }
                    }
                }
            }
        }
    }
end

function BM.open_gatchmon_peek()
    local deck = G.deck and G.deck.cards or {}
    local first = deck[#deck]
    local second = deck[#deck - 1]
    local columns = {}

    if first then
        columns[#columns + 1] = gatchmon_preview_column('Next draw', first)
    end

    if second then
        columns[#columns + 1] = gatchmon_preview_column('Then', second)
    end

    local rows

    if #columns > 0 then
        rows = {
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.05},
                nodes = columns
            }
        }
    else
        rows = {
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.05},
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = 'Your deck is empty.',
                            scale = 0.36,
                            colour = G.C.UI.TEXT_INACTIVE
                        }
                    }
                }
            }
        }
    end

    open_text_overlay('Gatchmon', 'Top 2 cards of your deck', rows)
end

local NAVIMON_RANKS = {
    'Any', '2', '3', '4', '5', '6', '7', '8', '9', '10',
    'Jack', 'Queen', 'King', 'Ace'
}

local NAVIMON_SUITS = {
    'Any', 'Spades', 'Hearts', 'Clubs', 'Diamonds'
}

BM.navimon_scan_state = BM.navimon_scan_state or {
    rank = 'Any',
    suit = 'Any',
    result = 'Choose a rank and/or suit, then scan.',
    scanned = false
}

G.FUNCS.balatromon_navimon_rank = function(args)
    if args and args.to_val then
        BM.navimon_scan_state.rank = args.to_val
        if not BM.navimon_scan_state.scanned then
            BM.navimon_scan_state.result = 'Choose a rank and/or suit, then scan.'
        end
    end
end

G.FUNCS.balatromon_navimon_suit = function(args)
    if args and args.to_val then
        BM.navimon_scan_state.suit = args.to_val
        if not BM.navimon_scan_state.scanned then
            BM.navimon_scan_state.result = 'Choose a rank and/or suit, then scan.'
        end
    end
end

local function navimon_matches(card, rank, suit)
    if not card or not card.base then
        return false
    end

    local rank_ok = rank == 'Any' or tostring(card.base.value) == tostring(rank)
    local suit_ok = suit == 'Any' or tostring(card.base.suit) == tostring(suit)
    return rank_ok and suit_ok
end

local function navimon_query_name(rank, suit)
    if rank ~= 'Any' and suit ~= 'Any' then
        return tostring(rank) .. ' of ' .. tostring(suit)
    elseif rank ~= 'Any' then
        return 'rank ' .. tostring(rank)
    elseif suit ~= 'Any' then
        return tostring(suit)
    end

    return 'a matching card'
end

G.FUNCS.balatromon_navimon_scan = function(e)
    local state = BM.navimon_scan_state
    if state.scanned then
        return
    end

    if state.rank == 'Any' and state.suit == 'Any' then
        state.result = 'Choose at least one rank or suit.'
        return
    end

    local deck = G.deck and G.deck.cards or {}
    local found_distance
    local found_card

    for distance = 1, #deck do
        local card = deck[#deck - distance + 1]
        if navimon_matches(card, state.rank, state.suit) then
            found_distance = distance
            found_card = card
            break
        end
    end

    local query = navimon_query_name(state.rank, state.suit)
    if found_distance then
        if found_distance == 1 then
            state.result = 'Next draw matches ' .. query .. ': ' .. appmon_card_name(found_card)
        else
            state.result = tostring(found_distance) .. ' draws until ' .. query
                .. ' (' .. tostring(found_distance - 1) .. ' cards before it)'
        end
    else
        state.result = 'No ' .. query .. ' remains in your deck.'
    end

    state.scanned = true
end

function BM.open_navimon_scan()
    BM.navimon_scan_state.rank = 'Any'
    BM.navimon_scan_state.suit = 'Any'
    BM.navimon_scan_state.result = 'Choose a rank and/or suit, then scan.'
    BM.navimon_scan_state.scanned = false

    local rows = {
        {
            n = G.UIT.R,
            config = {align = 'cm', padding = 0.04},
            nodes = {
                {
                    n = G.UIT.C,
                    config = {align = 'cm'},
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {align = 'cm', padding = 0.015},
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = 'Rank',
                                        scale = 0.32,
                                        colour = G.C.UI.TEXT_INACTIVE,
                                        shadow = true
                                    }
                                }
                            }
                        },
                        {
                            n = G.UIT.R,
                            config = {align = 'cm'},
                            nodes = {
                                create_option_cycle {
                                    label = '',
                                    options = NAVIMON_RANKS,
                                    current_option = 1,
                                    opt_callback = 'balatromon_navimon_rank',
                                    w = 3.4,
                                    scale = 0.72,
                                    no_pips = true
                                }
                            }
                        }
                    }
                }
            }
        },
        {
            n = G.UIT.R,
            config = {align = 'cm', padding = 0.04},
            nodes = {
                {
                    n = G.UIT.C,
                    config = {align = 'cm'},
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {align = 'cm', padding = 0.015},
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = 'Suit',
                                        scale = 0.32,
                                        colour = G.C.UI.TEXT_INACTIVE,
                                        shadow = true
                                    }
                                }
                            }
                        },
                        {
                            n = G.UIT.R,
                            config = {align = 'cm'},
                            nodes = {
                                create_option_cycle {
                                    label = '',
                                    options = NAVIMON_SUITS,
                                    current_option = 1,
                                    opt_callback = 'balatromon_navimon_suit',
                                    w = 3.4,
                                    scale = 0.72,
                                    no_pips = true
                                }
                            }
                        }
                    }
                }
            }
        },
        {
            n = G.UIT.R,
            config = {align = 'cm', padding = 0.08},
            nodes = {
                UIBox_button {
                    label = {'Scan'},
                    button = 'balatromon_navimon_scan',
                    minw = 2.6,
                    minh = 0.65,
                    scale = 0.4,
                    colour = G.C.BLUE
                }
            }
        },
        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.06,
                minw = 6.2,
                minh = 0.7,
                r = 0.08,
                colour = G.C.UI.TRANSPARENT_DARK
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        ref_table = BM.navimon_scan_state,
                        ref_value = 'result',
                        scale = 0.3,
                        colour = G.C.UI.TEXT_LIGHT,
                        shadow = true
                    }
                }
            }
        }
    }

    open_text_overlay(
        'Navimon',
        'Find the next card matching a rank, suit, or both',
        rows
    )
end

BM.onmon_state = BM.onmon_state or {
    armed = false,
    active = false
}

function BM.arm_onmon()
    BM.onmon_state = {
        armed = true,
        active = false
    }

    card_eval_status_text(
        G.GAME.blind,
        'extra',
        nil,
        nil,
        nil,
        {
            message = 'Next action protected!'
        }
    )
end

function BM.begin_onmon_action(action)
    local state = BM.onmon_state

    if not state
    or not state.armed
    or not G.GAME
    or not G.GAME.blind
    or not G.GAME.blind.boss then
        return
    end

    local blind = G.GAME.blind

    state.armed = false
    state.active = true
    state.action = action

    state.blind = blind
    state.definition = blind.config.blind

    state.chips = blind.chips
    state.dollars = blind.dollars
    state.sound_pings = blind.sound_pings

    state.hands = copy_table(blind.hands)
    state.only_hand = blind.only_hand
    state.prepped = blind.prepped
    state.triggered = blind.triggered

    state.start_hands =
        G.GAME.current_round.hands_played or 0

    state.start_discards =
        G.GAME.current_round.discards_used or 0

    blind:disable()
end

function BM.restore_onmon_blind()
    local state = BM.onmon_state

    if not state
    or not state.active then
        return
    end

    local blind = state.blind

    if not blind
    or blind ~= G.GAME.blind then
        BM.onmon_state = {
            armed = false,
            active = false
        }

        return
    end

    blind:set_blind(
        state.definition,
        false,
        true
    )

    blind.chips = state.chips
    blind.chip_text = number_format(state.chips)

    blind.dollars = state.dollars
    blind.sound_pings = state.sound_pings

    blind.hands = state.hands
    blind.only_hand = state.only_hand
    blind.prepped = state.prepped
    blind.triggered = state.triggered

    blind:set_text()

    for _, playing_card in ipairs(G.playing_cards or {}) do
        blind:debuff_card(playing_card)
    end

    for _, joker in ipairs(G.jokers and G.jokers.cards or {}) do
        blind:debuff_card(joker)
    end

    BM.onmon_state = {
        armed = false,
        active = false
    }
end

function BM.update_onmon_state()
    local state = BM.onmon_state

    if not state
    or not state.active then
        return
    end

    if G.GAME.blind ~= state.blind then
        BM.onmon_state = {
            armed = false,
            active = false
        }

        return
    end

    local round = G.GAME.current_round

    local action_finished = false

    if state.action == 'play' then
        action_finished =
            (round.hands_played or 0)
            > state.start_hands
    elseif state.action == 'discard' then
        action_finished =
            (round.discards_used or 0)
            > state.start_discards
    end

    if action_finished then
        state.restore_at =
            state.restore_at
            or ((G.TIMERS.REAL or 0) + 0.25)
    end

    if state.restore_at
    and (G.TIMERS.REAL or 0) >= state.restore_at
    and G.STATE == G.STATES.SELECTING_HAND then
        BM.restore_onmon_blind()
    end
end

function BM.capture_timemon_snapshot(action)
    if action ~= 'play' and action ~= 'discard' then
        return
    end

    BM.timemon_last_action = action
end

local old_appmon_play_cards =
    G.FUNCS.play_cards_from_highlighted



G.FUNCS.play_cards_from_highlighted =
function(e, ...)
    if BM.capture_timemon_snapshot then
        BM.capture_timemon_snapshot('play')
    end

    if BM.begin_onmon_action then
        BM.begin_onmon_action('play')
    end

    return old_appmon_play_cards(e, ...)
end


local old_appmon_discard_cards =
    G.FUNCS.discard_cards_from_highlighted

G.FUNCS.discard_cards_from_highlighted =
function(e, hook, ...)
    if not hook then
        if BM.capture_timemon_snapshot then
            BM.capture_timemon_snapshot('discard')
        end

        if BM.begin_onmon_action then
            BM.begin_onmon_action('discard')
        end
    end

    return old_appmon_discard_cards(
        e,
        hook,
        ...
    )
end



local function craftmon_boss_pool()
    local pool = {}

    for key, blind in pairs(G.P_BLINDS or {}) do
        if blind
        and blind.boss then
            pool[#pool + 1] = {
                key = key,
                blind = blind
            }
        end
    end

    table.sort(pool, function(a, b)
        return a.key < b.key
    end)

    return pool
end

function BM.apply_craftmon_blind()
    if not G.GAME
    or not G.GAME.blind then
        return nil
    end

    local current = G.GAME.blind
    local old_reward = current.dollars or 0

    local pool = craftmon_boss_pool()

    if #pool == 0 then
        return nil
    end

    local chosen =
        BM.random_element(
            pool,
            'craftmon_'
                .. tostring(G.GAME.round_resets.ante)
                .. '_'
                .. tostring(G.GAME.current_round.hands_played or 0)
        )

    if not chosen then
        return nil
    end

    current:set_blind(
        chosen.blind,
        false,
        true
    )

    current.dollars = old_reward * 2
    current.sound_pings = current.dollars + 2

    current:set_text()

    return chosen.blind
end

local DOGATCHMON_RANKS = {
    '2', '3', '4', '5', '6', '7', '8', '9', '10',
    'Jack', 'Queen', 'King', 'Ace'
}

BM.dogatchmon_state = BM.dogatchmon_state or {
    rank = '2',
    result = 'Choose a rank.',
    card = nil,
    submitted = false
}

G.FUNCS.balatromon_dogatchmon_rank = function(args)
    if args and args.to_val then
        BM.dogatchmon_state.rank = args.to_val
        BM.dogatchmon_state.result = 'Choose a rank.'
    end
end

G.FUNCS.balatromon_dogatchmon_draw = function(e)
    local state = BM.dogatchmon_state

    if state.submitted
    or not state.card
    or state.card.REMOVED
    or uses_remaining(state.card) <= 0
    or not G.deck then
        return
    end

    local targets = {}

    for i = #G.deck.cards, 1, -1 do
        local target = G.deck.cards[i]

        if target
        and target.base
        and tostring(target.base.value) == tostring(state.rank) then
            targets[#targets + 1] = target

            if #targets >= 2 then
                break
            end
        end
    end

    if #targets == 0 then
        state.result = 'No ' .. tostring(state.rank) .. ' remains in your deck.'
        return
    end

    state.submitted = true

    consume_appmon_use(state.card)

    G.FUNCS.exit_overlay_menu()

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,

        func = function()
            for i, target in ipairs(targets) do
                draw_card(
                    G.deck,
                    G.hand,
                    i * 100 / #targets,
                    'up',
                    true,
                    target,
                    0.08
                )
            end

            return true
        end
    }))
end

function BM.open_dogatchmon_draw(card)
    BM.dogatchmon_state.rank = '2'
    BM.dogatchmon_state.result = 'Choose a rank.'
    BM.dogatchmon_state.card = card
    BM.dogatchmon_state.submitted = false

    local rows = {
        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.04
            },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        align = 'cm'
                    },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {
                                align = 'cm',
                                padding = 0.015
                            },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = 'Rank',
                                        scale = 0.32,
                                        colour = G.C.UI.TEXT_INACTIVE,
                                        shadow = true
                                    }
                                }
                            }
                        },
                        {
                            n = G.UIT.R,
                            config = {
                                align = 'cm'
                            },
                            nodes = {
                                create_option_cycle {
                                    label = '',
                                    options = DOGATCHMON_RANKS,
                                    current_option = 1,
                                    opt_callback = 'balatromon_dogatchmon_rank',
                                    w = 3.4,
                                    scale = 0.72,
                                    no_pips = true
                                }
                            }
                        }
                    }
                }
            }
        },

        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.08
            },
            nodes = {
                UIBox_button {
                    label = {'Draw'},
                    button = 'balatromon_dogatchmon_draw',
                    minw = 2.6,
                    minh = 0.65,
                    scale = 0.4,
                    colour = G.C.BLUE
                }
            }
        },

        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.06,
                minw = 6.2,
                minh = 0.7,
                r = 0.08,
                colour = G.C.UI.TRANSPARENT_DARK
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        ref_table = BM.dogatchmon_state,
                        ref_value = 'result',
                        scale = 0.3,
                        colour = G.C.UI.TEXT_LIGHT,
                        shadow = true
                    }
                }
            }
        }
    }

    open_text_overlay(
        'Dogatchmon',
        'Draw 2 cards of a selected rank',
        rows
    )
end

SMODS.Consumable {
    set = 'Appmon',
    key = 'gatchmon',
    atlas = 'Appmon',
    pos = {x = 0, y = 3},
    soul_atlas = 'Appmon',
    soul_pos = {x = 1, y = 3},
    discovered = false,
    unlocked = true,
    cost = BM.APPMON_STANDARD_COST,
    attribute = 'Social',
    balatromon_appmon = true,
    appmon_stage = 'Standard',
    appmon_next_stage = 'Super',
    appmon_base = true,
    config = {
        extra = {
            uses = BM.APPMON_USE_COUNT,
            max_uses = BM.APPMON_USE_COUNT
        }
    },
    in_pool = function()
        return false
    end,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Gatchmon',
        text = {
            'Peek at the next {C:attention}2{} cards',
            'on top of your deck',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                uses_remaining(card),
                card and card.ability and card.ability.extra and card.ability.extra.max_uses or BM.APPMON_USE_COUNT
            }
        }
    end,
    can_use = function(self, card)
        return uses_remaining(card) > 0 and G.deck and #G.deck.cards > 0
    end,
    use = function(self, card)
        consume_appmon_use(card)
        BM.open_gatchmon_peek()
    end,
    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'navimon',
    atlas = 'Appmon',
    pos = {x = 2, y = 3},
    soul_atlas = 'Appmon',
    soul_pos = {x = 3, y = 3},
    discovered = false,
    unlocked = true,
    cost = BM.APPMON_STANDARD_COST,
    attribute = 'Navi',
    balatromon_appmon = true,
    appmon_stage = 'Standard',
    appmon_next_stage = 'Super',
    appmon_base = true,
    config = {
        extra = {
            uses = BM.APPMON_USE_COUNT,
            max_uses = BM.APPMON_USE_COUNT
        }
    },
    in_pool = function()
        return false
    end,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Navimon',
        text = {
            'Choose a {C:attention}rank{}, {C:attention}suit{}, or both',
            'to see how many draws until a match',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                uses_remaining(card),
                card and card.ability and card.ability.extra and card.ability.extra.max_uses or BM.APPMON_USE_COUNT
            }
        }
    end,
    can_use = function(self, card)
        return uses_remaining(card) > 0 and G.deck and #G.deck.cards > 0
    end,
    use = function(self, card)
        consume_appmon_use(card)
        BM.open_navimon_scan()
    end,
    keep_on_use = keep_appmon_on_use
}

BM.register_appmon_combination(
    BM.appmon_center_key('gatchmon'),
    BM.appmon_center_key('navimon'),
    BM.appmon_center_key('dogatchmon')
)

SMODS.Consumable {
    set = 'Appmon',
    key = 'onmon',

    atlas = 'Appmon',
    pos = {x = 4, y = 3},

    soul_atlas = 'Appmon',
    soul_pos = {x = 5, y = 3},

    discovered = false,
    unlocked = true,

    cost = BM.APPMON_STANDARD_COST,

    attribute = 'Game',

    balatromon_appmon = true,
    appmon_base = true,
    appmon_stage = 'Standard',
    appmon_next_stage = 'Super',

    config = {
        extra = {
            uses = BM.APPMON_USE_COUNT,
            max_uses = BM.APPMON_USE_COUNT
        }
    },

    in_pool = function()
        return false
    end,

    set_badges = appmon_stage_badge,

    loc_txt = {
        name = 'Onmon',
        text = {
            'Disable the current {C:attention}Boss Blind{}',
            'for the next {C:attention}hand or discard{}',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                uses_remaining(card),
                BM.get_appmon_max_uses(card)
            }
        }
    end,

    can_use = function(self, card)
        return uses_remaining(card) > 0
            and G.GAME
            and G.GAME.blind
            and G.GAME.blind.boss
            and not G.GAME.blind.disabled
            and not (
                BM.onmon_state
                and (
                    BM.onmon_state.armed
                    or BM.onmon_state.active
                )
            )
    end,

    use = function(self, card)
        consume_appmon_use(card)
        BM.arm_onmon()
    end,

    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'timemon',

    atlas = 'Appmon',
    pos = {x = 6, y = 3},

    soul_atlas = 'Appmon',
    soul_pos = {x = 7, y = 3},

    discovered = false,
    unlocked = true,

    cost = BM.APPMON_STANDARD_COST,

    attribute = 'Tool',

    balatromon_appmon = true,
    appmon_base = true,
    appmon_stage = 'Standard',
    appmon_next_stage = 'Super',

    config = {
        extra = {
            uses = BM.APPMON_USE_COUNT,
            max_uses = BM.APPMON_USE_COUNT
        }
    },

    in_pool = function()
        return false
    end,

    set_badges = appmon_stage_badge,

    loc_txt = {
        name = 'Timemon',
        text = {
            'Regain {C:attention}1 Hand{} if your',
            'last action was a {C:attention}Play{},',
            'or regain {C:attention}1 Discard{} if',
            'your last action was a {C:attention}Discard{}',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                uses_remaining(card),
                BM.get_appmon_max_uses(card)
            }
        }
    end,

    can_use = function(self, card)
        return uses_remaining(card) > 0
            and BM.can_timemon_undo()
    end,

    use = function(self, card)
        BM.use_timemon(card)
    end,

    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'craftmon',

    atlas = 'Appmon',
    pos = {x = 6, y = 4},

    soul_atlas = 'Appmon',
    soul_pos = {x = 7, y = 4},

    discovered = false,
    unlocked = true,

    cost = BM.APPMON_SUPER_COST,

    attribute = 'Tool',

    balatromon_appmon = true,
    appmon_base = true,
    appmon_stage = 'Super',
    appmon_next_stage = 'Ultimate',

    config = {
        extra = {
            uses = BM.APPMON_USE_COUNT,
            max_uses = BM.APPMON_USE_COUNT
        }
    },

    in_pool = function()
        return false
    end,

    set_badges = appmon_stage_badge,

    loc_txt = {
        name = 'Craftmon',
        text = {
            'Apply a random {C:attention}Boss Blind{}',
            'effect to the current Blind',
            'and {C:money}double{} its reward',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                uses_remaining(card),
                BM.get_appmon_max_uses(card)
            }
        }
    end,

    can_use = function(self, card)
        return uses_remaining(card) > 0
            and G.GAME
            and G.GAME.blind
            and G.GAME.blind.name ~= ''
    end,

    use = function(self, card)
        consume_appmon_use(card)

        local blind = BM.apply_craftmon_blind()

        if blind and card_eval_status_text then
            card_eval_status_text(
                card,
                'extra',
                nil,
                nil,
                nil,
                {
                    message = blind.name or 'Boss Effect!'
                }
            )
        end
    end,

    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'dogatchmon',

    atlas = 'Appmon',
    pos = {x = 0, y = 4},

    soul_atlas = 'Appmon',
    soul_pos = {x = 1, y = 4},

    discovered = false,
    unlocked = true,

    cost = BM.APPMON_SUPER_COST,

    attribute = 'Social',

    balatromon_appmon = true,
    appmon_base = false,
    appmon_stage = 'Super',
    appmon_next_stage = 'Ultimate',

    config = {
        extra = {
            uses = BM.APPMON_USE_COUNT,
            max_uses = BM.APPMON_USE_COUNT
        }
    },

    in_pool = function()
        return false
    end,

    set_badges = appmon_stage_badge,

    loc_txt = {
        name = 'Dogatchmon',
        text = {
            'Choose a {C:attention}rank{} and draw',
            'up to {C:attention}2{} cards of that rank',
            'from your deck into your hand',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                uses_remaining(card),
                card
                    and card.ability
                    and card.ability.extra
                    and card.ability.extra.max_uses
                    or BM.APPMON_USE_COUNT
            }
        }
    end,

    can_use = function(self, card)
        return uses_remaining(card) > 0
            and G.deck
            and #G.deck.cards > 0
    end,

    use = function(self, card)
        BM.open_dogatchmon_draw(card)
    end,

    keep_on_use = keep_appmon_on_use
}
