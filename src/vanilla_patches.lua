local BM = Balatromon

local function mega_digimon_pool()
    local pool = {}

    for slug, def in pairs(
        BM.joker_defs or {}
    ) do
        if def.stage == 'Mega' then
            local key =
                BM.center_key(slug)

            if G.P_CENTERS
            and G.P_CENTERS[key] then
                pool[#pool + 1] = {
                    slug = slug,
                    key = key
                }
            end
        end
    end

    return pool
end

SMODS.Consumable:take_ownership(
    'wraith',
    {
        in_pool = function(
            self,
            args
        )
            return false
        end,

        no_collection = true
    },
    true
)

SMODS.Consumable:take_ownership(
    'soul',
    {
        loc_txt = {
            name = 'The Soul',
            text = {
                'Creates a random',
                '{C:attention}Mega Digimon{}',
                '{C:inactive}(Must have room){}'
            }
        },

        can_use = function(
            self,
            card
        )
            if BM.has_room then
                return BM.has_room(
                    G.jokers
                )
            end

            return G.jokers
                and #G.jokers.cards
                < G.jokers.config.card_limit
        end,

        use = function(
            self,
            card,
            area,
            copier
        )
            local pool =
                mega_digimon_pool()

            if #pool == 0 then
                return
            end

            local seed =
                'balatromon_soul_'
                .. tostring(
                    G.GAME
                    and G.GAME.round_resets
                    and G.GAME.round_resets.ante
                    or 0
                )

            local chosen =
                pseudorandom_element(
                    pool,
                    pseudoseed(seed)
                )

            if not chosen then
                return
            end

            SMODS.add_card {
                set = 'Joker',
                area = G.jokers,
                key = chosen.key,
                key_append =
                    'balatromon_soul'
            }
        end
    },
    true
)