local BM = Balatromon


BM.stage_rarity_keys = BM.stage_rarity_keys or {}

local defs = {
    {stage='Fresh',       key='fresh',       colour='7ED7E8'},
    {stage='In-Training', key='in_training', colour='70B7E6'},
    {stage='Rookie',      key='rookie',      colour='69C66F'},
    {stage='Champion',    key='champion',    colour='E69B45'},
    {stage='Ultimate',    key='ultimate',    colour='9B72D0'},
    {stage='Mega',        key='mega',        colour='E45C9C'},
    {stage='Rare',        key='rare_digimon',colour='F2C94C'},
}

for _, def in ipairs(defs) do
    local rarity = SMODS.Rarity {
        key = def.key,
        loc_txt = { name = def.stage },
        pools = { Joker = true },
        default_weight = 0,
        disable_if_empty = true,
        badge_colour = HEX(def.colour),
        text_colour = G.C.WHITE,
        get_weight = function(self, weight, object_type)
            return 0
        end,
    }
    BM.stage_rarity_keys[def.stage] = rarity.key or (BM.PREFIX .. '_' .. def.key)
end
