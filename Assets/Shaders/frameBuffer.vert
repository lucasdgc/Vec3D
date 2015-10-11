#ifdef MOBILE
precision mediump float;
#endif

attribute vec4 a_position;

uniform int u_screenWidth;
uniform int u_screenHeight;

varying vec2 v_texcoord;

void main() {
	
	float normalizedU = (a_position.x * 0.5 + 0.5) / float(u_screenWidth);
	float normalizedV = (a_position.y * 0.5 + 0.5) / float(u_screenHeight);
	
	gl_Position = a_position;
	//v_texcoord = a_position.xy * 0.5 + 0.5;
	v_texcoord = vec2(normalizedU, normalizedV);
} 