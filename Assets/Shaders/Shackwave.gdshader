shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_opaque;

/*
BATTLE SHOUT SCALE + FADE
- Works with PNG alpha OR black/white masks.
- Animate `progress` 0 -> 1
*/

uniform sampler2D shout_tex : filter_linear;

uniform vec3 tint : source_color = vec3(1.0, 1.0, 1.0);
uniform float progress : hint_range(0.0, 1.0, 0.001) = 0.0;

uniform float start_scale : hint_range(0.01, 1.0, 0.01) = 0.12;
uniform float end_scale   : hint_range(0.1,  8.0, 0.01) = 2.5;

uniform float opacity    : hint_range(0.0, 2.0, 0.01) = 1.0;
uniform float mask_power : hint_range(0.1, 6.0, 0.01) = 1.6;

uniform float fade_in  : hint_range(0.0, 0.5, 0.001) = 0.05;
uniform float fade_out : hint_range(0.0, 0.9, 0.001) = 0.35;

/*
mask_source:
0 = Use texture alpha (PNG with transparency)
1 = Use luminance (black/white texture)
2 = Use red channel (common for grayscale masks)
*/
uniform int mask_source = 1;

// For B/W masks: push blacks to 0 and whites to 1
uniform float bw_threshold : hint_range(0.0, 1.0, 0.01) = 0.05;

// If your mask is black ring on white background, flip it
uniform bool invert_mask = false;

void fragment() {
	vec2 center = vec2(0.5, 0.5);

	float s = mix(start_scale, end_scale, progress);
	vec2 uv = (UV - center) / s + center;

	// No tiling: mask out-of-bounds UV
	float uv_mask =
		step(0.0, uv.x) * step(0.0, uv.y) *
		step(uv.x, 1.0) * step(uv.y, 1.0);

	vec4 tex = texture(shout_tex, uv);

	float m_alpha = tex.a;
	float m_lum   = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
	float m_red   = tex.r;

	float mask = m_lum; // default
	if (mask_source == 0) mask = m_alpha;
	else if (mask_source == 2) mask = m_red;

	// Threshold for B/W masks (removes grey haze)
	mask = clamp((mask - bw_threshold) / max(1.0 - bw_threshold, 0.0001), 0.0, 1.0);

	if (invert_mask) mask = 1.0 - mask;

	// Shape (crisp vs soft)
	mask = pow(mask, 1.0 / max(mask_power, 0.0001));

	// Fade in/out
	float f_in  = smoothstep(0.0, max(fade_in, 0.0001), progress);
	float f_out = 1.0 - smoothstep(1.0 - fade_out, 1.0, progress);
	float fade = f_in * f_out;

	ALBEDO = tint * tex.rgb;
	ALPHA  = mask * fade * opacity * uv_mask;
}