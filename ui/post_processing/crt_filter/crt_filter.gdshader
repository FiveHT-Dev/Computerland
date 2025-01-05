shader_type canvas_item;
/// This shit is a mess but whatever. TODO fix this shit
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;



/*group_uniforms EdgeDetection;
uniform float add : hint_range(0.0, 0.002, 0.0001);
uniform float threshold : hint_range(0.0, 1.0, 0.001);
uniform float threshold2 : hint_range(0.0, 1.0, 0.001);
uniform vec4 edgeColour : source_color;
uniform vec4 edgeColour2 : source_color;
uniform vec4 nonEdgeColour : source_color;*/

group_uniforms CrtStuff;
uniform sampler2D scanline_tex;
uniform sampler2D noise_tex : repeat_enable;
uniform sampler2D scaling_correction_tex;

/*vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}*/

void fragment() {
	/*vec3 up = rgb2hsv((texture(screen_texture, vec2(SCREEN_UV.x, SCREEN_UV.y + add))).rgb);
	vec3 down = rgb2hsv((texture(screen_texture, vec2(SCREEN_UV.x, SCREEN_UV.y - add))).rgb);
	vec3 left = rgb2hsv((texture(screen_texture, vec2(SCREEN_UV.x - add, SCREEN_UV.y))).rgb);
	vec3 right = rgb2hsv((texture(screen_texture, vec2(SCREEN_UV.x + add, SCREEN_UV.y))).rgb);
	vec3 real = rgb2hsv((texture(screen_texture, SCREEN_UV)).rgb);
	
	vec3 edges = vec3(0.0f);
	if(abs(real.z - up.z) > threshold || abs(real.z - down.z) > threshold || abs(real.z - left.z) > threshold || abs(real.z - right.z) > threshold){
		edges = edgeColour.rgb;
	} 
	else {
		edges = nonEdgeColour.rgb;
	}*/
	
	float offset = floor((sin(TIME * 80.0f) + 2.0f) -1.0f);
	vec3 scanlines = texture(scanline_tex, SCREEN_UV + vec2(0.0f, offset * SCREEN_PIXEL_SIZE.y)).rgb;
	float scaling_correction_factor = 1.0f + (texture(scaling_correction_tex, SCREEN_UV).r * 8.0f);
	vec2 scanline_uv = vec2(((SCREEN_UV.x - 0.5f) * (1.0f + (scanlines.r * (0.003f * scaling_correction_factor)))) + 0.5f, SCREEN_UV.y);
	vec3 scanline_screen = texture(screen_texture, scanline_uv).rgb;
	
	vec3 noise = texture(noise_tex, SCREEN_UV + (sin(TIME * 80.0f) * 100.0f)).rgb * 0.04f;
	vec3 ofs_screen_0 = texture(screen_texture, SCREEN_UV + vec2(0.005f, 0.0f)).rgb;
	vec3 ofs_screen_1 = texture(screen_texture, SCREEN_UV - vec2(0.005f, 0.0f)).rgb;
	vec3 screen = mix(mix(texture(screen_texture, SCREEN_UV).rgb, ofs_screen_0, 0.15f), ofs_screen_1, 0.15f);
	
	COLOR.rgb = mix(screen, scanline_screen, 0.55f) - (scanlines * 0.01f) - noise;
	//COLOR.rgb = vec3(scaling_correction_factor);
}