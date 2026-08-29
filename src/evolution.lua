local BM = Balatromon


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
        grizzlymon = {device = 'd3', note = 'D-3 Armor route'},
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
        kimeramon = {note = 'Standard route'}
    },
    kimeramon = {
        apocalymon = {note = 'Standard route'}
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
    kuramon = {
        tsumemon = {
            note = 'Standard route'
        },
    },

    tsumemon = {
        keramon = {
            note = 'Standard route'
        },

        espimon = {
            note = 'Rare route'
        },
    },

    keramon = {
        bakemon = {
            note = 'Standard route'
        },

        raremon = {
            bad_path = true,
            note = 'Care Crisis route'
        },
    },

    raremon = {
        garbagemon = {
            note = 'Standard route'
        },
    },

    bakemon = {
        phantomon = {
            note = 'Standard route'
        },
    },

    phantomon = {
        malomyotismon = {
            note = 'Standard route'
        },

        puppetmon = {
            note = 'Standard route'
        },
    },

    pumpkinmon = {
        puppetmon = {
            note = 'Standard route'
        },
    },

    yuramon = {
        tanemon = {
            note = 'Standard route'
        },
    },

    tanemon = {
        palmon = {
            note = 'Standard route'
        },
        lalamon = {
            note = 'Standard route'
        },
        mushroomon = {
            note = 'Standard route'
        },
    },

    palmon = {
        togemon = {
            note = 'Standard route'
        },
        numemon = {
            bad_path = true,
            note = 'Care Crisis route'
        },
    },

    lalamon = {
        sunflowmon = {
            note = 'Standard route'
        },
    },

    mushroomon = {
        redvegiemon = {
            min_hunger = 2,
            note = 'Hungry route'
        },
        woodmon = {
            max_hunger = 1,
            note = 'Well-fed route'
        },
    },

    togemon = {
        lillymon = {
            note = 'Standard route'
        },
    },

    sunflowmon = {
        lilamon = {
            note = 'Standard route'
        },
        pumpkinmon = {
            min_hunger = 2,
            note = 'Hungry route'
        },
    },

    redvegiemon = {
        jagamon = {
            note = 'Standard route'
        },
        pumpkinmon = {
            min_hunger = 2,
            note = 'Hungry route'
        },
    },

    woodmon = {
        cherrymon = {
            note = 'Standard route'
        },
    },

    lillymon = {
        rosemon = {
            note = 'Standard route'
        },
    },

    lilamon = {
        rosemon = {
            note = 'Standard route'
        },
    },

    jagamon = {
        hydramon = {
            note = 'Standard route'
        },
    },

    cherrymon = {
        rosemon = {
            note = 'Standard route'
        },
    },
    twins = {
        upamon = {
            note = 'Standard route'
        },
        motimon = {
            note = 'Standard route'
        },
    },
    upamon = {
        armadillomon = {
            note = 'Standard route'
        },
    },

    motimon = {
        tentomon = {
            note = 'Standard route'
        },
    },

    armadillomon = {
        ankiromon = {
            note = 'Standard route'
        },
        monochromon = {
            note = 'Alternate standard route'
        },
        digmon = {
            device = 'd3',
            note = 'D-3 Armor route'
        },
        tortomon = {
            min_hunger = 2,
            note = 'Hungry route'
        },
    },

    tentomon = {
        kabuterimon = {
            note = 'Standard route'
        },
        kuwagamon = {
            min_hunger = 3,
            note = 'High-Hunger route'
        },
    },

    ankiromon = {
        triceramon = {
            note = 'Standard route'
        },
        tankdramon = {
            min_care = 1,
            note = 'Rough-care route'
        },
    },

    digmon = {
        megakabuterimon = {
            note = 'Standard route'
        },
        okuwamon = {
            min_care = 1,
            note = 'Rough-care route'
        },
    },

    tortomon = {
        triceramon = {
            note = 'Standard route'
        },
        tankdramon = {
            min_care = 1,
            note = 'Rough-care route'
        },
    },

    kabuterimon = {
        megakabuterimon = {
            note = 'Standard route'
        },
    },

    kuwagamon = {
        okuwamon = {
            note = 'Standard route'
        },
    },

    megakabuterimon = {
        herculeskabuterimon = {
            note = 'Standard route'
        },
    },

    okuwamon = {
        herculeskabuterimon = {
            note = 'Standard route'
        },
    },

    leafmon = {
        minomon = {
            note = 'Standard route'
        },
    },

    minomon = {
        wormmon = {
            note = 'Standard route'
        },
    },

    wormmon = {
        stingmon = {
            note = 'Standard route'
        },
    },

    stingmon = {
        dinobeemon = {
            note = 'Standard route'
        },
    },

    dinobeemon = {
        imperialdramon_fighter_mode = {
            note = 'Mode choice'
        },
        imperialdramon_dragon_mode = {
            note = 'Mode choice'
        },
    },

    aoibotamamon = {
        wanyamon = {
            note = 'Standard route'
        },
    },

    wanyamon = {
        bearmon = {
            note = 'Standard route'
        },
    },

    bearmon = {
        grizzlymon = {
            note = 'Standard route'
        },
        garurumon = {
            min_hunger = 2,
            note = 'Hungry route'
        },
        leomon = {
            min_care = 1,
            note = 'Rough-care route'
        },
        madleomon = {
            min_care = 2,
            max_care = 2,
            note = '2 Care Mistakes route'
        },
    },

    grizzlymon = {
        greatgrizzlymon = {
            note = 'Standard route'
        },
        loaderleomon = {
            min_hunger = 3,
            note = 'High-Hunger route'
        },
    },

    greatgrizzlymon = {
        callismon = {
            note = 'Standard route'
        },
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


    return {}
end

function BM.get_valid_evolutions(card, device_key, opts)
    opts = opts or {}

    if not BM.is_digimon(card) then
        return {}
    end

    if BM.is_digivolution_blocked
    and BM.is_digivolution_blocked(card) then
        return {}
    end

    local e =
        card.ability
        and card.ability.extra
        or {}

    if e.permanently_disabled then
        return {}
    end

    local crisis =
        BM.is_care_crisis(card)

    if not crisis
    and not opts.ignore_bond
    and not BM.card_ready_for_digivolution(card) then
        return {}
    end

    local source_slug =
        BM.get_card_slug(card)

    local evolution_names =
        BM.parse_evolution_names(card)

    if BM.has_x_antibody
    and BM.has_x_antibody(card) then
        local extras =
            BM.x_antibody_extra_evolutions
            and BM.x_antibody_extra_evolutions[
                source_slug
            ]

        for _, target_slug in ipairs(
            extras or {}
        ) do
            local target_def =
                BM.joker_defs
                and BM.joker_defs[
                    target_slug
                ]

            if target_def then
                evolution_names[
                    #evolution_names + 1
                ] =
                    target_def.name
                    or target_slug
            end
        end
    end

    local options = {}

    for _, name in ipairs(
        evolution_names
    ) do
        local center,
            key,
            slug =
            BM.find_digimon_center(
                name
            )

        local rule =
            get_rule(
                source_slug,
                slug
            )

        local x_allowed =
            not (
                BM.has_x_antibody
                and BM.has_x_antibody(
                    card
                )
            )
            or (
                BM.can_x_evolve_to
                and BM.can_x_evolve_to(
                    slug
                )
            )

        if center
        and x_allowed then
            local bad =
                is_bad_rule(rule)

            if crisis then
                if bad
                and rule_allows(
                    card,
                    center,
                    slug,
                    device_key,
                    rule
                ) then
                    options[
                        #options + 1
                    ] =
                        make_option(
                            name,
                            center,
                            key,
                            slug,
                            rule
                        )
                end
            else
                if not bad
                and rule_allows(
                    card,
                    center,
                    slug,
                    device_key,
                    rule
                ) then
                    options[
                        #options + 1
                    ] =
                        make_option(
                            name,
                            center,
                            key,
                            slug,
                            rule
                        )
                end
            end
        end
    end

    if crisis
    and #options == 0 then
        return BM.get_care_crisis_baby_options(
            card
        )
    end

    return options
end

function BM.can_digivolve_with(card, device_key)
    return #BM.get_valid_evolutions(card, device_key) > 0
end


function BM.get_evolution_card_candidates()
    local candidates = {}

    if not (G.jokers and G.jokers.cards) then
        return candidates
    end

    for _, digimon in ipairs(G.jokers.cards) do

        if BM.is_digimon(digimon) then

            -- Evolution Cards ignore Bond, but all other
            -- evolution-route rules still apply.
            local options = BM.get_valid_evolutions(
                digimon,
                'evolution_card',
                {
                    ignore_bond = true
                }
            )

            if #options > 0 then
                candidates[#candidates + 1] = {
                    card = digimon,
                    options = options
                }
            end

        end
    end

    return candidates
end


function BM.trigger_evolution_card(source_card)
    local candidates = BM.get_evolution_card_candidates()

    if #candidates == 0 then
        return false
    end

    -- Pick a random Digimon.
    local target = BM.random_element(
        candidates,
        'balatromon_evolution_card_target_'
            .. tostring(source_card and source_card.sort_id or 0)
    )

    if not target then
        return false
    end

    -- Then randomly choose one of that Digimon's
    -- currently viable branches.
    local option = BM.random_element(
        target.options,
        'balatromon_evolution_card_branch_'
            .. tostring(source_card and source_card.sort_id or 0)
    )

    if not option then
        return false
    end

    return BM.perform_digivolution(
        target.card,
        option,
        'evolution_card',
        {
            ignore_bond = true
        }
    )
end

local function copy_evolution_history(history)
    local out = {}
    for i, value in ipairs(history or {}) do out[i] = value end
    return out
end

function BM.perform_digivolution(card, option, device_key, opts)
    opts = opts or {}
    if not (card and option and option.center) then return false end

    local crisis = BM.is_care_crisis(card)
    if not crisis and not opts.ignore_bond and not BM.card_ready_for_digivolution(card) then return false end

    -- Make sure the selected branch is still valid when the player clicks it.
    local still_valid = false
    device_key = device_key or (BM.pending_evolution and BM.pending_evolution.device_key)
    for _, candidate in ipairs(BM.get_valid_evolutions(card, device_key, opts)) do
        if candidate.key == option.key then
            still_valid = true
            option = candidate
            break
        end
    end
    if not still_valid then return false end

    local old_slug = BM.get_card_slug(card)
    local e = card.ability.extra or {}

    local had_x_antibody =
        BM.has_x_antibody
        and BM.has_x_antibody(card)

    local x_antibody_rounds =
        had_x_antibody
        and BM.get_x_antibody_rounds(card)
        or 0

    local history = copy_evolution_history(e.evolution_history)

    if option.is_dedigivolution then
        history = {}
    elseif old_slug then
        history[#history + 1] = old_slug
    end

    -- Gallantmon inherits one third of the previous form's accumulated
    -- numeric value. WarGrowlmon and Knightmon store that scaling as `mult`.
    -- Forms with no accumulated numeric value fall back to 3 (X1 Mult).
    local previous_form_value = 3
    if type(e.mult) == 'number' then
        previous_form_value = e.mult
    elseif type(e.chips) == 'number' then
        previous_form_value = e.chips
    elseif type(e.xmult) == 'number' then
        previous_form_value = e.xmult
    end

    local carry = {
        hunger = e.hunger or 1,
        care_mistakes = e.care_mistakes or 0,
        care_rounds = e.care_rounds or 0,
        evolution_history = history,
        previous_form = option.is_dedigivolution and nil or old_slug,
        previous_form_value = option.is_dedigivolution and nil or previous_form_value,
        chips = e.chips,
        mult = e.mult,
        xmult = e.xmult,
        xchips = e.xchips,
        x_garurumon_chips = e.x_garurumon_chips,
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

    if not option.is_dedigivolution then
        if (
            old_slug == 'gabumon'
            and (
                option.slug == 'garurumon'
                or option.slug == 'leomon'
            )
        )
        or (
            old_slug == 'garurumon'
            and option.slug == 'weregarurumon'
        ) then
            card.ability.extra.chips =
                carry.chips or 0
        end
    end

    card.ability.extra =
        card.ability.extra or {}

    card.ability.extra.hunger =
        carry.hunger

    card.ability.extra.care_rounds =
        carry.care_rounds

    card.ability.extra.evolution_history =
        carry.evolution_history

    card.ability.extra.previous_form =
        carry.previous_form

    card.ability.extra.previous_form_value =
        carry.previous_form_value
    
    if old_slug == 'garurumon'
        and option.slug == 'weregarurumon'
        and had_x_antibody then
            card.ability.extra.x_weregarurumon_chips =
                carry.x_garurumon_chips or 1
    end

    if not option.is_dedigivolution then
        if (
            old_slug == 'gabumon'
            and (
                option.slug == 'garurumon'
                or option.slug == 'leomon'
            )
        )
        or (
            old_slug == 'garurumon'
            and option.slug == 'weregarurumon'
        ) then
            card.ability.extra.chips =
                e.chips or 0
        end
    end

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

    if had_x_antibody
    and BM.can_x_evolve_to(option.slug) then
        BM.restore_x_antibody(
            card,
            x_antibody_rounds
        )

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.30,

            func = function()
                if card
                and not card.REMOVED
                and BM.has_x_antibody(card) then
                    BM.set_x_antibody_sprite(
                        card
                    )
                end

                return true
            end
        }))
    end

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

local function copy_recovery_data(value, seen)
    if type(value) ~= 'table' then
        return value
    end

    seen = seen or {}

    if seen[value] then
        return seen[value]
    end

    local out = {}
    seen[value] = out

    for k, v in pairs(value) do
        out[copy_recovery_data(k, seen)] =
            copy_recovery_data(v, seen)
    end

    return out
end

function BM.make_recovery_digitama(card)
    if not card
    or card.REMOVED
    or not BM.is_digimon(card) then
        return false
    end

    local e = card.ability
        and card.ability.extra
        or {}

    if not e.permanently_disabled then
        return false
    end

    local old_slug = BM.get_card_slug(card)

    if not old_slug
    or old_slug == 'recovery_digitama' then
        return false
    end

    local egg_center =
        G.P_CENTERS[
            BM.center_key('recovery_digitama')
        ]

    if not egg_center then
        return false
    end

    local saved_extra =
        copy_recovery_data(e)

    saved_extra.hunger = 1
    saved_extra.bond = 0
    saved_extra.care_mistakes = 0
    saved_extra.care_rounds = 0
    saved_extra.care_crisis = nil
    saved_extra.permanently_disabled = nil
    saved_extra._care_ticked_this_round = nil
    saved_extra._bond_shaking = nil
    saved_extra._recovery_ticked_this_round = nil

    if BM.on_remove then
        BM.on_remove(
            card,
            old_slug
        )
    end

    SMODS.debuff_card(
        card,
        false,
        'balatromon_hunger'
    )

    card:set_ability(
        egg_center,
        nil,
        true
    )

    card.ability.extra =
        card.ability.extra or {}

    card.ability.extra.recovery_rounds = 2
    card.ability.extra.recover_slug =
        old_slug
    card.ability.extra.recover_extra =
        saved_extra

    if SMODS.recalc_debuff then
        SMODS.recalc_debuff(card)
    end

    if card.set_cost then
        card:set_cost()
    end

    card:juice_up(1.25, 0.8)

    card_eval_status_text(
        card,
        'extra',
        nil,
        nil,
        nil,
        {
            message = 'Digitama!',
            colour = G.C.ATTENTION
        }
    )

    return true
end

function BM.restore_recovery_digitama(card)
    if not card
    or card.REMOVED
    or BM.get_card_slug(card)
        ~= 'recovery_digitama' then
        return false
    end

    local e = card.ability
        and card.ability.extra
        or {}

    local recover_slug =
        e.recover_slug

    if not recover_slug then
        return false
    end

    local center =
        G.P_CENTERS[
            BM.center_key(recover_slug)
        ]

    if not center then
        return false
    end

    local saved_extra =
        copy_recovery_data(
            e.recover_extra or {}
        )

    card._bm_suppress_on_add = true

    card:set_ability(
        center,
        nil,
        true
    )

    card.ability.extra =
        card.ability.extra or {}

    for k, v in pairs(saved_extra) do
        card.ability.extra[k] = v
    end

    card.ability.extra.hunger = 1
    card.ability.extra.bond = 0
    card.ability.extra.care_mistakes = 0
    card.ability.extra.care_rounds = 0
    card.ability.extra.care_crisis = nil
    card.ability.extra.permanently_disabled = nil
    card.ability.extra._care_ticked_this_round = nil
    card.ability.extra._bond_shaking = nil
    card.ability.extra.recovery_rounds = nil
    card.ability.extra.recover_slug = nil
    card.ability.extra.recover_extra = nil
    card.ability.extra._recovery_ticked_this_round = nil

    card.ability.extra._bm_passive_applied = nil
    card.ability.extra._bm_passive_removed = nil
    card.ability.extra._bm_passive_slug = nil

    SMODS.debuff_card(
        card,
        false,
        'balatromon_hunger'
    )

    if SMODS.recalc_debuff then
        SMODS.recalc_debuff(card)
    end

    card._bm_suppress_on_add = nil

    if BM.on_add then
        BM.on_add(
            card,
            recover_slug
        )
    end

    if card.set_cost then
        card:set_cost()
    end

    card:juice_up(1.4, 1.0)

    card_eval_status_text(
        card,
        'extra',
        nil,
        nil,
        nil,
        {
            message = 'Recovered!',
            colour = G.C.GREEN
        }
    )

    return true
end

function BM.tick_recovery_digitama(card, context)
    if not (
        context.end_of_round
        and context.main_eval
        and not context.blueprint
    ) then
        return
    end

    local e = card.ability.extra

    if e._recovery_ticked_this_round then
        return
    end

    e._recovery_ticked_this_round = true

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0,
        func = function()
            if card
            and not card.REMOVED
            and card.ability
            and card.ability.extra then
                card.ability.extra
                    ._recovery_ticked_this_round = nil
            end

            return true
        end
    }))

    e.recovery_rounds =
        math.max(
            0,
            (e.recovery_rounds or 2) - 1
        )

    if e.recovery_rounds > 0 then
        return {
            message =
                tostring(e.recovery_rounds)
                .. ' Round Left',
            colour = G.C.ATTENTION
        }
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = function()
            if card
            and not card.REMOVED then
                BM.restore_recovery_digitama(
                    card
                )
            end

            return true
        end
    }))

    return {
        message = 'Hatching!',
        colour = G.C.GREEN
    }
