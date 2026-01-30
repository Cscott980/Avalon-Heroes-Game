shader_type spatial;
render_mode unshaded, cull_disabled, blend_add;

uniform sampler2D slash_tex : source_color;

uniform vec4 tint : source_color = vec4(0.45, 0.9, 1.0, 1.0);
uniform float intensity : hint_range(0.0, 10.0) = 2.0;

// Texture motion (manual)
uniform vec2 uv_offset = vec2(0.0, 0.0);

// Optional auto scroll (set auto_scroll_enabled=0 to disable)
uniform float auto_scroll_enabled : hint_range(0.0, 1.0) = 0.0;
uniform float scroll_speed : hint_range(-20.0, 20.0) = 2.5;

// Texture tiling
uniform float flow_scale : hint_range(0.1, 30.0) = 6.0;
uniform float use_repeat : hint_range(0.0, 1.0) = 1.0; // 1 = wrap, 0 = clamp

// Shape
uniform float core_width : hint_range(0.01, 0.49) = 0.10;
uniform float edge_softness : hint_range(0.001, 0.5) = 0.18;
uniform float taper : hint_range(0.0, 1.0) = 0.25; // thinner near tip

// Tip glow
uniform float tip_glow : hint_range(0.0, 5.0) = 1.2;
uniform float tip_length : hint_range(0.01, 1.0) = 0.25;

// Lifetime (drive from code 0->1)
uniform float progress : hint_range(0.0, 1.0) = 1.0;
uniform float fade_in : hint_range(0.0, 0.5) = 0.06;
uniform float fade_out : hint_range(0.0, 0.5) = 0.18;

// Fade at mesh ends (prevents hard cut)
uniform float end_softness : hint_range(0.0, 0.5) = 0.06;

float luminance(vec3 c) { return dot(c, vec3(0.3333)); }

void fragment() {
    vec2 uv = UV;

    // Width mask (centered on UV.y = 0.5)
    float y = abs(uv.y - 0.5);

    // taper makes the slash narrower near the front (uv.x -> 1)
    float taper_amt = mix(1.0, 1.0 - taper, smoothstep(0.0, 1.0, uv.x));
    float core = smoothstep((core_width + edge_softness) * taper_amt, core_width * taper_amt, y);

    // Texture UVs (manual + optional auto)
    float auto_scroll = (auto_scroll_enabled > 0.5) ? (TIME * scroll_speed) : 0.0;
    vec2 fuv = vec2(uv.x * flow_scale + uv_offset.x + auto_scroll, uv.y + uv_offset.y);

    // Wrap or clamp
    if (use_repeat > 0.5) {
        fuv = fract(fuv);
    } else {
        fuv = clamp(fuv, vec2(0.0), vec2(1.0));
    }

    vec4 tex = texture(slash_tex, fuv);

    // Use brightness as mask (works for B/W textures too)
    float tex_mask = smoothstep(0.15, 1.0, luminance(tex.rgb));

    // Tip glow near front (uv.x = 1)
    float tip = smoothstep(1.0 - tip_length, 1.0, uv.x) * tip_glow;

    // End softness (fade near uv.x ends)
    float end_fade = 1.0;
    end_fade *= smoothstep(0.0, end_softness, uv.x);
    end_fade *= smoothstep(0.0, end_softness, 1.0 - uv.x);

    // Lifetime fade driven by progress
    float life_in  = smoothstep(0.0, max(0.0001, fade_in), progress);
    float life_out = 1.0 - smoothstep(1.0 - max(0.0001, fade_out), 1.0, progress);
    float life = life_in * life_out;

    float alpha = core * tex_mask * end_fade * life;

    vec3 col = tint.rgb * intensity;
    col += tint.rgb * tip * alpha;

    ALBEDO = col;
    ALPHA  = alpha;
}
