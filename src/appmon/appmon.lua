local BM = Balatromon

BM.APPMON_LOADER_SLOTS = BM.APPMON_LOADER_SLOTS or 2
BM.APPMON_USE_COUNT = BM.APPMON_USE_COUNT or 3
BM.APPMON_SHOP_RATE = BM.APPMON_SHOP_RATE or 0.7
BM.APPMON_BABY_COST = BM.APPMON_BABY_COST or 3
BM.APPMON_STANDARD_COST = BM.APPMON_STANDARD_COST or 4
BM.APPMON_SUPER_COST = BM.APPMON_SUPER_COST or 5
BM.APPMON_ULTIMATE_COST = BM.APPMON_ULTIMATE_COST or 6
BM.APPMON_GOD_COST = BM.APPMON_GOD_COST or 7

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
    System = true,
    Entertainment = true,
    Life = true
}

BM.APPMON_BASE_BY_ATTRIBUTE = BM.APPMON_BASE_BY_ATTRIBUTE or {
    Social = {'gatchmon'},
    Navi = {'navimon'},
    Game = {'onmon', 'offmon'},
    Tool = {'timemon', 'craftmon'},
    System = {'hackmon'},
    Entertainment = {'perorimon'},
    Life = {'virusmon'}
}

BM.appmon_combinations = BM.appmon_combinations or {}

