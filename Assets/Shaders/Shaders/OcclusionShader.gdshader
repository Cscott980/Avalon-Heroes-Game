shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back;

uniform vec3 player_position;
uniform vec3 camera_position;

uniform float fade_radius = 1.5;
uniform float fade_strength = 0.2;

varying vec3 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {

	float dist_to_player = distance(world_pos, player_position);

	float fade = smoothstep(fade_radius, fade_radius * 0.5, dist_to_player);

	float cam_dist = distance(camera_position, world_pos);
	float player_cam_dist = distance(camera_position, player_position);

	if (cam_dist < player_cam_dist) {
		ALPHA = mix(fade_strength, 1.0, fade);
	} else {
		ALPHA = 1.0;
	}
}