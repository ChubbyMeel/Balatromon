local BM = Balatromon

if BM._optimiser_loaded then
    return
end

BM._optimiser_loaded = true

BM.optimiser = BM.optimiser or {
    enabled = true,
    frame_cache = true,
    shop_pool_cache = true
}

local OPT = BM.optimiser

local frame_stamp = nil
local frame_values = {}

local joker_epoch = 0
local deck_epoch = 0

local shop_cache = {
    signature = nil,
    pool = nil,
    key = nil
}

local tamer_line_cache = {}

OPT.stats = OPT.stats or {
    shop_hits = 0,
    shop_misses = 0,
    frame_hits = 0,
    frame_misses = 0,
    find_card_hits = 0,
    find_card_misses = 0
}

local function current_frame()
    if G
    and G.TIMERS
    and type(G.TIMERS.REAL) == 'number' then
        return G.TIMERS.REAL
    end

    if love
    and love.timer
    and love.timer.getTime then
        return math.floor(
            love.timer.getTime() * 120
        )
    end

    return 0
end

local function update_frame()
    local stamp = current_frame()

    if stamp ~= frame_stamp then
        frame_stamp = stamp
        frame_values = {}
    end
end

local function frame_cached(
    namespace,
    key,
    producer
)
    if not OPT.enabled
    or not OPT.frame_cache then
        return producer()
    end

    update_frame()

    local cache_key =
        tostring(namespace)
        .. ':'
        .. tostring(key)

    local cached =
        frame_values[cache_key]

    if cached ~= nil then
        OPT.stats.frame_hits =
            OPT.stats.frame_hits + 1

        return cached
    end

    OPT.stats.frame_misses =
        OPT.stats.frame_misses + 1

    local result =
        producer()

    frame_values[cache_key] =
        result

    return result
end

function BM.invalidate_optimiser(kind)
    kind = kind or 'all'

    if kind == 'all'
    or kind == 'jokers' then
        joker_epoch =
            joker_epoch + 1

        shop_cache.signature = nil
        shop_cache.pool = nil
        shop_cache.key = nil

        tamer_line_cache = {}
    end

    if kind == 'all'
    or kind == 'deck' then
        deck_epoch =
            deck_epoch + 1
    end

    frame_values = {}
end

local function wrap_simple_frame_function(
    name,
    key_function
)
    local original =
        BM[name]

    if type(original) ~= 'function' then
        return
    end

    if BM[
        '_optimiser_wrapped_'
        .. name
    ] then
        return
    end

    BM[
        '_optimiser_wrapped_'
        .. name
    ] = true

    BM[name] =
    function(...)
        if not OPT.enabled
        or not OPT.frame_cache then
            return original(...)
        end

        local args = {...}
        local arg_count = select('#', ...)

        local key = ''

        if key_function then
            key =
                key_function(
                    unpack(
                        args,
                        1,
                        arg_count
                    )
                )
                or ''
        end

        return frame_cached(
            name,
            key,
            function()
                return original(
                    unpack(
                        args,
                        1,
                        arg_count
                    )
                )
            end
        )
    end
end

wrap_simple_frame_function(
    'count_food',
    function()
        local cards =
            G.consumeables
            and G.consumeables.cards
            or {}

        return #cards
    end
)

wrap_simple_frame_function(
    'count_deck_enhancement',
    function(key)
        return
            tostring(deck_epoch)
            .. ':'
            .. tostring(key)
    end
)

wrap_simple_frame_function(
    'deck_suits',
    function()
        return
            tostring(deck_epoch)
    end
)

wrap_simple_frame_function(
    'deck_ranks',
    function()
        return
            tostring(deck_epoch)
    end
)

wrap_simple_frame_function(
    'deck_card_targets',
    function()
        return
            tostring(deck_epoch)
    end
)

wrap_simple_frame_function(
    'active_digimon',
    function(slug)
        return
            tostring(joker_epoch)
            .. ':'
            .. tostring(
                slug or '*'
            )
    end
)

