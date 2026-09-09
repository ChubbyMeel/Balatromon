local BM = Balatromon

if BM._magnamon_repetition_hook then
    return
end

BM._magnamon_repetition_hook = true


local function has_real_retrigger(reps)
    if not reps then
        return false
    end

    for i = 2, #reps do
        local entry = reps[i]

        if type(entry) == 'table'
        and type(entry.retriggers) == 'table' then
            return true
        end
    end

    return false
end


local old_calculate_repetitions =
    SMODS.calculate_repetitions


SMODS.calculate_repetitions =
function(card, context, reps)
    reps = reps or {1}

    local previous_sources =
        context.balatromon_magnamon_sources

    context.balatromon_magnamon_sources =
        {}

    local result =
        old_calculate_repetitions(
            card,
            context,
            reps
        )

    reps = result or reps

    local sources =
        context.balatromon_magnamon_sources
        or {}

    context.balatromon_magnamon_sources =
        previous_sources

    if #sources == 0 then
        return reps
    end

    if not has_real_retrigger(reps) then
        return reps
    end

    for _, source in ipairs(sources) do
        if source
        and not source.REMOVED
        and not source.debuff then
            local e =
                source.ability
                and source.ability.extra
                or {}

            if not e.permanently_disabled then
                SMODS.insert_repetitions(
                    reps,
                    {
                        repetitions = 1,
                        message = 'Again!'
                    },
                    source
                )
            end
        end
    end

    return reps
end