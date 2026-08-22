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
    key = 'Consumable',
    path = 'DigiMeel_Consumable.png',
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

SMODS.Atlas {
    key = 'Voucher',
    path = 'DigiMeel_Voucher.png',
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = 'Booster',
    path = 'DigiMeel_Booster.png',
    px = 71,
    py = 95
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
assert(SMODS.load_file('src/vouchers.lua'))()
assert(SMODS.load_file('src/collections.lua'))()
assert(SMODS.load_file('src/editions.lua'))()
assert(SMODS.load_file('src/stickers.lua'))()

SMODS.current_mod.process_loc_text = function()
    G.localization.descriptions.Other['DigiMeel_sakuyamon_renamon_effect'] = {
        name = 'Renamon Effect',
        text = {
            'Earn {C:money}$5{} for each',
            'discarded {C:attention}#1#{}',
            '{C:inactive}(rank changes at end of round){}'
        }
    }
end


local function wrap_digimon_tooltip_text(text, max_length)
    max_length = max_length or 34

    if not text or text == '' then
        return {''}
    end

    local lines = {}
    local current = ''

    for word in tostring(text):gmatch('%S+') do
        if current == '' then
            current = word
        elseif #current + #word + 1 <= max_length then
            current = current .. ' ' .. word
        else
            lines[#lines + 1] = current
            current = word
        end
    end

    if current ~= '' then
        lines[#lines + 1] = current
    end

    return lines
end

local old_process_loc_text =
    SMODS.current_mod.process_loc_text

SMODS.current_mod.process_loc_text = function(self)
    if old_process_loc_text then
        old_process_loc_text(self)
    end

    G.localization.descriptions.Other =
        G.localization.descriptions.Other or {}

    for slug, def in pairs(
        Balatromon.joker_defs or {}
    ) do
        local key =
            Balatromon.PREFIX
            .. '_digimon_ref_'
            .. slug

        SMODS.process_loc_text(
            G.localization.descriptions.Other,
            key,
            {
                name = def.name or slug,
                text = wrap_digimon_tooltip_text(
                    def.effect
                        or 'No effect description',
                    34
                )
            }
        )
    end
end