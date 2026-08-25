#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
#define PRECISION highp
#else
#define PRECISION mediump
#endif

extern PRECISION number dissolve;
extern PRECISION number time;
extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;
extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;
extern bool shadow;

extern PRECISION vec2 mouse_screen_pos;
extern PRECISION float hovering;
extern PRECISION float screen_scale;

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 0.6666667, 0.3333333, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);

    return c.z * mix(
        K.xxx,
        clamp(p - K.xxx, 0.0, 1.0),
        c.y
    );
}

float hash21(vec2 p)
{
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float prism_line(
    vec2 uv,
    vec2 direction,
    float frequency
)
{
    float value =
        fract(
            dot(uv, direction)
            * frequency
        );

    float distance =
        abs(value - 0.5);

    return smoothstep(
        0.075,
        0.012,
        distance
    );
}

float shine_band(
    vec2 uv,
    float offset
)
{
    float value =
        fract(
            uv.x * 0.85
            + uv.y * 0.55
            + offset
        );

    return smoothstep(
        0.16,
        0.01,
        abs(value - 0.5)
    );
}

vec4 apply_dissolve(
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
            tex.a * 0.3
        );
    }

    if (dissolve <= 0.001)
    {
        return tex;
    }

    vec2 cell =
        floor(
            uv * 80.0
        );

    float noise =
        hash21(
            cell
            + floor(time * 3.0)
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

    if (tex.a <= 0.001)
    {
        return vec4(0.0);
    }

    vec2 uv =
        (
            texture_coords
            * image_details
            - texture_details.xy
            * texture_details.ba
        )
        / texture_details.ba;

    float t =
        time * 0.7;

    vec2 dir1 =
        normalize(
            vec2(
                1.0,
                0.0
            )
        );

    vec2 dir2 =
        normalize(
            vec2(
                0.5,
                0.8660254
            )
        );

    vec2 dir3 =
        normalize(
            vec2(
                -0.5,
                0.8660254
            )
        );

    float line1 =
        prism_line(
            uv
            + vec2(
                t * 0.018,
                0.0
            ),
            dir1,
            9.0
        );

    float line2 =
        prism_line(
            uv
            + vec2(
                0.0,
                t * 0.014
            ),
            dir2,
            9.0
        );

    float line3 =
        prism_line(
            uv
            - vec2(
                0.0,
                t * 0.016
            ),
            dir3,
            9.0
        );

    float geometry =
        max(
            line1,
            max(
                line2,
                line3
            )
        );

    float facet1 =
        sin(
            uv.x * 14.0
            + uv.y * 8.0
            + t * 1.8
        )
        * 0.5
        + 0.5;

    float facet2 =
        sin(
            uv.x * -9.0
            + uv.y * 13.0
            - t * 1.4
        )
        * 0.5
        + 0.5;

    float facet =
        (
            facet1
            + facet2
        )
        * 0.5;

    float hue =
        fract(
            uv.x * 0.85
            + uv.y * 0.45
            + facet * 0.24
            + t * 0.075
        );

    vec3 rainbow =
        hsv2rgb(
            vec3(
                hue,
                0.78,
                1.0
            )
        );

    float sweep1 =
        shine_band(
            uv,
            -t * 0.12
        );

    float sweep2 =
        shine_band(
            vec2(
                uv.x,
                1.0 - uv.y
            ),
            t * 0.08
        );

    float sweep =
        max(
            sweep1,
            sweep2 * 0.65
        );

    float rainbow_strength =
        0.10
        + geometry * 0.28
        + sweep * 0.50;

    vec3 result =
        tex.rgb
        + rainbow
        * rainbow_strength;

    result =
        mix(
            result,
            rainbow,
            geometry * 0.12
        );

    result +=
        vec3(1.0)
        * sweep
        * 0.20;

    tex =
        vec4(
            clamp(
                result,
                0.0,
                1.0
            ),
            tex.a
        )
        * colour;

    return apply_dissolve(
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
            -
            0.3
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