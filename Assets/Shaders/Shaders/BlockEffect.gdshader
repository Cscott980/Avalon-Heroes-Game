shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_opaque, blend_add;

/*
SHIELD CAP (front-of-player)
Put on a curved mesh (sphere segment / cap).
- Looks good in Compatibility too (no screen texture).
- Trigger impacts by setting `impact_pos_ws` and `impact_time`.
*/
varying vec3 world_pos;
uniform vec3 shield_color : source_color = vec3(0.35, 0.65, 1.0);
uniform float opacity : hint_range(0.0, 2.0, 0.01) = 1.0;

// Fresnel rim
uniform float rim_power : hint_range(0.5, 8.0, 0.1) = 3.0;
uniform float rim_strength : hint_range(0.0, 4.0, 0.01) = 1.6;

// Noise scroll
uniform sampler2D noise_tex : filter_linear, repeat_enable;
uniform float noise_tiling : hint_range(0.1, 20.0, 0.1) = 6.0;
uniform vec2 noise_scroll = vec2(0.15, 0.08);
uniform float noise_strength : hint_range(0.0, 2.0, 0.01) = 0.5;

// Impact wave (hit ripple)
uniform vec3 impact_pos_ws = vec3(0.0);              // set this on hit (world space)
uniform float impact_time : hint_range(0.0, 10.0) = 0.0; // set to TIME when hit happens
uniform float wave_speed : hint_range(0.1, 50.0) = 18.0;
uniform float wave_freq  : hint_range(1.0, 80.0) = 28.0;
uniform float wave_amp   : hint_range(0.0, 2.0) = 0.6;
uniform float wave_decay : hint_range(0.1, 10.0) = 2.5;
void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}
void fragment() {
	// Fresnel rim (view-based glow)
	float fresnel = pow(1.0 - clamp(dot(normalize(NORMAL), normalize(VIEW)), 0.0, 1.0), rim_power);

	// Noise in UV space
	vec2 nuv = UV * noise_tiling + TIME * noise_scroll;
	float n = texture(noise_tex, nuv).r;

	// Impact wave from world-space point
	float t = max(TIME - impact_time, 0.0);
	float d = distance(world_pos, impact_pos_ws);
	float wave = sin(d * wave_freq - t * wave_speed);
	wave = (wave * 0.5 + 0.5);                   // 0..1
	wave *= exp(-d * wave_decay) * exp(-t * 2.0); // fade in space + time
	wave *= wave_amp;

	// Combine
	float alpha = (fresnel * rim_strength + n * noise_strength + wave) * opacity;
	alpha = clamp(alpha, 0.0, 1.0);

	ALBEDO = shield_color;
	EMISSION = shield_color * (fresnel * rim_strength + wave); // extra pop
	ALPHA = alpha;
}