if BM.active_digimon then
    BM.has_active_digimon =
    function(slug)
        return
            #BM.active_digimon(slug)
            > 0
    end
end

wrap_simple_frame_function(
    'has_active_polarbearmon',
    function()
        return
            tostring(joker_epoch)
    end
)

wrap_simple_frame_function(
    'has_sunflowmon_effect',
    function()
        return
            tostring(joker_epoch)
    end
)

if type(BM.set_enhancement)
== 'function'
and not BM._optimiser_enhancement_wrapped then
    BM._optimiser_enhancement_wrapped =
        true

    local old_set_enhancement =
        BM.set_enhancement

    BM.set_enhancement =
    function(card, key, skip_juice)
        local already =
            BM.has_enhancement
            and BM.has_enhancement(
                card,
                key
            )

        local result =
            old_set_enhancement(
                card,
                key,
                skip_juice
            )

        if result
        and not already then
            BM.invalidate_optimiser(
                'deck'
            )
        end

        return result
    end
end

if type(BM.on_add) == 'function'
and not BM._optimiser_on_add_wrapped then
    BM._optimiser_on_add_wrapped =
        true

    local old_on_add =
        BM.on_add

    BM.on_add =
    function(card, slug)
        local result =
            old_on_add(
                card,
                slug
            )

        BM.invalidate_optimiser(
            'jokers'
        )

        return result
    end
end

if type(BM.on_remove) == 'function'
and not BM._optimiser_on_remove_wrapped then
    BM._optimiser_on_remove_wrapped =
        true

    local old_on_remove =
        BM.on_remove

    BM.on_remove =
    function(card, slug)
        local result =
            old_on_remove(
                card,
                slug
            )

        BM.invalidate_optimiser(
            'jokers'
        )

        return result
    end
end

if SMODS
and type(SMODS.find_card) == 'function'
and not BM._optimiser_find_card_wrapped then
    BM._optimiser_find_card_wrapped =
        true

    local old_find_card =
        SMODS.find_card

    local hot_keys = {
        [
            BM.center_key(
                'machmon'
            )
        ] = true,

        [
            BM.center_key(
                'andromon'
            )
        ] = true
    }

    SMODS.find_card =
    function(
        key,
        include_debuffed,
        ...
    )
        if not OPT.enabled
        or not OPT.frame_cache
        or not hot_keys[key]
        or select('#', ...) > 0 then
            return old_find_card(
                key,
                include_debuffed,
                ...
            )
        end

        update_frame()

        local cache_key =
            'find_card:'
            .. tostring(joker_epoch)
            .. ':'
            .. tostring(key)
            .. ':'
            .. tostring(
                include_debuffed
            )

        local cached =
            frame_values[
                cache_key
            ]

        if cached ~= nil then
            OPT.stats.find_card_hits =
                OPT.stats.find_card_hits
                + 1

            return cached
        end

        OPT.stats.find_card_misses =
            OPT.stats.find_card_misses
            + 1

        local result =
            old_find_card(
                key,
                include_debuffed
            )

        frame_values[
            cache_key
        ] =
            result

        return result
    end
end

if type(BM.tamer_card_in_lineage)
== 'function'
and not BM._optimiser_tamer_line_wrapped then
    BM._optimiser_tamer_line_wrapped =
        true

    local old_tamer_card_in_lineage =
        BM.tamer_card_in_lineage

    BM.tamer_card_in_lineage =
    function(card, root)
        if not OPT.enabled
        or not card
        or not root then
            return
                old_tamer_card_in_lineage(
                    card,
                    root
                )
        end

        local slug =
            BM.get_card_slug(card)

        if not slug then
            return
                old_tamer_card_in_lineage(
                    card,
                    root
                )
        end

        local is_x =
            BM.has_x_antibody
            and BM.has_x_antibody(card)
            or false

        local key =
            tostring(slug)
            .. ':'
            .. tostring(
                BM.slug(root)
            )
            .. ':'
            .. tostring(is_x)

        local cached =
            tamer_line_cache[key]

        if cached ~= nil then
            return cached
        end

        local result =
            old_tamer_card_in_lineage(
                card,
                root
            )
            == true

        tamer_line_cache[key] =
            result

        return result
    end
