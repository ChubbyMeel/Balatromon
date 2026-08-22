local BM = Balatromon

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

                        for _ = 1, math.max(
                            0,
                            math.floor(weight)
                        ) do
                            pool[#pool + 1] = entry.key
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

    if _type == 'Booster'
    and BM.has_active_digimon
    and BM.has_active_digimon('sunflowmon')
    and type(pool) == 'table' then
        for i, key in ipairs(pool) do
            pool[i] = BM.mega_digital_pack_key(
                key,
                'sunflowmon_shop_' .. tostring(i)
            )
        end
    end

    return pool, pool_key
    end
end