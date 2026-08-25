local BM = Balatromon

local function has_native_element_support()
    if not SMODS
    or type(SMODS.localize_box) ~= 'function'
    or not G
    or not G.UIT then
        return false
    end

    local marker = {
        n = G.UIT.C,
        config = {
            align = 'cm'
        },
        nodes = {}
    }

    local ok, result = pcall(
        SMODS.localize_box,
        {
            {
                control = {
                    element = '1'
                },
                strings = {
                    ' '
                }
            }
        },
        {
            vars = {
                elements = {
                    marker
                },
                colours = {}
            },
            scale = 1
        }
    )

    if not ok or type(result) ~= 'table' then
        return false
    end

    for _, node in ipairs(result) do
        if node == marker then
            return true
        end
    end

    return false
end

if SMODS
and type(SMODS.localize_box) == 'function'
and not has_native_element_support() then
    local old_localize_box = SMODS.localize_box

    SMODS.localize_box = function(lines, args)
        args = args or {}
        args.vars = args.vars or {}
        args.vars.elements = args.vars.elements or {}
        args.vars.colours = args.vars.colours or {}

        local final_line = {}

        for _, part in ipairs(lines or {}) do
            if part.control and part.control.element then
                local elem =
                    args.vars.elements[
                        tonumber(part.control.element)
                    ]

                if type(elem) == 'function' then
                    elem = elem()
                end

                if elem then
                    if Node
                    and elem.is
                    and elem:is(Node) then
                        elem = {
                            n = G.UIT.O,
                            config = {
                                object = elem
                            }
                        }
                    end

                    final_line[#final_line + 1] = elem
                end
            end

            local rendered =
                old_localize_box(
                    {
                        part
                    },
                    args
                )

            for _, node in ipairs(rendered or {}) do
                final_line[#final_line + 1] = node
            end
        end

        return final_line
    end
end