end

function BM.can_dedigivolve_one_stage(card)
    if not card
    or card.REMOVED
    or not BM.is_digimon(card) then
        return false
    end

    if BM.get_card_slug(card)
        == 'recovery_digitama' then
        return false
    end

    local e = card.ability
        and card.ability.extra
        or {}

    if e.permanently_disabled then
        return false
    end

    return e.evolution_history
        and #e.evolution_history > 0
end

function BM.dedigivolve_one_stage(card)
    if not BM.can_dedigivolve_one_stage(
        card
    ) then
        return false
    end

    local old_slug =
        BM.get_card_slug(card)

    local old_extra =
        card.ability.extra

    local history =
        copy_evolution_history(
            old_extra.evolution_history
        )

    local previous_slug =
        table.remove(history)

    if not previous_slug then
        return false
    end

    local center =
        G.P_CENTERS[
            BM.center_key(previous_slug)
        ]

    if not center then
        return false
    end

    local hunger =
        old_extra.hunger or 1

    local care_mistakes =
        old_extra.care_mistakes or 0

    local care_rounds =
        old_extra.care_rounds or 0

    card:juice_up(0.9, 0.8)

    card_eval_status_text(
        card,
        'extra',
        nil,
        nil,
        nil,
        {
            message = 'De-Digivolving...',
            colour = G.C.ATTENTION
        }
    )

    if old_slug
    and BM.on_remove then
        BM.on_remove(
            card,
            old_slug
        )
    end

    card:set_ability(
        center,
        nil,
        true
    )

    card.ability.extra =
        card.ability.extra or {}

    card.ability.extra.hunger =
        hunger

    card.ability.extra.bond =
        0

    card.ability.extra.care_mistakes =
        care_mistakes

    card.ability.extra.care_rounds =
        care_rounds

    card.ability.extra.care_crisis =
        nil

    card.ability.extra.evolution_history =
        history

    card.ability.extra.previous_form =
        history[#history]

    card.ability.extra.previous_form_value =
        nil

    if BM.on_add then
        BM.on_add(
            card,
            previous_slug
        )
    end

    if card.set_cost then
        card:set_cost()
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.25,
        func = function()
            if card
            and not card.REMOVED then
                card:juice_up(
                    1.25,
                    0.8
                )

                card_eval_status_text(
                    card,
                    'extra',
                    nil,
                    nil,
                    nil,
                    {
                        message =
                            'De-Digivolved!',
                        colour =
                            G.C.RED
                    }
                )
            end

            return true
        end
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

function BM.queue_care_crisis(card)
    if not card
    or card.REMOVED
    or not BM.is_digimon(card) then
        return false
    end

    local e = card.ability and card.ability.extra or {}

    if e.permanently_disabled
    or not BM.is_care_crisis(card) then
        return false
    end

    if BM.pending_evolution
    and BM.pending_evolution.card == card then
        return false
    end

    BM.evolution_queue = BM.evolution_queue or {}

    for _, entry in ipairs(BM.evolution_queue) do
        if entry.card == card then
            return false
        end
    end

    BM.evolution_queue[#BM.evolution_queue + 1] = {
        card = card,
        device_key = 'care_crisis'
    }

    BM.process_evolution_queue()

    return true
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


function BM.get_display_evolutions(card)
    if not BM.is_digimon(card) then
        return {}
    end

    local source_slug =
        BM.get_card_slug(card)

    local evolution_names =
        BM.parse_evolution_names(card)

    local is_x =
        BM.has_x_antibody
        and BM.has_x_antibody(card)

    if is_x then
        local extras =
            BM.x_antibody_extra_evolutions
            and BM.x_antibody_extra_evolutions[
                source_slug
            ]

        for _, target_slug in ipairs(
            extras or {}
        ) do
            local def =
                BM.joker_defs
                and BM.joker_defs[
                    target_slug
                ]

            if def then
                evolution_names[
                    #evolution_names + 1
                ] =
                    def.name
                    or target_slug
            end
        end
    end

    local options = {}

    for _, name in ipairs(
        evolution_names
    ) do
        local center,
            key,
            slug =
            BM.find_digimon_center(
                name
            )

        local x_allowed =
            not is_x
            or (
                BM.can_x_evolve_to
                and BM.can_x_evolve_to(
                    slug
                )
            )

        if center
        and x_allowed then
            local rule =
                BM.evolution_rules
                and BM.evolution_rules[
                    source_slug
                ]
                and BM.evolution_rules[
                    source_slug
                ][slug]

            local route_note =
                'Standard route'

            local bad_path =
                false

            if type(rule) == 'table' then
                route_note =
                    rule.note
                    or route_note

                bad_path =
                    rule.bad_path
                    == true
            end

            local def =
                BM.joker_defs
                and BM.joker_defs[
                    slug
                ]

            if is_x
            and BM.x_antibody_extra_evolutions
            and BM.x_antibody_extra_evolutions[
                source_slug
            ] then
                for _, extra_slug in ipairs(
                    BM.x_antibody_extra_evolutions[
                        source_slug
                    ]
                ) do
                    if extra_slug == slug then
                        route_note =
                            'X-Antibody route'

                        break
                    end
                end
            end

            options[
                #options + 1
            ] = {
                name =
                    (def and def.name)
                    or name,

                stage =
                    (def and def.stage)
                    or center.balatromon_stage
                    or '',

                slug = slug,
                key = key,
                center = center,

                route_note =
                    route_note,

                bad_path =
                    bad_path,

                x_form =
                    is_x
            }
        end
    end

    return options
end



BM.evolution_display = BM.evolution_display or nil


local function make_display_preview(option)
    local preview = Card(
        0,
        0,
        G.CARD_W * 0.72,
        G.CARD_H * 0.72,
        nil,
        option.center
    )

    preview.states.drag.can = false
    preview.states.click.can = false
    preview.states.hover.can = true

    if option.x_form
    and BM.x_antibody_forms
    and BM.x_antibody_forms[
        option.slug
    ] then
        preview.ability.extra =
            preview.ability.extra or {}

        preview.ability.extra
            .x_antibody_rounds =
            1

        BM.set_x_antibody_sprite(
            preview
        )
    end

    return preview
end


function BM.create_evolution_display_ui()

    local display = BM.evolution_display

    if not display then
        return {
            n = G.UIT.ROOT,
            config = {
                align = 'cm',
                colour = G.C.CLEAR
            },
            nodes = {}
        }
    end


    local source = display.card

    local source_slug =
        BM.get_card_slug(source)

    local source_def =
        source_slug
        and BM.joker_defs[source_slug]

    local source_center =
        source
        and source.config
        and source.config.center

    local source_name =
        (source_def and source_def.name)
        or (
            source_center
            and source_center.loc_txt
            and source_center.loc_txt.name
        )
        or 'Digimon'



    local option_nodes = {}

    for _, option in ipairs(display.options or {}) do

        local preview =
            make_display_preview(option)

        option_nodes[#option_nodes + 1] = {

            n = G.UIT.C,

            config = {
                align = 'cm',
                padding = 0.12,
                minw = 2.5,
                r = 0.08,
                colour = lighten(
                    G.C.BLACK,
                    0.08
                ),
            },

            nodes = {

                
                {
                    n = G.UIT.R,
                    config = {
                        align = 'cm'
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = option.name,
                                colour = G.C.UI.TEXT_LIGHT,
                                scale = 0.42,
                                shadow = true,
                            }
                        },
                    }
                },


                
                {
                    n = G.UIT.R,
                    config = {
                        align = 'cm',
                        padding = 0.03
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = option.stage,
                                colour =
                                    G.C.UI.TEXT_INACTIVE,
                                scale = 0.28,
                            }
                        },
                    }
                },


                
                {
                    n = G.UIT.R,
                    config = {
                        align = 'cm',
                        padding = 0.02
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text =
                                    option.route_note
                                    or 'Standard route',

                                colour =
                                    option.bad_path
                                    and G.C.RED
                                    or G.C.UI.TEXT_INACTIVE,

                                scale = 0.23,
                            }
                        },
                    }
                },


                {
                    n = G.UIT.R,
                    config = {
                        align = 'cm',
                        padding = 0.04
                    },
                    nodes = {
                        {
                            n = G.UIT.O,
                            config = {
                                object = preview
                            }
                        },
                    }
                },
            }
        }
    end


    local option_rows = {}

    for i = 1, #option_nodes, 3 do

        local row = {}

        for j = i, math.min(
            i + 2,
            #option_nodes
        ) do

            row[#row + 1] =
                option_nodes[j]
        end

        option_rows[#option_rows + 1] = {

            n = G.UIT.R,

            config = {
                align = 'cm',
                padding = 0.06,
            },

            nodes = row
        }
    end


    local content = {

        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.05
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        text = 'Evolution Paths',
                        colour = G.C.UI.TEXT_LIGHT,
                        scale = 0.62,
                        shadow = true,
                    }
                },
            }
        },



        {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.03
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        text =
                            source_name
                            .. ' can evolve into:',

                        colour =
                            G.C.UI.TEXT_INACTIVE,

                        scale = 0.34,
                    }
                },
            }
        },
    }


    if #option_rows == 0 then

        content[#content + 1] = {

            n = G.UIT.R,

            config = {
                align = 'cm',
                padding = 0.25,
            },

            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        text =
                            'No further evolutions',

                        colour =
                            G.C.UI.TEXT_INACTIVE,

                        scale = 0.38,
                    }
                },
            }
        }

    else

        for _, row in ipairs(option_rows) do
            content[#content + 1] = row
        end

    end



    content[#content + 1] = {

        n = G.UIT.R,

        config = {
            align = 'cm',
            padding = 0.12
        },

        nodes = {

            UIBox_button {
                button =
                    'balatromon_close_evolution_display',

                label = {'CLOSE'},

                minw = 2.3,
                minh = 0.55,

                colour =
                    G.C.UI.BACKGROUND_INACTIVE,

                scale = 0.35,

                shadow = true,
            }
        }
    }


    return {

        n = G.UIT.ROOT,

        config = {
            align = 'cm',
            colour = G.C.CLEAR
        },

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

                nodes = content
            }
        }
    }
