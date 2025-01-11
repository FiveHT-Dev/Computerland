shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx;
uniform sampler2D tex : repeat_enable, filter_linear;
uniform vec3 modulate : source_color = vec3(1.0f);
uniform vec2 uv_scale = vec2(1.0f);
uniform vec2 uv_offset;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(tex, UV * uv_scale - uv_offset).rgb * modulate;
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
