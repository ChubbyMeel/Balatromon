local BM = Balatromon

BM.digital_pack_keys = BM.digital_pack_keys or {
    regular = {},
    jumbo = {},
    mega = {},
}

local REGULAR_TOTAL_WEIGHT = 4.00
local JUMBO_TOTAL_WEIGHT = 1.40
local MEGA_TOTAL_WEIGHT = 0.60

local REGULAR_WEIGHT = REGULAR_TOTAL_WEIGHT / 4
local JUMBO_WEIGHT = JUMBO_TOTAL_WEIGHT / 2
local MEGA_WEIGHT = MEGA_TOTAL_WEIGHT / 2

local function booster_center_key(slug)
    return 'p_' .. BM.PREFIX .. '_' .. slug
end

local function random_from(list, seed)
    if not list or #list == 0 then
        return nil
    end

    return pseudorandom_element(
        list,
        pseudoseed(seed or 'balatromon_booster')
    )
end

function BM.random_digital_pack_key(size, seed)
    local list = BM.digital_pack_keys[size]

    return random_from(
        list,
        seed or (
            'balatromon_'
            .. tostring(size)
            .. '_digital_pack'
        )
    )
end

function BM.digital_pack_size(key)
    for size, list in pairs(BM.digital_pack_keys or {}) do
        for _, pack_key in ipairs(list or {}) do
            if pack_key == key then
                return size
            end
        end
    end

    return nil
end

function BM.mega_digital_pack_key(key, seed)
    local size = BM.digital_pack_size(key)

    if not size or size == 'mega' then
        return key
    end

    return BM.random_digital_pack_key('mega', seed) or key
end

