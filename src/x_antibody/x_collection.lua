local BM = Balatromon

local function x_profile()
    return G.PROFILES
        and G.SETTINGS
        and G.PROFILES[G.SETTINGS.profile]
end

local function x_discovery_table()
    local profile = x_profile()

    if not profile then
        return {}
    end

    profile.balatromon_x_antibody_discovered =
        profile.balatromon_x_antibody_discovered
        or {}

    return profile.balatromon_x_antibody_discovered
end

function BM.is_x_antibody_discovered(slug)
    if not slug then
        return false
    end

    local profile = x_profile()

    if profile
    and profile.all_unlocked then
        return true
    end

    return x_discovery_table()[slug] == true
end

function BM.discover_x_antibody(slug)
    if not slug then
        return
    end

    if BM.x_antibody_viable
    and BM.x_antibody_viable[slug] ~= true then
        return
    end

    local discovered =
        x_discovery_table()

    if discovered[slug] then
        return
    end

    discovered[slug] = true

    if G.save_progress then
        G:save_progress()
    end
end

local function get_x_collection_entries()
    local entries = {}

    for slug, form in pairs(
        BM.x_antibody_forms or {}
    ) do
        local center =
            G.P_CENTERS[
                BM.center_key(slug)
            ]

        if center
        and form
        and form.pos then
            entries[#entries + 1] = {
                slug = slug,
                form = form,
                center = center
            }
        end
    end

    table.sort(
        entries,
        function(a, b)
            local ay =
                a.form.pos.y or 0

            local by =
                b.form.pos.y or 0

            if ay ~= by then
                return ay < by
            end

            local ax =
                a.form.pos.x or 0

            local bx =
                b.form.pos.x or 0

            if ax ~= bx then
                return ax < bx
            end

            return a.slug < b.slug
        end
    )

    return entries
end

local function get_x_collection_tally()
    local entries =
        get_x_collection_entries()

    local tally = 0

    for _, entry in ipairs(entries) do
        if BM.is_x_antibody_discovered(
            entry.slug
        ) then
            tally = tally + 1
        end
    end

    return {
        tally = tally,
        of = #entries
    }
end

local undiscovered_x_center

local function make_undiscovered_x_center()
    if undiscovered_x_center then
        return undiscovered_x_center
    end

    undiscovered_x_center = {
        key =
            'j_'
            .. BM.PREFIX
            .. '_x_collection_undiscovered',

        name = 'Undiscovered',
        set = 'Joker',

        unlocked = true,
        discovered = false,
        alerted = true,

        atlas = 'Joker',

        pos =
            G.j_undiscovered
            and G.j_undiscovered.pos
            or {
                x = 0,
                y = 0
            },

        config = {},

        rarity = 1,
        cost = 0,

        blueprint_compat = false,
        eternal_compat = false,
        perishable_compat = false
    }

    return undiscovered_x_center
end

local function make_x_collection_card(
    area,
    entry
)
    local discovered =
        BM.is_x_antibody_discovered(
            entry.slug
        )

    local center
    local params = {}

    if discovered then
        center =
            entry.center

        params.bypass_discovery_center =
            true
    else
        center =
            make_undiscovered_x_center()
    end

    local card =
        Card(
            area.T.x
                + area.T.w / 2,
            area.T.y,
            G.CARD_W,
            G.CARD_H,
            G.P_CARDS.empty,
            center,
            params
        )

    card.states.drag.can = false
    card.states.click.can = false

    if discovered then
        card.bypass_lock = true
        card.bypass_discovery_ui = true

        card.config.center_key =
            entry.center.key

        card.ability.extra =
            card.ability.extra
            or {}

        card.ability.extra.x_antibody_rounds =
            1

        BM.set_x_antibody_sprite(
            card
        )
    end

    return card
end

