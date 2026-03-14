shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float strength = 0.05;

void fragment() {
    // Distort UV based on noise or sine waves
    vec2 distortedUV = SCREEN_UV + sin(TIME * 10.0 + SCREEN_UV.y * 20.0) * strength;
    COLOR = texture(SCREEN_TEXTURE, distortedUV);
}
