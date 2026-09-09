local BM = Balatromon
local MOD = BM.MOD or SMODS.current_mod

BM.MODE_STANDARD = 'standard'
BM.MODE_CASUAL = 'casual'

BM.MODE_RULES = {
    standard = {
        name = 'Standard',
        hunger_max = 5,
        bond_gain_max_hunger = 3,
        starvation_revivable = false,
        manual_evolution = false,
        digivice_bond = 'max',
        care_crisis_revert_stages = nil,
        bond_caps = {
            Fresh = 1,
            ['In-Training'] = 1,
            Rookie = 3,
            Champion = 5,
            Rare = 5,
            Ultimate = 5,
            Mega = 5,
            Beyond = 5,
            Digitama = 5,
        },
    },

    casual = {
        name = 'Casual',
        hunger_max = 7,
        bond_gain_max_hunger = 5,
        starvation_revivable = true,
        manual_evolution = true,
        digivice_bond = 3,
        care_crisis_revert_stages = 2,
        bond_caps = {
            Fresh = 3,
            ['In-Training'] = 3,
            Rookie = 5,
            Champion = 7,
            Rare = 7,
            Ultimate = 9,
            Mega = 9,
            Beyond = 9,
            Digitama = 5,
        },
    },
}

local function configured_mode_index()
    local config = (MOD and MOD.config) or {}
    local index = tonumber(config.mode) or 1
    return index == 2 and 2 or 1
end

function BM.get_configured_mode()
    return configured_mode_index() == 2
        and BM.MODE_CASUAL
        or BM.MODE_STANDARD
end

function BM.set_configured_mode(mode)
    local index = (mode == BM.MODE_CASUAL or tonumber(mode) == 2) and 2 or 1

    if MOD then
        MOD.config = MOD.config or {}
        MOD.config.mode = index

        if SMODS and SMODS.save_mod_config then
            pcall(SMODS.save_mod_config, MOD)
        end
    end

    return index == 2 and BM.MODE_CASUAL or BM.MODE_STANDARD
end

function BM.get_mode()
    local run_mode = G
        and G.GAME
        and G.GAME.balatromon_mode

    if run_mode == BM.MODE_STANDARD
    or run_mode == BM.MODE_CASUAL then
        return run_mode
    end

    return BM.get_configured_mode()
end

function BM.get_mode_name()
    local rules = BM.MODE_RULES[BM.get_mode()]
        or BM.MODE_RULES.standard
    return rules.name
end

function BM.get_mode_rules()
    return BM.MODE_RULES[BM.get_mode()]
        or BM.MODE_RULES.standard
end

function BM.is_casual_mode()
    return BM.get_mode() == BM.MODE_CASUAL
end

function BM.get_hunger_max()
    return BM.get_mode_rules().hunger_max or 5
end

function BM.get_bond_gain_max_hunger()
    return BM.get_mode_rules().bond_gain_max_hunger or 3
end

function BM.can_revive_starved()
    return BM.get_mode_rules().starvation_revivable == true
end

function BM.manual_evolution_enabled()
    return BM.get_mode_rules().manual_evolution == true
end

function BM.get_mode_bond_max(stage)
    local caps = BM.get_mode_rules().bond_caps or {}
    return caps[stage] or 5
end

local DIGIVICE_KEYS = {
    digivice = true,
    d3 = true,
    d_ark = true,
    golden_d_ark = true,
    golden_digivice = true,
}

function BM.get_digivolution_bond_requirement(card, device_key)
    local max_bond = BM.get_bond_max
        and BM.get_bond_max(card)
        or 5

    if BM.is_casual_mode()
    and DIGIVICE_KEYS[device_key] then
        return math.min(
            tonumber(BM.get_mode_rules().digivice_bond) or 3,
            max_bond
        )
    end

    return max_bond
end

function BM.get_care_crisis_revert_stages()
    return BM.get_mode_rules().care_crisis_revert_stages
end

local old_start_run = Game.start_run

Game.start_run = function(self, args)
    local loading_save = args and args.savetext ~= nil
    local ret = old_start_run(self, args)

    if G and G.GAME then
        if loading_save then
            if G.GAME.balatromon_mode ~= BM.MODE_STANDARD
            and G.GAME.balatromon_mode ~= BM.MODE_CASUAL then
                G.GAME.balatromon_mode = BM.MODE_STANDARD
            end
        else
            G.GAME.balatromon_mode = BM.get_configured_mode()
        end
    end

    return ret
end