local function populate_x_collection(page)
    local entries =
        get_x_collection_entries()

    local offset =
        15 * (page - 1)

    for i = 1, 5 do
        for j = 1, 3 do
            local index =
                i
                + (j - 1) * 5
                + offset

            local entry =
                entries[index]

            if entry then
                local card =
                    make_x_collection_card(
                        G.your_collection[j],
                        entry
                    )

                G.your_collection[j]:
                    emplace(card)
            end
        end
    end
end

function create_UIBox_your_collection_balatromon_x_antibodies()
    local deck_tables = {}

    G.your_collection = {}

    for j = 1, 3 do
        G.your_collection[j] =
            CardArea(
                G.ROOM.T.x
                    + 0.2
                    * G.ROOM.T.w
                    / 2,
                G.ROOM.T.h,
                5 * G.CARD_W,
                0.95 * G.CARD_H,
                {
                    card_limit = 5,
                    type = 'title',
                    highlight_limit = 0,
                    collection = true
                }
            )

        deck_tables[#deck_tables + 1] = {
            n = G.UIT.R,

            config = {
                align = 'cm',
                padding = 0.07,
                no_fill = true
            },

            nodes = {
                {
                    n = G.UIT.O,

                    config = {
                        object =
                            G.your_collection[j]
                    }
                }
            }
        }
    end

    local entries =
        get_x_collection_entries()

    local page_count =
        math.max(
            1,
            math.ceil(
                #entries / 15
            )
        )

    local page_options = {}

    for i = 1, page_count do
        page_options[#page_options + 1] =
            localize('k_page')
            .. ' '
            .. tostring(i)
            .. '/'
            .. tostring(page_count)
    end

    populate_x_collection(1)

    return create_UIBox_generic_options({
        back_func = 'your_collection',

        contents = {
            {
                n = G.UIT.R,

                config = {
                    align = 'cm',
                    r = 0.1,
                    colour = G.C.BLACK,
                    emboss = 0.05
                },

                nodes = deck_tables
            },

            {
                n = G.UIT.R,

                config = {
                    align = 'cm'
                },

                nodes = {
                    create_option_cycle({
                        options =
                            page_options,

                        w = 4.5,

                        cycle_shoulders =
                            true,

                        opt_callback =
                            'your_collection_balatromon_x_antibody_page',

                        current_option = 1,

                        colour =
                            G.C.PURPLE,

                        no_pips = true,

                        focus_args = {
                            snap_to = true,
                            nav = 'wide'
                        }
                    })
                }
            }
        }
    })
end

G.FUNCS.your_collection_balatromon_x_antibody_page =
function(args)
    if not args
    or not args.cycle_config then
        return
    end

    for j = 1, #G.your_collection do
        for i =
            #G.your_collection[j].cards,
            1,
            -1
        do
            local card =
                G.your_collection[j]:
                    remove_card(
                        G.your_collection[j].cards[i]
                    )

            if card then
                card:remove()
            end
        end
    end

    populate_x_collection(
        args.cycle_config.current_option
        or 1
    )
end

G.FUNCS.your_collection_balatromon_x_antibodies =
function()
    G.SETTINGS.paused = true

    G.FUNCS.overlay_menu({
        definition =
            create_UIBox_your_collection_balatromon_x_antibodies()
    })
end

local previous_custom_collection_tabs =
    SMODS.current_mod.custom_collection_tabs

SMODS.current_mod.custom_collection_tabs =
function(...)
    local tabs = {}

    if previous_custom_collection_tabs then
        local existing =
            previous_custom_collection_tabs(...)

        for _, tab in ipairs(
            existing or {}
        ) do
            tabs[#tabs + 1] = tab
        end
    end

    if not G.ACTIVE_MOD_UI then
        tabs[#tabs + 1] =
            UIBox_button({
                button =
                    'your_collection_balatromon_x_antibodies',

                id =
                    'your_collection_balatromon_x_antibodies',

                label = {
                    'X-Antibody'
                },

                count =
                    get_x_collection_tally(),

                minw = 5,
                minh = 1.2,

                focus_args = {
                    snap_to = true
                }
            })
    end

    return tabs
end