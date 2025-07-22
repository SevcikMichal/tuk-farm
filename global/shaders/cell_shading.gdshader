shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float levels : hint_range(1.0, 20.0, 1.0) = 10.0;
uniform float edge_threshold : hint_range(0.0, 1.0) = 0.15;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 px = SCREEN_PIXEL_SIZE;

    // Sample 3x3 neighborhood
    float l00 = dot(texture(screen_texture, uv + px * vec2(-1.0, -1.0)).rgb, vec3(0.2126, 0.7152, 0.0722));
    float l10 = dot(texture(screen_texture, uv + px * vec2( 0.0, -1.0)).rgb, vec3(0.2126, 0.7152, 0.0722));
    float l20 = dot(texture(screen_texture, uv + px * vec2( 1.0, -1.0)).rgb, vec3(0.2126, 0.7152, 0.0722));
    
    float l01 = dot(texture(screen_texture, uv + px * vec2(-1.0,  0.0)).rgb, vec3(0.2126, 0.7152, 0.0722));
    float l21 = dot(texture(screen_texture, uv + px * vec2( 1.0,  0.0)).rgb, vec3(0.2126, 0.7152, 0.0722));
    
    float l02 = dot(texture(screen_texture, uv + px * vec2(-1.0,  1.0)).rgb, vec3(0.2126, 0.7152, 0.0722));
    float l12 = dot(texture(screen_texture, uv + px * vec2( 0.0,  1.0)).rgb, vec3(0.2126, 0.7152, 0.0722));
    float l22 = dot(texture(screen_texture, uv + px * vec2( 1.0,  1.0)).rgb, vec3(0.2126, 0.7152, 0.0722));

    // Sobel edge detection (on luminance)
    float gx = l20 + 2.0 * l21 + l22 - (l00 + 2.0 * l01 + l02);
    float gy = l02 + 2.0 * l12 + l22 - (l00 + 2.0 * l10 + l20);
    float edge_strength = length(vec2(gx, gy));

    // Quantize original color (cel shading)
    vec3 color = texture(screen_texture, uv).rgb;
    float lum = dot(color, vec3(0.2126, 0.7152, 0.0722));
    float band = floor(lum * levels + 0.5) / levels;
    vec3 toon_color = color * band;

    // Output: edge = black, otherwise toon color
    if (edge_strength > edge_threshold) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0); // black line
    } else {
        COLOR = vec4(toon_color, 1.0);
    }
}
