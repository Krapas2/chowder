shader_type canvas_item;

uniform float exponent;
uniform sampler2D palette : source_color;

uniform sampler2D screenTexture : hint_screen_texture;

vec3 paletteMap(float value){
	return texture(palette, vec2(value, 0.)).xyz;
}

void fragment() {
    vec2 screenPos = FRAGCOORD.xy;
	
	vec4 pCol = textureLod(screenTexture, SCREEN_UV, 0.0);
	float brightness = pow((pCol.x+pCol.y+pCol.z) / 3., exponent);
	
	vec3 color = paletteMap(brightness);
	COLOR = vec4(color, 1.);
}