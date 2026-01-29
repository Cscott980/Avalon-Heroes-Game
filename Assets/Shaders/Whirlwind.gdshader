shader_type spatial;
render_mode unshaded, cull_disabled, blend_mix;

uniform sampler2D swirl_tex : source_color;

uniform vec2 pivot = vec2(0.5, 0.5);

uniform vec3 color_bottom : source_color = vec3(0.2, 0.8, 1.0);
uniform vec3 color_top    : source_color = vec3(0.9, 0.4, 1.0);

uniform float spin_speed   = 4.0;
uniform float scroll_speed = 1.0;

uniform float alpha_strength = 1.0;
uniform float gradient_power = 1.0; // >1 pushes more colour change near the top

void fragment() {
    vec2 uv = UV;

    // --- spin around pivot (compat-safe) ---
    vec2 p = uv - pivot;
    float ang = TIME * spin_speed;
    float c = cos(ang);
    float s = sin(ang);

    vec2 rotated;
    rotated.x = c * p.x - s * p.y;
    rotated.y = s * p.x + c * p.y;
    uv = rotated + pivot;

    // --- scroll upward ---
    

    vec4 tex = texture(swirl_tex, uv);

    // --- black → invisible mask (works for B/W textures) ---
    float mask = dot(tex.rgb, vec3(0.333)); // brightness

    // --- vertical gradient (0 bottom → 1 top) ---
    float t = clamp(pow(UV.y, gradient_power), 0.0, 1.0);
    vec3 grad = mix(color_bottom, color_top, t);
	// 1 pulse per second
	// center mask (strong in center, fades outward)
	float dist = length(UV - pivot);
	float center_mask = 1.0 - smoothstep(0.0, 0.6, dist);

	// 1 pulse per second (sharper pop)
	float pulse = sin(TIME * TAU) * 0.5 + 0.5;   // 0..1
	pulse = pow(pulse, 3.0);                     // sharper peak

	// add extra brightness near center
	vec3 pulsed = grad + grad * center_mask * pulse * 0.6;


    ALBEDO = pulsed;
	ALPHA  = mask * alpha_strength;


}
