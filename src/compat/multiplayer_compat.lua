local BM = Balatromon
local mp_mod = SMODS
    and SMODS.Mods
    and SMODS.Mods['Multiplayer']

if not (mp_mod and mp_mod.can_load) then
    return
end

if BM._multiplayer_compat_bootstrap then
    return
end

BM._multiplayer_compat_bootstrap = true
BM.multiplayer_compat =
    BM.multiplayer_compat or {}

local MC = BM.multiplayer_compat


local function multiplayer_active()
    if not MP then
        return false
    end

    if MP.LOBBY
    and MP.LOBBY.code then
        return true
    end

    if MP.is_practice_mode
    and MP.is_practice_mode() then
        return true
    end

    if MP.GHOST
    and MP.GHOST.is_active
    and MP.GHOST.is_active() then
        return true
    end

    return false
end


MC.is_active = multiplayer_active


local function reset_transients()
    if G
    and G.jokers
    and G.jokers.config
    and BM._multi_joker_previous_limit then
        G.jokers.config.highlighted_limit =
            BM._multi_joker_previous_limit
    end

    BM.evolution_queue = {}
    BM.pending_evolution = nil

    BM._evolution_choice_busy = false
    BM._evolution_animation_busy = false

    BM._multi_joker_target_card = nil
    BM._multi_joker_previous_limit = nil
    BM._multi_joker_target_limit = nil

    BM._signal_pending_draws = nil
    BM._missimon_bonus_leveling = nil

    BM._last_digimon_click = nil
    BM._last_digimon_click_time = 0

    BM.last_sold_joker_key = nil

    if BM.invalidate_optimiser then
        BM.invalidate_optimiser('all')
    end
end


MC.reset_transients =
    reset_transients


local function install_shop_fix()
    if MC._shop_fix_installed then
        return
    end

    MC._shop_fix_installed = true
    MC._shop_create_depth = 0


    if create_card then
        local create_card_ref =
            create_card

        create_card = function(
            _type,
            area,
            legendary,
            rarity,
            skip_materialize,
            soulable,
            forced_key,
            key_append
        )
            local order_shop =
                _type == 'Joker'
                and G
                and area == G.shop_jokers
                and not forced_key
                and MP
                and MP.should_use_the_order
                and MP.should_use_the_order()

            if order_shop then
                MC._shop_create_depth =
                    MC._shop_create_depth + 1
            end

            local card =
                create_card_ref(
                    _type,
                    area,
                    legendary,
                    rarity,
                    skip_materialize,
                    soulable,
                    forced_key,
                    key_append
                )

            if order_shop then
                MC._shop_create_depth =
                    math.max(
                        0,
                        MC._shop_create_depth - 1
                    )
            end

            return card
        end
    end


    if get_current_pool then
        local get_current_pool_ref =
            get_current_pool

        get_current_pool = function(
            _type,
            rarity,
            legendary,
            append
        )
            if _type == 'Joker'
            and MC._shop_create_depth > 0
            and (
                append == nil
                or append == ''
            ) then
                append = 'shop'
            end

            local balatromon_shop =
                _type == 'Joker'
                and (
                    append == 'sho'
                    or append == 'shop'
                )

            local optimiser =
                BM.optimiser

            local old_cache =
                optimiser
                and optimiser.shop_pool_cache

            if balatromon_shop
            and multiplayer_active()
            and optimiser then
                optimiser.shop_pool_cache =
                    false
            end

            local pool,
                pool_key =
                get_current_pool_ref(
                    _type,
                    rarity,
                    legendary,
                    append
                )

            if balatromon_shop
            and multiplayer_active()
            and optimiser then
                optimiser.shop_pool_cache =
                    old_cache
            end

            return pool, pool_key
        end
    end
end


local function install_run_reset()
    if MC._run_reset_installed
    or not Game
    or not Game.start_run then
        return
    end

    MC._run_reset_installed = true

    local start_run_ref =
        Game.start_run

    Game.start_run = function(
        self,
        args
    )
        if multiplayer_active() then
            reset_transients()
        end

        return start_run_ref(
            self,
            args
        )
    end
end


local function install_mode_hash()
    if MC._mode_hash_installed
    or not MP
    or not MP.generate_hash then
        return
    end

    MC._mode_hash_installed = true

    local generate_hash_ref =
        MP.generate_hash


    function MP:generate_hash(...)
        local mod =
            SMODS.Mods
            and SMODS.Mods[
                'Balatromon'
            ]

        local original_version =
            mod
            and mod.version

        if mod then
            local mode =
                BM.get_configured_mode
                and BM.get_configured_mode()
                or 'standard'

            mod.version =
                tostring(
                    original_version
                    or 'UNK'
                )
                .. '+mode_'
                .. tostring(mode)
        end

        local ret =
            generate_hash_ref(
                self,
                ...
            )

        if mod then
            mod.version =
                original_version
        end

        return ret
    end


    if BM.set_configured_mode
    and not MC._mode_setter_wrapped then
        MC._mode_setter_wrapped =
            true

        local set_mode_ref =
            BM.set_configured_mode

        BM.set_configured_mode =
        function(mode)
            local ret =
                set_mode_ref(mode)

            if MP
            and MP.generate_hash
            and SMODS.booted then
                MP:generate_hash()
            end

            return ret
        end
    end
end


function MC.install()
    if MC._installed
    or not MP then
        return
    end

    MC._installed = true

    install_shop_fix()
    install_run_reset()
    install_mode_hash()

    if sendDebugMessage then
        sendDebugMessage(
            'Balatromon compatibility installed',
            'MULTIPLAYER'
        )
    end
end


local inject_items_ref =
    SMODS.injectItems


if type(inject_items_ref)
== 'function' then

    SMODS.injectItems =
    function(...)
        local ret =
            inject_items_ref(...)

        MC.install()

        return ret
    end
end