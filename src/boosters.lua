local BM = Balatromon

-- ============================================================
-- BUFFOON PACKS: DIGIMON ONLY
-- ============================================================

local function weighted_digimon_key(seed)
    local pool = {}

    for _, entry in ipairs(BM.shop_joker_keys or {}) do
        local center = G.P_CENTERS[entry.key]
        if center then
            local allowed = true
            if center.in_pool then
                local ok = center:in_pool({source = 'buf'})
                allowed = ok ~= false
            end

            if allowed then
                for _ = 1, math.max(1, entry.weight or 1) do
                    pool[#pool + 1] = entry.key
                end
            end
        end
    end

    return BM.random_element(pool, seed or 'balatromon_buffoon')
end

SMODS.Booster:take_ownership_by_kind('Buffoon', {
    create_card = function(self, card, i)
        local key = weighted_digimon_key('balatromon_buffoon_' .. tostring(i or 1))

        return {
            set = 'Joker',
            area = G.pack_cards,
            key = key or BM.center_key('botamon'),
            skip_materialize = true,
            soulable = false,
            key_append = key and ('balatromon_buffoon_' .. tostring(i or 1))
                or 'balatromon_buffoon_fallback',
        }
    end,
}, true)

-- ============================================================
-- DIGITAL PACKS
-- ============================================================

local function digital_pack_def(args)
    SMODS.Booster {
        key = args.key,
        kind = args.kind,
        atlas = 'Joker',
        pos = {x = 0, y = 0},
        cost = args.cost or 4,
        weight = args.weight or 0,
        no_collection = args.no_collection or false,
        discovered = true,
        unlocked = true,

        config = {
            extra = args.extra or 3,
            choose = args.choose or 1,
        },

        select_card = 'consumeables',

        loc_txt = {
            name = args.name or 'Digital Pack',
            group_name = 'Digital Pack',
            text = {
                'Choose {C:attention}#1#{} of up to',
                '{C:attention}#2#{} {C:attention}Digi Items{}',
            },
        },

        loc_vars = function(self, info_queue, card)
            return {vars = {self.config.choose, self.config.extra}}
        end,

        create_card = function(self, card, i)
            return {
                set = 'DigiItem',
                area = G.pack_cards,
                skip_materialize = true,
                soulable = false,
                key_append = args.key .. '_' .. tostring(i or 1),
            }
        end,
    }
end

-- Normal Digital Pack variants. Their kind makes them compete in the
-- same booster families you were already using.
digital_pack_def {
    key = 'digital_pack_arcana',
    kind = 'Arcana',
    weight = 1.0,
    extra = 3,
    choose = 1,
    cost = 4,
    name = 'Digital Pack',
}

digital_pack_def {
    key = 'digital_pack_celestial',
    kind = 'Celestial',
    weight = 2.0,
    no_collection = true,
    extra = 3,
    choose = 1,
    cost = 4,
    name = 'Digital Pack',
}

-- Jumbo can ALSO naturally appear in the shop, and Digitag can force-open
-- this exact same complete Booster definition.
digital_pack_def {
    key = 'jumbo_digital_pack',
    kind = 'Digital',
    weight = 0.75,
    extra = 5,
    choose = 2,
    cost = 6,
    name = 'Jumbo Digital Pack',
}
