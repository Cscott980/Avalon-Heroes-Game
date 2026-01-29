shader_type spatial;
render_mode unshaded, cull_disabled, blend_mix;

uniform sampler2D noise_tex : source_color; // greyscale noise / cloud texture

// Colours (cartoon smoke often uses a darker outline + lighter body)
uniform vec3 color_light : source_color = vec3(0.90, 0.90, 0.95);
uniform vec3 color_dark  : source_color = vec3(0.55, 0.55, 0.65);

// Optional tint gradient bottom->top (set both equal to disable)
uniform vec3 grad_bottom : source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 grad_top    : source_color = vec3(1.0, 1.0, 1.0);

uniform float alpha_strength = 1.0;

// Motion
uniform float scroll_speed = 0.15;
uniform float swirl_strength = 0.06;
uniform float noise_scale = 1.5;

// Shape + toon look
uniform float softness = 0.25;     // higher = softer edges
uniform float threshold = 0.45;    // higher = less smoke (more cutout)
uniform float toon_steps = 4.0;    // 3–6 looks good
uniform float outline_width = 0.10; // 0.06–0.18

float toon(float x, float steps) {
    // posterize / banding
    return floor(x * steps) / max(steps - 1.0, 1.0);
}

void fragment() {
    vec2 uv = UV;

    // --- Animated distortion so it feels alive ---
    // Two moving noise samples to "boil" the smoke
    vec2 t1 = vec2(TIME * scroll_speed, TIME * scroll_speed * 0.7);
    vec2 t2 = vec2(-TIME * scroll_speed * 0.6, TIME * scroll_speed * 0.9);

    float n1 = texture(noise_tex, uv * noise_scale + t1).r;
    float n2 = texture(noise_tex, uv * (noise_scale * 1.4) + t2).r;

    // Distort UVs (cartoon wobble)
    vec2 warp = vec2(n1 - 0.5, n2 - 0.5) * swirl_strength;
    float base = texture(noise_tex, uv * noise_scale + warp).r;

    // --- Build a soft smoke mask ---
    // Remap base noise into a soft thresholded blob
    float mask = smoothstep(threshold - softness, threshold + softness, base);

    // --- Toon banding (cartoon look) ---
    float band = toon(mask, toon_steps);

    // --- Outline: darker band near edges ---
    float outline = smoothstep(0.0, outline_width, mask) - smoothstep(1.0 - outline_width, 1.0, mask);
    // outline is strongest around transitions; we’ll use it to push dark colour

    // --- Vertical gradient tint (optional) ---
    float g = clamp(UV.y, 0.0, 1.0);
    vec3 grad = mix(grad_bottom, grad_top, g);

    // --- Colour mix: light body + dark outline ---
    vec3 col = mix(color_dark, color_light, band);
    // Emphasise outline slightly
    col = mix(col, color_dark, clamp(1.0 - band, 0.0, 1.0) * 0.35);

    ALBEDO = col * grad;
    ALPHA  = band * alpha_strength;
	

}
