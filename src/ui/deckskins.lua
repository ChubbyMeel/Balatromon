local BM = Balatromon

local face_ranks = {
    'Jack',
    'Queen',
    'King',
}

local display_ranks = {
    'King',
    'Queen',
    'Jack',
}

local suits = {
    {
        key = 'clubs',
        suit = 'Clubs',
        lc = 'Clubs_LC.png',
        hc = 'Clubs_HC.png',
    },
    {
        key = 'diamonds',
        suit = 'Diamonds',
        lc = 'Diamonds_LC.png',
        hc = 'Diamonds_HC.png',
    },
    {
        key = 'hearts',
        suit = 'Hearts',
        lc = 'Hearts_LC.png',
        hc = 'Hearts_HC.png',
    },
    {
        key = 'spades',
        suit = 'Spades',
        lc = 'Spades_LC.png',
        hc = 'Spades_HC.png',
    },
}

for _, def in ipairs(suits) do
    local atlas_lc = SMODS.Atlas {
        key = def.key .. '_lc',
        path = def.lc,
        px = 71,
        py = 95,
    }

    local atlas_hc = SMODS.Atlas {
        key = def.key .. '_hc',
        path = def.hc,
        px = 71,
        py = 95,
    }

    SMODS.DeckSkin {
        key = def.key,
        suit = def.suit,
        loc_txt = 'Balatromon',

        palettes = {
            {
                key = 'lc',
                ranks = face_ranks,
                display_ranks = display_ranks,
                atlas = atlas_lc.key,
                pos_style = 'ranks',
            },

            {
                key = 'hc',
                ranks = face_ranks,
                display_ranks = display_ranks,
                atlas = atlas_hc.key,
                pos_style = 'ranks',
                hc_default = true,
            },
        },
    }
end