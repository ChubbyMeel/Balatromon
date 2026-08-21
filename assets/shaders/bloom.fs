#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
#define PRECISION highp
#else
#define PRECISION mediump
#endif




extern PRECISION vec2 bloom;
extern PRECISION float bloom_time;

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


 

#define PI 3.14159265359
#define TAU 6.28318530718


float bloom_hash(vec2 p)
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


vec2 bloom_rotate(
    vec2 p,
    float angle
)
{
    float s = sin(angle);
    float c = cos(angle);

    return mat2(
        c, -s,
        s,  c
    ) * p;
}



vec3 bloom_palette(float t)
{
    return
        0.56
        + 0.44
        * cos(
            TAU
            * (
                t
                + vec3(
                    0.00,
                    0.28,
                    0.58
                )
            )
        );
}

 

 
vec2 bloom_flower_layer(
    vec2 uv,
    vec2 grid_size,
    vec2 grid_offset,
    float anim_time,
    float petals,
    float speed,
    float flower_size
)
{
    vec2 grid_uv =
        uv * grid_size
        + grid_offset;

    vec2 cell =
        floor(grid_uv);

    vec2 p =
        fract(grid_uv)
        - 0.5;


 
    float random_value =
        bloom_hash(
            cell
            + grid_offset * 17.31
        );

 
    vec2 drift =
        vec2(
            sin(
                anim_time
                * speed
                * 0.72
                + random_value * TAU
            ),

            cos(
                anim_time
                * speed
                * 0.57
                + random_value
                * TAU
                * 1.7
            )
        )
        * 0.065;

    p -= drift;


 
    float rotation =
        anim_time
        * speed
        * (
            0.25
            + random_value * 0.35
        )
        + random_value * TAU;

    p =
        bloom_rotate(
            p,
            rotation
        );


 
    float pulse =
        1.0
        + 0.10
        * sin(
            anim_time
            * (
                1.1
                + random_value
            )
            + random_value * TAU
        );


    float angle =
        atan(
            p.y,
            p.x
        );

    float radius =
        length(p);


 
    float petal_wave =
        0.5
        + 0.5
        * cos(
            angle * petals
        );


  
    float flower_edge =
        flower_size
        + flower_size
        * 0.54
        * pow(
            petal_wave,
            1.55
        );

 
    flower_edge +=
        0.018
        * sin(
            angle
            * petals
            * 2.0
            + anim_time
            * speed
        );


    flower_edge *= pulse;


    float flower =
        1.0
        - smoothstep(
            flower_edge - 0.025,
            flower_edge + 0.025,
            radius
        );

 
    float center =
        1.0
        - smoothstep(
            0.035,
            0.105,
            radius
        );

 
    float inner_ring =
        1.0
        - smoothstep(
            0.018,
            0.045,
            abs(
                radius
                - flower_size * 0.72
            )
        );

    inner_ring *= flower;

 
    float petal_light =
        0.72
        + petal_wave * 0.28;


    float mask =
        clamp(
            flower
            * petal_light
            + center * 0.25
            + inner_ring * 0.12,
            0.0,
            1.0
        );

 
    float hue =
        random_value
        + anim_time
        * speed
        * 0.025
        + angle / TAU * 0.15
        + radius * 0.55
        + petal_wave * 0.08;


    return vec2(
        mask,
        hue
    );
}


 
vec2 bloom_local_uv(
    vec2 texture_coords
)
{
    vec2 atlas_pixel =
        texture_coords
        * image_details;

    vec2 sprite_size =
        max(
            texture_details.ba,
            vec2(1.0)
        );

    vec2 sprite_origin =
        texture_details.xy
        * sprite_size;

    return
        (
            atlas_pixel
            - sprite_origin
        )
        / sprite_size;
}


 
vec4 bloom_dissolve(
    vec4 tex,
    vec2 uv
)
{
    if (shadow)
    {
        tex.rgb =
            vec3(0.0);

        tex.a *=
            0.30;
    }


    if (dissolve <= 0.001)
    {
        return tex;
    }


    float pattern =
        0.5
        + 0.25
        * sin(
            uv.x * 37.0
            + uv.y * 53.0
            + time * 5.0
        )
        + 0.25
        * sin(
            uv.x * 91.0
            - uv.y * 47.0
            - time * 3.0
        );


    float visible_mask =
        smoothstep(
            dissolve - 0.08,
            dissolve + 0.08,
            pattern
        );


    float burn_outer =
        smoothstep(
            dissolve - 0.08,
            dissolve + 0.01,
            pattern
        );


    float burn_inner =
        smoothstep(
            dissolve + 0.01,
            dissolve + 0.10,
            pattern
        );


    float burn_mask =
        clamp(
            burn_outer
            - burn_inner,
            0.0,
            1.0
        );


    if (!shadow)
    {
        vec4 burn_colour =
            mix(
                burn_colour_1,
                burn_colour_2,
                0.5
                + 0.5
                * sin(
                    time * 4.0
                    + uv.x * 20.0
                )
            );


        tex.rgb =
            mix(
                tex.rgb,
                burn_colour.rgb,
                burn_mask
                * burn_colour.a
            );
    }


    tex.a *=
        visible_mask;


    return tex;
}


 