local function merge_legacy_appmon_loader_save(args)
    local card_areas = args and args.savetext and args.savetext.cardAreas
    local loader = card_areas and card_areas.appmon_loader
    if not loader then return end

    local jokers = card_areas.jokers
    if jokers and loader.cards then
        jokers.cards = jokers.cards or {}
        for _, card in ipairs(loader.cards) do
            jokers.cards[#jokers.cards + 1] = card
        end
    end

    card_areas.appmon_loader = nil
end

local function remove_legacy_loader_area()
    if not G.appmon_loader then return end
    if not G.appmon_loader.REMOVED then G.appmon_loader:remove() end
    G.appmon_loader = nil
end

local game_update = Game.update
function Game:update(dt, ...)
    local result = game_update(self, dt, ...)
    BM.update_onmon_state()
    if not G.OVERLAY_MENU then BM.cleanup_exhausted_appmon() end
    return result
end

function BM.prepare_appmon_run(args)
    merge_legacy_appmon_loader_save(args)
    return args
end

function BM.finish_appmon_run()
    G.GAME.appmon_rate = G.GAME.appmon_rate or BM.APPMON_SHOP_RATE
    remove_legacy_loader_area()
    BM.rebalance_appmon_loader()

    G.E_MANAGER:add_event(Event {
        trigger = 'after',
        delay = 0.05,
        func = function()
            BM.rebalance_appmon_loader()
            if not G.OVERLAY_MENU then BM.cleanup_exhausted_appmon() end
            return true
        end
    })
end

local ATTRIBUTE_DEFS = {
    Social = HEX('27C7E6'),
    Navi = HEX('39B54A'),
    Game = HEX('F47A37'),
    Tool = HEX('8D3FD1'),
    System = HEX('F2D62E'),
    Entertainment = HEX('E43B31'),
    Life = HEX('E25AC8'),
    God = HEX('F6C945')
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
    if source and source.config and source.config.center then
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
    return center and center.appmon_stage
end

function BM.get_appmon_attribute(source)
    return BM.get_attribute(source)
end

function BM.is_base_appmon(source)
    local center = center_from_source(source)
    return center and center.appmon_base == true or false
end

function BM.appmon_center_key(slug)
    return 'c_' .. BM.PREFIX .. '_' .. slug
end

function BM.localized_object_name(source, set_override, key_override, fallback)
    local object = center_from_source(source)
    local key = key_override or (object and object.key)
    local set = set_override or (object and object.set)

    if key and set then
        local name = localize {type = 'name_text', set = set, key = key}
        if name and name ~= 'ERROR' then return name end
    end

    if object and object.loc_txt and object.loc_txt.name then return object.loc_txt.name end
    if object and object.name then return object.name end
    return fallback or key or 'Unknown'
end

function BM.localized_blind_name(blind, fallback)
    return BM.localized_object_name(blind, 'Blind', blind and blind.key or fallback, fallback)
end

local function combination_key(left, right)
    local left_center = type(left) == 'table' and center_from_source(left)
    local right_center = type(right) == 'table' and center_from_source(right)
    local a = tostring(left_center and left_center.key or left or '')
    local b = tostring(right_center and right_center.key or right or '')

    if a > b then a, b = b, a end
    return a .. '|' .. b
end

function BM.register_appmon_combination(left, right, result, args)
    local route = {left = left, right = right, result = result, args = args or {}}
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

function BM.has_appmon_voucher(slug)
    if not G.GAME then return false end
    local key = 'v_' .. BM.PREFIX .. '_' .. slug
    return G.GAME['balatromon_' .. slug] == true or G.GAME.used_vouchers and G.GAME.used_vouchers[key] == true
end

function BM.get_loader_limit()
    return BM.APPMON_LOADER_SLOTS + (BM.has_appmon_voucher('appli_driver') and 1 or 0)
end

function BM.get_loader_slots_used()
    return math.min(appmon_count(), BM.get_loader_limit())
end

local function applied_loader_bonus_total()
    if not G.jokers then return 0 end
    local total = 0
    for _, card in ipairs(G.jokers.cards) do
        if BM.is_appmon(card) then
            total = total + (card.ability.balatromon_loader_bonus or 0)
        end
    end
    return total
end

function BM.get_regular_joker_limit()
    if not G.jokers then return 0 end
    return math.max(0, G.jokers.config.card_limit - applied_loader_bonus_total())
end

function BM.get_regular_joker_slots_used()
    if not G.jokers then return 0 end
    return math.max(0, #G.jokers.cards - BM.get_loader_slots_used())
end

local function refresh_loader_ui()
    BM.loader_ui_state = BM.loader_ui_state or {}
    BM.loader_ui_state.text = BM.get_loader_slots_used() .. '/' .. BM.get_loader_limit()
end

function BM.sync_loader_slots()
    BM.rebalance_appmon_loader()
end

local function strip_loader_bonus(card)
    if not card.ability then return end
    local bonus = card.ability.balatromon_loader_bonus or 0
    if bonus ~= 0 then card.ability.card_limit = (card.ability.card_limit or 0) - bonus end
    card.ability.balatromon_loader_bonus = 0
end

local function set_loader_bonus(card, bonus)
    if not card.ability then return end
    local old_bonus = card.ability.balatromon_loader_bonus or 0
    if old_bonus == bonus then return end
    card.ability.card_limit = (card.ability.card_limit or 0) - old_bonus + bonus
    card.ability.balatromon_loader_bonus = bonus
end

function BM.rebalance_appmon_loader()
    if BM._appmon_loader_rebalancing or not G.jokers then return end

    remove_legacy_loader_area()
    BM._appmon_loader_rebalancing = true

    local loader_index = 0
    local loader_limit = BM.get_loader_limit()
    for _, card in ipairs(G.jokers.cards) do
        if BM.is_appmon(card) then
            loader_index = loader_index + 1
            set_loader_bonus(card, loader_index <= loader_limit and 1 or 0)
        end
    end

    G.jokers:handle_card_limit()
    BM._appmon_loader_rebalancing = false
    refresh_loader_ui()
end

local function incoming_card_limit(card)
    local limit = (card.ability.card_limit or 0) - (card.ability.balatromon_loader_bonus or 0)
    if limit == 0 and card.edition and card.edition.negative then return 1 end
    return limit
end

function BM.can_add_appmon(card)
    if not G.jokers then return false end
    BM.rebalance_appmon_loader()

    local loader_bonus = appmon_count() < BM.get_loader_limit() and 1 or 0
    return #G.jokers.cards < G.jokers.config.card_limit + incoming_card_limit(card) + loader_bonus
end

local function ensure_loader_counter()
    refresh_loader_ui()

    if BM._loader_counter_area ~= G.jokers then
        if BM.loader_counter_box then BM.loader_counter_box:remove() end
        BM.loader_counter_box = nil
        BM._loader_counter_area = G.jokers
    end

    if BM.loader_counter_box and not BM.loader_counter_box.REMOVED then return end

    BM.loader_counter_box = UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = {align = 'cm', colour = G.C.CLEAR},
            nodes = {
                {
                    n = G.UIT.R,
                    config = {align = 'cm', r = 0.08, padding = 0.04, colour = G.C.UI.TRANSPARENT_DARK},
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

local function area_contains(area, card)
    for _, other in ipairs(area.cards) do
        if other == card then return true end
    end
    return false
end

local function discard_failed_appmon_spawn(card)
    if card.area and area_contains(card.area, card) then card.area:remove_card(card) end
    strip_loader_bonus(card)
    card.area = nil
    card:remove()
end

local function finish_appmon_emplace(card)
    if BM.get_appmon_stage(card) == 'Baby' then BM.appmon_digivolve_baby(card) end
    BM.rebalance_appmon_loader()
end

local cardarea_emplace = CardArea.emplace
local cardarea_remove_card = CardArea.remove_card
local cardarea_draw = CardArea.draw

function CardArea:emplace(card, location, stay_flipped)
    if not BM._appmon_loader_rebalancing
    and G.jokers
    and BM.is_appmon(card)
    and (self == G.consumeables or self == G.jokers) then
        if not area_contains(G.jokers, card) and not BM.can_add_appmon(card) then
            alert_no_space(card, G.jokers)
            discard_failed_appmon_spawn(card)
            return
        end

        local result = cardarea_emplace(G.jokers, card, location, stay_flipped)
        finish_appmon_emplace(card)
        return result
    end

    local result = cardarea_emplace(self, card, location, stay_flipped)
    if self == G.jokers then refresh_loader_ui() end
    return result
end

function CardArea:remove_card(card, discarded_only)
    local was_appmon = self == G.jokers and BM.is_appmon(card)
    local result = cardarea_remove_card(self, card, discarded_only)

    if was_appmon then
        strip_loader_bonus(card)
        if not BM._appmon_loader_rebalancing then BM.rebalance_appmon_loader() end
    elseif self == G.jokers then
        refresh_loader_ui()
    end

    return result
end

function CardArea:draw(...)
    local result = cardarea_draw(self, ...)
    if self == G.jokers then
        refresh_loader_ui()
        ensure_loader_counter()
        if BM.loader_counter_box and not BM.loader_counter_box.REMOVED then BM.loader_counter_box:draw() end
    end
    return result
end

local card_set_ability = Card.set_ability
function Card:set_ability(...)
    local in_jokers = self.area == G.jokers
    if in_jokers and BM.is_appmon(self) then strip_loader_bonus(self) end

    local result = card_set_ability(self, ...)
    if in_jokers and BM.is_appmon(self) and not BM._appmon_loader_rebalancing then
        BM.rebalance_appmon_loader()
    end
    return result
end

local card_set_edition = Card.set_edition
function Card:set_edition(...)
    local in_jokers = self.area == G.jokers
    if in_jokers and BM.is_appmon(self) then strip_loader_bonus(self) end

    local result = card_set_edition(self, ...)
    if in_jokers and BM.is_appmon(self) and not BM._appmon_loader_rebalancing then
        BM.rebalance_appmon_loader()
    end
    return result
end

local check_for_buy_space = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card, ...)
    if not BM.is_appmon(card) then return check_for_buy_space(card, ...) end
    if BM.can_add_appmon(card) then return true end
    alert_no_space(card, G.jokers)
    return false
end

function BM.initialise_appmon_uses(card)
    if not BM.is_appmon(card) or BM.get_appmon_stage(card) == 'Baby' then return end
    card.ability.extra = card.ability.extra or {}
    card.ability.extra.max_uses = card.ability.extra.max_uses or BM.APPMON_USE_COUNT
    card.ability.extra.uses = card.ability.extra.uses or card.ability.extra.max_uses
end

function BM.appmon_digivolve_baby(card)
    if not BM.is_appmon(card) or BM.get_appmon_stage(card) ~= 'Baby' then return false end

    local attribute = BM.get_attribute(card)
    local valid = {}

    for _, slug in ipairs(BM.APPMON_BASE_BY_ATTRIBUTE[attribute] or {}) do
        if G.P_CENTERS[BM.appmon_center_key(slug)] then valid[#valid + 1] = slug end
    end

    if BM.has_appmon_voucher('ultimate_app_realise') then
        for key, center in pairs(G.P_CENTERS) do
            if center.balatromon_appmon
            and center.appmon_stage == 'Super'
            and not center.appmon_base
            and center.attribute == attribute then
                valid[#valid + 1] = key:gsub('^c_' .. BM.PREFIX .. '_', '')
            end
        end
    end

    if #valid == 0 then return false end
    table.sort(valid)

    local target_slug = BM.random_element(valid, 'appmon_base_' .. tostring(attribute) .. '_' .. tostring(card.sort_id or 0))
    local target_key = BM.appmon_center_key(target_slug)
    local target = G.P_CENTERS[target_key]

    card:juice_up(0.8, 0.5)
    card:set_ability(target, nil, true)
    BM.initialise_appmon_uses(card)
    card:set_cost()
    card_eval_status_text(card, 'extra', nil, nil, nil, {
        message = BM.localized_object_name(target, nil, target_key, target_slug)
    })
    BM.rebalance_appmon_loader()
    return true
end

function BM.buy_appmon_from_shop(buy_from_shop, e, ...)
    local card = e.config.ref_table
    if not BM.is_appmon(card) then return buy_from_shop(e, ...) end
    if e.config.id == 'buy_and_use' then return false end

    if not BM.can_add_appmon(card) then
        alert_no_space(card, G.jokers)
        e.disable_button = nil
        return false
    end

    local was_consumeable = card.ability.consumeable
    card.ability.consumeable = false
    local result = buy_from_shop(e, ...)

    G.E_MANAGER:add_event(Event {
        trigger = 'after',
        delay = 0.12,
        func = function()
            if not card.REMOVED then
                card.ability.consumeable = was_consumeable
                BM.appmon_digivolve_baby(card)
                BM.initialise_appmon_uses(card)
                BM.rebalance_appmon_loader()
            end
            return true
        end
    })

    return result
end

local card_focus_ui = G.UIDEF.card_focus_ui
G.UIDEF.card_focus_ui = function(card, ...)
    local ui = card_focus_ui(card, ...)
    if BM.is_appmon(card) and card.area == G.jokers and card.ability.consumeable and ui then
        local attach = ui:get_UIE_by_ID('ATTACH_TO_ME')
        if attach and not attach.children.use then
            local key = card.config.center.key
            local blind_appmon = key == BM.appmon_center_key('logimon')
                or key == BM.appmon_center_key('bootmon')
                or key == BM.appmon_center_key('rebootmon')

            attach.children.use = G.UIDEF.card_focus_button {
                card = card,
                parent = attach,
                type = 'use',
                func = blind_appmon and 'balatromon_can_use_blind_appmon' or 'can_use_consumeable',
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
        G.C.SECONDARY_SET.Appmon or HEX('243447'),
        G.C.WHITE,
        1
    )
end

local function baby_in_pool(self)
    local attribute = self.attribute
    if not BM.APPMON_SHOP_ATTRIBUTES[attribute] then return false end

    for _, slug in ipairs(BM.APPMON_BASE_BY_ATTRIBUTE[attribute] or {}) do
        if G.P_CENTERS[BM.appmon_center_key(slug)] then return true end
    end
    return false
end

local function baby_loc_vars(self)
    return {vars = {self.attribute or 'Unknown'}}
end

local baby_names = {
    {name = 'Tapmon', slug = 'tapmon', y = 0},
    {name = 'Flickmon', slug = 'flickmon', y = 1},
    {name = 'Swipemon', slug = 'swipemon', y = 2}
}

local attribute_order = {'Social', 'Navi', 'Game', 'Tool', 'System', 'Entertainment', 'Life'}

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
                    'the {C:attention}#1#{} Attribute',
                    '{C:inactive}Uses a {C:attention}Loader Slot{C:inactive} while available,{}',
                    '{C:inactive}then occupies a {C:attention}Joker Slot{C:inactive} when full{}'
                }
            },
            loc_vars = baby_loc_vars,
            can_use = function() return false end
        }
    end
end

function BM.appmon_uses_remaining(card)
    if not card then return BM.APPMON_USE_COUNT end
    BM.initialise_appmon_uses(card)
    return card.ability.extra.uses or BM.APPMON_USE_COUNT
end

function BM.get_appmon_uses(card)
    return BM.appmon_uses_remaining(card)
end

function BM.get_appmon_max_uses(card)
    if not card then return BM.APPMON_USE_COUNT end
    BM.initialise_appmon_uses(card)
    return card.ability.extra.max_uses or BM.APPMON_USE_COUNT
end

function BM.refill_appmon_uses(card)
    if not BM.is_appmon(card) then return false end
    BM.initialise_appmon_uses(card)
    card.ability.extra.uses = card.ability.extra.max_uses or BM.APPMON_USE_COUNT
    card:juice_up(0.5, 0.5)
    return true
end

local function remove_exhausted_appmon(card)
    if card.REMOVED or not BM.is_appmon(card) then return false end
    if card._bm_appmon_remove_at and G.TIMERS.REAL < card._bm_appmon_remove_at then return false end

    local extra = card.ability.extra
    if not extra or not extra.uses or extra.uses > 0 then return false end

    if card.area then
        card.area:remove_from_highlighted(card)
        if area_contains(card.area, card) then card.area:remove_card(card) end
    end

    card:start_dissolve()
    return true
end

function BM.cleanup_exhausted_appmon()
    if not G.jokers then return end

    local exhausted = {}
    for _, card in ipairs(G.jokers.cards) do
        local extra = card.ability and card.ability.extra
        if BM.is_appmon(card) and BM.get_appmon_stage(card) ~= 'Baby' and extra and extra.uses and extra.uses <= 0 then
            exhausted[#exhausted + 1] = card
        end
    end

    for _, card in ipairs(exhausted) do
        remove_exhausted_appmon(card)
    end
end

function BM.consume_appmon_use(card)
    BM.initialise_appmon_uses(card)
    card.ability.extra.uses = math.max(0, card.ability.extra.uses - 1)
    if card.ability.extra.uses <= 0 then card._bm_appmon_remove_at = G.TIMERS.REAL + 0.6 end
end

local function keep_appmon_on_use()
    return true
end

local function appmon_in_pool()
    return false
end

local function appmon_loc_vars(self, info_queue, card)
    return {vars = {BM.appmon_uses_remaining(card), BM.get_appmon_max_uses(card)}}
end

function BM.combine_appmon(left, right)
    if not BM.is_appmon(left) or not BM.is_appmon(right) then return false end

    local route = BM.get_appmon_combination(left, right)
    if not route then return false end

    local target_key = G.P_CENTERS[route.result] and route.result or BM.appmon_center_key(route.result)
    local target = G.P_CENTERS[target_key]
    if not target then return false end

    left:juice_up(0.8, 0.5)
    right:juice_up(0.8, 0.5)
    left:set_ability(target, nil, true)
    BM.initialise_appmon_uses(left)
    left.ability.extra.uses = left.ability.extra.max_uses or BM.APPMON_USE_COUNT
    left:set_cost()

    if right.area == G.jokers then G.jokers:remove_card(right) end
    right:start_dissolve()
    BM.rebalance_appmon_loader()
    card_eval_status_text(left, 'extra', nil, nil, nil, {
        message = BM.localized_object_name(target, nil, target_key, 'Combined!')
    })
    return true
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
    in_pool = appmon_in_pool,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Gatchmon',
        text = {
            'Peek at the next {C:attention}2{} cards',
            'on top of your deck',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0 and G.deck and #G.deck.cards > 0
    end,
    use = function(self, card)
        BM.consume_appmon_use(card)
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
    in_pool = appmon_in_pool,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Navimon',
        text = {
            'Choose a {C:attention}rank{}, {C:attention}suit{}, or both',
            'to see how many draws until a match',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0 and G.deck and #G.deck.cards > 0
    end,
    use = function(self, card)
        BM.consume_appmon_use(card)
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
    in_pool = appmon_in_pool,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Onmon',
        text = {
            'Disable the current {C:attention}Boss Blind{}',
            'for the next {C:attention}hand or discard{}',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        local blind = G.GAME.blind
        local state = BM.onmon_state
        return BM.appmon_uses_remaining(card) > 0
            and blind and blind.boss and not blind.disabled
            and not (state and (state.armed or state.active))
    end,
    use = function(self, card)
        BM.consume_appmon_use(card)
        BM.arm_onmon()
    end,
    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'offmon',
    atlas = 'Appmon',
    pos = {x = 2, y = 4},
    soul_atlas = 'Appmon',
    soul_pos = {x = 3, y = 4},
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
    in_pool = appmon_in_pool,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Offmon',
        text = {
            'Gain {C:chips}2/15{} of the',
            'current Blind requirement',
            'and use {C:red}1 Discard{}',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0 and BM.can_use_offmon()
    end,
    use = function(self, card)
        BM.use_offmon(card)
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
    in_pool = appmon_in_pool,
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
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0 and BM.can_timemon_undo()
    end,
    use = function(self, card)
        BM.use_timemon(card)
    end,
    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'hackmon',
    atlas = 'Appmon',
    pos = {x = 8, y = 3},
    soul_atlas = 'Appmon',
    soul_pos = {x = 9, y = 3},
    discovered = false,
    unlocked = true,
    cost = BM.APPMON_STANDARD_COST,
    attribute = 'System',
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
    in_pool = appmon_in_pool,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Hackmon',
        text = {
            'Your next {C:red}discard{}',
            'scores like a {C:attention}played hand{},',
            'but its final Chips are {C:attention}halved{}',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0 and BM.can_use_hackmon(card)
    end,
    use = function(self, card)
        BM.use_hackmon(card)
    end,
    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'perorimon',
    atlas = 'Appmon',
    pos = {x = 10, y = 3},
    soul_atlas = 'Appmon',
    soul_pos = {x = 11, y = 3},
    discovered = false,
    unlocked = true,
    cost = BM.APPMON_STANDARD_COST,
    attribute = 'Entertainment',
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
    in_pool = appmon_in_pool,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Perorimon',
        text = {
            'Pay {C:money}$7{} to create a copy',
            'of the last {C:attention}Consumable{} used',
            '{C:inactive}(Last: {C:attention}#3#{C:inactive}){}',
            '{C:inactive}(Appmon, The Soul, and Golden Digivice excluded){}',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                BM.appmon_uses_remaining(card),
                BM.get_appmon_max_uses(card),
                BM.get_perorimon_last_consumable_name()
            }
        }
    end,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0 and BM.can_use_perorimon(card)
    end,
    use = function(self, card)
        BM.use_perorimon(card)
    end,
    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'virusmon',
    atlas = 'Appmon',
    pos = {x = 12, y = 3},
    soul_atlas = 'Appmon',
    soul_pos = {x = 13, y = 3},
    discovered = false,
    unlocked = true,
    cost = BM.APPMON_STANDARD_COST,
    attribute = 'Life',
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
    in_pool = appmon_in_pool,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Virusmon',
        text = {
            'Increase the {C:red}Hunger{} of',
            'the {C:attention}Digimon directly to its left{} by {C:attention}1{}',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0 and BM.can_use_virusmon(card)
    end,
    use = function(self, card)
        BM.use_virusmon(card)
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
    in_pool = appmon_in_pool,
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
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0 and G.GAME.blind and G.GAME.blind.name ~= ''
    end,
    use = function(self, card)
        BM.consume_appmon_use(card)
        local blind = BM.apply_craftmon_blind()
        if blind then
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = BM.localized_blind_name(blind, 'Boss Effect!')
            })
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
    in_pool = appmon_in_pool,
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
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0 and G.deck and #G.deck.cards > 0
    end,
    use = function(self, card)
        BM.open_dogatchmon_draw(card)
    end,
    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'logimon',
    atlas = 'Appmon',
    pos = {x = 4, y = 4},
    soul_atlas = 'Appmon',
    soul_pos = {x = 5, y = 4},
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
    in_pool = appmon_in_pool,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Logimon',
        text = {
            'Reroll the upcoming',
            '{C:attention}Boss Blind{}',
            '{C:inactive}Usable during Blind selection{}',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0
            and BM.can_use_boss_select_appmon()
            and #BM.appmon_valid_boss_pool(true) > 0
    end,
    use = function(self, card)
        if BM.reroll_boss_with_logimon() then
            BM.consume_appmon_use(card)
            card_eval_status_text(
                card,
                'extra',
                nil,
                nil,
                nil,
                {
                    message = 'Rerolled!'
                }
            )
        end
    end,
    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'logamon',
    atlas = 'Appmon',
    pos = {x = 2, y = 5},
    soul_atlas = 'Appmon',
    soul_pos = {x = 3, y = 5},
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
    in_pool = appmon_in_pool,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Logamon',
        text = {
            'Gain {C:chips}1/10{} of the',
            'current Blind requirement',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0 and BM.can_use_scoring_appmon()
    end,
    use = function(self, card)
        BM.consume_appmon_use(card)
        BM.appmon_gain_blind_score(card, 1, 10)
    end,
    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'globemon',
    atlas = 'Appmon',
    pos = {x = 0, y = 5},
    soul_atlas = 'Appmon',
    soul_pos = {x = 1, y = 5},
    discovered = false,
    unlocked = true,
    cost = BM.APPMON_ULTIMATE_COST,
    attribute = 'Social',
    balatromon_appmon = true,
    appmon_base = false,
    appmon_stage = 'Ultimate',
    appmon_next_stage = 'God',
    config = {
        extra = {
            uses = BM.APPMON_USE_COUNT,
            max_uses = BM.APPMON_USE_COUNT
        }
    },
    in_pool = appmon_in_pool,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Globemon',
        text = {
            'Choose a {C:attention}rank{} and draw',
            'up to {C:attention}4{} cards of that rank',
            'then regain all',
            '{C:blue}Hands{} and {C:red}Discards{}',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0 and G.deck and #G.deck.cards > 0
    end,
    use = function(self, card)
        BM.open_globemon_draw(card)
    end,
    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'bootmon',
    atlas = 'Appmon',
    pos = {x = 4, y = 5},
    soul_atlas = 'Appmon',
    soul_pos = {x = 5, y = 5},
    discovered = false,
    unlocked = true,
    cost = BM.APPMON_ULTIMATE_COST,
    attribute = 'Tool',
    balatromon_appmon = true,
    appmon_base = false,
    appmon_stage = 'Ultimate',
    appmon_next_stage = 'God',
    config = {
        extra = {
            uses = BM.APPMON_USE_COUNT,
            max_uses = BM.APPMON_USE_COUNT
        }
    },
    in_pool = appmon_in_pool,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Bootmon',
        text = {
            'Choose the upcoming',
            '{C:attention}Boss Blind{} and',
            '{C:money}double{} its monetary reward',
            '{C:inactive}Usable during Blind selection{}',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0
            and BM.can_use_boss_select_appmon()
            and #BM.appmon_valid_boss_pool(true) > 0
    end,
    use = function(self, card)
        BM.open_bootmon_selector(card)
    end,
    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'shutmon',
    atlas = 'Appmon',
    pos = {x = 2, y = 6},
    soul_atlas = 'Appmon',
    soul_pos = {x = 3, y = 6},
    discovered = false,
    unlocked = true,
    cost = BM.APPMON_ULTIMATE_COST,
    attribute = 'Tool',
    balatromon_appmon = true,
    appmon_base = false,
    appmon_stage = 'Ultimate',
    appmon_next_stage = 'God',
    config = {
        extra = {
            uses = BM.APPMON_USE_COUNT,
            max_uses = BM.APPMON_USE_COUNT
        }
    },
    in_pool = appmon_in_pool,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Shutmon',
        text = {
            'Gain {C:chips}1/5{} of the',
            'current Blind requirement',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0 and BM.can_use_scoring_appmon()
    end,
    use = function(self, card)
        BM.consume_appmon_use(card)
        BM.appmon_gain_blind_score(card, 1, 5)
    end,
    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'rebootmon',
    atlas = 'Appmon',
    pos = {x = 4, y = 6},
    soul_atlas = 'Appmon',
    soul_pos = {x = 5, y = 6},
    discovered = false,
    unlocked = true,
    cost = BM.APPMON_GOD_COST,
    attribute = 'God',
    balatromon_appmon = true,
    appmon_base = false,
    appmon_stage = 'God',
    config = {
        extra = {
            uses = BM.APPMON_USE_COUNT,
            max_uses = BM.APPMON_USE_COUNT
        }
    },
    in_pool = appmon_in_pool,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Rebootmon',
        text = {
            'During Blind selection, choose the',
            'upcoming {C:attention}Boss Blind{} and',
            '{C:money}double{} its monetary reward',
            'During a Blind, gain {C:chips}1/4{} of',
            'its requirement and disable its',
            '{C:attention}Boss Blind{} effect',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        local extra = card.ability.extra
        if BM.appmon_uses_remaining(card) <= 0 then
            extra.rebootmon_mode = nil
            return false
        end
        if BM.can_use_boss_select_appmon() and #BM.appmon_valid_boss_pool(true) > 0 then
            extra.rebootmon_mode = 'boss_select'
            return true
        end
        if BM.can_use_scoring_appmon() then
            extra.rebootmon_mode = 'blind'
            return true
        end
        extra.rebootmon_mode = nil
        return false
    end,
    use = function(self, card)
        BM.use_rebootmon(card)
    end,
    keep_on_use = keep_appmon_on_use
}

SMODS.Consumable {
    set = 'Appmon',
    key = 'rebootmon_virus',
    atlas = 'Appmon',
    pos = {x = 4, y = 7},
    soul_atlas = 'Appmon',
    soul_pos = {x = 5, y = 7},
    discovered = false,
    unlocked = true,
    cost = BM.APPMON_GOD_COST,
    attribute = 'God',
    balatromon_appmon = true,
    appmon_base = false,
    appmon_stage = 'God',
    config = {
        extra = {
            uses = BM.APPMON_USE_COUNT,
            max_uses = BM.APPMON_USE_COUNT
        }
    },
    in_pool = appmon_in_pool,
    set_badges = appmon_stage_badge,
    loc_txt = {
        name = 'Rebootmon Virus',
        text = {
            'Gain {C:chips}Chips{} equal to the current',
            '{C:attention}Blind requirement{}, then increase',
            'every Digimon\'s',
            '{C:red}Hunger{} by {C:attention}1{}',
            '{C:inactive}(#1#/#2# uses remaining){}'
        }
    },
    loc_vars = appmon_loc_vars,
    can_use = function(self, card)
        return BM.appmon_uses_remaining(card) > 0 and BM.can_use_scoring_appmon()
    end,
    use = function(self, card)
        BM.use_rebootmon_virus(card)
    end,
    keep_on_use = keep_appmon_on_use
}

BM.register_appmon_combination(
    BM.appmon_center_key('onmon'),
    BM.appmon_center_key('gatchmon'),
    BM.appmon_center_key('logimon')
)

BM.register_appmon_combination(
    BM.appmon_center_key('dogatchmon'),
    BM.appmon_center_key('timemon'),
    BM.appmon_center_key('globemon')
)

BM.register_appmon_combination(
    BM.appmon_center_key('logimon'),
    BM.appmon_center_key('craftmon'),
    BM.appmon_center_key('bootmon')
)

BM.register_appmon_combination(
    BM.appmon_center_key('offmon'),
    BM.appmon_center_key('offmon'),
    BM.appmon_center_key('logamon')
)

BM.register_appmon_combination(
    BM.appmon_center_key('hackmon'),
    BM.appmon_center_key('logamon'),
    BM.appmon_center_key('shutmon')
)

BM.register_appmon_combination(
    BM.appmon_center_key('shutmon'),
    BM.appmon_center_key('bootmon'),
    BM.appmon_center_key('rebootmon')
)

BM.register_appmon_combination(
    BM.appmon_center_key('rebootmon'),
    BM.appmon_center_key('virusmon'),
    BM.appmon_center_key('rebootmon_virus')
)
