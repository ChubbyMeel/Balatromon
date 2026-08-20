-- Balatromon
-- Generated from the Balatromon design database.

Balatromon = Balatromon or {}
local BM = Balatromon
BM.MOD_ID = 'Balatromon'
BM.PREFIX = 'DigiMeel'

-- Some Balatromon effects need these modern SMODS contexts.
SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
        post_trigger = true,
        cardareas = {
            discard = true,
            deck = true,
        },
    }
end

-- Keep the atlas key short: DigiMeel is already the mod prefix.
SMODS.Atlas {
    key = 'Joker',
    path = 'DigiMeel_Joker.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'Enhancement',
    path = 'DigiMeel_Enhancement.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'Seal',
    path = 'DigiMeel_Seal.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'Tag',
    path = 'DigiMeel_Tag.png',
    px = 34,
    py = 34,
}

assert(SMODS.load_file('src/core.lua'))()
assert(SMODS.load_file('src/rarities.lua'))()
assert(SMODS.load_file('src/evolution.lua'))()
assert(SMODS.load_file('src/digi_items.lua'))()
assert(SMODS.load_file('src/effects.lua'))()
assert(SMODS.load_file('src/jokers.lua'))()
assert(SMODS.load_file('src/boosters.lua'))()
assert(SMODS.load_file('src/tarot_revisions.lua'))()
assert(SMODS.load_file('src/shop.lua'))()
assert(SMODS.load_file('src/enhancements.lua'))()
assert(SMODS.load_file('src/seals.lua'))()
assert(SMODS.load_file('src/tags.lua'))()