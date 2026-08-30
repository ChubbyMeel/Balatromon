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

-- Jogress Cards may count as either complete source identity when forming
-- a Poker Hand. One physical card chooses one identity per evaluation.
if evaluate_poker_hand
and not BM._jogress_poker_eval_wrapped then
    BM._jogress_poker_eval_wrapped = true

    local original_evaluate_poker_hand =
        evaluate_poker_hand

    local function jogress_rank_key(rank_id)
        for _, rank_key in ipairs(
            SMODS.Rank
            and SMODS.Rank.obj_buffer
            or {}
        ) do
            local rank_data =
                SMODS.Ranks
                and SMODS.Ranks[rank_key]

            if rank_data
            and rank_data.id == rank_id then
                return rank_key, rank_data
            end
        end

        return nil, nil
    end

    local function save_jogress_base(card)
        return {
            value = card.base and card.base.value,
            suit = card.base and card.base.suit,
            id = card.base and card.base.id,
            nominal = card.base and card.base.nominal,
            face_nominal = card.base and card.base.face_nominal,
        }
    end

    local function apply_jogress_identity(
        card,
        identity
    )
        if not card
        or not card.base
        or not identity then
            return false
        end

        local rank_key, rank_data =
            jogress_rank_key(
                identity.rank
            )

        if not rank_key
        or not rank_data then
            return false
        end

        card.base.value = rank_key
        card.base.suit = identity.suit
        card.base.id = identity.rank
        card.base.nominal =
            rank_data.nominal
            or card.base.nominal
        card.base.face_nominal =
            rank_data.face_nominal
            or 0

        return true
    end

    local function restore_jogress_base(
        card,
        saved
    )
        if not card
        or not card.base
        or not saved then
            return
        end

        card.base.value = saved.value
        card.base.suit = saved.suit
        card.base.id = saved.id
        card.base.nominal = saved.nominal
        card.base.face_nominal =
            saved.face_nominal
    end

    local function merge_jogress_results(
        combined,
        result
    )
        for hand_name, groups in pairs(
            result or {}
        ) do
            if hand_name ~= 'top'
            and type(groups) == 'table'
            and next(groups) then
                combined[hand_name] =
                    combined[hand_name]
                    or {}

                for _, scoring_group in ipairs(
                    groups
                ) do
                    combined[hand_name][
                        #combined[hand_name] + 1
                    ] = scoring_group
                end
            end
        end
    end

    evaluate_poker_hand = function(hand)
        local jogress_cards = {}

        for _, playing_card in ipairs(
            hand or {}
        ) do
            if BM.is_jogress_card(
                playing_card
            ) then
                local identities =
                    BM.card_identities(
                        playing_card
                    )

                if #identities > 0 then
                    jogress_cards[
                        #jogress_cards + 1
                    ] = {
                        card = playing_card,
                        identities = identities,
                        original =
                            save_jogress_base(
                                playing_card
                            )
                    }
                end
            end
        end

        if #jogress_cards == 0 then
            return original_evaluate_poker_hand(
                hand
            )
        end

        local combined = {}

        for hand_name, _ in pairs(
            SMODS.PokerHands or {}
        ) do
            combined[hand_name] = {}
        end

        local function evaluate_combination(index)
            if index > #jogress_cards then
                merge_jogress_results(
                    combined,
                    original_evaluate_poker_hand(
                        hand
                    )
                )
                return
            end

            local entry =
                jogress_cards[index]

            for _, identity in ipairs(
                entry.identities
            ) do
                if apply_jogress_identity(
                    entry.card,
                    identity
                ) then
                    evaluate_combination(
                        index + 1
                    )
                end
            end
        end

        local ok, err =
            pcall(
                evaluate_combination,
                1
            )

        for _, entry in ipairs(
            jogress_cards
        ) do
            restore_jogress_base(
                entry.card,
                entry.original
            )
        end

        if not ok then
            error(err)
        end

        for _, hand_name in ipairs(
            G.handlist or {}
        ) do
            if next(
                combined[hand_name]
                or {}
            ) then
                combined.top =
                    combined[hand_name]
                break
            end
        end

        return combined
    end
end