end

local function history_signature(card)
    local e =
        card
        and card.ability
        and card.ability.extra
        or {}

    local history =
        e.evolution_history

    if type(history) ~= 'table'
    or #history == 0 then
        return ''
    end

    local out = {}

    for i, slug in ipairs(history) do
        out[i] =
            tostring(slug)
    end

    return table.concat(
        out,
        '>'
    )
end

local function joker_signature()
    local cards =
        G.jokers
        and G.jokers.cards
        or {}

    local out = {
        tostring(joker_epoch),
        tostring(#cards)
    }

    for i, card in ipairs(cards) do
        local center =
            card.config
            and card.config.center

        local center_key =
            center
            and center.key
            or '?'

        local e =
            card.ability
            and card.ability.extra
            or {}

        local is_x =
            BM.has_x_antibody
            and BM.has_x_antibody(card)
            or false

        out[#out + 1] =
            table.concat(
                {
                    tostring(i),
                    tostring(center_key),
                    is_x and 'x' or 'n',
                    e.permanently_disabled
                        and 'd'
                        or 'a',
                    history_signature(card)
                },
                ','
            )
    end

    return table.concat(
        out,
        '|'
    )
end

local function shop_signature(
    rarity,
    legendary,
    append
)
    local game =
        G.GAME or {}

    local round_resets =
        game.round_resets
        or {}

    return table.concat(
        {
            tostring(rarity),
            tostring(legendary),
            tostring(append),
            tostring(
                round_resets.ante
                or 0
            ),
            game.balatromon_digivice_abundance
                and 'da1'
                or 'da0',
            game.balatromon_mega_digivolution
                and 'md1'
                or 'md0',
            joker_signature()
        },
        '#'
    )
end

if get_current_pool
and not BM._optimiser_pool_wrapped then
    BM._optimiser_pool_wrapped =
        true

    local old_get_current_pool =
        get_current_pool

    get_current_pool =
    function(
        _type,
        _rarity,
        _legendary,
        _append
    )
        local is_shop =
            _type == 'Joker'
            and (
                _append == 'sho'
                or _append == 'shop'
            )

        if not OPT.enabled
        or not OPT.shop_pool_cache
        or not is_shop then
            return old_get_current_pool(
                _type,
                _rarity,
                _legendary,
                _append
            )
        end

        local signature =
            shop_signature(
                _rarity,
                _legendary,
                _append
            )

        if shop_cache.signature
        == signature
        and shop_cache.pool then
            OPT.stats.shop_hits =
                OPT.stats.shop_hits
                + 1

            return
                shop_cache.pool,
                shop_cache.key
        end

        OPT.stats.shop_misses =
            OPT.stats.shop_misses
            + 1

        local pool,
            pool_key =
            old_get_current_pool(
                _type,
                _rarity,
                _legendary,
                _append
            )

        if type(pool) == 'table'
        and (
            pool_key == 'BalatromonShop'
            or tostring(
                pool_key or ''
            ):find(
                'Balatromon',
                1,
                true
            )
        ) then
            shop_cache.signature =
                signature

            shop_cache.pool =
                pool

            shop_cache.key =
                pool_key
        end

        return
            pool,
            pool_key
    end
end

function BM.optimiser_clear()
    BM.invalidate_optimiser(
        'all'
    )
end

function BM.optimiser_get_stats()
    return {
        shop_hits =
            OPT.stats.shop_hits,

        shop_misses =
            OPT.stats.shop_misses,

        frame_hits =
            OPT.stats.frame_hits,

        frame_misses =
            OPT.stats.frame_misses,

        find_card_hits =
            OPT.stats.find_card_hits,

        find_card_misses =
            OPT.stats.find_card_misses
    }
end