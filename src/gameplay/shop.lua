local BM = Balatromon

BM.lineage_shop_balance = BM.lineage_shop_balance or {
    Rookie = {
        decay = 0.65,
        minimum = 0.10
    },
    ['In-Training'] = {
        decay = 0.82,
        minimum = 0.30
    },
    Fresh = {
        decay = 0.90,
        minimum = 0.50
    },
    precision = 10
}

local function split_lineage_targets(text)
    local out = {}

    for part in tostring(text or ''):gmatch('[^,]+') do
        local name = part:match('^%s*(.-)%s*$')

        if name ~= '' and name ~= '-' then
            out[#out + 1] = BM.slug(name)
        end
    end

    return out
end

local function add_lineage_edge(graph, source, target)
    if not source
    or not target
    or source == ''
    or target == '' then
        return
    end

    graph.forward[source] =
        graph.forward[source] or {}

    graph.reverse[target] =
        graph.reverse[target] or {}

    graph.forward[source][
        #graph.forward[source] + 1
    ] = target

    graph.reverse[target][
        #graph.reverse[target] + 1
    ] = source
end

local function build_lineage_graph(include_x)
    local graph = {
        forward = {},
        reverse = {}
    }

    for slug, def in pairs(
        BM.joker_defs or {}
    ) do
        for _, target in ipairs(
            split_lineage_targets(
                def.evolves_to
            )
        ) do
            add_lineage_edge(
                graph,
                slug,
                target
            )
        end
    end

    if include_x then
        for source, targets in pairs(
            BM.x_antibody_extra_evolutions
            or {}
        ) do
            for _, target in ipairs(
                targets or {}
            ) do
                add_lineage_edge(
                    graph,
                    BM.slug(source),
                    BM.slug(target)
                )
            end
        end
    end

    return graph
end

local function lineage_sorted_keys(set)
    local out = {}

    for key in pairs(set or {}) do
        out[#out + 1] = key
    end

    table.sort(out)

    return out
end

local function get_rookie_families(
    slug,
    graph,
    cache
)
    slug = BM.slug(slug or '')

    if slug == '' then
        return {}
    end

    if cache[slug] then
        return cache[slug]
    end

    local def =
        BM.joker_defs
        and BM.joker_defs[slug]

    if not def then
        cache[slug] = {}
        return cache[slug]
    end

    if def.stage == 'Rookie' then
        cache[slug] = {slug}
        return cache[slug]
    end

    local found = {}
    local seen = {}

    local forward =
        def.stage == 'Fresh'
        or def.stage == 'In-Training'

    local function walk(current)
        if seen[current] then
            return
        end

        seen[current] = true

        local current_def =
            BM.joker_defs
            and BM.joker_defs[current]

        if current_def
        and current_def.stage == 'Rookie' then
            found[current] = true
            return
        end

        local next_nodes

        if forward then
            next_nodes =
                graph.forward[current]
        else
            next_nodes =
                graph.reverse[current]
        end

        for _, next_slug in ipairs(
            next_nodes or {}
        ) do
            walk(next_slug)
        end
    end

    walk(slug)

    cache[slug] =
        lineage_sorted_keys(found)

    return cache[slug]
end

local function get_history_rookie(card)
    local e =
        card
        and card.ability
        and card.ability.extra
        or {}

    for i =
        #(e.evolution_history or {}),
        1,
        -1
    do
        local slug =
            BM.slug(
                e.evolution_history[i]
            )

        local def =
            BM.joker_defs
            and BM.joker_defs[slug]

        if def
        and def.stage == 'Rookie' then
            return slug
        end
    end

    return nil
end

local function add_card_lineage_pressure(
    card,
    pressure,
    normal_graph,
    x_graph,
    normal_cache,
    x_cache
)
    if not BM.is_digimon(card) then
        return
    end

    local slug =
        BM.get_card_slug(card)

    if not slug then
        return
    end

    local has_x =
        BM.has_x_antibody
        and BM.has_x_antibody(card)
        or false

    local graph =
        has_x
        and x_graph
        or normal_graph

    local cache =
        has_x
        and x_cache
        or normal_cache

    local families =
        get_rookie_families(
            slug,
            graph,
            cache
        )

    if #families == 1 then
        local rookie =
            families[1]

        pressure[rookie] =
            (pressure[rookie] or 0)
            + 1

        return
    end

    local history_rookie =
        get_history_rookie(card)

    if history_rookie then
        pressure[history_rookie] =
            (pressure[history_rookie] or 0)
            + 1

        return
    end

    if #families > 0 then
        local share =
            1 / #families

        for _, rookie in ipairs(
            families
        ) do
            pressure[rookie] =
                (pressure[rookie] or 0)
                + share
        end
    end
end

local function get_lineage_pressure(
    normal_graph,
    x_graph,
    normal_cache,
    x_cache
)
    local pressure = {}

    for _, card in ipairs(
        G.jokers
        and G.jokers.cards
        or {}
    ) do
        add_card_lineage_pressure(
            card,
            pressure,
            normal_graph,
            x_graph,
            normal_cache,
            x_cache
        )
    end

    BM.current_rookie_lineage_pressure =
        pressure

    return pressure
end

local function get_entry_slug(entry)
    local key =
        tostring(entry.key or '')

    local prefix =
        'j_'
        .. BM.PREFIX
        .. '_'

    if key:sub(1, #prefix)
    == prefix then
        return key:sub(
            #prefix + 1
        )
    end

    return BM.slug(key)
end

local function get_shop_lineage_pressure(
    entry,
    pressure,
    graph,
    cache
)
    if entry.stage ~= 'Rookie'
    and entry.stage ~= 'In-Training'
    and entry.stage ~= 'Fresh' then
        return 0
    end

    local families =
        get_rookie_families(
            get_entry_slug(entry),
            graph,
            cache
        )

    if #families == 0 then
        return 0
    end

    local total = 0

    for _, rookie in ipairs(
        families
    ) do
        total =
            total
            + (pressure[rookie] or 0)
    end

    return total / #families
end

local function get_lineage_multiplier(
    stage,
    pressure
)
    local config =
        BM.lineage_shop_balance[
            stage
        ]

    if not config
    or pressure <= 0 then
        return 1
    end

    return math.max(
        config.minimum,
        config.decay ^ pressure
    )
end

if not BM._shop_pool_patched and get_current_pool then
    BM._shop_pool_patched = true

    local old_get_current_pool = get_current_pool

    get_current_pool = function(
        _type,
        _rarity,
        _legendary,
        _append
    )
        if _type == 'Joker'
        and (_append == 'sho' or _append == 'shop') then

            local pool = {}

            local normal_graph =
                build_lineage_graph(false)

            local x_graph =
                build_lineage_graph(true)

            local normal_cache = {}
            local x_cache = {}

            local lineage_pressure =
                get_lineage_pressure(
                    normal_graph,
                    x_graph,
                    normal_cache,
                    x_cache
                )

            local precision =
                BM.lineage_shop_balance.precision
                or 10
            
            for _, entry in ipairs(BM.shop_joker_keys) do
                local center = G.P_CENTERS[entry.key]

                if center then
                    local allowed = true

                    local special_shop_ultimate =
                        entry.stage == 'Ultimate'
                        and (
                            entry.key == BM.center_key('monzaemon')
                            or entry.key == BM.center_key('warumonzaemon')
                            or entry.key == BM.center_key('polarbearmon')
                        )

                    local voucher_ultimate =
                        entry.stage == 'Ultimate'
                        and G.GAME
                        and G.GAME.balatromon_mega_digivolution == true

                    if entry.stage == 'Ultimate'
                    and not special_shop_ultimate
                    and not voucher_ultimate then
                        allowed = false
                    end

                    if allowed
                    and center.in_pool
                    and not special_shop_ultimate
                    and not voucher_ultimate then
                        local ok = center:in_pool({
                            source = _append
                        })

                        allowed = ok ~= false
                    end

                    if allowed then
                        local weight = entry.weight or 1

                        if entry.stage == 'Rookie' then
                            if G.GAME
                            and G.GAME.balatromon_digivice_abundance then
                                weight = 10
                            else
                                weight = 4
                            end

                        elseif entry.stage == 'Champion' then
                            if G.GAME
                            and G.GAME.balatromon_digivice_abundance then
                                weight = 3
                            else
                                weight = 1
                            end
                        end

                        local family_pressure =
                            get_shop_lineage_pressure(
                                entry,
                                lineage_pressure,
                                normal_graph,
                                normal_cache
                            )

                        local multiplier =
                            get_lineage_multiplier(
                                entry.stage,
                                family_pressure
                            )

                        weight =
                            weight
                            * multiplier

                    local copies =
                            math.max(
                                1,
                                math.floor(
                                weight
                                    * precision
                                    + 0.5
                                )
                            )

                        for _ = 1, copies do
                            pool[#pool + 1] =
                                entry.key
                        end
                    end
                end
            end

            if #pool > 0 then
                return pool, 'BalatromonShop'
            end
        end

    local pool, pool_key = old_get_current_pool(
        _type,
        _rarity,
        _legendary,
        _append
    )


    return pool, pool_key
    end
end