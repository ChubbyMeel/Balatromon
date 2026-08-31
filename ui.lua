local BM = Balatromon
local MOD = BM.MOD or SMODS.current_mod

local function balatromon_mode_index()
    local config = (MOD and MOD.config) or {}
    return tonumber(config.mode) == 2 and 2 or 1
end

G.FUNCS.balatromon_change_mode = function(args)
    if not args then
        return
    end

    local selected = args.to_key
        or (args.cycle_config and args.cycle_config.current_option)
        or 1

    if BM.set_configured_mode then
        BM.set_configured_mode(tonumber(selected) == 2 and BM.MODE_CASUAL or BM.MODE_STANDARD)
    elseif MOD then
        MOD.config = MOD.config or {}
        MOD.config.mode = tonumber(selected) == 2 and 2 or 1
    end
end

MOD.config_tab = function()
    local mode_cycle = create_option_cycle({
        options = {
            'Standard',
            'Casual'
        },
        w = 4.5,
        cycle_shoulders = true,
        opt_callback = 'balatromon_change_mode',
        current_option = balatromon_mode_index(),
        colour = G.C.GREEN,
        no_pips = true,
        focus_args = {
            snap_to = true,
            nav = 'wide'
        }
    })

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
                    {
                        n = G.UIT.R,
                        config = {
                            align = 'cm',
                            padding = 0.08
                        },
                        nodes = {mode_cycle}
                    },
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
                                    text = 'Standard: A harder but intended way to play.',
                                    scale = 0.33,
                                    colour = G.C.UI.TEXT_LIGHT
                                }
                            }
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
                                    text = 'Casual: More relaxed and casual way to play',
                                    scale = 0.33,
                                    colour = G.C.UI.TEXT_INACTIVE
                                }
                            }
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = {
                            align = 'cm',
                            padding = 0.08
                        },
                        nodes = {
                            {
                                n = G.UIT.T,
                                config = {
                                    text = 'Mode changes apply when starting a new run.',
                                    scale = 0.28,
                                    colour = G.C.RED
                                }
                            }
                        }
                    }
                }
            }
        }
    }
end

MOD.credits_tab =
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