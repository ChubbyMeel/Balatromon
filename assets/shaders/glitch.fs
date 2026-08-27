#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
#define PRECISION highp
#else
#define PRECISION mediump
#endif

extern PRECISION float dissolve;
extern PRECISION float time;

extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;

extern bool shadow;

extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;

extern PRECISION vec2 mouse_screen_pos;
extern PRECISION float hovering;
extern PRECISION float screen_scale;

extern PRECISION float glitch_time;
extern PRECISION float glitch_seed;

float hash11(float p)
{
    return fract(
        sin(p * 127.1 + 311.7)
        * 43758.5453123
    );
}

float hash21(vec2 p)
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

vec2 get_local_uv(vec2 texture_coords)
{
    vec2 sprite_size =
        texture_details.ba;

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

vec2 get_atlas_uv(vec2 uv)
{
    vec2 sprite_size =
        texture_details.ba;

    vec2 sprite_origin =
        texture_details.xy
        * sprite_size;

    uv = clamp(
        uv,
        vec2(0.003),
        vec2(0.997)
    );

    return
        (
            sprite_origin
            + uv * sprite_size
        )
        / image_details;
}

vec4 sample_sprite(
    Image texture,
    vec2 uv
)
{
    return Texel(
        texture,
        get_atlas_uv(uv)
    );
}

float get_dissolve_mask(vec2 uv)
{
    float unused_time =
        time * 0.000001;

    float burn_use =
        burn_colour_1.r * 0.000001
        + burn_colour_2.g * 0.000001;

    if (dissolve < 0.001)
    {
        return
            1.0
            - unused_time
            - burn_use;
    }

    vec2 cell =
        floor(
            uv * 70.0
        );

    float n =
        hash21(
            cell
            + floor(
                glitch_time * 4.0
            )
        );

    return step(
        dissolve,
        n
    );
}

vec4 effect(
    vec4 colour,
    Image texture,
    vec2 texture_coords,
    vec2 screen_coords
)
{
    vec2 uv =
        get_local_uv(
            texture_coords
        );

    if (shadow)
    {
        vec4 shadow_tex =
            sample_sprite(
                texture,
                uv
            );

        return vec4(
            0.0,
            0.0,
            0.0,
            shadow_tex.a * 0.3
        );
    }

    float seed =
        glitch_seed * 0.731
        + texture_details.x * 12.37
        + texture_details.y * 37.91;

    float frame =
        floor(
            glitch_time * 12.0
            + seed
        );

    float fast_frame =
        floor(
            glitch_time * 28.0
            + seed * 3.1
        );

    float burst_random =
        hash11(
            frame * 23.17
            + seed * 11.31
        );

    float burst =
        smoothstep(
            0.68,
            0.95,
            burst_random
        );

    float heavy_burst =
        smoothstep(
            0.88,
            0.99,
            burst_random
        );

    float row =
        floor(
            uv.y * 28.0
        );

    float row_random =
        hash11(
            row * 17.73
            + frame * 31.91
            + seed
        );

    float row_active =
        step(
            0.88
            - burst * 0.30,
            row_random
        );

    float row_direction =
        hash11(
            row * 53.71
            + frame * 7.91
            + seed * 2.7
        )
        * 2.0
        - 1.0;

    float row_shift =
        row_direction
        * row_active
        * (
            0.018
            + burst * 0.055
            + heavy_burst * 0.055
        );

    vec2 block =
        floor(
            uv
            * vec2(
                8.0,
                16.0
            )
        );

    float block_random =
        hash21(
            block
            + vec2(
                frame * 0.73,
                seed * 0.31
            )
        );

    float block_active =
        step(
            0.94
            - burst * 0.19,
            block_random
        );

    float block_direction =
        hash21(
            block
            + vec2(
                fast_frame * 0.37,
                seed * 1.91
            )
        )
        * 2.0
        - 1.0;

    float block_shift =
        block_direction
        * block_active
        * (
            0.018
            + burst * 0.055
            + heavy_burst * 0.08
        );

    float jitter =
        sin(
            uv.y * 180.0
            + glitch_time * 14.0
            + seed
        )
        * 0.0015;

    float displacement =
        row_shift
        + block_shift
        + jitter;

    float rgb_amount =
        0.0035
        + row_active * 0.004
        + burst * 0.007
        + heavy_burst * 0.008;

    vec2 displaced_uv =
        uv
        + vec2(
            displacement,
            0.0
        );

    vec4 original =
        sample_sprite(
            texture,
            uv
        );

    vec4 red_tex =
        sample_sprite(
            texture,
            displaced_uv
            + vec2(
                rgb_amount,
                0.0
            )
        );

    vec4 green_tex =
        sample_sprite(
            texture,
            displaced_uv
        );

    vec4 blue_tex =
        sample_sprite(
            texture,
            displaced_uv
            - vec2(
                rgb_amount,
                0.0
            )
        );

    vec3 result =
        vec3(
            red_tex.r,
            green_tex.g,
            blue_tex.b
        );

    float alpha =
        max(
            red_tex.a,
            max(
                green_tex.a,
                blue_tex.a
            )
        );

    float scan =
        sin(
            uv.y * 430.0
            + glitch_time * 25.0
        )
        * 0.5
        + 0.5;

    float scan_mask =
        smoothstep(
            0.75,
            1.0,
            scan
        );

    result *=
        1.0
        - scan_mask * 0.09;

    float colour_band =
        hash11(
            row * 8.73
            + fast_frame
            + seed
        );

    float colour_band_active =
        row_active
        * step(
            0.72,
            colour_band
        );

    vec3 cyan =
        vec3(
            0.0,
            0.95,
            1.0
        );

    vec3 magenta =
        vec3(
            1.0,
            0.05,
            0.85
        );

    vec3 digital_colour =
        mix(
            cyan,
            magenta,
            hash11(
                row
                + frame
                + seed
            )
        );

    result =
        mix(
            result,
            digital_colour,
            colour_band_active
            * (
                0.15
                + burst * 0.35
            )
        );

    vec2 noise_cell =
        floor(
            uv
            * vec2(
                75.0,
                100.0
            )
        );

    float pixel_noise =
        hash21(
            noise_cell
            + vec2(
                fast_frame,
                seed
            )
        );

    float static_active =
        step(
            0.985
            - heavy_burst * 0.10,
            pixel_noise
        );

    result =
        mix(
            result,
            vec3(pixel_noise),
            static_active
            * (
                0.25
                + heavy_burst * 0.55
            )
        );

    float line_position =
        hash11(
            frame * 2.91
            + seed
        );

    float flash_line =
        1.0
        - smoothstep(
            0.008,
            0.025,
            abs(
                uv.y
                - line_position
            )
        );

    flash_line *=
        heavy_burst;

    result +=
        vec3(
            0.15,
            0.35,
            0.42
        )
        * flash_line;

    float second_line_position =
        hash11(
            frame * 5.71
            + seed * 2.3
        );

    float second_line =
        1.0
        - smoothstep(
            0.004,
            0.012,
            abs(
                uv.y
                - second_line_position
            )
        );

    second_line *=
        burst;

    result =
        mix(
            result,
            vec3(
                1.0,
                0.05,
                0.75
            ),
            second_line * 0.40
        );

    float invert_roll =
        hash11(
            frame * 101.7
            + seed * 11.0
        );

    float invert =
        step(
            0.975,
            invert_roll
        )
        * heavy_burst;

    result =
        mix(
            result,
            vec3(1.0) - result,
            invert * 0.75
        );

    float dropout_row =
        hash11(
            row * 39.7
            + frame * 13.1
            + seed
        );

    float dropout =
        step(
            0.975
            - heavy_burst * 0.11,
            dropout_row
        );

    result =
        mix(
            result,
            vec3(
                0.02,
                0.03,
                0.04
            ),
            dropout
            * (
                0.30
                + heavy_burst * 0.40
            )
        );

    float edge_noise =
        sin(
            (
                uv.x
                + uv.y
            )
            * 80.0
            + glitch_time * 5.0
            + seed
        )
        * 0.5
        + 0.5;

    result +=
        vec3(
            0.02,
            0.06,
            0.07
        )
        * edge_noise;

    result =
        mix(
            original.rgb,
            result,
            0.78
            + burst * 0.22
        );

    result *= colour.rgb;

    alpha *= colour.a;

    alpha *=
        get_dissolve_mask(
            uv
        );

    return vec4(
        clamp(
            result,
            0.0,
            1.0
        ),
        alpha
    );
}

#ifdef VERTEX

vec4 position(
    mat4 transform_projection,
    vec4 vertex_position
)
{
    float safe_scale =
        max(
            screen_scale,
            0.001
        );

    vec2 mouse_offset =
        (
            vertex_position.xy
            - mouse_screen_pos
        )
        / safe_scale;

    float hover_amount =
        hovering
        * dot(
            mouse_offset,
            mouse_offset
        )
        * 0.000001;

    vertex_position.xy +=
        mouse_offset
        * hover_amount;

    return
        transform_projection
        * vertex_position;
}

#endif