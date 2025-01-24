shader_type spatial;
uniform sampler2D tex_base;
uniform sampler2D tex_scroll : repeat_enable;
uniform vec2 scroll_dir;
uniform float mix_factor : hint_range(0.0, 1.0, 0.01);

uniform vec3 base_modulate : source_color = vec3(1.0f);

uniform vec3 scroll_modulate : source_color = vec3(1.0f);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 scroll_uv = UV + (TIME * normalize(scroll_dir));
	vec3 base_col = texture(tex_base, UV).rgb * base_modulate;
	vec3 scroll_col = texture(tex_scroll, scroll_uv).rgb * scroll_modulate;
	ALBEDO = mix(base_col,scroll_col,mix_factor);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
