local BM = Balatromon

BM.digimon_costs = {
    Fresh = 2,
    ['In-Training'] = 3,
    Rookie = 4,
    Champion = 6,
    Rare = 10,
    Ultimate = 8,
    Mega = 15,
    Beyond = 18,
}

function BM.register_digimon(def)
    local slug, stage = def.slug, def.stage
    local extra = {hunger = 1, bond = 0, care_mistakes = 0, care_rounds = 0}

    for key, value in pairs(def.extra or {}) do
        extra[key] = value
    end

    SMODS.Joker {
        key = slug,
        unlocked = def.unlocked ~= false,
        loc_txt = {
            name = def.name,
            text = {def.text, {BM.care_status_text(stage)}},
            unlock = def.unlock
        },
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = def.cost or BM.digimon_costs[stage] or 5,
        atlas = def.atlas or 'Joker',
        pos = def.pos,
        blueprint_compat = def.blueprint_compat ~= false,
        eternal_compat = true,
        perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage,
        balatromon_attribute = def.attribute or def.balatromon_attribute,
        balatromon_evolves_to = def.evolves_to,

        set_badges = function(self, card, badges)
            BM.add_royal_knight_badge(slug, badges)
        end,

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra

            for _, seal in ipairs(def.seal_tooltips or {}) do
                BM.add_seal_tooltip(info_queue, seal)
            end
            for _, digimon in ipairs(def.digimon_tooltips or {}) do
                BM.add_digimon_tooltip(info_queue, digimon, card)
            end
            for _, center_key in ipairs(def.joker_tooltips or {}) do
                if G.P_CENTERS and G.P_CENTERS[center_key] then
                    info_queue[#info_queue + 1] = G.P_CENTERS[center_key]
                end
            end
            if def.negative_tooltip and G.P_CENTERS and G.P_CENTERS.e_negative then
                info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
            end

            local vars = {e.hunger or 1, e.bond or 0, e.care_mistakes or 0}
            vars.elements = {BM.care_bars(e, stage)}

            local dynamic = def.dynamic_vars and def.dynamic_vars(card, e) or {}
            for _, value in ipairs(dynamic) do
                vars[#vars + 1] = value
            end
            if type(dynamic.colours) == 'table' and #dynamic.colours > 0 then
                vars.colours = dynamic.colours
            end

            return {vars = vars}
        end,

        in_pool = function(self, args)
            return stage == 'Fresh' or stage == 'In-Training' or stage == 'Rookie'
                or stage == 'Champion' or stage == 'Rare'
        end,

        add_to_deck = function(self, card, from_debuff)
            if not from_debuff then BM.on_add(card, slug) end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if not from_debuff then BM.on_remove(card, slug) end
        end,

        can_sell = function(self, card, context)
            return BM.can_sell(card, slug)
        end,

        check_for_unlock = def.check_for_unlock,
        locked_loc_vars = def.locked_loc_vars,

        calculate = function(self, card, context)
            BM.care_tick(card, context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug, card, context)
        end,
    }

    BM.joker_defs[slug] = {
        name = def.name,
        stage = stage,
        evolves_to = def.evolves_to,
        effect = def.effect
    }

    local weight = BM.stage_shop_weight(stage)
    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {
            key = BM.center_key(slug),
            weight = weight,
            stage = stage
        }
    end
end

do
    local slug = 'recovery_digitama'
    local stage = 'Digitama'
    local extra = {recovery_rounds = 2, recover_slug = nil, recover_extra = nil}

    SMODS.Joker {
        key = slug,
        loc_txt = {
            name = 'Digitama',
            text = {
                'Does nothing while recovering',
                'Returns to {C:attention}#2#{}',
                'after {C:attention}#1#{} #3#'
            }
        },
        config = {extra = extra},
        rarity = BM.stage_rarity(stage),
        cost = 0,
        atlas = 'Joker',
        pos = {x = 3, y = 15},
        blueprint_compat = false,
        eternal_compat = true,
        perishable_compat = false,
        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = '-',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra
            local rounds = e.recovery_rounds or 2
            local recover_slug = e.recover_slug
            local recover_name = 'Digimon'

            if recover_slug and BM.joker_defs and BM.joker_defs[recover_slug] then
                recover_name = BM.joker_defs[recover_slug].name
                BM.add_digimon_tooltip(info_queue, recover_slug)
            end

            return {vars = {rounds, recover_name, rounds == 1 and 'round' or 'rounds'}}
        end,

        in_pool = function()
            return false
        end,

        calculate = function(self, card, context)
            return BM.tick_recovery_digitama(card, context)
        end,
    }

    BM.joker_defs[slug] = {
        name = 'Digitama',
        stage = stage,
        evolves_to = '-',
        effect = 'Does nothing while recovering. Returns to its previous Digimon after 2 rounds'
    }
end
