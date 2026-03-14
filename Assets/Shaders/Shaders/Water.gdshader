shader_type spatial;
render_mode cull_disabled, depth_draw_opaque, specular_disabled;

uniform vec4 shallow_color : source_color = vec4(0.25, 0.75, 0.95, 1.0);
uniform vec4 deep_color : source_color = vec4(0.10, 0.45, 0.75, 1.0);
uniform vec4 foam_color : source_color = vec4(0.85, 0.97, 1.0, 1.0);

uniform float wave_speed = 1.2;
uniform float wave_scale = 2.0;
uniform float wave_height = 0.08;

uniform float small_wave_speed = 2.0;
uniform float small_wave_scale = 5.0;
uniform float small_wave_height = 0.03;

uniform float color_ramp_strength = 0.6;
uniform float fresnel_strength = 0.45;
uniform float foam_amount = 0.12;
uniform float foam_cutoff = 0.72;

varying float v_wave_mix;
varying vec3 v_world_pos;
varying vec3 v_world_normal;

void vertex() {
	v_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	float t = TIME * wave_speed;
	float t2 = TIME * small_wave_speed;

	float wave_a = sin(v_world_pos.x * wave_scale + t);
	float wave_b = cos(v_world_pos.z * wave_scale * 0.9 + t * 1.1);
	float wave_c = sin((v_world_pos.x + v_world_pos.z) * small_wave_scale + t2);

	float big_waves = (wave_a + wave_b) * 0.5 * wave_height;
	float small_waves = wave_c * small_wave_height;

	VERTEX.y += big_waves + small_waves;

	v_wave_mix = big_waves + small_waves;
	v_world_normal = normalize((MODEL_NORMAL_MATRIX * NORMAL));
}

void fragment() {
	vec3 view_dir = normalize(CAMERA_POSITION_WORLD - v_world_pos);
	float fresnel = pow(1.0 - max(dot(normalize(v_world_normal), view_dir), 0.0), 2.0);

	float height_blend = clamp(v_wave_mix * 4.0 + 0.5, 0.0, 1.0);
	vec3 base_col = mix(deep_color.rgb, shallow_color.rgb, height_blend * color_ramp_strength + 0.2);

	float foam_wave = sin(v_world_pos.x * 6.0 + TIME * 2.2) * 0.5 + 0.5;
	foam_wave += cos(v_world_pos.z * 5.0 - TIME * 1.8) * 0.5 + 0.5;
	foam_wave *= 0.5;

	float foam_mask = step(foam_cutoff, height_blend + foam_wave * foam_amount);

	vec3 final_col = base_col;
	final_col = mix(final_col, foam_color.rgb, foam_mask * 0.65);
	final_col += fresnel * fresnel_strength * 0.25;

	ALBEDO = final_col;
	ROUGHNESS = 1.0;
	METALLIC = 0.0;
	SPECULAR = 0.0;
}