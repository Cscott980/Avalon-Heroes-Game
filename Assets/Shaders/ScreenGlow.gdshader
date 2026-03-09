shader_type canvas_item;

uniform vec4 border_color : source_color = vec4(1.0, 0.84, 0.2, 1.0);

uniform float border_thickness : hint_range(0.0, 10.0) = 2.0;
uniform float glow_size : hint_range(0.0, 20.0) = 5.0;
uniform float glow_strength : hint_range(0.0, 5.0) = 1.6;

uniform float pulse_speed : hint_range(0.0, 10.0) = 2.0;
uniform float pulse_amount : hint_range(0.0, 1.0) = 0.15;

uniform float deform_speed : hint_range(0.0, 10.0) = 2.5;
uniform float deform_amount : hint_range(0.0, 0.05) = 0.008;
uniform float deform_scale : hint_range(1.0, 50.0) = 14.0;

float wave(vec2 uv, float t) {
	return sin(uv.x * deform_scale + t) * sin(uv.y * deform_scale * 0.8 + t * 1.2);
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float alpha = tex.a;
	vec2 pixel = TEXTURE_PIXEL_SIZE;

	float t = TIME * deform_speed;

	// --- border detection (stable, so the actual edge stays readable) ---
	float max_neighbor_alpha = 0.0;
	for (int x = -1; x <= 1; x++) {
		for (int y = -1; y <= 1; y++) {
			vec2 offset = vec2(float(x), float(y)) * pixel * border_thickness;
			float sample_a = texture(TEXTURE, UV + offset).a;
			max_neighbor_alpha = max(max_neighbor_alpha, sample_a);
		}
	}

	float border = clamp(max_neighbor_alpha - alpha, 0.0, 1.0);

	// --- deform only the glow sampling ---
	vec2 wobble = vec2(
		sin(UV.y * deform_scale + t) * cos(UV.x * deform_scale * 0.7 + t * 1.1),
		cos(UV.x * deform_scale + t * 0.9) * sin(UV.y * deform_scale * 0.9 + t * 1.3)
	) * deform_amount;

	float glow = 0.0;

	for (int x = -2; x <= 2; x++) {
		for (int y = -2; y <= 2; y++) {
			vec2 offset = vec2(float(x), float(y)) * pixel * glow_size;

			// extra drifting distortion
			vec2 deformed_uv = UV + offset + wobble;
			float sample_a = texture(TEXTURE, deformed_uv).a;
			glow = max(glow, sample_a);
		}
	}

	glow = clamp(glow - alpha, 0.0, 1.0);

	float pulse = 1.0 + sin(TIME * pulse_speed) * pulse_amount;

	vec3 final_rgb = tex.rgb;
	final_rgb += border_color.rgb * border * 1.8 * pulse;
	final_rgb += border_color.rgb * glow * glow_strength * pulse;

	float final_alpha = max(alpha, border * border_color.a + glow * 0.65);

	COLOR = vec4(final_rgb, final_alpha);
}