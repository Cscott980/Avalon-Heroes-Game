shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back;

const float SMOOTHSTEP_AA = 0.01;

uniform sampler2D surfaceNoise;
uniform sampler2D distortNoise;

// ----- Colour gradient (fake "depth") -----
uniform vec4 _DepthGradientShallow : source_color = vec4(0.325, 0.807, 0.971, 0.725);
uniform vec4 _DepthGradientDeep    : source_color = vec4(0.086, 0.407, 1.0, 0.749);

uniform float shallow_world_y = 0.0;          // water plane Y
uniform float depth_fade_world = 1.5;         // how quickly it goes "deep"
uniform float _DepthFactor = 1.0;

// ----- Foam -----
uniform vec4 foam_color : source_color = vec4(1.0);

// Rim foam (view-angle)
uniform float rim_foam_amount : hint_range(0.0, 2.0) = 0.75;
uniform float rim_foam_power  : hint_range(0.5, 8.0) = 2.8;

// Painted shore foam using vertex color alpha (optional)
uniform float shore_foam_amount : hint_range(0.0, 2.0) = 1.0;
uniform float shore_foam_power  : hint_range(0.5, 8.0) = 1.8;

// ----- Surface noise / distortion -----
uniform vec2 surface_noise_tiling = vec2(1.0, 4.0);
uniform vec3 surface_noise_scroll = vec3(0.03, 0.03, 0.0);
uniform float surface_noise_cutoff : hint_range(0.0, 1.0) = 0.777;
uniform float surface_distortion_amount : hint_range(0.0, 1.0) = 0.27;

// Optional toon-ish diffuse
uniform float toon_steps : hint_range(1.0, 8.0) = 4.0;

varying vec2 v_noise_uv;
varying vec2 v_distort_uv;
varying vec3 v_world_pos;
varying vec3 v_view_normal;
varying float v_shore_mask;

vec4 alphaBlend(vec4 top, vec4 bottom) {
	vec3 color = (top.rgb * top.a) + (bottom.rgb * (1.0 - top.a));
	float alpha = top.a + bottom.a * (1.0 - top.a);
	return vec4(color, alpha);
}

void vertex() {
	v_noise_uv = UV * surface_noise_tiling;
	v_distort_uv = UV;

	v_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	v_view_normal = (MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;

	// Paint shoreline foam into vertex color alpha (0..1). If unused, default mesh alpha is often 1.
	// If you don't paint vertex colours, set shore_foam_amount = 0 to disable this contribution.
	v_shore_mask = COLOR.a;
}

void fragment() {
	// Fake "depth" using world height
	float height_delta = max(shallow_world_y - v_world_pos.y, 0.0);
	float waterDepth = clamp((height_delta / max(depth_fade_world, 0.0001)) * _DepthFactor, 0.0, 1.0);
	vec4 waterColor = mix(_DepthGradientShallow, _DepthGradientDeep, waterDepth);

	// Distortion
	vec4 distortNoiseSample = texture(distortNoise, v_distort_uv);
	vec2 distortAmount = (distortNoiseSample.xy * 2.0 - 1.0) * surface_distortion_amount;

	vec2 noise_uv = vec2(
		(v_noise_uv.x + TIME * surface_noise_scroll.x) + distortAmount.x,
		(v_noise_uv.y + TIME * surface_noise_scroll.y) + distortAmount.y
	);

	// Foam noise
	float surfaceNoiseSample = texture(surfaceNoise, noise_uv).r;

	// Rim foam (view-angle)
	float fres = 1.0 - max(dot(normalize(v_view_normal), normalize(VIEW)), 0.0);
	float rim = pow(fres, rim_foam_power) * rim_foam_amount;

	// Shore foam mask (vertex alpha)
	float shore = pow(clamp(v_shore_mask, 0.0, 1.0), shore_foam_power) * shore_foam_amount;

	float foam_mask = clamp(rim + shore, 0.0, 1.0);

	// Use foam mask to drive noise cutoff
	float cutoff = mix(1.0, surface_noise_cutoff, foam_mask);
	float foam_amount = smoothstep(cutoff - SMOOTHSTEP_AA, cutoff + SMOOTHSTEP_AA, surfaceNoiseSample);

	// Composite
	vec4 foamCol = foam_color;
	foamCol.a *= foam_amount;

	vec4 color = alphaBlend(foamCol, waterColor);

	ALBEDO = color.rgb;
	ALPHA = color.a;
	ROUGHNESS = 0.2;
	METALLIC = 0.0;
}

void light() {
	float ndl = max(dot(NORMAL, LIGHT), 0.0);
	float steps = max(toon_steps, 1.0);
	ndl = floor(ndl * steps) / steps;

	DIFFUSE_LIGHT += ALBEDO * LIGHT_COLOR * (0.35 + 0.65 * ndl) * ATTENUATION;
}