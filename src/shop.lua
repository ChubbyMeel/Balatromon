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

                local center =
                    G.P_CENTERS[entry.key]


                if center then

                    local allowed = true


                    if entry.stage == 'Ultimate' then

                        -- These three are special exceptions.
                        local special_shop_ultimate =
                            entry.key == BM.center_key('monzaemon')
                            or entry.key == BM.center_key('warumonzaemon')
                            or entry.key == BM.center_key('polarbearmon')


                        -- Every other Ultimate needs the voucher.
                        if not special_shop_ultimate then

                            allowed =
                                G.GAME
                                and G.GAME.balatromon_mega_digivolution
                                == true
                        end
                    end




                    if allowed and center.in_pool then

                        local voucher_ultimate =
                            entry.stage == 'Ultimate'
                            and G.GAME
                            and G.GAME.balatromon_mega_digivolution


                        -- Mega Digivolution overrides the
                        -- normal Ultimate exclusion.
                        if not voucher_ultimate then

                            local ok = center:in_pool({
                                source = _append
                            })

                            allowed = ok ~= false
                        end
                    end


                    if allowed then

                        local weight =
                            entry.weight or 1


                        if G.GAME
                        and G.GAME.balatromon_digivice_abundance then

                            if entry.stage == 'Rookie' then

                                weight =
                                    weight * 2

                            elseif entry.stage == 'Champion' then

                                weight =
                                    weight * 3
                            end
                        end


                        for _ = 1,
                            math.max(
                                0,
                                math.floor(weight)
                            )
                        do
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


        return old_get_current_pool(
            _type,
            _rarity,
            _legendary,
            _append
        )
    end
end