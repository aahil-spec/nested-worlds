shader_type canvas_item;

uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform float intensity : hint_range(0.0, 1.0) = 0.4;

void fragment() {
    vec2 centered = UV * 2.0 - 1.0;
    float dist = length(centered);
    float vignette = smoothstep(0.5, 1.4, dist);
    COLOR = vec4(vignette_color.rgb, vignette * intensity);
}