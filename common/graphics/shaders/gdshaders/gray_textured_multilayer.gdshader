shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx;
uniform sampler2D tex_bottom : repeat_enable, filter_linear;
uniform sampler2D tex_top : repeat_disable, filter_linear;
uniform vec3 modulate_bottom : source_color;
uniform vec3 modulate_top : source_color;
uniform vec2 uv_scale_top = vec2(1.0f);
uniform vec2 uv_offset_top;
uniform vec2 uv_scale_bottom = vec2(1.0f);
uniform vec2 uv_offset_bottom;
uniform float brightness_bottom : hint_range(0.0, 5.0, 0.01) = 1.0f;
uniform float contrast_bottom : hint_range(0.0, 5.0, 0.01) = 1.0f;
uniform float brightness_top : hint_range(0.0, 5.0, 0.01) = 1.0f;
uniform float contrast_top : hint_range(0.0, 5.0, 0.01) = 1.0f;
uniform bool invert_bottom = false;
uniform bool invert_top = false;
void vertex() {
	// Called for every vertex the material is visible on.
}

vec3 brightness_contrast(vec3 color, float b, float c)
{
	const float avg_lum_r = 0.5;
	const float avg_lum_g = 0.5;
	const float avg_lum_b = 0.5;

	const vec3 lum_coeff = vec3(0.2125, 0.7154, 0.0721);

	vec3 avg_lumen  = vec3(avg_lum_r, avg_lum_g, avg_lum_b);
	vec3 brightness_color = color * b;
	vec3 contrast_color  = mix(avg_lumen, brightness_color, c);

	return contrast_color;
}

void fragment() {
	float inv_b = float(invert_bottom);
	float inv_t = float(invert_top);
	vec3 tex_col_bottom = texture(tex_bottom, UV * uv_scale_bottom + uv_offset_bottom).rgb;
	vec4 tex_col_top = texture(tex_top, UV * uv_scale_top + uv_offset_top);
	vec3 inverted_col_bottom = vec3(1.0f) - tex_col_bottom;
	vec3 inverted_col_top = vec3(1.0f) - tex_col_top.rgb;
	
	vec3 current_col_b = brightness_contrast((tex_col_bottom * (1.0f - inv_b)) + (inverted_col_bottom * inv_b), brightness_bottom, contrast_bottom);
	vec3 current_col_t = brightness_contrast((tex_col_top.rgb * (1.0f - inv_t)) + (inverted_col_top * inv_t), brightness_top, contrast_top);
	float i_b = 0.5f * (current_col_b.r + current_col_b.b);
	float i_t = 0.5f * (current_col_t.r + current_col_t.b);
	vec3 col_b = vec3(mix(vec3(1.0f, 1.0f, 1.0f), modulate_bottom.rgb * i_b, 1.0 - current_col_b.g)) * modulate_bottom;
	vec3 col_t = vec3(mix(vec3(1.0f, 1.0f, 1.0f), modulate_top.rgb * i_t, 1.0 - current_col_t.g)) * modulate_top;
	ALBEDO = mix(col_b, col_t, tex_col_top.a);
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
