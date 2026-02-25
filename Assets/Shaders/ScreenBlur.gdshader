shader_type canvas_item;

// Allows you to control the blur amount in the inspector
uniform float blur_amount : hint_range(0.0, 5.0) = 2.0;
// Hint enables grabbing the screen texture
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // LOD (Level of Detail) controls how blurry the texture is
    vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
    COLOR = color;
}
