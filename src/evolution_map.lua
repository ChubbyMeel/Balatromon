local BM = Balatromon

BM.evolution_map_row = BM.evolution_map_row or 1
BM.evolution_map_rows_visible = 5
BM.evolution_map_layout = nil

local STAGE_COL = {
    Fresh=1,
    ['In-Training']=2,
    Rookie=3,
    Champion=4,
    Rare=4,
    Ultimate=5,
    Mega=6,
}

local STAGE_LABEL = {
    'FRESH',
    'IN-TRAINING',
    'ROOKIE',
    'CHAMPION / RARE',
    'ULTIMATE',
    'MEGA',
}

local function split_targets(text)
    local out = {}

    for part in tostring(text or ''):gmatch('[^,]+') do
        local name = part:match('^%s*(.-)%s*$')

        if name ~= ''
        and name ~= '-' then
            out[#out+1] =
                BM.slug(name)
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

function BM.build_evolution_map_layout()
    local nodes = {}
    local edges = {}

    for slug, def in pairs(
        BM.joker_defs or {}
    ) do
        local col =
            STAGE_COL[def.stage]

        local center =
            G.P_CENTERS
            and G.P_CENTERS[
                BM.center_key(slug)
            ]

        if col
        and center
        and slug ~= 'recovery_digitama' then
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
        local def =
            BM.joker_defs[slug]

        for _, target in ipairs(
            split_targets(
                def
                and def.evolves_to
            )
        ) do
            if nodes[target] then
                node.children[
                    #node.children+1
                ] = target

                nodes[target].parents[
                    #nodes[target].parents+1
                ] = slug

                edges[#edges+1] = {
                    from = slug,
                    to = target,

                    rule =
                        BM.evolution_rules
                        and BM.evolution_rules[
                            slug
                        ]
                        and BM.evolution_rules[
                            slug
                        ][target]
                }
            end
        end
    end

    local desired = {}
    local visiting = {}
    local next_row = 1

    local function place(slug)
        if desired[slug] then
            return desired[slug]
        end

        if visiting[slug] then
            return next_row
        end

        visiting[slug] = true

        local node =
            nodes[slug]

        local total = 0
        local count = 0

        for _, child in ipairs(
            node.children
        ) do
            if nodes[child] then
                total =
                    total
                    + place(child)

                count =
                    count + 1
            end
        end

        if count > 0 then
            desired[slug] =
                total / count
        else
            desired[slug] =
                next_row

            next_row =
                next_row + 1
        end

        visiting[slug] = nil

        return desired[slug]
    end

    local roots = {}

    for slug, node in pairs(nodes) do
        if #node.parents == 0 then
            roots[#roots+1] =
                slug
        end
    end

    table.sort(
        roots,
        function(a,b)
            local na =
                nodes[a]

            local nb =
                nodes[b]

            if na.col ~= nb.col then
                return na.col < nb.col
            end

            return na.name < nb.name
        end
    )

    for _, slug in ipairs(roots) do
        place(slug)

        next_row =
            next_row + 1
    end

    for slug in pairs(nodes) do
        if not desired[slug] then
            place(slug)
        end
    end

    local by_position = {}
    local total_rows = 1

    for col=1,#STAGE_LABEL do
        by_position[col] = {}

        local list = {}

        for _, node in pairs(nodes) do
            if node.col == col then
                list[#list+1] =
                    node
            end
        end

        table.sort(
            list,
            function(a,b)
                local ar =
                    desired[a.slug]
                    or 0

                local br =
                    desired[b.slug]
                    or 0

                if ar ~= br then
                    return ar < br
                end

                return a.name < b.name
            end
        )

        local last = 0

        for _, node in ipairs(list) do
            local row =
                math.max(
                    last+1,
                    math.floor(
                        (
                            desired[
                                node.slug
                            ]
                            or 1
                        )
                        + 0.5
                    )
                )

            node.row = row

            by_position[col][row] =
                node

            last = row

            total_rows =
                math.max(
                    total_rows,
                    row
                )
        end
    end

    BM.evolution_map_layout = {
        nodes = nodes,
        edges = edges,
        by_position =
            by_position,
        total_rows =
            total_rows,
    }

    return BM.evolution_map_layout
end

BM.EvolutionMapEdges =
    Moveable:extend()

function BM.EvolutionMapEdges:init(
    edges,
    previews
)
    Moveable.init(
        self,
        0,
        0,
        0,
        0
    )

    self.edges =
        edges or {}

    self.previews =
        previews or {}

    self.states.collide.can =
        false

    self.states.hover.can =
        false

    self.states.click.can =
        false

    self.states.drag.can =
        false
end

function BM.EvolutionMapEdges:draw()
    if not self.states.visible then
        return
    end

    love.graphics.push()

    love.graphics.scale(
        G.TILESCALE
        * G.TILESIZE
    )

    love.graphics.setLineWidth(
        0.04
    )

    for _, edge in ipairs(
        self.edges
    ) do
        local a =
            self.previews[
                edge.from
            ]

        local b =
            self.previews[
                edge.to
            ]

        if a
        and b
        and a.VT
        and b.VT then
            local c =
                edge_colour(
                    edge.rule
                )

            love.graphics.setColor(
                c[1],
                c[2],
                c[3],
                0.85
            )

            local x1 =
                a.VT.x
                + a.VT.w

            local y1 =
                a.VT.y
                + a.VT.h/2

            local x2 =
                b.VT.x

            local y2 =
                b.VT.y
                + b.VT.h/2

            local mid =
                (x1+x2)/2

            if math.abs(
                x2-x1
            ) < 0.05 then
                x1 =
                    a.VT.x
                    + a.VT.w/2

                x2 =
                    b.VT.x
                    + b.VT.w/2

                mid = x1
            end

            love.graphics.line(
                x1,
                y1,
                mid,
                y1,
                mid,
                y2,
                x2,
                y2
            )
        end
    end

    love.graphics.setColor(
        1,
        1,
        1,
        1
    )

    love.graphics.pop()
end

local function map_card(node)
    local card =
        Card(
            0,
            0,

            G.CARD_W*0.42,
            G.CARD_H*0.42,

            nil,
            node.center,

            {
                bypass_discovery_center =
                    true,

                bypass_discovery_ui =
                    true,

                bypass_lock =
                    true,
            }
        )

    card.states.drag.can =
        false

    card.states.click.can =
        false

    card.states.hover.can =
        true

    return card
end

local function map_cell(
    node,
    previews
)
    if not node then
        return {
            n = G.UIT.C,

            config = {
                align = 'cm',
                minw = 1.75,
                minh = 1.15,
            },

            nodes = {}
        }
    end

    local card =
        map_card(node)

    previews[node.slug] =
        card

    return {
        n = G.UIT.C,

        config = {
            align = 'cm',
            minw = 1.75,
            minh = 1.15,
            padding = 0.015,
        },

        nodes = {
            {
                n = G.UIT.O,

                config = {
                    object = card
                }
            },

            {
                n = G.UIT.T,

                config = {
                    text =
                        node.name,

                    colour =
                        G.C.UI.TEXT_LIGHT,

                    scale =
                        0.17,

                    shadow =
                        true
                }
            },

            {
                n = G.UIT.T,

                config = {
                    text =
                        node.stage,

                    colour =
                        G.C.UI.TEXT_INACTIVE,

                    scale =
                        0.13
                }
            }
        }
    }
end

local function legend(
    text,
    colour
)
    return {
        n = G.UIT.R,

        config = {
            align = 'cm',
            padding = 0.015,
        },

        nodes = {
            {
                n = G.UIT.B,

                config = {
                    w = 0.22,
                    h = 0.08,
                    colour = colour,
                    r = 0.02
                }
            },

            {
                n = G.UIT.T,

                config = {
                    text = text,

                    colour =
                        G.C.UI.TEXT_INACTIVE,

                    scale =
                        0.18
                }
            }
        }
    }
end

function BM.create_evolution_map_content()
    local layout =
        BM.evolution_map_layout
        or BM.build_evolution_map_layout()

    local shown =
        BM.evolution_map_rows_visible

    local max_start =
        math.max(
            1,

            layout.total_rows
            - shown
            + 1
        )

    BM.evolution_map_row =
        math.max(
            1,

            math.min(
                BM.evolution_map_row
                or 1,

                max_start
            )
        )

    local first =
        BM.evolution_map_row

    local last =
        math.min(
            layout.total_rows,
            first+shown-1
        )

    local previews = {}
    local rows = {}
    local headers = {}

    for _, label in ipairs(
        STAGE_LABEL
    ) do
        headers[#headers+1] = {
            n = G.UIT.C,

            config = {
                align = 'cm',
                minw = 1.75,
            },

            nodes = {
                {
                    n = G.UIT.T,

                    config = {
                        text =
                            label,

                        colour =
                            G.C.ATTENTION,

                        scale =
                            0.22,

                        shadow =
                            true
                    }
                }
            }
        }
    end

    for row=first,last do
        local cells = {}

        for col=1,#STAGE_LABEL do
            cells[#cells+1] =
                map_cell(
                    layout.by_position[
                        col
                    ][row],

                    previews
                )
        end

        rows[#rows+1] = {
            n = G.UIT.R,

            config = {
                align = 'cm',
                minh = 1.15,
            },

            nodes = cells
        }
    end

    while #rows < shown do
        local cells = {}

        for _=1,#STAGE_LABEL do
            cells[#cells+1] =
                map_cell(
                    nil,
                    previews
                )
        end

        rows[#rows+1] = {
            n = G.UIT.R,

            config = {
                align = 'cm',
                minh = 1.15,
            },

            nodes = cells
        }
    end

    local body = {
        {
            n = G.UIT.O,

            config = {
                object =
                    BM.EvolutionMapEdges(
                        layout.edges,
                        previews
                    )
            }
        },

        {
            n = G.UIT.R,

            config = {
                align = 'cm',
                padding = 0.025,
            },

            nodes = headers
        }
    }

    for _, row in ipairs(rows) do
        body[#body+1] =
            row
    end

    body[#body+1] = {
        n = G.UIT.R,

        config = {
            align = 'cm',
            padding = 0.015
        },

        nodes = {
            {
                n = G.UIT.T,

                config = {
                    text =
                        'Rows '
                        .. tostring(first)
                        .. '-'
                        .. tostring(last)
                        .. ' / '
                        .. tostring(
                            layout.total_rows
                        ),

                    colour =
                        G.C.UI.TEXT_INACTIVE,

                    scale =
                        0.2
                }
            }
        }
    }

    return {
        n = G.UIT.ROOT,

        config = {
            align = 'cm',
            colour = G.C.CLEAR,
        },

        nodes = {
            {
                n = G.UIT.C,

                config = {
                    align = 'cm',
                    padding = 0.06,
                    r = 0.08,

                    colour =
                        lighten(
                            G.C.BLACK,
                            0.06
                        ),

                    minw = 10.8,
                },

                nodes = body
            }
        }
    }
end

function BM.refresh_evolution_map()
    if not G.OVERLAY_MENU then
        return
    end

    local holder =
        G.OVERLAY_MENU:get_UIE_by_ID(
            'balatromon_evolution_map_contents'
        )

    if not holder then
        return
    end

    if holder.config.object then
        holder.config.object:remove()
    end

    holder.config.object =
        UIBox {
            definition =
                BM.create_evolution_map_content(),

            config = {
                offset = {
                    x = 0,
                    y = 0
                },

                align = 'cm',
                parent = holder
            }
        }
end

G.FUNCS.balatromon_evolution_map_up =
function()
    BM.evolution_map_row =
        math.max(
            1,

            (
                BM.evolution_map_row
                or 1
            )
            - 4
        )

    BM.refresh_evolution_map()
end

G.FUNCS.balatromon_evolution_map_down =
function()
    local layout =
        BM.evolution_map_layout
        or BM.build_evolution_map_layout()

    local max_start =
        math.max(
            1,

            layout.total_rows
            - BM.evolution_map_rows_visible
            + 1
        )

    BM.evolution_map_row =
        math.min(
            max_start,

            (
                BM.evolution_map_row
                or 1
            )
            + 4
        )

    BM.refresh_evolution_map()
end

G.FUNCS.balatromon_evolution_map_top =
function()
    BM.evolution_map_row = 1

    BM.refresh_evolution_map()
end

G.FUNCS.balatromon_evolution_map_bottom =
function()
    local layout =
        BM.evolution_map_layout
        or BM.build_evolution_map_layout()

    BM.evolution_map_row =
        math.max(
            1,

            layout.total_rows
            - BM.evolution_map_rows_visible
            + 1
        )

    BM.refresh_evolution_map()
end

function BM.create_evolution_map_ui()
    local layout =
        BM.evolution_map_layout
        or BM.build_evolution_map_layout()

    local content =
        UIBox {
            definition =
                BM.create_evolution_map_content(),

            config = {
                align = 'cm',

                offset = {
                    x = 0,
                    y = 0
                }
            }
        }

    return create_UIBox_generic_options {
        back_func =
            BM.evolution_map_origin
                == 'options'

            and 'options'

            or 'exit_overlay_menu',

        contents = {
            {
                n = G.UIT.R,

                config = {
                    align = 'cm',
                    padding = 0.025,
                },

                nodes = {
                    {
                        n = G.UIT.T,

                        config = {
                            text =
                                'DIGIVOLUTION MAP',

                            colour =
                                G.C.UI.TEXT_LIGHT,

                            scale =
                                0.65,

                            shadow =
                                true
                        }
                    }
                }
            },

            {
                n = G.UIT.R,

                config = {
                    align = 'cm',
                    padding = 0.015,
                },

                nodes = {
                    {
                        n = G.UIT.T,

                        config = {
                            text =
                                'Hover a Digimon to inspect it',

                            colour =
                                G.C.UI.TEXT_INACTIVE,

                            scale =
                                0.24
                        }
                    }
                }
            },

            {
                n = G.UIT.O,

                config = {
                    id =
                        'balatromon_evolution_map_contents',

                    object =
                        content
                }
            },

            {
                n = G.UIT.R,

                config = {
                    align = 'cm',
                    padding = 0.04,
                },

                nodes = {
                    legend(
                        'Standard',
                        G.C.GREEN
                    ),

                    legend(
                        'Hungry',
                        G.C.ORANGE
                    ),

                    legend(
                        'Care',
                        G.C.YELLOW
                    ),

                    legend(
                        'Care Crisis',
                        G.C.RED
                    ),

                    legend(
                        'Device',
                        G.C.PURPLE
                    ),
                }
            },

            {
                n = G.UIT.R,

                config = {
                    align = 'cm',
                    padding = 0.04,
                },

                nodes = {
                    UIBox_button {
                        button =
                            'balatromon_evolution_map_top',

                        label = {
                            'TOP'
                        },

                        minw = 1.35,
                        minh = 0.45,
                        scale = 0.3,

                        colour =
                            G.C.UI.BACKGROUND_INACTIVE
                    },

                    UIBox_button {
                        button =
                            'balatromon_evolution_map_up',

                        label = {
                            'UP'
                        },

                        minw = 1.35,
                        minh = 0.45,
                        scale = 0.3,

                        colour =
                            G.C.BLUE
                    },

                    {
                        n = G.UIT.C,

                        config = {
                            align = 'cm',
                            minw = 2.8,
                        },

                        nodes = {
                            {
                                n = G.UIT.T,

                                config = {
                                    text =
                                        'PAN',

                                    colour =
                                        G.C.UI.TEXT_INACTIVE,

                                    scale =
                                        0.22
                                }
                            }
                        }
                    },

                    UIBox_button {
                        button =
                            'balatromon_evolution_map_down',

                        label = {
                            'DOWN'
                        },

                        minw = 1.35,
                        minh = 0.45,
                        scale = 0.3,

                        colour =
                            G.C.BLUE
                    },

                    UIBox_button {
                        button =
                            'balatromon_evolution_map_bottom',

                        label = {
                            'BOTTOM'
                        },

                        minw = 1.35,
                        minh = 0.45,
                        scale = 0.3,

                        colour =
                            G.C.UI.BACKGROUND_INACTIVE
                    }
                }
            }
        }
    }
end

function BM.open_evolution_map(origin)
    BM.evolution_map_origin =
        origin
        or 'main_menu'

    BM.evolution_map_row =
        1

    BM.evolution_map_layout =
        BM.build_evolution_map_layout()

    G.SETTINGS.paused =
        true

    G.FUNCS.overlay_menu {
        definition =
            BM.create_evolution_map_ui()
    }
end

G.FUNCS.balatromon_open_evolution_map_main =
function()
    BM.open_evolution_map(
        'main_menu'
    )
end

G.FUNCS.balatromon_open_evolution_map_options =
function()
    BM.open_evolution_map(
        'options'
    )
end

local old_options =
    create_UIBox_options

create_UIBox_options =
function(...)
    local ui =
        old_options(...)

    local button =
        UIBox_button {
            button =
                'balatromon_open_evolution_map_options',

            label = {
                'DIGIVOLUTION MAP'
            },

            minw = 5,
            minh = 0.55,
            scale = 0.35,

            colour =
                G.C.PURPLE
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
        target[#target+1] =
            button
    end

    return ui
end

local old_main_menu =
    set_main_menu_UI

set_main_menu_UI =
function(...)
    local result =
        old_main_menu(...)

    if BM.evolution_map_main_button then
        BM.evolution_map_main_button:
            remove()

        BM.evolution_map_main_button =
            nil
    end

    BM.evolution_map_main_button =
        UIBox {
            definition = {
                n = G.UIT.ROOT,

                config = {
                    align = 'cm',
                    colour = G.C.CLEAR,
                },

                nodes = {
                    UIBox_button {
                        button =
                            'balatromon_open_evolution_map_main',

                        label = {
                            'DIGIVOLUTION',
                            'MAP',
                        },

                        minw = 2.7,
                        minh = 0.85,
                        scale = 0.34,

                        colour =
                            G.C.PURPLE,

                        shadow =
                            true
                    }
                }
            },

            config = {
                align =
                    'bri',

                offset = {
                    x = -0.65,
                    y = -0.65,
                },

                major =
                    G.ROOM_ATTACH,

                bond =
                    'Weak'
            }
        }

    return result
end