local BM = Balatromon

local original_create_joker_collection =
    create_UIBox_your_collection_jokers

local original_joker_page =
    G.FUNCS.your_collection_joker_page

local original_create_collection =
    create_UIBox_your_collection

local function is_vanilla_joker(center)
    return center
        and center.set == 'Joker'
        and center.original_mod == nil
end

local function visible_in_collection(center)
    if SMODS.hide_from_collection then
        return not SMODS.hide_from_collection(center)
    end

    return true
end

local function get_vanilla_jokers()
    local pool = {}

    for _, center in ipairs(G.P_CENTER_POOLS.Joker or {}) do
        if is_vanilla_joker(center)
        and visible_in_collection(center) then
            pool[#pool + 1] = center
        end
    end

    return pool
end

local function get_non_vanilla_jokers()
    local pool = {}

    for _, center in ipairs(G.P_CENTER_POOLS.Joker or {}) do
        if not is_vanilla_joker(center)
        and visible_in_collection(center) then
            pool[#pool + 1] = center
        end
    end

    return pool
end

local function tally_pool(pool)
    local tally = 0
    local total = 0

    for _, center in ipairs(pool or {}) do
        total = total + 1

        if center.discovered then
            tally = tally + 1
        end
    end

    return {
        tally = tally,
        of = total
    }
end

local function vanilla_joker_tally()
    return tally_pool(
        get_vanilla_jokers()
    )
end

local function non_vanilla_joker_tally()
    return tally_pool(
        get_non_vanilla_jokers()
    )
end

local function with_joker_pool(pool, func, ...)
    local original_pool =
        G.P_CENTER_POOLS.Joker

    G.P_CENTER_POOLS.Joker =
        pool

    local ok, result =
        pcall(func, ...)

    G.P_CENTER_POOLS.Joker =
        original_pool

    if not ok then
        error(result)
    end

    return result
end

create_UIBox_your_collection_jokers = function(...)
    BM._showing_vanilla_jokers =
        false

    return with_joker_pool(
        get_non_vanilla_jokers(),
        original_create_joker_collection,
        ...
    )
end

G.FUNCS.your_collection_joker_page = function(args)
    local pool

    if BM._showing_vanilla_jokers then
        pool =
            get_vanilla_jokers()
    else
        pool =
            get_non_vanilla_jokers()
    end

    return with_joker_pool(
        pool,
        original_joker_page,
        args
    )
end

G.FUNCS.your_collection_balatromon_vanilla_jokers =
function()
    G.SETTINGS.paused =
        true

    BM._showing_vanilla_jokers =
        true

    local definition =
        with_joker_pool(
            get_vanilla_jokers(),
            original_create_joker_collection
        )

    G.FUNCS.overlay_menu({
        definition =
            definition
    })
end

if original_create_collection
and not BM._collection_joker_tally_wrapped then
    BM._collection_joker_tally_wrapped =
        true

    create_UIBox_your_collection =
    function(...)
        local original_UIBox_button =
            UIBox_button

        UIBox_button =
        function(args)
            if args
            and args.id == 'your_collection_jokers' then
                args.count =
                    non_vanilla_joker_tally()
            end

            return original_UIBox_button(
                args
            )
        end

        local ok, result =
            pcall(
                original_create_collection,
                ...
            )

        UIBox_button =
            original_UIBox_button

        if not ok then
            error(result)
        end

        return result
    end
end

local previous_custom_collection_tabs =
    SMODS.current_mod.custom_collection_tabs

SMODS.current_mod.custom_collection_tabs =
function(...)
    local tabs = {}

    if previous_custom_collection_tabs then
        local existing =
            previous_custom_collection_tabs(...)

        for _, tab in ipairs(existing or {}) do
            tabs[#tabs + 1] =
                tab
        end
    end

    if not G.ACTIVE_MOD_UI then
        tabs[#tabs + 1] =
            UIBox_button({
                button =
                    'your_collection_balatromon_vanilla_jokers',

                id =
                    'your_collection_balatromon_vanilla_jokers',

                label = {
                    'Vanilla Jokers'
                },

                count =
                    vanilla_joker_tally(),

                minw = 5,
                minh = 1.2,

                focus_args = {
                    snap_to = true
                }
            })
    end

    return tabs
end