vec4 effect(
    vec4 colour,
    Image texture,
    vec2 texture_coords,
    vec2 screen_coords
)
{
    vec4 base =
        Texel(
            texture,
            texture_coords
        )
        * colour;


    vec2 uv =
        bloom_local_uv(
            texture_coords
        );


   
    float anim =
        bloom_time
        + bloom.x * 0.000001;


 
    vec2 warped_uv =
        uv;


    warped_uv.x +=
        sin(
            uv.y * 9.0
            + anim * 0.42
        )
        * 0.018;


    warped_uv.y +=
        cos(
            uv.x * 8.0
            - anim * 0.34
        )
        * 0.016;

 
    vec2 flower_a =
        bloom_flower_layer(
            warped_uv,
            vec2(
                2.6,
                3.6
            ),
            vec2(
                0.12,
                0.17
            ),
            anim,
            6.0,
            0.75,
            0.20
        );


 
    vec2 flower_b =
        bloom_flower_layer(
            warped_uv,
            vec2(
                3.7,
                4.8
            ),
            vec2(
                0.63,
                0.42
            ),
            -anim,
            7.0,
            0.62,
            0.17
        );


 
    vec2 flower_c =
        bloom_flower_layer(
            warped_uv,
            vec2(
                2.1,
                2.8
            ),
            vec2(
                0.38,
                0.71
            ),
            anim,
            5.0,
            0.46,
            0.18
        );

 
    vec3 colour_a =
        bloom_palette(
            flower_a.y
        );


    vec3 colour_b =
        bloom_palette(
            flower_b.y
            + 0.28
        );


    vec3 colour_c =
        bloom_palette(
            flower_c.y
            + 0.57
        );

 
    float total_weight =
        flower_a.x
        + flower_b.x * 0.82
        + flower_c.x * 0.65;


    vec3 flower_colour =
        (
            colour_a
            * flower_a.x

            + colour_b
            * flower_b.x
            * 0.82

            + colour_c
            * flower_c.x
            * 0.65
        )
        / max(
            total_weight,
            0.001
        );


    float flower_mask =
        clamp(
            flower_a.x * 0.90
            + flower_b.x * 0.70
            + flower_c.x * 0.48,
            0.0,
            1.0
        );


 

    float liquid_wave =
        0.5
        + 0.5
        * sin(
            warped_uv.x * 7.0
            + warped_uv.y * 5.0
            + sin(
                warped_uv.y * 8.0
                - anim * 0.40
            )
            + anim * 0.35
        );


    vec3 ambient_colour =
        bloom_palette(
            liquid_wave * 0.30
            + anim * 0.012
        );


   
    vec3 final_colour =
        mix(
            base.rgb,
            ambient_colour,
            0.08
        );


 
    final_colour =
        mix(
            final_colour,
            flower_colour,
            flower_mask * 0.58
        );


 
    final_colour +=
        flower_colour
        * flower_mask
        * 0.10;


 
    float shimmer =
        0.5
        + 0.5
        * sin(
            uv.x * 14.0
            - uv.y * 11.0
            + anim * 1.7
        );


    final_colour +=
        flower_colour
        * flower_mask
        * shimmer
        * 0.035;


    vec4 result =
        vec4(
            clamp(
                final_colour,
                0.0,
                1.0
            ),
            base.a
        );


    return
        bloom_dissolve(
            result,
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
        / length(
            love_ScreenSize.xy
        );


    vec2 mouse_offset =
        (
            vertex_position.xy
            - mouse_screen_pos.xy
        )
        / max(
            screen_scale,
            0.001
        );


    float scale =
        0.2
        * (
            -0.03
            - 0.3
            * max(
                0.0,
                0.3 - mid_dist
            )
        )
        * hovering
        * dot(
            mouse_offset,
            mouse_offset
        )
        / (
            2.0
            - mid_dist
        );


    return
        transform_projection
        * vertex_position
        + vec4(
            0.0,
            0.0,
            0.0,
            scale
        );
}

#endif