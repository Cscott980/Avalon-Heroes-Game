shader_type spatial;
render_mode unshaded, cull_disabled, blend_add;

uniform sampler2D slash_tex : source_color;
uniform vec4 tint : source_color = vec4(0.45, 0.9, 1.0, 1.0);

uniform float intensity = 2.0;

// Manual movement
uniform vec2 uv_offset = vec2(0.0, 0.0);

uniform float flow_scale = 6.0;

uniform float core_width = 0.12;
uniform float edge_softness = 0.10;

uniform float tip_glow = 1.2;
uniform float tip_length = 0.25;

uniform float progress = 1.0;
uniform float fade_in = 0.08;
uniform float fade_out = 0.20;

uniform float end_softness = 0.08;

void fragment() {
    vec2 uv = UV;

    float x = abs(uv.y - 0.5);
    float core = smoothstep(core_width + edge_softness, core_width, x);

    // Manual texture movement
    vec2 fuv = vec2(uv.x * flow_scale + uv_offset.x, uv.y + uv_offset.y);

    vec4 tex = texture(slash_tex, fuv);

    float tex_mask = dot(tex.rgb, vec3(0.3333));
    tex_mask = smoothstep(0.15, 1.0, tex_mask);

    float tip = smoothstep(1.0 - tip_length, 1.0, uv.x) * tip_glow;

    float end_fade = 1.0;
    end_fade *= smoothstep(0.0, end_softness, uv.x);
    end_fade *= smoothstep(0.0, end_softness, 1.0 - uv.x);

    float life_in  = smoothstep(0.0, fade_in, progress);
    float life_out = 1.0 - smoothstep(1.0 - fade_out, 1.0, progress);
    float life = life_in * life_out;

    float alpha = core * tex_mask * end_fade * life;

    vec3 col = tint.rgb * intensity;
    col += tint.rgb * tip * alpha;

    ALBEDO = col;
    ALPHA = alpha;
}
