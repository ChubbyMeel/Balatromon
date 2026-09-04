local BM =
    Balatromon


SMODS.DrawStep {
    key =
        'balatromon_x_antibody_outline',

    order = 100,

    conditions = {
        facing = 'front'
    },

    func = function(
        card,
        layer
    )
        if not BM.x_antibody_targeting_active
        or not BM.x_antibody_targeting_active() then
            return
        end

        if not BM.is_digimon
        or not BM.is_digimon(card) then
            return
        end

        if not BM.is_x_antibody_viable
        or not BM.is_x_antibody_viable(card) then
            return
        end

        if not card.VT then
            return
        end

        love.graphics.push(
            'all'
        )

        prep_draw(
            card,
            1,
            0
        )


        local w =
            card.VT.w

        local h =
            card.VT.h


        love.graphics.setColor(
            0,
            0,
            0,
            0.70
        )

        love.graphics.setLineWidth(
            0.085
        )

        love.graphics.rectangle(
            'line',

            -0.065,
            -0.065,

            w + 0.13,
            h + 0.13,

            0.13,
            0.13
        )


        love.graphics.setColor(
            1,
            1,
            1,
            1
        )

        love.graphics.setLineWidth(
            0.035
        )

        love.graphics.rectangle(
            'line',

            -0.035,
            -0.035,

            w + 0.07,
            h + 0.07,

            0.11,
            0.11
        )


        love.graphics.pop()
        love.graphics.pop()
    end
}