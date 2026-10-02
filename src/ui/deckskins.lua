local ranks = {
    '2', '3', '4', '5', '6', '7', '8', '9', '10',
    'Jack', 'Queen', 'King', 'Ace'
}

local faces = {
    'Jack', 'Queen', 'King'
}

local display = {
    'Ace', 'King', 'Queen', 'Jack', '10'
}

local suits = {
    {'hearts', 'Hearts'},
    {'clubs', 'Clubs'},
    {'diamonds', 'Diamonds'},
    {'spades', 'Spades'},
}

local lc = SMODS.Atlas {
    key = 'deckskin_lc',
    path = 'Deckskin_LC.png',
    px = 71,
    py = 95,
}

local hc = SMODS.Atlas {
    key = 'deckskin_hc',
    path = 'Deckskin_HC.png',
    px = 71,
    py = 95,
}

for _, suit in ipairs(suits) do
    SMODS.DeckSkin {
        key = suit[1],
        suit = suit[2],
        loc_txt = 'Balatromon',
        palettes = {
            {
                key = 'lc',
                ranks = ranks,
                display_ranks = display,
                atlas = lc.key,
                pos_style = 'deck',
                loc_txt = {['en-us'] = 'Full Deck'},
            },
            {
                key = 'face_lc',
                ranks = faces,
                display_ranks = display,
                atlas = lc.key,
                pos_style = 'deck',
                loc_txt = {['en-us'] = 'Face Cards'},
            },
            {
                key = 'hc',
                ranks = ranks,
                display_ranks = display,
                atlas = hc.key,
                pos_style = 'deck',
                loc_txt = {['en-us'] = 'Full Deck (High Contrast)'},
                hc_default = true,
            },
            {
                key = 'face_hc',
                ranks = faces,
                display_ranks = display,
                atlas = hc.key,
                pos_style = 'deck',
                loc_txt = {['en-us'] = 'Face Cards (High Contrast)'},
                hc_default = true,
            },
        },
    }
end
