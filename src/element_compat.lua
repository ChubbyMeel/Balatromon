local function supports_elements()
    if not SMODS or type(SMODS.localize_box) ~= 'function' then
        return false
    end

    local test_element = {
        n = G.UIT.C,
        config = {align = 'cm'}
    }

    local ok, result = pcall(
        SMODS.localize_box,
        {
            {
                control = {element = '1'},
                strings = {}
            }
        },
        {
            vars = {
                elements = {test_element},
                colours = {}
            }
        }
    )

    if not ok or type(result) ~= 'table' then
        return false
    end

    for _, node in ipairs(result) do
        if node == test_element then
            return true
        end
    end

    return false
end

if SMODS
and type(SMODS.localize_box) == 'function'
and not supports_elements() then

    local old_localize_box = SMODS.localize_box

    SMODS.localize_box = function(lines, args)
        args = args or {}
        args.vars = args.vars or {}

        local result = {}

        for _, part in ipairs(lines or {}) do
            if part.control and part.control.element then
                local elements = args.vars.elements
                local element = elements
                    and elements[tonumber(part.control.element)]

                if element then
                    if element.is and element:is(Node) then
                        element = {
                            n = G.UIT.O,
                            config = {
                                object = element
                            }
                        }
                    end

                    result[#result + 1] = element
                end
            end

            local rendered = old_localize_box({part}, args)

            if rendered then
                for _, node in ipairs(rendered) do
                    result[#result + 1] = node
                end
            end
        end

        return result
    end
end