end


function BM.open_evolution_display(card)
    if not BM.is_digimon(card) then
        return
    end

    local options = BM.get_display_evolutions(card)

    local is_collection =
        card.area
        and card.area.config
        and card.area.config.collection == true

    BM.evolution_display = {
        card = card,
        options = options,
        from_collection = is_collection
    }

    if is_collection then
        if not G.OVERLAY_MENU then
            BM.evolution_display = nil
            return
        end

        G.OVERLAY_MENU:remove()

        G.OVERLAY_MENU = UIBox {
            definition = BM.create_evolution_display_ui(),
            config = {
                align = 'cm',
                offset = {
                    x = 0,
                    y = 0
                },
                major = G.ROOM_ATTACH,
                bond = 'Weak'
            }
        }

        return
    end

    G.FUNCS.overlay_menu({
        definition = BM.create_evolution_display_ui()
    })
end


G.FUNCS.balatromon_close_evolution_display = function(e)
    local from_collection =
        BM.evolution_display
        and BM.evolution_display.from_collection

    BM.evolution_display = nil

    if from_collection then
        if G.OVERLAY_MENU then
            G.OVERLAY_MENU:remove()
            G.OVERLAY_MENU = nil
        end

        G.OVERLAY_MENU = UIBox {
            definition = create_UIBox_your_collection_jokers(),
            config = {
                align = 'cm',
                offset = {
                    x = 0,
                    y = 0
                },
                major = G.ROOM_ATTACH,
                bond = 'Weak'
            }
        }

        return
    end

    if G.FUNCS and G.FUNCS.exit_overlay_menu then
        G.FUNCS.exit_overlay_menu(e)
    end
end