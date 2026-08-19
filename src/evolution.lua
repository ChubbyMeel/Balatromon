local BM = Balatromon

-- ============================================================
-- Balatromon Digivolution engine
-- ============================================================
-- Branching philosophy:
--   * Full Bond is required for ordinary Digivolution.
--   * The first / core route is generally always viable.
--   * Hunger and Care Mistakes unlock additional alternate routes.
--   * D-3 unlocks Armor-style routes where listed below.
--   * At 3 Care Mistakes, ordinary routes are suppressed:
--       - if the current form has a marked bad path, only bad paths are valid;
--       - otherwise a compatible Digivice De-Digivolves the Digimon to a
--         Fresh form from its own history (or a reachable Fresh ancestor).
--   * Resolving a Care Crisis consumes the 3 Care Mistakes and resets them to 0.
--
-- The 131 Joker definitions stay data-only. All route logic lives here.
-- ============================================================

BM.evolution_rules = {
    agumon = {
        greymon = {note = 'Standard route'},
        tyrannomon = {min_hunger = 2, note = 'Hungry route'},
        numemon = {bad_path = true, note = 'Care Crisis route'},
    },
    greymon = {
        metalgreymon = {note = 'Standard route'},
        skullgreymon = {bad_path = true, note = 'Care Crisis route'},
    },
    metalgreymon = {
        wargreymon = {note = 'Standard route'},
        machinedramon = {min_care = 1, note = 'Rough-care route'},
    },
    tyrannomon = {
        metalgreymon = {note = 'Standard route'},
        skullgreymon = {bad_path = true, note = 'Care Crisis route'},
    },
    guilmon = {
        growlmon = {note = 'Standard route'},
        monochromon = {min_hunger = 2, note = 'Hungry route'},
        numemon = {bad_path = true, note = 'Care Crisis route'},
    },
    growlmon = {
        wargrowlmon = {note = 'Standard route'},
        megadramon = {min_hunger = 3, note = 'High-Hunger route'},
        gigadramon = {min_care = 1, note = 'Rough-care route'},
    },
    monochromon = {
        mammothmon = {note = 'Standard route'},
        triceramon = {min_hunger = 3, note = 'High-Hunger route'},
    },
    wargrowlmon = {
        gallantmon = {note = 'Standard route'},
        blackwargreymon = {bad_path = true, note = 'Care Crisis route'},
    },
    megadramon = {
        machinedramon = {note = 'Standard route'},
        blackwargreymon = {bad_path = true, note = 'Care Crisis route'},
    },
    gigadramon = {
        machinedramon = {note = 'Standard route'},
        blackwargreymon = {bad_path = true, note = 'Care Crisis route'},
    },
    triceramon = {
        wargreymon = {note = 'Standard route'},
        heavyleomon = {min_hunger = 3, note = 'High-Hunger route'},
        blackwargreymon = {bad_path = true, note = 'Care Crisis route'},
    },
    tialudomon = {
        raijiludomon = {note = 'Standard route'},
        knightmon = {min_care = 1, note = 'Rough-care route'},
    },
    gabumon = {
        garurumon = {note = 'Standard route'},
        leomon = {min_hunger = 2, note = 'Hungry route'},
        madleomon = {min_care = 2, max_care = 2, note = '2 Care Mistakes route'},
        numemon = {bad_path = true, note = 'Care Crisis route'},
    },
    garurumon = {
        weregarurumon = {note = 'Standard route'},
        mammothmon = {min_hunger = 3, note = 'High-Hunger route'},
    },
    leomon = {
        loaderleomon = {note = 'Standard route'},
        knightmon = {min_care = 1, note = 'Rough-care route'},
    },
    madleomon = {
        loaderleomon = {note = 'Standard route'},
        knightmon = {min_hunger = 3, note = 'High-Hunger route'},
    },
    bukamon = {
        gomamon = {note = 'Standard route'},
        crabmon = {min_hunger = 2, note = 'Hungry route'},
    },
    gomamon = {
        ikkakumon = {note = 'Standard route'},
        shellmon = {min_hunger = 3, note = 'High-Hunger route'},
    },
    crabmon = {
        seadramon = {note = 'Standard route'},
        shellmon = {min_hunger = 3, note = 'High-Hunger route'},
    },
    ikkakumon = {
        zudomon = {note = 'Standard route'},
        mammothmon = {min_hunger = 3, note = 'High-Hunger route'},
    },
    marinebullmon = {
        hydramon = {note = 'Stone route'},
        vikemon = {min_hunger = 3, note = 'High-Hunger route'},
    },
    poyomon = {
        tokomon = {note = 'Standard route'},
        pagumon = {bad_path = true, note = 'Care Crisis route'},
    },
    patamon = {
        angemon = {note = 'Standard route'},
        pegasusmon = {device = 'd3', note = 'D-3 Armor route'},
    },
    pegasusmon = {
        magnaangemon = {note = 'Standard route'},
        hippogryphonmon = {min_hunger = 3, note = 'High-Hunger route'},
    },
    yukimibotamon = {
        nyaromon = {note = 'Standard route'},
        pagumon = {bad_path = true, note = 'Care Crisis route'},
    },
    salamon = {
        gatomon = {note = 'Standard route'},
        nefertimon = {device = 'd3', note = 'D-3 Armor route'},
    },
    nefertimon = {
        angewomon = {note = 'Standard route'},
        hippogryphonmon = {min_hunger = 3, note = 'High-Hunger route'},
    },
    devimon = {
        myotismon = {note = 'Standard route'},
        ladydevimon = {min_hunger = 3, note = 'High-Hunger route'},
    },
    veemon = {
        exveemon = {note = 'Standard route'},
        flamedramon = {device = 'd3', note = 'D-3 Armor route'},
    },
    paildramon = {
        imperialdramon_fighter_mode = {note = 'Mode choice'},
        imperialdramon_dragon_mode = {note = 'Mode choice'},
    },
    wingdramon = {
        gallantmon = {note = 'Standard route'},
        blackwargreymon = {bad_path = true, note = 'Care Crisis route'},
    },
    renamon = {
        kyubimon = {note = 'Standard route'},
        zubaeagermon = {min_hunger = 3, note = 'High-Hunger route'},
        gatomon = {min_care = 1, note = 'Rough-care route'},
    },
    kyubimon = {
        taomon = {note = 'Standard route'},
        ladydevimon = {bad_path = true, note = 'Care Crisis route'},
    },
    taomon = {
        sakuyamon = {note = 'Standard route'},
        piedmon = {bad_path = true, note = 'Care Crisis route'},
    },
    terriermon = {
        gargomon = {note = 'Standard route'},
        guardromon = {min_hunger = 2, note = 'Hungry route'},
        machmon = {min_care = 1, note = 'Rough-care route'},
    },
    guardromon = {
        andromon = {note = 'Standard route'},
        tankdramon = {min_care = 1, note = 'Rough-care route'},
    },
    machmon = {
        loaderleomon = {note = 'Standard route'},
        tankdramon = {min_hunger = 3, note = 'High-Hunger route'},
    },
    poromon = {
        hawkmon = {note = 'Standard route'},
        biyomon = {min_hunger = 2, note = 'Hungry route'},
    },
    hawkmon = {
        aquilamon = {note = 'Standard route'},
        halsemon = {device = 'd3', note = 'D-3 Armor route'},
    },
    aquilamon = {
        parrotmon = {note = 'Standard route'},
        hippogryphonmon = {min_hunger = 3, note = 'High-Hunger route'},
    },
    garudamon = {
        phoenixmon = {note = 'Standard route'},
        valkyrimon = {min_hunger = 3, note = 'High-Hunger route'},
    },
    parrotmon = {
        phoenixmon = {note = 'Standard route'},
        valkyrimon = {min_hunger = 3, note = 'High-Hunger route'},
    },
    hippogryphonmon = {
        phoenixmon = {note = 'Standard route'},
        valkyrimon = {min_care = 1, note = 'Rough-care route'},
    },
    pinamon = {
        akatorimon = {note = 'Wide-feeding route'},
        kokatorimon = {note = 'Focused-feeding route'},
    },
}

