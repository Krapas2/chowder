shader_type spatial;
render_mode blend_mix, cull_back, depth_prepass_alpha;

const int MAX_POINTS = 128;

uniform vec3 temp_positions[MAX_POINTS];
uniform float temp_values[MAX_POINTS];
uniform int temp_count;
uniform float temp_mult;
uniform float temp_exponent;

uniform float opacity = 1.;
uniform float light_exponent;

varying vec3 world_pos;

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float temp_sum = 0.;
	for (int i = 0; i < temp_count; i++){
		float temp_dist = distance(world_pos, temp_positions[i]);
		temp_sum += temp_values[i] / pow(temp_dist, temp_exponent);
	}
	temp_sum *= temp_mult;
	ALBEDO = vec3(temp_sum);
	ALPHA = opacity;
}

void light() {
	float fresnel = pow(max(dot(NORMAL, VIEW), 0.0), light_exponent);
    DIFFUSE_LIGHT = vec3(fresnel);
	ALPHA = opacity * fresnel;
}
