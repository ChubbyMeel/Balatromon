local BM = Balatromon

SMODS.current_mod.credits_tab =
function()
    local function credit_text(
        text,
        scale,
        colour
    )
        return {
            n = G.UIT.R,
            config = {
                align = 'cm',
                padding = 0.06
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        text = text,
                        scale = scale or 0.35,
                        colour =
                            colour
                            or G.C.UI.TEXT_LIGHT
                    }
                }
            }
        }
    end

    return {
        n = G.UIT.ROOT,

        config = {
            align = 'cm',
            colour = G.C.CLEAR,
            padding = 0.2
        },

        nodes = {
            {
                n = G.UIT.C,

                config = {
                    align = 'cm',
                    padding = 0.2,
                    minw = 7.5,
                    r = 0.1,
                    colour = G.C.BLACK
                },

                nodes = {
                    credit_text(
                        'Balatromon',
                        0.7,
                        G.C.UI.TEXT_LIGHT
                    ),

                    credit_text(
                        'A Digimon mod for Balatro.',
                        0.4,
                        G.C.UI.TEXT_INACTIVE
                    ),

                    {
                        n = G.UIT.R,
                        config = {
                            align = 'cm',
                            minh = 0.25
                        }
                    },

                    credit_text(
                        'Created by ChubbyMeel',
                        0.42,
                        G.C.UI.TEXT_LIGHT
                    ),

                    credit_text(
                        'Additional art by StarRush',
                        0.38,
                        G.C.UI.TEXT_LIGHT
                    ),

                    {
                        n = G.UIT.R,
                        config = {
                            align = 'cm',
                            minh = 0.3
                        }
                    },

                    credit_text(
                        'Digimon characters and related intellectual property',
                        0.3,
                        G.C.UI.TEXT_INACTIVE
                    ),

                    credit_text(
                        'belong to Bandai Namco Entertainment Inc.',
                        0.3,
                        G.C.UI.TEXT_INACTIVE
                    ),

                    {
                        n = G.UIT.R,
                        config = {
                            align = 'cm',
                            minh = 0.12
                        }
                    },

                    credit_text(
                        'Some visual assets are adapted from the',
                        0.3,
                        G.C.UI.TEXT_INACTIVE
                    ),

                    credit_text(
                        'mobile game Digimon Up.',
                        0.3,
                        G.C.UI.TEXT_INACTIVE
                    )
                }
            }
        }
    }
end