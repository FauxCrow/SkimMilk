shader_type canvas_item;
render_mode blend_mix, unshaded;

uniform vec4 line_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float line_density : hint_range(1.0, 100.0) = 100.0;
uniform float line_thickness : hint_range(0.001, 0.5) = 0.3;
uniform float animation_speed : hint_range(0.0, 30.0) = 12.0;

// Pseudo-random gradient direction vector
vec2 grad(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
	return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

// Classic 2D Perlin / Gradient Noise matching the JavaScript logic
float perlin_noise(vec2 p) {
	vec2 i = floor(p);
    vec2 f = fract(p);

    vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);

    float n00 = dot(grad(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0));
    float n10 = dot(grad(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0));
    float n01 = dot(grad(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0));
    float n11 = dot(grad(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0));

    return mix(mix(n00, n10, u.x), mix(n01, n11, u.x), u.y);
}

void fragment() {
    vec4 sprite_color = texture(TEXTURE, UV);
	
    if (sprite_color.a <= 0.0) {
        discard;
    }
	
    vec2 screen_uv = SCREEN_UV;
    screen_uv.x *= SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;

    float stepped_time = floor(TIME * animation_speed);
    vec2 offset = vec2(
        fract(sin(stepped_time * 12.9898) * 43758.5453),
        fract(sin(stepped_time * 78.2330) * 43758.5453)
    ) * 100.0;

    vec2 uv = (screen_uv * line_density) + offset;

    float raw_n = perlin_noise(uv);
    float abs_n = abs(raw_n);
    float line_mask = 1.0 - smoothstep(0.0, line_thickness, abs_n);
	
    vec4 effect_color = vec4(line_color.rgb, line_mask * line_color.a);
    
    COLOR = effect_color;
    COLOR.a *= sprite_color.a;
}