local function digiitem_keys()
    local keys = {}

    local pool =
        G.P_CENTER_POOLS
        and G.P_CENTER_POOLS.DigiItem
        or {}

    for _, center in ipairs(pool) do
        if center then
            local allowed = true

            if center.in_pool then
                local ok = center:in_pool({
                    source = 'digital_pack'
                })

                allowed = ok ~= false
            end

            if allowed then
                keys[#keys + 1] = center.key
            end
        end
    end

    return keys
end

local function random_digiitem_key(seed)
    local pool = digiitem_keys()

    if #pool == 0 then
        return nil
    end

    return random_from(
        pool,
        seed or 'balatromon_digiitem'
    )
end

local function pack_card_def(seed_base, i)
    local index = i or 1

    local key = random_digiitem_key(
        seed_base
        .. '_'
        .. tostring(index)
    )

    if not key then
        return nil
    end

    return {
        set = 'DigiItem',
        area = G.pack_cards,
        key = key,
        skip_materialize = true,
        soulable = false,
        key_append =
            seed_base
            .. '_'
            .. tostring(index),
    }
end

local function make_digital_pack(args)
    SMODS.Booster {
        key = args.key,
        kind = 'Digital',
        atlas = 'Booster',
        pos = args.pos,
        cost = args.cost,
        weight = args.weight,
        no_collection = false,
        discovered = false,

        config = {
            extra = args.extra,
            choose = args.choose,
        },

        loc_txt = {
            name = args.display_name,
            group_name = 'Digital Pack',
            text = {
                'Choose {C:attention}#1#{} of up to',
                '{C:attention}#2#{} {C:attention}Digi Items{}',
            },
        },

        select_card = 'consumeables',

        create_card = function(self, card, i)
            return pack_card_def(
                args.key,
                i
            )
        end,
    }
end

local function add_pack_key(size, slug)
    BM.digital_pack_keys[size][
        #BM.digital_pack_keys[size] + 1
    ] = booster_center_key(slug)
end

make_digital_pack {
    key = 'digital_pack_orange',
    display_name = 'Digital Pack',
    pos = {x = 0, y = 0},
    extra = 3,
    choose = 1,
    cost = 4,
    weight = REGULAR_WEIGHT,
}

add_pack_key(
    'regular',
    'digital_pack_orange'
)

make_digital_pack {
    key = 'digital_pack_blue',
    display_name = 'Digital Pack',
    pos = {x = 1, y = 0},
    extra = 3,
    choose = 1,
    cost = 4,
    weight = REGULAR_WEIGHT,
}

add_pack_key(
    'regular',
    'digital_pack_blue'
)

make_digital_pack {
    key = 'digital_pack_red',
    display_name = 'Digital Pack',
    pos = {x = 0, y = 1},
    extra = 3,
    choose = 1,
    cost = 4,
    weight = REGULAR_WEIGHT,
}

add_pack_key(
    'regular',
    'digital_pack_red'
)

make_digital_pack {
    key = 'digital_pack_green',
    display_name = 'Digital Pack',
    pos = {x = 1, y = 1},
    extra = 3,
    choose = 1,
    cost = 4,
    weight = REGULAR_WEIGHT,
}

add_pack_key(
    'regular',
    'digital_pack_green'
)

make_digital_pack {
    key = 'jumbo_digital_pack_pink',
    display_name = 'Jumbo Digital Pack',
    pos = {x = 2, y = 0},
    extra = 5,
    choose = 1,
    cost = 6,
    weight = JUMBO_WEIGHT,
}

add_pack_key(
    'jumbo',
    'jumbo_digital_pack_pink'
)

make_digital_pack {
    key = 'jumbo_digital_pack_cyan',
    display_name = 'Jumbo Digital Pack',
    pos = {x = 2, y = 1},
    extra = 5,
    choose = 1,
    cost = 6,
    weight = JUMBO_WEIGHT,
}

add_pack_key(
    'jumbo',
    'jumbo_digital_pack_cyan'
)

make_digital_pack {
    key = 'mega_digital_pack_blue',
    display_name = 'Mega Digital Pack',
    pos = {x = 3, y = 0},
    extra = 5,
    choose = 2,
    cost = 8,
    weight = MEGA_WEIGHT,
}

add_pack_key(
    'mega',
    'mega_digital_pack_blue'
)

make_digital_pack {
    key = 'mega_digital_pack_orange',
    display_name = 'Mega Digital Pack',
    pos = {x = 3, y = 1},
    extra = 5,
    choose = 2,
    cost = 8,
    weight = MEGA_WEIGHT,
}

add_pack_key(
    'mega',
    'mega_digital_pack_orange'
)

local function weighted_digimon_key(seed)
    local pool = {}

    for _, entry in ipairs(
        BM.shop_joker_keys or {}
    ) do
        local center =
            G.P_CENTERS[entry.key]

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
                    math.floor(entry.weight or 1)
                )

                for _ = 1, weight do
                    pool[#pool + 1] =
                        entry.key
                end
            end
        end
    end

    if #pool == 0 then
        return BM.center_key('botamon')
    end

    return BM.random_element(
        pool,
        seed or 'balatromon_crest'
    )
end

local function crest_create_card(
    self,
    card,
    i
)
    local index = i or 1

    local tamer_key =
        BM.roll_crest_tamer(
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

    local key =
        weighted_digimon_key(
            'balatromon_crest_'
            .. tostring(self.key)
            .. '_'
            .. tostring(index)
        )

    return {
        set = 'Joker',
        area = G.pack_cards,
        key = key,
        skip_materialize = true,
        soulable = false,
        key_append =
            'balatromon_crest_'
            .. tostring(index)
    }
end

local function crest_loc_vars(
    self,
    info_queue,
    card
)
    local cfg =
        card
        and card.ability
        or self.config
        or {}

    local modifiers =
        G.GAME
        and G.GAME.modifiers
        or {}

    local extra = math.max(
        1,
        (cfg.extra or 1)
        + (modifiers.booster_size_mod or 0)
    )

    local choose = math.min(
        (cfg.choose or 1)
        + (modifiers.booster_choice_mod or 0),
        extra
    )

    return {
        vars = {
            choose,
            extra,
        }
    }
end

SMODS.Booster:take_ownership(
    'buffoon_normal_1',
    {
        name = 'Crest Pack',
        atlas = 'Booster',
        pos = {x = 0, y = 2},

        group_key =
            'k_booster_group_p_buffoon_normal_1',

        loc_txt = {
            name = 'Crest Pack',
            group_name = 'Crest Pack',
            text = {
                'Choose {C:attention}#1#{} of up to',
                '{C:attention}#2#{} {C:attention}Digimon Jokers{}',
            },
        },

        loc_vars = crest_loc_vars,
        create_card = crest_create_card,
    },
    true
)

SMODS.Booster:take_ownership(
    'buffoon_normal_2',
    {
        name = 'Crest Pack',
        atlas = 'Booster',
        pos = {x = 1, y = 2},

        group_key =
            'k_booster_group_p_buffoon_normal_2',

        loc_txt = {
            name = 'Crest Pack',
            group_name = 'Crest Pack',
            text = {
                'Choose {C:attention}#1#{} of up to',
                '{C:attention}#2#{} {C:attention}Digimon Jokers{}',
            },
        },

        loc_vars = crest_loc_vars,
        create_card = crest_create_card,
    },
    true
)

SMODS.Booster:take_ownership(
    'buffoon_jumbo_1',
    {
        name = 'Jumbo Crest Pack',
        atlas = 'Booster',
        pos = {x = 2, y = 2},

        group_key =
            'k_booster_group_p_buffoon_jumbo_1',

        loc_txt = {
            name = 'Jumbo Crest Pack',
            group_name = 'Crest Pack',
            text = {
                'Choose {C:attention}#1#{} of up to',
                '{C:attention}#2#{} {C:attention}Digimon Jokers{}',
            },
        },

        loc_vars = crest_loc_vars,
        create_card = crest_create_card,
    },
    true
)

SMODS.Booster:take_ownership(
    'buffoon_mega_1',
    {
        name = 'Mega Crest Pack',
        atlas = 'Booster',
        pos = {x = 3, y = 2},

        group_key =
            'k_booster_group_p_buffoon_mega_1',

        loc_txt = {
            name = 'Mega Crest Pack',
            group_name = 'Crest Pack',
            text = {
                'Choose {C:attention}#1#{} of up to',
                '{C:attention}#2#{} {C:attention}Digimon Jokers{}',
            },
        },

        loc_vars = crest_loc_vars,
        create_card = crest_create_card,
    },
    true
)