shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx, blend_mix, depth_draw_always, cull_back;
uniform sampler2D tex : repeat_enable, filter_linear;
uniform vec3 modulate : source_color;
uniform vec2 uv_scale = vec2(1.0f);
uniform vec2 uv_offset;
uniform float brightness : hint_range(0.0, 5.0, 0.01) = 1.0f;
uniform float contrast : hint_range(0.0, 5.0, 0.01) = 1.0f;
uniform bool invert = false;
void vertex() {
	// Called for every vertex the material is visible on.
}

vec3 brightness_contrast(vec3 color)
{
	const float avg_lum_r = 0.5;
	const float avg_lum_g = 0.5;
	const float avg_lum_b = 0.5;

	const vec3 lum_coeff = vec3(0.2125, 0.7154, 0.0721);

	vec3 avg_lumen  = vec3(avg_lum_r, avg_lum_g, avg_lum_b);
	vec3 brightness_color = color * brightness;
	vec3 contrast_color  = mix(avg_lumen, brightness_color, contrast);

	return contrast_color;
}

void fragment() {
	float inv = float(invert);
	vec4 tex_with_alpha = texture(tex, UV * uv_scale + uv_offset);
	vec3 inverted_col = vec3(1.0f) - tex_with_alpha.rgb;
	vec3 tex_col = brightness_contrast((tex_with_alpha.rgb * (1.0f - inv)) + (inverted_col * inv));
	float i = 0.5f * (tex_col.r + tex_col.b);
	vec3 col = vec3(mix(vec3(1.0f, 1.0f, 1.0f), modulate.rgb * i, 1.0 - tex_col.g)) * modulate;
	
	ALBEDO = col;
	ALPHA = tex_with_alpha.a;
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
