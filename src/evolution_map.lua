local BM = Balatromon

BM.evolution_map_layout = nil
BM.evolution_map_origin = BM.evolution_map_origin or 'main_menu'
BM.evolution_map_canvas = nil
BM.evolution_map_page = BM.evolution_map_page or 1

local STAGE_COL = {
    Fresh = 1,
    ['In-Training'] = 2,
    Rookie = 3,
    Champion = 4,
    Rare = 4,
    Ultimate = 5,
    Mega = 6,
    Beyond = 7,
}

local STAGE_LABEL = {
    'FRESH',
    'IN-TRAINING',
    'ROOKIE',
    'CHAMPION / RARE',
    'ULTIMATE',
    'MEGA',
    'BEYOND',
}

local VIEW_W = 13.4
local VIEW_H = 7.15
local CANVAS_W = 1500
local CANVAS_H = 820
local CARD_W = 126
local CARD_H = 169
local LABEL_H = 34
local NODE_STEP = 255
local STAGE_X = {58, 305, 552, 799, 1046, 1293, 1540,}
local WORLD_W = 1724
local WORLD_TOP = 138
local WORLD_BOTTOM = 96

local function split_targets(text)
    local out = {}

    for part in tostring(text or ''):gmatch('[^,]+') do
        local name = part:match('^%s*(.-)%s*$')

        if name ~= '' and name ~= '-' then
            out[#out + 1] = BM.slug(name)
        end
    end

    return out
end

local function edge_colour(rule)
    if rule and rule.device then
        return G.C.PURPLE
    end

    if rule and rule.bad_path then
        return G.C.RED
    end

    if rule and rule.min_hunger then
        return G.C.ORANGE
    end

    if rule and rule.min_care then
        return G.C.YELLOW
    end

    return G.C.GREEN
end

local function colour_with_alpha(colour, alpha)
    if not colour then
        return 1, 1, 1, alpha or 1
    end

    return colour[1] or 1, colour[2] or 1, colour[3] or 1, alpha or colour[4] or 1
end

local function short_name(name)
    name = tostring(name or '')

    if #name <= 19 then
        return name
    end

    return name:sub(1, 17) .. '..'
end

local function average(values)
    if #values == 0 then
        return nil
    end

    local total = 0

    for _, value in ipairs(values) do
        total = total + value
    end

    return total / #values
end

local function list_index(list, value)
    for i, v in ipairs(list or {}) do
        if v == value then
            return i
        end
    end

    return 1
end

local function port_offset(index, count)
    if not count or count <= 1 then
        return 0
    end

    local spread = math.min(CARD_H * 0.58, (count - 1) * 20)
    local step = spread / (count - 1)

    return -spread / 2 + (index - 1) * step
end

local function page_name(roots, nodes)
    local names = {}

    for _, slug in ipairs(roots or {}) do
        names[#names + 1] = nodes[slug] and nodes[slug].name or slug
    end

    table.sort(names)

    if #names == 0 then
        return 'Digivolution Line'
    end

    if #names == 1 then
        return names[1] .. ' Line'
    end

    if #names == 2 then
        return names[1] .. ' / ' .. names[2]
    end

    return names[1] .. ' + ' .. tostring(#names - 1) .. ' Roots'
end

local function collect_descendants(root, nodes)
    local set = {}
    local queue = {root}
    local index = 1

    while index <= #queue do
        local slug = queue[index]
        index = index + 1

        if nodes[slug] and not set[slug] then
            set[slug] = true

            for _, child in ipairs(nodes[slug].children) do
                if nodes[child] and not set[child] then
                    queue[#queue + 1] = child
                end
            end
        end
    end

    return set
end

local function set_signature(set)
    local keys = {}

    for slug in pairs(set) do
        keys[#keys + 1] = slug
    end

    table.sort(keys)

    return table.concat(keys, '|')
end

local function route_base_slug(slug)
    if type(slug) == 'string' and slug:sub(1, 2) == 'x_' then
        return slug:sub(3)
    end

    return slug
end

local function route_rule(from_slug, to_slug)
    from_slug = route_base_slug(from_slug)
    to_slug = route_base_slug(to_slug)

    return BM.evolution_rules
        and BM.evolution_rules[from_slug]
        and BM.evolution_rules[from_slug][to_slug]
end

local function route_is_standard(rule)
    if not rule then
        return true
    end

    if rule.device or rule.bad_path or rule.min_hunger or rule.min_care then
        return false
    end

    local note = string.lower(tostring(rule.note or ''))

    if note:find('hungry', 1, true)
    or note:find('care', 1, true)
    or note:find('crisis', 1, true)
    or note:find('device', 1, true)
    or note:find('armor', 1, true)
    or note:find('bad', 1, true) then
        return false
    end

    return true
end

local function route_priority(rule)
    if not route_is_standard(rule) then
        return -100
    end

    local note = string.lower(tostring(rule and rule.note or ''))

    if note:find('alternate', 1, true) then
        return 10
    end

    if note:find('standard', 1, true) then
        return 30
    end

    return 20
end

local function choose_standard_child(slug, page, nodes)
    local node = nodes[slug]

    if not node then
        return nil
    end

    local best = nil
    local best_score = -math.huge

    for _, child in ipairs(node.children or {}) do
        if page.node_set[child] then
            local score = route_priority(route_rule(slug, child))

            if score > best_score then
                best = child
                best_score = score
            end
        end
    end

    if best_score < 0 then
        return nil
    end

    return best
end

local function lane_offset(index)
    local distance = math.ceil(index / 2)

    if index % 2 == 1 then
        return -distance
    end

    return distance
end

local function round_lane(value)
    if value >= 0 then
        return math.floor(value + 0.5)
    end

    return math.ceil(value - 0.5)
end

local function layout_page(page, nodes, all_edges)
    local primary_child = {}

    for slug in pairs(page.node_set) do
        primary_child[slug] = choose_standard_child(slug, page, nodes)
    end

    local occupied = {}
    local lanes = {}

    for col = 1, #STAGE_LABEL do
        occupied[col] = {}
    end

    local function claim_lane(slug, preferred)
        if lanes[slug] ~= nil then
            return lanes[slug]
        end

        local node = nodes[slug]

        if not node then
            return preferred or 0
        end

        preferred = round_lane(preferred or 0)
        local lane = preferred

        if occupied[node.col][lane] then
            local radius = 1

            while radius < 40 do
                local upper = preferred - radius
                local lower = preferred + radius

                if not occupied[node.col][upper] then
                    lane = upper
                    break
                end

                if not occupied[node.col][lower] then
                    lane = lower
                    break
                end

                radius = radius + 1
            end
        end

        lanes[slug] = lane
        occupied[node.col][lane] = slug

        return lane
    end

    local function move_lane(slug, target)
        local node = nodes[slug]
        local current = lanes[slug]

        if not node or current == nil then
            return false
        end

        target = round_lane(target)

        if current == target then
            return true
        end

        local owner = occupied[node.col][target]

        if owner and owner ~= slug then
            return false
        end

        occupied[node.col][current] = nil
        occupied[node.col][target] = slug
        lanes[slug] = target

        return true
    end

    local visiting = {}

    local function assign_branch(slug, preferred)
        if not page.node_set[slug] or lanes[slug] ~= nil or visiting[slug] then
            return
        end

        visiting[slug] = true

        local lane = claim_lane(slug, preferred)
        local main_child = primary_child[slug]

        if main_child and page.node_set[main_child] then
            assign_branch(main_child, lane)
        end

        local branch_index = 0

        for _, child in ipairs(nodes[slug].children or {}) do
            if page.node_set[child] and child ~= main_child then
                branch_index = branch_index + 1
                assign_branch(child, lane + lane_offset(branch_index))
            end
        end

        visiting[slug] = nil
    end

    table.sort(page.roots, function(a, b)
        return (nodes[a] and nodes[a].name or a) < (nodes[b] and nodes[b].name or b)
    end)

    local root_count = #page.roots

    for index, root in ipairs(page.roots) do
        local root_lane = 0

        if root_count > 1 then
            root_lane = (index - (root_count + 1) / 2) * 2
        end

        assign_branch(root, root_lane)
    end

    for slug in pairs(page.node_set) do
        if lanes[slug] == nil then
            assign_branch(slug, 0)
        end
    end

    for _ = 1, 5 do
        for slug in pairs(page.node_set) do
            local parent_lanes = {}

            for _, parent in ipairs(nodes[slug].parents or {}) do
                if page.node_set[parent] and lanes[parent] ~= nil then
                    parent_lanes[#parent_lanes + 1] = lanes[parent]
                end
            end

            if #parent_lanes > 1 then
                local total = 0

                for _, lane in ipairs(parent_lanes) do
                    total = total + lane
                end

                move_lane(slug, total / #parent_lanes)
            end
        end

        for slug in pairs(page.node_set) do
            local child = primary_child[slug]

            if child and page.node_set[child] then
                local parent_count = 0

                for _, parent in ipairs(nodes[child].parents or {}) do
                    if page.node_set[parent] then
                        parent_count = parent_count + 1
                    end
                end

                if parent_count <= 1 then
                    move_lane(child, lanes[slug] or 0)
                end
            end
        end
    end

    local min_lane = 0
    local max_lane = 0

    for slug in pairs(page.node_set) do
        local lane = lanes[slug] or 0
        min_lane = math.min(min_lane, lane)
        max_lane = math.max(max_lane, lane)
    end

    local content_h = CARD_H + (max_lane - min_lane) * NODE_STEP
    local fixed_space = CANVAS_H - WORLD_TOP - WORLD_BOTTOM

    if content_h <= fixed_space then
        page.world_h = CANVAS_H
        page.base_y = WORLD_TOP + (fixed_space - content_h) / 2 - min_lane * NODE_STEP
    else
        page.world_h = WORLD_TOP + WORLD_BOTTOM + content_h
        page.base_y = WORLD_TOP - min_lane * NODE_STEP
    end

    page.positions = {}
    page.lanes = lanes
    page.primary_child = primary_child

    for slug in pairs(page.node_set) do
        local node = nodes[slug]
        local lane = lanes[slug] or 0

        page.positions[slug] = {
            x = STAGE_X[node.col],
            y = page.base_y + lane * NODE_STEP,
        }
    end

    page.edges = {}

    for _, edge in ipairs(all_edges) do
        if page.node_set[edge.from] and page.node_set[edge.to] then
            page.edges[#page.edges + 1] = edge
        end
    end

    local max_pan_y = math.max(0, page.world_h - CANVAS_H)
    local lane_zero_y = page.base_y + CARD_H / 2
    page.initial_pan_y = math.max(0, math.min(max_pan_y, lane_zero_y - CANVAS_H / 2))
end

local function x_compatible(slug)
    if BM.can_x_evolve_to then
        return BM.can_x_evolve_to(slug)
    end

    return BM.x_antibody_viable
        and BM.x_antibody_viable[slug] == true
end

local function make_x_map_node(slug)
    local def = BM.joker_defs and BM.joker_defs[slug]

    if not def or not x_compatible(slug) then
        return nil
    end

    local col = STAGE_COL[def.stage]

    if not col then
        return nil
    end

    local form = BM.x_antibody_forms and BM.x_antibody_forms[slug]

    return {
        slug = 'x_' .. slug,
        base_slug = slug,
        name = (def.name or slug) .. ' X',
        stage = def.stage,
        col = col,
        x_form = true,
        atlas_key = form and form.atlas or BM.X_ANTIBODY_ATLAS,
        pos = form and form.pos or nil,
        parents = {},
        children = {},
    }
end

function BM.build_evolution_map_layout()
    local nodes = {}
    local edges = {}

    for slug, def in pairs(BM.joker_defs or {}) do
        local col = STAGE_COL[def.stage]
        local center = G.P_CENTERS and G.P_CENTERS[BM.center_key(slug)]

        if col and center and slug ~= 'recovery_digitama' then
            nodes[slug] = {
                slug = slug,
                name = def.name or slug,
                stage = def.stage,
                col = col,
                center = center,
                parents = {},
                children = {},
            }
        end
    end

    for slug, node in pairs(nodes) do
        local def = BM.joker_defs[slug]

        for _, target in ipairs(split_targets(def and def.evolves_to)) do
            if nodes[target] then
                node.children[#node.children + 1] = target
                nodes[target].parents[#nodes[target].parents + 1] = slug

                edges[#edges + 1] = {
                    from = slug,
                    to = target,
                    rule = route_rule(slug, target),
                }
            end
        end
    end

    local roots = {}

    for slug, node in pairs(nodes) do
        if not node.x_form and #node.parents == 0 then
            roots[#roots + 1] = slug
        end
    end

    table.sort(roots, function(a, b)
        local ac = nodes[a].col or 99
        local bc = nodes[b].col or 99

        if ac ~= bc then
            return ac < bc
        end

        return nodes[a].name < nodes[b].name
    end)

    local forced_groups = {
        leafmon_chibomon = {
            name = 'Leafmon / Chibomon Line',
            roots = {
                leafmon = true,
                chibomon = true,
            }
        }
    }

    local forced_by_root = {}

    for key, group in pairs(forced_groups) do
        for root in pairs(group.roots) do
            forced_by_root[root] = key
        end
    end

    local normal_pages = {}
    local signature_pages = {}
    local forced_pages = {}
    local covered = {}

    for _, root in ipairs(roots) do
        local set = collect_descendants(root, nodes)
        local forced_key = forced_by_root[root]
        local page

        if forced_key then
            page = forced_pages[forced_key]

            if not page then
                page = {
                    roots = {},
                    node_set = {},
                    forced_name = forced_groups[forced_key].name,
                    x_page = false,
                }

                forced_pages[forced_key] = page
                normal_pages[#normal_pages + 1] = page
            end

            for slug in pairs(set) do
                page.node_set[slug] = true
            end
        else
            local signature = set_signature(set)
            page = signature_pages[signature]

            if not page then
                page = {
                    roots = {},
                    node_set = set,
                    x_page = false,
                }

                signature_pages[signature] = page
                normal_pages[#normal_pages + 1] = page
            end
        end

        page.roots[#page.roots + 1] = root

        for slug in pairs(set) do
            covered[slug] = true
        end
    end

    for slug, node in pairs(nodes) do
        if not node.x_form and not covered[slug] then
            local set = {}
            local queue = {slug}
            local index = 1

            while index <= #queue do
                local current = queue[index]
                index = index + 1

                if nodes[current] and not nodes[current].x_form and not set[current] and not covered[current] then
                    set[current] = true
                    covered[current] = true

                    for _, other in ipairs(nodes[current].parents) do
                        queue[#queue + 1] = other
                    end

                    for _, other in ipairs(nodes[current].children) do
                        queue[#queue + 1] = other
                    end
                end
            end

            normal_pages[#normal_pages + 1] = {
                roots = {slug},
                node_set = set,
                x_page = false,
            }
        end
    end

    local filtered_pages = {}

    for _, page in ipairs(
        normal_pages
    ) do
        local standalone_bancho =
            page.roots
            and #page.roots == 1
            and page.roots[1]
                == 'bancholeomon'

        if not standalone_bancho then
            local has_leomon =
                false

            for slug in pairs(
                page.node_set or {}
            ) do
                if slug
                    ~= 'bancholeomon'
                and slug
                    ~= 'bancholeomon_burst_mode'
                and BM.is_leomon_slug(
                    slug
                ) then
                    has_leomon =
                        true

                    break
                end
            end

            if has_leomon then
                if nodes.bancholeomon then
                    page.node_set
                        .bancholeomon =
                        true
                end

                if nodes[
                    'bancholeomon_burst_mode'
                ] then
                    page.node_set[
                        'bancholeomon_burst_mode'
                    ] =
                        true
                end
            end

            filtered_pages[
                #filtered_pages + 1
            ] =
                page
        end
    end

    normal_pages =
        filtered_pages



    local baby_order = {}
    local next_baby_order = 1

    for _, entry in ipairs(BM.shop_joker_keys or {}) do
        local key = type(entry) == 'table' and entry.key or entry

        if key then
            for slug, node in pairs(nodes) do
                if not node.x_form
                and node.col == 1
                and not baby_order[slug]
                and BM.center_key(slug) == key then
                    baby_order[slug] = next_baby_order
                    next_baby_order = next_baby_order + 1
                    break
                end
            end
        end
    end

    local fallback_babies = {}

    for slug, node in pairs(nodes) do
        if not node.x_form and node.col == 1 and not baby_order[slug] then
            fallback_babies[#fallback_babies + 1] = slug
        end
    end

    table.sort(fallback_babies, function(a, b)
        local ao = nodes[a].center and nodes[a].center.order or math.huge
        local bo = nodes[b].center and nodes[b].center.order or math.huge

        if ao ~= bo then
            return ao < bo
        end

        return nodes[a].name < nodes[b].name
    end)

    for _, slug in ipairs(fallback_babies) do
        baby_order[slug] = next_baby_order
        next_baby_order = next_baby_order + 1
    end

    for _, page in ipairs(normal_pages) do
        page.name = page.forced_name or page_name(page.roots, nodes)

        if page.forced_name == 'Leafmon / Chibomon Line' then
            page.sort_order = baby_order.chibomon or math.huge
        else
            page.sort_order = math.huge

            for _, root in ipairs(page.roots or {}) do
                page.sort_order = math.min(
                    page.sort_order,
                    baby_order[root] or math.huge
                )
            end
        end

        layout_page(page, nodes, edges)
    end

    table.sort(normal_pages, function(a, b)
        if a.sort_order ~= b.sort_order then
            return a.sort_order < b.sort_order
        end

        return a.name < b.name
    end)

    local x_slugs = {}

    for slug in pairs(BM.joker_defs or {}) do
        if x_compatible(slug) then
            local x_node = make_x_map_node(slug)

            if x_node then
                nodes[x_node.slug] = x_node
                x_slugs[#x_slugs + 1] = slug
            end
        end
    end

    table.sort(x_slugs, function(a, b)
        local an = BM.joker_defs[a] and BM.joker_defs[a].name or a
        local bn = BM.joker_defs[b] and BM.joker_defs[b].name or b
        return an < bn
    end)

    local x_edges = {}

    for _, slug in ipairs(x_slugs) do
        local from_id = 'x_' .. slug
        local from_node = nodes[from_id]
        local def = BM.joker_defs[slug]
        local targets = {}
        local seen_targets = {}

        if from_node and def then
            for _, target in ipairs(split_targets(def.evolves_to)) do
                if x_compatible(target) and not seen_targets[target] then
                    seen_targets[target] = true
                    targets[#targets + 1] = target
                end
            end

            local extras = BM.x_antibody_extra_evolutions
                and BM.x_antibody_extra_evolutions[slug]

            for _, target in ipairs(extras or {}) do
                target = BM.slug(target)

                if target ~= ''
                and x_compatible(target)
                and not seen_targets[target] then
                    seen_targets[target] = true
                    targets[#targets + 1] = target
                end
            end

            for _, target in ipairs(targets) do
                local to_id = 'x_' .. target

                if nodes[to_id] then
                    from_node.children[#from_node.children + 1] = to_id
                    nodes[to_id].parents[#nodes[to_id].parents + 1] = from_id

                    local edge = {
                        from = from_id,
                        to = to_id,
                        rule = route_rule(slug, target),
                        x_route = true,
                    }

                    x_edges[#x_edges + 1] = edge
                    edges[#edges + 1] = edge
                end
            end
        end
    end

    local x_roots = {}

    for _, slug in ipairs(x_slugs) do
        local id = 'x_' .. slug
        local node = nodes[id]

        if node and #node.parents == 0 then
            x_roots[#x_roots + 1] = id
        end
    end

    table.sort(x_roots, function(a, b)
        local an = nodes[a] and nodes[a].name or a
        local bn = nodes[b] and nodes[b].name or b
        return an < bn
    end)

    local x_forced_groups = {
        gomamon_crabmon = {
            name = 'Gomamon / Crabmon Line',
            roots = {
                x_gomamon = true,
                x_crabmon = true,
            },
        },
    }

    local x_forced_by_root = {}

    for key, group in pairs(x_forced_groups) do
        for root in pairs(group.roots) do
            x_forced_by_root[root] = key
        end
    end

    local x_pages = {}
    local x_signatures = {}
    local x_forced_pages = {}

    for _, root in ipairs(x_roots) do
        local set = collect_descendants(root, nodes)
        local forced_key = x_forced_by_root[root]
        local page

        if forced_key then
            page = x_forced_pages[forced_key]

            if not page then
                page = {
                    roots = {},
                    node_set = {},
                    x_page = true,
                    forced_name = x_forced_groups[forced_key].name,
                }

                x_forced_pages[forced_key] = page
                x_pages[#x_pages + 1] = page
            end

            for node_id in pairs(set) do
                page.node_set[node_id] = true
            end
        else
            local signature = set_signature(set)
            page = x_signatures[signature]

            if not page then
                page = {
                    roots = {},
                    node_set = set,
                    x_page = true,
                }

                x_signatures[signature] = page
                x_pages[#x_pages + 1] = page
            end
        end

        page.roots[#page.roots + 1] = root
    end

    local x_covered = {}

    for _, page in ipairs(x_pages) do
        for node_id in pairs(page.node_set) do
            x_covered[node_id] = true
        end
    end

    for _, slug in ipairs(x_slugs) do
        local id = 'x_' .. slug

        if nodes[id] and not x_covered[id] then
            local set = collect_descendants(id, nodes)

            x_pages[#x_pages + 1] = {
                roots = {id},
                node_set = set,
                x_page = true,
            }

            for node_id in pairs(set) do
                x_covered[node_id] = true
            end
        end
    end

    for _, page in ipairs(x_pages) do
        page.name = 'X-ANTIBODY - ' .. (page.forced_name or page_name(page.roots, nodes))
        layout_page(page, nodes, x_edges)
    end

    table.sort(x_pages, function(a, b)
        return a.name < b.name
    end)

    local pages = {}

    for _, page in ipairs(normal_pages) do
        pages[#pages + 1] = page
    end

    for _, page in ipairs(x_pages) do
        pages[#pages + 1] = page
    end

    BM.evolution_map_layout = {
        nodes = nodes,
        edges = edges,
        pages = pages,
    }

    BM.evolution_map_page = math.max(1, math.min(BM.evolution_map_page or 1, math.max(1, #pages)))

    return BM.evolution_map_layout
end

local function resolve_atlas_key(key)
    if not key then
        return nil
    end

    local candidates = {
        key,
        BM.PREFIX .. '_' .. key,
    }

    for _, candidate in ipairs(candidates) do
        if candidate and G.ASSET_ATLAS and G.ASSET_ATLAS[candidate] then
            return G.ASSET_ATLAS[candidate]
        end
    end

    return nil
end

local function evolution_map_unlock_all()
    local profile =
        G.PROFILES
        and G.SETTINGS
        and G.PROFILES[G.SETTINGS.profile]

    return profile
        and profile.all_unlocked == true
end

local function evolution_map_node_discovered(node)
    if evolution_map_unlock_all() then
        return true
    end

    if not node then
        return false
    end

    if node.stage == 'Fresh' then
        return true
    end

    if node.x_form then
        if BM.is_x_antibody_discovered then
            return BM.is_x_antibody_discovered(
                node.base_slug
            )
        end

        local center =
            G.P_CENTERS
            and G.P_CENTERS[
                BM.center_key(
                    node.base_slug
                )
            ]

        return center
            and center.discovered == true
    end

    return node.center
        and node.center.discovered == true
end

local function get_undiscovered_joker_sprite()
    local atlas =
        G.ASSET_ATLAS
        and G.ASSET_ATLAS.Joker

    local pos =
        G.j_undiscovered
        and G.j_undiscovered.pos

    return atlas, pos
end

local function resolve_atlas(center)
    if not center then
        return nil
    end

    local candidates = {
        center.atlas,
        center.atlas and BM.PREFIX .. '_' .. center.atlas or nil,
        BM.PREFIX .. '_Joker',
        'Joker',
    }

    for _, key in ipairs(candidates) do
        if key and G.ASSET_ATLAS and G.ASSET_ATLAS[key] then
            return G.ASSET_ATLAS[key]
        end
    end

    return nil
end

local function prepare_node_sprite(node)
    local discovered =
        evolution_map_node_discovered(
            node
        )

    if node.quad
    and node.atlas
    and node.sprite_discovered == discovered then
        return true
    end

    local atlas
    local pos

    if not discovered then
        atlas, pos =
            get_undiscovered_joker_sprite()

    elseif node.x_form then
        atlas =
            resolve_atlas_key(
                node.atlas_key
                or BM.X_ANTIBODY_ATLAS
            )

        pos = node.pos

    else
        atlas =
            resolve_atlas(
                node.center
            )

        pos =
            node.center
            and node.center.pos
    end

    if not atlas
    or not atlas.image
    or not pos then
        return false
    end

    local image_w,
        image_h =
        atlas.image:getDimensions()

    local px =
        atlas.px or 71

    local py =
        atlas.py or 95

    node.atlas = atlas

    node.quad =
        love.graphics.newQuad(
            pos.x * px,
            pos.y * py,
            px,
            py,
            image_w,
            image_h
        )

    node.source_w = px
    node.source_h = py
    node.sprite_discovered =
        discovered

    return true
end

local function draw_text_centered(text, x, y, width, size, colour)
    local font = G.LANG and G.LANG.font and G.LANG.font.FONT or love.graphics.getFont()

    if not font then
        return
    end

    love.graphics.setFont(font)

    local font_height = math.max(1, font:getHeight())
    local scale = (size or 20) / font_height

    love.graphics.setColor(colour_with_alpha(colour, colour and colour[4] or 1))
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.scale(scale, scale)
    love.graphics.printf(tostring(text or ''), 0, 0, width / scale, 'center')
    love.graphics.pop()
end

local function stage_colour(stage)
    if stage == 'In-Training' then
        return G.C.BLUE
    end

    if stage == 'Champion' or stage == 'Rare' then
        return G.C.ORANGE
    end

    if stage == 'Ultimate' then
        return G.C.PURPLE
    end

    if stage == 'Mega' then
        return G.C.RED
    end

    if stage == 'Beyond' then
        return G.C.GOLD
    end

    return G.C.GREEN
end

local function draw_edge(page, edge, nodes, pan_x, pan_y)
    local from = nodes[edge.from]
    local to = nodes[edge.to]
    local from_pos = page.positions[edge.from]
    local to_pos = page.positions[edge.to]

    if not from
    or not to
    or not from_pos
    or not to_pos then
        return
    end

    local from_idx =
        list_index(
            from.children,
            edge.to
        )

    local to_idx =
        list_index(
            to.parents,
            edge.from
        )

    local x1 =
        from_pos.x
        - pan_x
        + CARD_W
        + 7

    local x2 =
        to_pos.x
        - pan_x
        - 7

    local y1 =
        from_pos.y
        - pan_y
        + CARD_H / 2
        + port_offset(
            from_idx,
            #from.children
        )

    local y2 =
        to_pos.y
        - pan_y
        + CARD_H / 2
        + port_offset(
            to_idx,
            #to.parents
        )

    if math.max(y1, y2) < -80
    or math.min(y1, y2) > CANVAS_H + 80 then
        return
    end

    if math.max(x1, x2) < -80
    or math.min(x1, x2) > CANVAS_W + 80 then
        return
    end

    local dx =
        math.max(
            70,
            x2 - x1
        )

    local bend =
        math.max(
            72,
            math.min(
                135,
                dx * 0.38
            )
        )

    local curve =
        love.math.newBezierCurve(
            x1,
            y1,
            x1 + bend,
            y1,
            x2 - bend,
            y2,
            x2,
            y2
        )

    local points =
        curve:render(5)

    local colour =
        edge_colour(edge.rule)

    love.graphics.setLineWidth(10)
    love.graphics.setColor(
        0,
        0,
        0,
        0.52
    )
    love.graphics.line(points)

    love.graphics.setLineWidth(5)
    love.graphics.setColor(
        colour_with_alpha(
            colour,
            0.92
        )
    )
    love.graphics.line(points)

    love.graphics.circle(
        'fill',
        x2,
        y2,
        5
    )
end

local function draw_map_canvas(sprite)
    if not sprite or not sprite.canvas or not sprite.layout then
        return
    end

    local layout = sprite.layout
    local page_count = #layout.pages
    local page_index = math.max(1, math.min(sprite.page_index or 1, math.max(1, page_count)))
    local page = layout.pages[page_index]

    if not page then
        return
    end

    local pan_x = sprite.pan_x or 0
    local pan_y = sprite.pan_y or 0

    sprite.canvas:renderTo(function()
        local canvas_bg = G.C.BLACK
        love.graphics.clear(colour_with_alpha(canvas_bg, 1))

        love.graphics.setColor(1, 1, 1, 0.025)

        for x = 0, CANVAS_W, 50 do
            love.graphics.line(x, 0, x, CANVAS_H)
        end

        for y = 0, CANVAS_H, 50 do
            love.graphics.line(0, y, CANVAS_W, y)
        end

        for _, edge in ipairs(page.edges) do
            draw_edge(page, edge, layout.nodes, pan_x, pan_y)
        end

        for slug in pairs(page.node_set) do
            local node = layout.nodes[slug]
            local pos = page.positions[slug]

            if node and pos then
                local x = pos.x - pan_x
                local y = pos.y - pan_y

                if y + CARD_H + LABEL_H >= -40 and y <= CANVAS_H + 40 and x + CARD_W + 60 >= -40 and x <= CANVAS_W + 40 then
                    love.graphics.setColor(0, 0, 0, 0.5)
                    love.graphics.rectangle('fill', x - 7, y - 7, CARD_W + 14, CARD_H + LABEL_H + 14, 12, 12)

                    local border = stage_colour(node.stage)
                    love.graphics.setLineWidth(4)
                    love.graphics.setColor(colour_with_alpha(border, 0.72))
                    love.graphics.rectangle('line', x - 5, y - 5, CARD_W + 10, CARD_H + LABEL_H + 10, 11, 11)

                    if prepare_node_sprite(node) then
                        love.graphics.setColor(1, 1, 1, 1)
                        love.graphics.draw(
                            node.atlas.image,
                            node.quad,
                            x,
                            y,
                            0,
                            CARD_W / node.source_w,
                            CARD_H / node.source_h
                        )
                    else
                        love.graphics.setColor(0.18, 0.2, 0.24, 1)
                        love.graphics.rectangle('fill', x, y, CARD_W, CARD_H, 8, 8)
                        draw_text_centered('?', x, y + 54, CARD_W, sprite.font_large, G.C.UI.TEXT_LIGHT)
                    end

                    local display_name

                    if evolution_map_node_discovered(node) then
                        display_name = short_name(node.name)
                    else
                        display_name = 'Discover Me'
                    end

                    draw_text_centered(
                        display_name,
                        x - 34,
                        y + CARD_H + 7,
                        CARD_W + 68,
                        sprite.font_small,
                        G.C.UI.TEXT_LIGHT
                    )
                end
            end
        end

        love.graphics.setColor(colour_with_alpha(G.C.BLACK, 0.98))
        love.graphics.rectangle('fill', 0, 0, CANVAS_W, 100)
        love.graphics.setColor(1, 1, 1, 0.11)
        love.graphics.line(0, 100, CANVAS_W, 100)

        draw_text_centered(page.name, 24, 12, CANVAS_W - 48, sprite.font_title, G.C.UI.TEXT_LIGHT)
        draw_text_centered('Page ' .. tostring(page_index) .. ' / ' .. tostring(page_count), 24, 51, CANVAS_W - 48, sprite.font_page, G.C.UI.TEXT_INACTIVE)

        for col, label in ipairs(STAGE_LABEL) do
            draw_text_centered(label, STAGE_X[col] - 58 - pan_x, 76, CARD_W + 116, sprite.font_header, G.C.ATTENTION)
        end

        local max_pan_y = math.max(0, page.world_h - CANVAS_H)

        if max_pan_y > 0 then
            local track_h = CANVAS_H - 132
            local thumb_h = math.max(60, track_h * CANVAS_H / page.world_h)
            local thumb_y = 112 + (track_h - thumb_h) * (pan_y / max_pan_y)

            love.graphics.setColor(1, 1, 1, 0.08)
            love.graphics.rectangle('fill', CANVAS_W - 16, 112, 6, track_h, 3, 3)
            love.graphics.setColor(1, 1, 1, 0.34)
            love.graphics.rectangle('fill', CANVAS_W - 16, thumb_y, 6, thumb_h, 3, 3)
        end

        local max_pan_x =
            math.max(
                0,
                WORLD_W - CANVAS_W
            )

        if max_pan_x > 0 then
            local track_x = 12
            local track_y = CANVAS_H - 16
            local track_w = CANVAS_W - 40

            local thumb_w =
                math.max(
                    90,
                    track_w
                    * CANVAS_W
                    / WORLD_W
                )

            local thumb_x =
                track_x
                + (
                    track_w
                    - thumb_w
                )
                * (
                    pan_x
                    / max_pan_x
                )

            love.graphics.setColor(
                1,
                1,
                1,
                0.08
            )

            love.graphics.rectangle(
                'fill',
                track_x,
                track_y,
                track_w,
                6,
                3,
                3
            )

            love.graphics.setColor(
                1,
                1,
                1,
                0.34
            )

            love.graphics.rectangle(
                'fill',
                thumb_x,
                track_y,
                thumb_w,
                6,
                3,
                3
            )
        end
    end)
end

local function create_map_canvas(layout)
    local sprite = SMODS.CanvasSprite {
        X = 0,
        Y = 0,
        W = VIEW_W,
        H = VIEW_H,
        canvasW = CANVAS_W,
        canvasH = CANVAS_H,
        canvasScale = 1,
    }

    sprite.layout = layout
    sprite.page_index = BM.evolution_map_page or 1
    local initial_page = layout.pages[sprite.page_index or 1]
    sprite.pan_x = 0
    sprite.pan_y = initial_page and initial_page.initial_pan_y or 0
    sprite.dragging_map = false
    sprite.last_cursor_x = nil
    sprite.last_cursor_y = nil
    sprite.font_small = 22
    sprite.font_page = 20
    sprite.font_header = 20
    sprite.font_large = 48
    sprite.font_title = 34
    sprite.states.drag.can = false
    sprite.states.click.can = false
    sprite.states.hover.can = true

    sprite.cursor_inside = function(self)
        local cursor = G.CURSOR and G.CURSOR.T
        local transform = self.VT or self.T
        local room_x = G.ROOM and G.ROOM.T and G.ROOM.T.x or 0
        local room_y = G.ROOM and G.ROOM.T and G.ROOM.T.y or 0

        if not cursor or not transform then
            return false
        end

        local local_x = cursor.x - transform.x - room_x
        local local_y = cursor.y - transform.y - room_y

        return local_x >= 0
            and local_y >= 0
            and local_x <= transform.w
            and local_y <= transform.h
    end

    sprite.scroll_x_pixels = function(self, amount)
        local max_pan_x =
            math.max(
                0,
                WORLD_W - CANVAS_W
            )

        local old_pan =
            self.pan_x or 0

        self.pan_x =
            math.max(
                0,
                math.min(
                    max_pan_x,
                    old_pan + amount
                )
            )

        if self.pan_x ~= old_pan then
            draw_map_canvas(self)
            return true
        end

        return false
    end

    sprite.scroll_pixels = function(self, amount)
        local page = self.layout.pages[self.page_index or 1]

        if not page then
            return false
        end

        local max_pan_y = math.max(0, page.world_h - CANVAS_H)
        local old_pan = self.pan_y or 0
        self.pan_y = math.max(0, math.min(max_pan_y, old_pan + amount))

        if self.pan_y ~= old_pan then
            draw_map_canvas(self)
            return true
        end

        return false
    end

    local base_update = sprite.update

    sprite.update = function(self, dt)
        if base_update then
            base_update(self, dt)
        end

        local page = self.layout.pages[self.page_index or 1]
        local cursor = G.CURSOR and G.CURSOR.T
        local room_x = G.ROOM and G.ROOM.T and G.ROOM.T.x or 0
        local room_y = G.ROOM and G.ROOM.T and G.ROOM.T.y or 0
        local transform = self.VT or self.T

        if not page or not cursor or not transform then
            return
        end

        local local_x = cursor.x - transform.x - room_x
        local local_y = cursor.y - transform.y - room_y
        local inside = self:cursor_inside()
        local mouse_down = love.mouse.isDown(1)

        if mouse_down and inside and not self.dragging_map then
            self.dragging_map = true
            self.last_cursor_x = cursor.x
            self.last_cursor_y = cursor.y
        elseif not mouse_down then
            self.dragging_map = false
            self.last_cursor_x = nil
            self.last_cursor_y = nil
        end

        if self.dragging_map and mouse_down and self.last_cursor_x and self.last_cursor_y then
            local dx = cursor.x - self.last_cursor_x
            local dy = cursor.y - self.last_cursor_y
            self.last_cursor_x = cursor.x
            self.last_cursor_y = cursor.y

            if dx ~= 0 then
                local px_per_unit_x = CANVAS_W / math.max(0.01, transform.w)
                self:scroll_x_pixels(-dx * px_per_unit_x)
            end
            if dy ~= 0 then
                local px_per_unit_y = CANVAS_H / math.max(0.01, transform.h)
                self:scroll_pixels(-dy * px_per_unit_y)
            end
        end
    end

    draw_map_canvas(sprite)

    return sprite
end

local old_balatromon_wheelmoved = love.wheelmoved

love.wheelmoved = function(x, y)
    local canvas = BM.evolution_map_canvas
    local holder = G.OVERLAY_MENU
        and G.OVERLAY_MENU.get_UIE_by_ID
        and G.OVERLAY_MENU:get_UIE_by_ID('balatromon_evolution_map_holder')

    if canvas and holder and canvas.cursor_inside and canvas:cursor_inside() then
        local shift_down = love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')
        if shift_down and (y or 0) ~= 0 then
            if canvas:scroll_x_pixels(
                -(y or 0) * 105
            ) then
                return
            end
        elseif (y or 0) ~= 0 then
            if canvas:scroll_pixels(
                -(y or 0) * 105
            ) then
                return
            end
        end
    end

    if old_balatromon_wheelmoved then
        return old_balatromon_wheelmoved(x, y)
    end
end

local function legend_chip(text, colour)
    return {
        n = G.UIT.C,
        config = {align = 'cm', minw = 1.35, padding = 0.025},
        nodes = {
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.02},
                nodes = {
                    {
                        n = G.UIT.B,
                        config = {w = 0.34, h = 0.12, r = 0.03, colour = colour}
                    },
                    {
                        n = G.UIT.T,
                        config = {text = text, colour = G.C.UI.TEXT_LIGHT, scale = 0.24, shadow = true}
                    }
                }
            }
        }
    }
end

local function change_page(delta)
    local layout = BM.evolution_map_layout
    local canvas = BM.evolution_map_canvas

    if not layout or not canvas or #layout.pages == 0 then
        return
    end

    local count = #layout.pages
    local next_page = (canvas.page_index or BM.evolution_map_page or 1) + delta

    if next_page < 1 then
        next_page = count
    elseif next_page > count then
        next_page = 1
    end

    BM.evolution_map_page = next_page
    canvas.page_index = next_page
    local page = layout.pages[next_page]
    canvas.pan_x = 0
    canvas.pan_y = page and page.initial_pan_y or 0
    canvas.dragging_map = false
    canvas.last_cursor_x = nil
    canvas.last_cursor_y = nil
    draw_map_canvas(canvas)
end

G.FUNCS.balatromon_evolution_map_prev = function()
    change_page(-1)
end

G.FUNCS.balatromon_evolution_map_next = function()
    change_page(1)
end

function BM.create_evolution_map_ui()
    local layout = BM.evolution_map_layout or BM.build_evolution_map_layout()
    local canvas = create_map_canvas(layout)
    BM.evolution_map_canvas = canvas

    return create_UIBox_generic_options {
        back_func = BM.evolution_map_origin == 'options' and 'options' or 'exit_overlay_menu',
        contents = {
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.012},
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = 'DIGIVOLUTION',
                            colour = G.C.UI.TEXT_LIGHT,
                            scale = 0.48,
                            shadow = true,
                        }
                    }
                }
            },
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.005},
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = ' ',
                            colour = G.C.UI.TEXT_INACTIVE,
                            scale = 0.20,
                        }
                    }
                }
            },
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.015},
                nodes = {
                    {
                        n = G.UIT.C,
                        config = {
                            align = 'cm',
                            minw = VIEW_W,
                            maxw = VIEW_W,
                            minh = VIEW_H,
                            maxh = VIEW_H,
                            padding = 0.02,
                            r = 0.08,
                            id = 'balatromon_evolution_map_holder',
                            colour = G.C.BLACK,
                        },
                        nodes = {
                            {
                                n = G.UIT.O,
                                config = {object = canvas}
                            }
                        }
                    }
                }
            },
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.014},
                nodes = {
                    {
                        n = G.UIT.C,
                        config = {align = 'cm', minw = 3.0, minh = 0.52},
                        nodes = {
                            UIBox_button {
                                button = 'balatromon_evolution_map_prev',
                                label = {'PREV'},
                                minw = 2.8,
                                minh = 0.50,
                                scale = 0.30,
                                colour = G.C.BLUE,
                            }
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = {align = 'cm', minw = 0.45},
                        nodes = {}
                    },
                    {
                        n = G.UIT.C,
                        config = {align = 'cm', minw = 3.0, minh = 0.52},
                        nodes = {
                            UIBox_button {
                                button = 'balatromon_evolution_map_next',
                                label = {'NEXT'},
                                minw = 2.8,
                                minh = 0.50,
                                scale = 0.30,
                                colour = G.C.BLUE,
                            }
                        }
                    },
                }
            },
            {
                n = G.UIT.R,
                config = {align = 'cm', padding = 0.012},
                nodes = {
                    legend_chip('Standard', G.C.GREEN),
                    legend_chip('Hungry', G.C.ORANGE),
                    legend_chip('Care', G.C.YELLOW),
                    legend_chip('Crisis', G.C.RED),
                    legend_chip('Device', G.C.PURPLE),
                }
            }
        }
    }
end

function BM.open_evolution_map(origin)
    BM.evolution_map_origin = origin or 'main_menu'
    BM.evolution_map_layout = BM.build_evolution_map_layout()
    BM.evolution_map_page = math.max(1, math.min(BM.evolution_map_page or 1, math.max(1, #BM.evolution_map_layout.pages)))
    G.SETTINGS.paused = true

    G.FUNCS.overlay_menu {
        definition = BM.create_evolution_map_ui()
    }
end

G.FUNCS.balatromon_open_evolution_map_main = function()
    BM.open_evolution_map('main_menu')
end

G.FUNCS.balatromon_open_evolution_map_options = function()
    BM.open_evolution_map('options')
end

local old_options = create_UIBox_options

create_UIBox_options = function(...)
    local ui = old_options(...)

    local button = UIBox_button {
        button = 'balatromon_open_evolution_map_options',
        id = 'balatromon_options_evolution_map',
        label = {'DIGIVOLUTION'},
        minw = 5,
        minh = 0.55,
        scale = 0.35,
        colour = G.C.PURPLE,
    }

    local target =
        ui
        and ui.nodes
        and ui.nodes[1]
        and ui.nodes[1].nodes
        and ui.nodes[1].nodes[1]
        and ui.nodes[1].nodes[1].nodes
        and ui.nodes[1].nodes[1].nodes[1]
        and ui.nodes[1].nodes[1].nodes[1].nodes

    if target then
        target[#target + 1] = button
    end

    return ui
end

local old_main_menu = set_main_menu_UI

set_main_menu_UI = function(...)
    local base_button = UIBox_button
    local inserted = false

    UIBox_button = function(args)
        if args and args.id == 'mods_button' and not inserted then
            inserted = true

            local original_h = args.minh or 1.1
            local original_w = args.minw or 2.7
            local original_scale = args.scale or 0.5
            local half_h = math.max(0.42, original_h * 0.46)

            local mods_args = {}

            for key, value in pairs(args) do
                mods_args[key] = value
            end

            mods_args.minw = original_w
            mods_args.minh = half_h
            mods_args.scale = original_scale * 0.72
            mods_args.col = true

            local mods_button = base_button(mods_args)

            local map_button = base_button {
                id = 'balatromon_evolution_map_main',
                button = 'balatromon_open_evolution_map_main',
                label = {'DIGIVOLUTION'},
                minw = original_w,
                minh = half_h,
                scale = original_scale * 0.52,
                colour = G.C.PURPLE,
                col = true,
            }

            return {
                n = G.UIT.C,
                config = {
                    align = 'cm',
                    minw = original_w,
                    maxw = original_w,
                    minh = original_h,
                    maxh = original_h,
                    padding = 0.01,
                },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = {
                            align = 'cm',
                            minw = original_w,
                            maxw = original_w,
                            minh = half_h,
                            maxh = half_h,
                        },
                        nodes = {
                            mods_button,
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = {
                            align = 'cm',
                            minw = original_w,
                            maxw = original_w,
                            minh = half_h,
                            maxh = half_h,
                        },
                        nodes = {
                            map_button,
                        }
                    },
                }
            }
        end

        return base_button(args)
    end

    local result = {pcall(old_main_menu, ...)}
    UIBox_button = base_button

    if not result[1] then
        error(result[2])
    end

    return unpack(result, 2)
end
