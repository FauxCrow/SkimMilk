shader_type canvas_item;

uniform float white_progress : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    COLOR = mix(tex_color, vec4(1.0, 1.0, 1.0, tex_color.a), white_progress);
}