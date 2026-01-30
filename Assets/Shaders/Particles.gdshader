shader_type spatial;
render_mode unshaded, cull_disabled, blend_add;

// Color
uniform vec4 tint : source_color = vec4(0.45, 0.9, 1.0, 1.0);
uniform float intensity : hint_range(0.0, 10.0) = 2.0;
uniform float overall_alpha : hint_range(0.0, 2.0) = 1.0;

// Sprite texture for each particle (use alpha)
uniform sampler2D particle_tex : source_color;

// Optional: soft “edge fade” so the quad corners disappear (prevents boxy look)
uniform float quad_soft_fade : hint_range(0.0, 1.0) = 0.35;

// Flicker (purely visual)
uniform float flicker_speed : hint_range(0.0, 60.0) = 22.0;
uniform float flicker_amount : hint_range(0.0, 1.0) = 0.25;

float hash12(vec2 p){
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

void fragment() {
    vec2 uv = UV;

    // Sample the particle sprite alpha (this is your particle shape)
    float a = texture(particle_tex, uv).a;

    // Optional: fade out toward quad edges (kills “square” particles)
    if (quad_soft_fade > 0.001) {
        float fx = smoothstep(0.0, quad_soft_fade, uv.x) * (1.0 - smoothstep(1.0 - quad_soft_fade, 1.0, uv.x));
        float fy = smoothstep(0.0, quad_soft_fade, uv.y) * (1.0 - smoothstep(1.0 - quad_soft_fade, 1.0, uv.y));
        a *= fx * fy;
    }

    // Flicker (stable per-particle + time)
    // NOTE: CPUParticles3D doesn't give us a unique id directly, so we fake it using UV + TIME.
    // This still looks good for energy sparks.
    float n = hash12(uv * 23.0);
    float flick = mix(1.0 - flicker_amount, 1.0, hash12(vec2(floor(TIME * flicker_speed), n * 100.0)));

    float alpha = a * flick * overall_alpha;
   ALBEDO = tint.rgb * intensity;
    ALPHA = alpha;
}
