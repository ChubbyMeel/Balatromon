local BM = Balatromon

-- Balatromon shops contain Balatromon Jokers only.
-- Vanilla Balatro uses the append key "sho" for the normal shop Joker roll.
-- We intentionally leave other Joker-generation sources alone.
if not BM._shop_pool_patched and get_current_pool then
    BM._shop_pool_patched = true
    local old_get_current_pool = get_current_pool

    get_current_pool = function(_type, _rarity, _legendary, _append)
        if _type == 'Joker' and (_append == 'sho' or _append == 'shop') then
            local pool = {}
            for _, entry in ipairs(BM.shop_joker_keys) do
                local center = G.P_CENTERS[entry.key]
                if center then
                    local allowed = true
                    if center.in_pool then
                        local ok = center:in_pool({source=_append})
                        allowed = ok ~= false
                    end
                    if allowed then
                        for _ = 1, entry.weight do pool[#pool+1] = entry.key end
                    end
                end
            end
            if #pool > 0 then return pool, 'BalatromonShop' end
        end
        return old_get_current_pool(_type, _rarity, _legendary, _append)
    end
end
