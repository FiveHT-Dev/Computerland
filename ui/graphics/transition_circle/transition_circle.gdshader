shader_type canvas_item;

uniform float circle_r = 0.5f;
void vertex() {
	// Called for every vertex the material is visible on.
}

float when_gt(float x, float y) {
  return max(sign(x - y), 0.0);
}

void fragment() {
	COLOR.rgb = vec3(0.0f);
	vec2 new_uv = vec2(UV.x * 1.75f - 0.5f * 1.75f, UV.y - 0.5f) / circle_r; 
	COLOR.a = when_gt(length(new_uv), 0.5f);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
