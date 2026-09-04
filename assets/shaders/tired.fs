#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
#define PRECISION highp
#else
#define PRECISION mediump
#endif


extern PRECISION float dissolve;
extern PRECISION float time;

extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;

extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;

extern bool shadow;

extern PRECISION vec2 mouse_screen_pos;
extern PRECISION float hovering;
extern PRECISION float screen_scale;

extern PRECISION float tired_time;


float tired_hash(vec2 p)
{
    p = fract(
        p * vec2(
            123.34,
            456.21
        )
    );

    p += dot(
        p,
        p + 45.32
    );

    return fract(
        p.x * p.y
    );
}


vec2 tired_local_uv(
    vec2 texture_coords
)
{
    vec2 sprite_size =
        max(
            texture_details.ba,
            vec2(1.0)
        );

    vec2 sprite_origin =
        texture_details.xy
        * sprite_size;

    vec2 atlas_pixel =
        texture_coords
        * image_details;

    return
        (
            atlas_pixel
            - sprite_origin
        )
        / sprite_size;
}


float tired_segment(
    vec2 p,
    vec2 a,
    vec2 b,
    float width
)
{
    vec2 pa =
        p - a;

    vec2 ba =
        b - a;

    float denominator =
        max(
            dot(ba, ba),
            0.0001
        );

    float h =
        clamp(
            dot(pa, ba)
            / denominator,
            0.0,
            1.0
        );

    float distance_to_line =
        length(
            pa
            - ba * h
        );

    return
        1.0
        - smoothstep(
            width,
            width * 1.8,
            distance_to_line
        );
}


float tired_z(
    vec2 uv,
    vec2 center,
    float size
)
{
    vec2 p =
        (
            uv
            - center
        )
        / size;

    float top =
        tired_segment(
            p,
            vec2(
                -0.40,
                -0.35
            ),
            vec2(
                0.40,
                -0.35
            ),
            0.075
        );

    float diagonal =
        tired_segment(
            p,
            vec2(
                0.40,
                -0.35
            ),
            vec2(
                -0.40,
                0.35
            ),
            0.075
        );

    float bottom =
        tired_segment(
            p,
            vec2(
                -0.40,
                0.35
            ),
            vec2(
                0.40,
                0.35
            ),
            0.075
        );

    return max(
        top,
        max(
            diagonal,
            bottom
        )
    );
}


vec4 tired_dissolve(
    vec4 tex,
    vec2 uv
)
{
    if (shadow)
    {
        return vec4(
            0.0,
            0.0,
            0.0,
            tex.a * 0.30
        );
    }

    if (dissolve <= 0.001)
    {
        return tex;
    }

    float noise =
        tired_hash(
            floor(
                uv * 80.0
            )
            + floor(
                time * 3.0
            )
        );

    float threshold =
        clamp(
            dissolve,
            0.0,
            1.0
        );

    if (noise < threshold)
    {
        tex.a = 0.0;

        return tex;
    }

    float edge =
        smoothstep(
            threshold + 0.10,
            threshold,
            noise
        );

    vec3 burn =
        mix(
            burn_colour_2.rgb,
            burn_colour_1.rgb,
            edge
        );

    tex.rgb =
        mix(
            tex.rgb,
            burn,
            edge * 0.8
        );

    return tex;
}


vec4 effect(
    vec4 colour,
    Image texture,
    vec2 texture_coords,
    vec2 screen_coords
)
{
    vec4 tex =
        Texel(
            texture,
            texture_coords
        );

    vec2 uv =
        tired_local_uv(
            texture_coords
        );

    if (shadow)
    {
        return tired_dissolve(
            tex * colour,
            uv
        );
    }


    float animation_time =
        tired_time
        + time * 0.000001;


    float grey =
        dot(
            tex.rgb,
            vec3(
                0.299,
                0.587,
                0.114
            )
        );


    vec3 sleepy_colour =
        vec3(
            grey
        );


    sleepy_colour =
        mix(
            sleepy_colour,
            vec3(
                0.36,
                0.40,
                0.46
            ),
            0.20
        );


    tex.rgb =
        mix(
            tex.rgb,
            sleepy_colour,
            0.88
        );


    tex.rgb *=
        0.78;


    float phase_a =
        fract(
            animation_time
            * 0.22
        );

    float phase_b =
        fract(
            animation_time
            * 0.22
            + 0.34
        );

    float phase_c =
        fract(
            animation_time
            * 0.22
            + 0.68
        );


    vec2 pos_a =
        vec2(
            0.68
            + sin(
                animation_time
                * 1.30
            )
            * 0.025,

            0.92
            - phase_a * 0.70
        );


    vec2 pos_b =
        vec2(
            0.78
            + sin(
                animation_time
                * 1.10
                + 2.0
            )
            * 0.030,

            0.92
            - phase_b * 0.70
        );


    vec2 pos_c =
        vec2(
            0.59
            + sin(
                animation_time
                * 1.50
                + 4.0
            )
            * 0.020,

            0.92
            - phase_c * 0.70
        );


    float z_a =
        tired_z(
            uv,
            pos_a,
            0.14
        );


    float z_b =
        tired_z(
            uv,
            pos_b,
            0.11
        );


    float z_c =
        tired_z(
            uv,
            pos_c,
            0.08
        );


    float z_mask =
        max(
            z_a,
            max(
                z_b,
                z_c
            )
        );


    float fade_a =
        sin(
            phase_a
            * 3.14159265
        );

    float fade_b =
        sin(
            phase_b
            * 3.14159265
        );

    float fade_c =
        sin(
            phase_c
            * 3.14159265
        );


    float z_fade =
        max(
            z_a * fade_a,
            max(
                z_b * fade_b,
                z_c * fade_c
            )
        );


    vec3 z_colour =
        vec3(
            0.72,
            0.84,
            1.0
        );


    tex.rgb =
        mix(
            tex.rgb,
            z_colour,
            clamp(
                z_fade,
                0.0,
                1.0
            )
        );


    tex.a =
        max(
            tex.a,
            z_mask * 0.95
        );


    tex *=
        colour;


    return tired_dissolve(
        tex,
        uv
    );
}


#ifdef VERTEX

vec4 position(
    mat4 transform_projection,
    vec4 vertex_position
)
{
    if (hovering <= 0.0)
    {
        return
            transform_projection
            * vertex_position;
    }


    float mid_dist =
        length(
            vertex_position.xy
            - 0.5
            * love_ScreenSize.xy
        )
        /
        length(
            love_ScreenSize.xy
        );


    vec2 mouse_offset =
        (
            vertex_position.xy
            - mouse_screen_pos.xy
        )
        /
        max(
            screen_scale,
            0.001
        );


    float scale =
        0.2
        *
        (
            -0.03
            - 0.3
            * max(
                0.0,
                0.3
                - mid_dist
            )
        )
        *
        hovering
        *
        (
            length(mouse_offset)
            * length(mouse_offset)
        )
        /
        (
            2.0
            - mid_dist
        );


    return
        transform_projection
        * vertex_position
        +
        vec4(
            0.0,
            0.0,
            0.0,
            scale
        );
}

#endif