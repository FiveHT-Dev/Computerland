shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx;
uniform sampler2D tex : repeat_enable, filter_linear;
uniform vec3 modulate : source_color;
uniform vec2 uv_scale = vec2(1.0f);
uniform vec2 uv_offset;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 tex_col = texture(tex, UV * uv_scale + uv_offset).rgb;
	float i = 0.5f * (tex_col.r + tex_col.b);
	ALBEDO = vec3(mix(vec3(1.0f, 1.0f, 1.0f), modulate.rgb * i, 1.0 - tex_col.g)) * modulate; 
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