BM.evolution_queue = BM.evolution_queue or {}
BM.pending_evolution = BM.pending_evolution or nil
BM._evolution_choice_busy = BM._evolution_choice_busy or false

local function trim(text)
    return (text or ''):gsub('^%s+', ''):gsub('%s+$', '')
end

local function split_evolution_names(raw)
    if not raw or raw == '' or raw == '-' or raw == '—' then return {} end

    local out = {}
    for name in raw:gmatch('[^,]+') do
        name = trim(name)
        if name ~= '' then out[#out + 1] = name end
    end
    return out
end

function BM.get_card_slug(card)
    if not (card and card.config and card.config.center) then return nil end

    local key = card.config.center.key or card.config.center_key
    local prefix = 'j_' .. BM.PREFIX .. '_'
    if type(key) == 'string' and key:sub(1, #prefix) == prefix then
        return key:sub(#prefix + 1)
    end

    local name = card.config.center.loc_txt and card.config.center.loc_txt.name
        or card.config.center.name
    return name and BM.slug(name) or nil
end

function BM.parse_evolution_names(card)
    local center = card and card.config and card.config.center
    return split_evolution_names(center and center.balatromon_evolves_to)
end

function BM.find_digimon_center(name)
    local slug = BM.slug(name)
    local key = BM.center_key(slug)
    return G.P_CENTERS[key], key, slug
end

local function get_rule(source_slug, target_slug)
    local source_rules = source_slug and BM.evolution_rules[source_slug]
    return source_rules and source_rules[target_slug] or nil
end

function BM.is_care_crisis(card)
    if not BM.is_digimon(card) then return false end
    local e = card.ability and card.ability.extra or {}
    return (e.care_mistakes or 0) >= 3 or e.care_crisis == true
end

local function is_bad_rule(rule)
    return type(rule) == 'table' and rule.bad_path == true
end

local function rule_allows(card, target_center, target_slug, device_key, rule)
    local source_slug = BM.get_card_slug(card)
    rule = rule ~= nil and rule or get_rule(source_slug, target_slug)

    -- No explicit rule means the connected route is a normal route.
    if rule == nil then return true end
    if rule == false then return false end
    if rule == true then return true end

    if type(rule) == 'function' then
        return rule(card, target_center, device_key) ~= false
    end

    if type(rule) ~= 'table' then return true end

    local e = card.ability and card.ability.extra or {}
    local bond = e.bond or 0
    local hunger = e.hunger or 1
    local care = e.care_mistakes or 0

    if rule.min_bond and bond < rule.min_bond then return false end
    if rule.max_bond and bond > rule.max_bond then return false end
    if rule.min_hunger and hunger < rule.min_hunger then return false end
    if rule.max_hunger and hunger > rule.max_hunger then return false end
    if rule.min_care and care < rule.min_care then return false end
    if rule.max_care and care > rule.max_care then return false end
    if rule.device and rule.device ~= device_key then return false end
    if rule.valid and rule.valid(card, target_center, device_key) == false then return false end

    return true
end

local function rule_note(rule)
    if type(rule) == 'table' and rule.note then
        return rule.note
    end
    return 'Standard route'
end

local function make_option(name, center, key, slug, rule)
    local def = BM.joker_defs and BM.joker_defs[slug]
    return {
        name = (def and def.name) or name,
        stage = (def and def.stage) or (center and center.balatromon_stage) or '',
        slug = slug,
        key = key,
        center = center,
        route_note = rule_note(rule),
        bad_path = is_bad_rule(rule),
    }
end

local function def_evolution_slugs(slug)
    local def = BM.joker_defs and BM.joker_defs[slug]
    local out = {}
    for _, name in ipairs(split_evolution_names(def and def.evolves_to)) do
        out[#out + 1] = BM.slug(name)
    end
    return out
end

local function can_reach_slug(start_slug, target_slug, seen)
    if start_slug == target_slug then return true end
    seen = seen or {}
    if seen[start_slug] then return false end
    seen[start_slug] = true

    for _, next_slug in ipairs(def_evolution_slugs(start_slug)) do
        if can_reach_slug(next_slug, target_slug, seen) then
            return true
        end
    end

    return false
end

local function baby_option_from_slug(slug)
    local def = BM.joker_defs and BM.joker_defs[slug]
    local center = G.P_CENTERS[BM.center_key(slug)]
    if not (def and center) then return nil end

    return {
        name = def.name or slug,
        stage = def.stage or center.balatromon_stage or 'Fresh',
        slug = slug,
        key = BM.center_key(slug),
        center = center,
        route_note = 'Care Crisis: return to baby form',
        is_dedigivolution = true,
    }
end

function BM.get_care_crisis_baby_options(card)
    local source_slug = BM.get_card_slug(card)
    if not source_slug then return {} end

    local e = card.ability and card.ability.extra or {}

    -- Prefer the actual Fresh form this individual Digimon came from.
    for _, slug in ipairs(e.evolution_history or {}) do
        local def = BM.joker_defs and BM.joker_defs[slug]
        if def and def.stage == 'Fresh' then
            local option = baby_option_from_slug(slug)
            return option and {option} or {}
        end
    end

    -- Shop-obtained higher stages may have no personal history. In that case,
    -- find every Fresh Digimon in the database that can reach this form.
    local candidates = {}
    for slug, def in pairs(BM.joker_defs or {}) do
        if def.stage == 'Fresh' and slug ~= source_slug
        and can_reach_slug(slug, source_slug, {}) then
            local option = baby_option_from_slug(slug)
            if option then candidates[#candidates + 1] = option end
        end
    end

    table.sort(candidates, function(a, b)
        return tostring(a.name) < tostring(b.name)
    end)

    if #candidates > 0 then
        return candidates
    end

    -- A few special/standalone high-stage Digimon have no incoming line in
    -- the current database. They still need a valid Care Crisis consequence.
    -- Because Balatromon's Fresh forms are intentionally universal starting
    -- points, fall back to one deterministic random Fresh form.
    local source_def = BM.joker_defs and BM.joker_defs[source_slug]
    if source_def and source_def.stage ~= 'Fresh' then
        local fresh = {}
        for slug, def in pairs(BM.joker_defs or {}) do
            if def.stage == 'Fresh' and slug ~= source_slug then
                fresh[#fresh + 1] = slug
            end
        end
        table.sort(fresh)

        local picked = BM.random_element(
            fresh,
            'balatromon_crisis_baby_' .. tostring(source_slug)
                .. '_' .. tostring(card.sort_id or 0)
        )

        local option = picked and baby_option_from_slug(picked) or nil
        if option then
            option.route_note = 'Care Crisis: emergency baby reset'
            return {option}
        end
    end

    -- A Fresh Digimon is already at the baby stage. If it has no marked bad
    -- path, the player must repair its Care Mistakes instead.
    return {}
end

function BM.get_valid_evolutions(card, device_key)
    if not BM.is_digimon(card) then return {} end
    local e = card.ability and card.ability.extra or {}
    if e.permanently_disabled then return {} end

    local crisis = BM.is_care_crisis(card)

    -- Normal Digivolution requires full Bond. A Care Crisis is an exception:
    -- the Digivice is being used to resolve the crisis, so Bond is ignored.
    if not crisis and not BM.card_ready_for_digivolution(card) then return {} end

    local source_slug = BM.get_card_slug(card)
    local options = {}

    for _, name in ipairs(BM.parse_evolution_names(card)) do
        local center, key, slug = BM.find_digimon_center(name)
        local rule = get_rule(source_slug, slug)

        if center then
            local bad = is_bad_rule(rule)

            if crisis then
                -- At Care Mistakes 3, only explicitly marked bad routes may
                -- move forward.
                if bad and rule_allows(card, center, slug, device_key, rule) then
                    options[#options + 1] = make_option(name, center, key, slug, rule)
                end
            else
                -- Bad routes are hidden until an actual Care Crisis.
                if not bad and rule_allows(card, center, slug, device_key, rule) then
                    options[#options + 1] = make_option(name, center, key, slug, rule)
                end
            end
        end
    end

    if crisis and #options == 0 then
        return BM.get_care_crisis_baby_options(card)
    end

    return options
end

function BM.can_digivolve_with(card, device_key)
    return #BM.get_valid_evolutions(card, device_key) > 0
end

local function copy_evolution_history(history)
    local out = {}
    for i, value in ipairs(history or {}) do out[i] = value end
    return out
end

function BM.perform_digivolution(card, option, device_key)
    if not (card and option and option.center) then return false end

    local crisis = BM.is_care_crisis(card)
    if not crisis and not BM.card_ready_for_digivolution(card) then return false end

    -- Make sure the selected branch is still valid when the player clicks it.
    local still_valid = false
    device_key = device_key or (BM.pending_evolution and BM.pending_evolution.device_key)
    for _, candidate in ipairs(BM.get_valid_evolutions(card, device_key)) do
        if candidate.key == option.key then
            still_valid = true
            option = candidate
            break
        end
    end
    if not still_valid then return false end

    local old_slug = BM.get_card_slug(card)
    local e = card.ability.extra or {}
    local history = copy_evolution_history(e.evolution_history)

    if option.is_dedigivolution then
        history = {}
    elseif old_slug then
        history[#history + 1] = old_slug
    end

    local carry = {
        hunger = e.hunger or 1,
        care_mistakes = e.care_mistakes or 0,
        care_rounds = e.care_rounds or 0,
        evolution_history = history,
        previous_form = option.is_dedigivolution and nil or old_slug,
    }

    -- Give every form change a visible two-beat Digivolution animation, even
    -- when there is only one possible route and no branch-selection panel.
    card:juice_up(0.9, 0.8)
    play_sound('generic1')
    card_eval_status_text(card, 'extra', nil, nil, nil, {
        message = option.is_dedigivolution and 'De-Digivolving...' or 'Digivolving...',
        colour = G.C.ATTENTION,
        instant = true,
    })

    -- Card:set_ability does not represent removing/adding a Joker from the
    -- Joker area, so manually undo/apply Balatromon's passive on_add effects.
    if old_slug and BM.on_remove then BM.on_remove(card, old_slug) end

    card:set_ability(option.center, nil, true)
    card.ability.extra = card.ability.extra or {}
    card.ability.extra.hunger = carry.hunger
    card.ability.extra.care_rounds = carry.care_rounds
    card.ability.extra.evolution_history = carry.evolution_history
    card.ability.extra.previous_form = carry.previous_form

    -- Every form change starts the new form at 0 Bond.
    card.ability.extra.bond = 0
    card.ability.extra._bond_shaking = nil

    -- Care Crisis is the consequence itself. Once a bad Digivolution or
    -- forced De-Digivolution resolves it, the three mistakes are consumed.
    if crisis then
        card.ability.extra.care_mistakes = 0
        card.ability.extra.care_crisis = nil
    else
        card.ability.extra.care_mistakes = carry.care_mistakes
        card.ability.extra.care_crisis = nil
    end

    if option.slug and BM.on_add then BM.on_add(card, option.slug) end
    if card.set_cost then card:set_cost() end

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.25,
        func = function()
            if card and not card.REMOVED then
                card:juice_up(1.25, 0.8)
                play_sound('generic1')
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = option.is_dedigivolution and 'De-Digivolved!' or 'Digivolved!',
                    colour = option.is_dedigivolution and G.C.RED or G.C.GREEN,
                    instant = true,
                })
            end
            return true
        end,
    }))

    return true
end

local function make_preview_card(option)
    local preview = Card(0, 0, G.CARD_W * 0.72, G.CARD_H * 0.72, nil, option.center)
    preview.states.drag.can = false
    preview.states.click.can = false
    preview.states.hover.can = true
    return preview
end

local function make_choice_button(option)
    local button = UIBox_button({
        button = 'balatromon_choose_evolution',
        label = {option.is_dedigivolution and 'DE-DIGIVOLVE' or 'DIGIVOLVE'},
        minw = 2.25,
        minh = 0.55,
        colour = option.is_dedigivolution and G.C.RED or G.C.GREEN,
        scale = 0.35,
        shadow = true,
    })

    -- UIBox_button returns UI nodes; attach our target to the clickable node.
    if button and button.nodes and button.nodes[1] and button.nodes[1].config then
        button.nodes[1].config.balatromon_target_key = option.key
    end

    return button
end

function BM.create_evolution_choice_ui()
    local pending = BM.pending_evolution
    if not pending then
        return {n = G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes = {}}
    end

    local source = pending.card
    local source_center = source and source.config and source.config.center
    local source_slug = BM.get_card_slug(source)
    local source_def = source_slug and BM.joker_defs[source_slug]
    local source_name = (source_def and source_def.name)
        or (source_center and source_center.loc_txt and source_center.loc_txt.name)
        or 'Digimon'

    local option_nodes = {}
    for _, option in ipairs(pending.options or {}) do
        local preview = make_preview_card(option)
        option_nodes[#option_nodes + 1] = {
            n = G.UIT.C,
            config = {
                align = 'cm',
                padding = 0.12,
                minw = 2.55,
                r = 0.08,
                colour = lighten(G.C.BLACK, 0.08),
            },
            nodes = {
                {n = G.UIT.R, config = {align = 'cm'}, nodes = {
                    {n = G.UIT.T, config = {
                        text = option.name,
                        colour = G.C.UI.TEXT_LIGHT,
                        scale = 0.42,
                        shadow = true,
                    }},
                }},
                {n = G.UIT.R, config = {align = 'cm', padding = 0.03}, nodes = {
                    {n = G.UIT.T, config = {
                        text = option.stage,
                        colour = G.C.UI.TEXT_INACTIVE,
                        scale = 0.28,
                    }},
                }},
                {n = G.UIT.R, config = {align = 'cm', padding = 0.02}, nodes = {
                    {n = G.UIT.T, config = {
                        text = option.route_note or 'Standard route',
                        colour = option.bad_path and G.C.RED or G.C.UI.TEXT_INACTIVE,
                        scale = 0.23,
                    }},
                }},
                {n = G.UIT.R, config = {align = 'cm', padding = 0.04}, nodes = {
                    {n = G.UIT.O, config = {object = preview}},
                }},
                {n = G.UIT.R, config = {align = 'cm', padding = 0.05}, nodes = {
                    make_choice_button(option),
                }},
            },
        }
    end

    -- Keep large branches readable: at most three choices per row.
    local option_rows = {}
    for i = 1, #option_nodes, 3 do
        local row_nodes = {}
        for j = i, math.min(i + 2, #option_nodes) do
            row_nodes[#row_nodes + 1] = option_nodes[j]
        end
        option_rows[#option_rows + 1] = {
            n = G.UIT.R,
            config = {align = 'cm', padding = 0.06},
            nodes = row_nodes,
        }
    end

    local crisis = BM.is_care_crisis(source)
    local title = crisis and 'Care Crisis' or 'Choose Digivolution'
    local subtitle = crisis
        and (source_name .. ' must change form:')
        or (source_name .. ' can Digivolve into:')

    local content_nodes = {
        {n = G.UIT.R, config = {align = 'cm', padding = 0.05}, nodes = {
            {n = G.UIT.T, config = {
                text = title,
                colour = crisis and G.C.RED or G.C.UI.TEXT_LIGHT,
                scale = 0.62,
                shadow = true,
            }},
        }},
        {n = G.UIT.R, config = {align = 'cm', padding = 0.03}, nodes = {
            {n = G.UIT.T, config = {
                text = subtitle,
                colour = G.C.UI.TEXT_INACTIVE,
                scale = 0.34,
            }},
        }},
    }

    for _, row in ipairs(option_rows) do
        content_nodes[#content_nodes + 1] = row
    end

    content_nodes[#content_nodes + 1] = {
        n = G.UIT.R,
        config = {align = 'cm', padding = 0.03},
        nodes = {
            {n = G.UIT.T, config = {
                text = 'Choose the path of your destiny',
                colour = G.C.UI.TEXT_INACTIVE,
                scale = 0.26,
            }},
        },
    }

    return {
        n = G.UIT.ROOT,
        config = {align = 'cm', colour = G.C.CLEAR},
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    align = 'cm',
                    padding = 0.18,
                    r = 0.12,
                    colour = G.C.BLACK,
                    emboss = 0.08,
                },
                nodes = content_nodes,
            },
        },
    }
end

function BM.open_evolution_choice(card, options, device_key)
    BM.pending_evolution = {
        card = card,
        options = options,
        device_key = device_key,
        was_paused = G.SETTINGS and G.SETTINGS.paused == true,
    }

    G.FUNCS.overlay_menu({
        definition = BM.create_evolution_choice_ui(),
    })
end

local function close_choice_overlay(e)
    if G.FUNCS and G.FUNCS.exit_overlay_menu then
        G.FUNCS.exit_overlay_menu(e)
    end
end

function BM.process_evolution_queue()
    if BM.pending_evolution or BM._evolution_animation_busy then return end
    if not (BM.evolution_queue and #BM.evolution_queue > 0) then return end

    local entry = table.remove(BM.evolution_queue, 1)
    local card = entry and entry.card
    local device_key = entry and entry.device_key

    if not (card and not card.REMOVED) then
        return BM.process_evolution_queue()
    end

    local options = BM.get_valid_evolutions(card, device_key)

    if #options == 1 then
        BM._evolution_animation_busy = true
        BM.perform_digivolution(card, options[1], device_key)

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.45,
            func = function()
                BM._evolution_animation_busy = false
                BM.process_evolution_queue()
                return true
            end,
        }))
    elseif #options > 1 then
        BM.open_evolution_choice(card, options, device_key)
    else
        BM.process_evolution_queue()
    end
end

function BM.begin_evolution_sequence(cards, device_key)
    BM.evolution_queue = {}
    BM.pending_evolution = nil

    for _, card in ipairs(cards or {}) do
        if card and not card.REMOVED and BM.can_digivolve_with(card, device_key) then
            BM.evolution_queue[#BM.evolution_queue + 1] = {
                card = card,
                device_key = device_key,
            }
        end
    end

    BM.process_evolution_queue()
end

G.FUNCS.balatromon_choose_evolution = function(e)
    if BM._evolution_choice_busy then return end
    local pending = BM.pending_evolution
    local key = e and e.config and e.config.balatromon_target_key
    if not (pending and key) then return end

    local chosen = nil
    for _, option in ipairs(pending.options or {}) do
        if option.key == key then
            chosen = option
            break
        end
    end
    if not chosen then return end

    BM._evolution_choice_busy = true
    local card = pending.card

    if BM.perform_digivolution(card, chosen, pending.device_key) then
        BM.pending_evolution = nil
        close_choice_overlay(e)

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.45,
            func = function()
                BM._evolution_choice_busy = false
                BM.process_evolution_queue()
                return true
            end,
        }))
    else
        BM._evolution_choice_busy = false
    end
end
