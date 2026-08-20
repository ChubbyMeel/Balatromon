local BM = Balatromon

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
        if key then
            return {
                set = 'Joker',
                area = G.pack_cards,
                key = key,
                skip_materialize = true,
                soulable = false,
                key_append = 'balatromon_buffoon_' .. tostring(i or 1),
            }
        end

        return {
            set = 'Joker',
            area = G.pack_cards,
            key = BM.center_key('botamon'),
            skip_materialize = true,
            soulable = false,
            key_append = 'balatromon_buffoon_fallback',
        }
    end,
}, true)

local function digital_pack_def(key, kind, weight, no_collection)
    SMODS.Booster {
        key = key,
        kind = kind,
        atlas = 'Joker',
        pos = {x = 0, y = 0},
        cost = 4,
        weight = weight,
        no_collection = no_collection,
        config = {extra = 3, choose = 1},

        select_card = 'consumeables',
        loc_txt = {
            name = 'Digital Pack',
            group_name = 'Digital Pack',
            text = {
                'Choose {C:attention}#1#{} of up to',
                '{C:attention}#2#{} {C:attention}Digi Items{}',
            },
        },
        create_card = function(self, card, i)
            return {
                set = 'DigiItem',
                area = G.pack_cards,
                skip_materialize = true,
                soulable = false,
                key_append = 'digital_pack_' .. tostring(i or 1),
            }
        end,
    }
end

digital_pack_def('digital_pack_arcana', 'Arcana', 1.0, false)
digital_pack_def('digital_pack_celestial', 'Celestial', 2.0, true)
