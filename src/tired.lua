local BM =
    Balatromon


local TIRED_SHADER_KEY =
    BM.PREFIX
    .. '_tired'


SMODS.Shader {
    key = 'tired',
    path = 'tired.fs',

    send_vars = function(
        sprite,
        card
    )
        return {
            tired_time =
                G.TIMERS
                and G.TIMERS.REAL
                or 0
        }
    end
}


SMODS.DrawStep {
    key =
        'balatromon_tired',

    order = 18,

    conditions = {
        facing = 'front'
    },

    func = function(
        card,
        layer
    )
        if not BM.is_tired
        or not BM.is_tired(card) then
            return
        end

        if not card.children
        or not card.children.center then
            return
        end

        card.children.center:draw_shader(
            TIRED_SHADER_KEY,
            nil,
            nil
        )
    end
}