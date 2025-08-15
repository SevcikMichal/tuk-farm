shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform float levels: hint_range(1.0, 20.0, 1.0) = 10.0;
uniform float edge_threshold: hint_range(0.0, 1.0) = 0.15;

// Pixelation block size (in screen pixels)
uniform int pixel_block: hint_range(1, 128, 1) = 16;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 px = SCREEN_PIXEL_SIZE;

    // ----- Pixelated base color -----
    float block = max(1.0, float(pixel_block));
    vec2 step_uv = px * block;
    // Snap to block center to avoid bias
    vec2 snapped_uv = (floor(uv / step_uv) + 0.5) * step_uv;

    vec3 color = texture(screen_texture, snapped_uv).rgb;

    // Cel-shade quantization
    float lum = dot(color, vec3(0.2126, 0.7152, 0.0722));
    float band = floor(lum * levels + levels * 0.5) / levels;
    vec3 toon_color = color * band;


    COLOR = vec4(toon_color, 1.0);
}