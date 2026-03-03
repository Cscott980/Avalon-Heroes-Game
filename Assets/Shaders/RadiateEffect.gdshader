shader_type spatial;
render_mode unshaded, cull_disabled, blend_add;

uniform sampler2D shout_tex : source_color;

/*
UV expectation (typical Follow Active Quads on a radial grid):
- One axis wraps around the ring (0..1 seam)
- The other axis goes inner->outer (0..1)

If it scrolls the wrong direction, swap uv.x/uv.y below or flip with (1.0 - uv.y).
*/

uniform float radial_scroll_speed = 2.0;   // outward motion speed
uniform float angular_scroll_speed = 0.0;  // optional spin
uniform float radial_repeat = 1.0;         // repeats from inner->outer
uniform float angular_repeat = 1.0;        // repeats around
uniform float intensity = 1.0;             // brightness
uniform float alpha = 1.0;                 // overall alpha

// Drive the effect lifetime from script (0..1). If you don't set it, it stays 0.
uniform float progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec2 uv = UV;

    // --- Choose which axis is radial vs angular ---
    // Most common: uv.x = angular, uv.y = radial
    float ang = uv.x;
    float rad = uv.y;

    // If yours is swapped, use:
    // float ang = uv.y;
    // float rad = uv.x;

    // Outward scrolling: move the radial coordinate over time
    rad = rad * radial_repeat - TIME * radial_scroll_speed;

    // Optional spin
    ang = ang * angular_repeat + TIME * angular_scroll_speed;

    vec4 col = texture(shout_tex, vec2(fract(ang), fract(rad)));

    // Fade out near the end of life (WoW-style)
    float fade = 1.0 - smoothstep(0.65, 1.0, progress);

    ALBEDO = col.rgb * intensity;
    ALPHA  = col.a * alpha * fade;
}