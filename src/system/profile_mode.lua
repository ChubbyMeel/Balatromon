local BM = Balatromon

local function profile_file_exists(profile)
    if not (love and love.filesystem and profile) then
        return false
    end

    return love.filesystem.getInfo(
        tostring(profile) .. '/profile.jkr'
    ) ~= nil
end

local function text_row(text, scale, colour)
    return {
        n = G.UIT.R,
        config = {
            align = 'cm',
            padding = 0.025,
        },
        nodes = {
            {
                n = G.UIT.T,
                config = {
                    text = text,
                    scale = scale or 0.29,
                    colour = colour or G.C.UI.TEXT_LIGHT,
                },
            },
        },
    }
end

local function mode_panel(args)
    local nodes = {
        text_row(args.title, 0.52, args.colour),
        text_row(args.subtitle, 0.28, G.C.UI.TEXT_INACTIVE),
        {
            n = G.UIT.R,
            config = {align = 'cm', minh = 0.12},
        },
    }

    for _, line in ipairs(args.lines) do
        nodes[#nodes + 1] = text_row(
            line,
            0.265,
            G.C.UI.TEXT_LIGHT
        )
    end

    nodes[#nodes + 1] = {
        n = G.UIT.R,
        config = {align = 'cm', minh = 0.16},
    }

    nodes[#nodes + 1] = UIBox_button({
        label = {args.button_label},
        button = args.button,
        colour = args.colour,
        minw = 3.4,
        minh = 0.62,
        scale = 0.43,
        focus_args = args.focus_args,
    })

    return {
        n = G.UIT.C,
        config = {
            align = 'cm',
            padding = 0.16,
            minw = 5.35,
            minh = 6.35,
            r = 0.12,
            colour = G.C.BLACK,
            emboss = 0.06,
        },
        nodes = nodes,
    }
end

function BM.create_profile_mode_picker_ui()
    local standard = mode_panel({
        title = 'STANDARD MODE',
        subtitle = 'More challenging way to play.',
        colour = G.C.RED,
        button_label = 'CHOOSE STANDARD',
        button = 'balatromon_choose_standard_mode',
        focus_args = {
            snap_to = true,
            nav = 'wide',
        },
        lines = {
            'Max Hunger: 5',
            'Starvation permanently disables Digimon',
            'Digivices require full Bond',
            'Max Bond: Fresh and In-Training: 1',
            'Rookie: 3',
            'Champion, Ultimate, and Mega: 5',
            'Bond stops increasing at Hunger 3',
            '3 Care Mistakes revert to In-Training',
        },
    })

    local casual = mode_panel({
        title = 'CASUAL MODE',
        subtitle = 'More forgiving and relaxed way to play.',
        colour = G.C.GREEN,
        button_label = 'CHOOSE CASUAL',
        button = 'balatromon_choose_casual_mode',
        focus_args = {
            nav = 'wide',
        },
        lines = {
            'Max Hunger: 7',
            'Food can revive starvation',
            'At full Bond, double click to digivolve',
            'Digivices require only 3 Bond',
            'Max Bond: Fresh and In-Training: 3',
            'Rookie: 5',
            'Champion: 7',
            'Ultimate and Mega: 9',
            'Bond stops increasing at Hunger 5',
            '3 Care Mistakes revert by 2 stages',
            'Minimum reversion is In-Training',
        },
    })

    return {
        n = G.UIT.ROOT,
        config = {
            align = 'cm',
            colour = G.C.CLEAR,
            padding = 0.16,
        },
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    align = 'cm',
                    padding = 0.2,
                    r = 0.14,
                    colour = G.C.UI.TRANSPARENT_DARK,
                    emboss = 0.08,
                    minw = 11.35,
                },
                nodes = {
                    text_row('Choose Your Balatromon Mode', 0.72, G.C.UI.TEXT_LIGHT),
                    text_row(
                        'Pick your gameplay mode',
                        0.31,
                        G.C.UI.TEXT_INACTIVE
                    ),
                    {
                        n = G.UIT.R,
                        config = {align = 'cm', minh = 0.16},
                    },
                    {
                        n = G.UIT.R,
                        config = {
                            align = 'cm',
                            padding = 0.08,
                        },
                        nodes = {
                            standard,
                            {
                                n = G.UIT.B,
                                config = {w = 0.22, h = 0.1},
                            },
                            casual,
                        },
                    },
                    {
                        n = G.UIT.R,
                        config = {align = 'cm', minh = 0.12},
                    },
                    text_row(
                        'You can change this later in Mods > Balatromon > Config.',
                        0.29,
                        G.C.UI.TEXT_LIGHT
                    ),
                    text_row(
                        'Mode changes apply when starting a new run.',
                        0.27,
                        G.C.UI.TEXT_INACTIVE
                    ),
                },
            },
        },
    }
end

function BM.open_profile_mode_picker()
    if not (G and G.FUNCS and G.FUNCS.overlay_menu) then
        return
    end

    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu({
        definition = BM.create_profile_mode_picker_ui(),
        config = {
            no_esc = true,
        },
    })
end

local function finish_mode_choice(mode, e)
    if BM.set_configured_mode then
        BM.set_configured_mode(mode)
    end

    BM._pending_profile_mode_picker = nil

    if G.FUNCS and G.FUNCS.exit_overlay_menu then
        G.FUNCS.exit_overlay_menu(e)
    end
end

G.FUNCS.balatromon_choose_standard_mode = function(e)
    finish_mode_choice(BM.MODE_STANDARD, e)
end

G.FUNCS.balatromon_choose_casual_mode = function(e)
    finish_mode_choice(BM.MODE_CASUAL, e)
end

local old_load_profile = G.FUNCS.load_profile

G.FUNCS.load_profile = function(arg)
    local target_profile =
        G.focused_profile
        or G.SETTINGS.profile
        or 1

    local should_prompt =
        arg == true
        or not profile_file_exists(target_profile)

    if should_prompt then
        BM._pending_profile_mode_picker = {
            profile = target_profile,
        }
    end

    return old_load_profile(arg)
end


local old_main_menu = Game.main_menu

function Game:main_menu(change_context)
    local ret = old_main_menu(self, change_context)

    local pending =
        BM._pending_profile_mode_picker

    if pending
    and pending.profile == G.SETTINGS.profile then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.25,
            blockable = false,
            blocking = false,

            func = function()
                local current =
                    BM._pending_profile_mode_picker

                if current
                and current.profile
                    == G.SETTINGS.profile then

                    BM.open_profile_mode_picker()
                end

                return true
            end,
        }))
    end

    return ret
end