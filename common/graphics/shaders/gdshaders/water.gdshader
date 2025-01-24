shader_type spatial;
uniform sampler2D tex;
uniform vec3 modulate : source_color;
uniform vec2 uv_scale = vec2(1.0f);
uniform vec2 uv_offset;
uniform float brightness : hint_range(0.0, 5.0, 0.01) = 1.0f;
uniform float contrast : hint_range(0.0, 5.0, 0.01) = 1.0f;
uniform bool invert = false;
uniform float alpha : hint_range(0.0, 1.0, 0.01);
group_uniforms waves;
uniform vec2 scroll_dir;
uniform float scroll_speed;
uniform vec2 wave_dir;
uniform float wave_strength;
void vertex() {
	VERTEX.y += sin(TIME + VERTEX.x + VERTEX.z) * 0.1f * wave_strength;
	VERTEX.x += sin(TIME + VERTEX.z - VERTEX.x) * 0.2f * wave_strength;
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
	vec3 tex_col = texture(tex, UV * uv_scale + uv_offset + (normalize(scroll_dir) * TIME * scroll_speed)).rgb;
	vec3 inverted_col = vec3(1.0f) - tex_col;
	vec3 current_col = brightness_contrast((tex_col * (1.0f - inv)) + (inverted_col * inv));
	float i = 0.5f * (current_col.r + current_col.b);
	vec3 col = vec3(mix(vec3(1.0f, 1.0f, 1.0f), modulate.rgb * i, 1.0 - current_col.g)) * modulate;
	ALBEDO = col;
	ALPHA = alpha;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
