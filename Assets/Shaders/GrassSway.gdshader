shader_type spatial;
render_mode cull_back;

uniform float sway_strength : hint_range(0.0, 1.0) = 0.25;
uniform float sway_speed : hint_range(0.0, 5.0) = 1.5;
uniform float sway_variation : hint_range(0.0, 5.0) = 2.0;

uniform sampler2D albedo_tex : source_color;
uniform vec4 tint : source_color = vec4(1.0);

void vertex() {
	float height_factor = clamp(VERTEX.y, 0.0, 1.0);
	float wave = sin(TIME * sway_speed + VERTEX.x * sway_variation);
	VERTEX.x += wave * sway_strength * height_factor;
}

void fragment() {
	vec4 col = texture(albedo_tex, UV) * tint;
	ALBEDO = col.rgb;
	ALPHA = col.a;
}
