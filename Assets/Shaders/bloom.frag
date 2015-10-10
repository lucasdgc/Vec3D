#ifdef MOBILE
precision mediump float;
#endif

varying vec2 v_texcoord;
uniform sampler2D u_sampler;

uniform vec4 backgroundColor;

uniform float offset;


vec4 calculateBlur () {
	
	float blurRatio = 128.0;
	float blurfactor = 16.0;
	
	float blurSizeH = 1.0 / ( blurRatio * 16.0 );
	float blurSizeV = 1.0 / ( blurRatio * 9.0 );

	vec4 sum = vec4(0.0);	
	
	if (texture2D(u_sampler, v_texcoord) != backgroundColor) {
		for (int x = -4; x <= 4; x++) {
			for (int y = -4; y <= 4; y++) {
				sum += texture2D(
					u_sampler,
					vec2(v_texcoord.x + float(x) * blurSizeH, v_texcoord.y + float(y) * blurSizeV)
				) / blurfactor;
			}
		}
	}
	//sum = texture2D(u_sampler, v_texcoord);
	//outColor = sum;
	
	
	
	return sum;
		
}

void main() {
	
	//vec2 new_coord = v_texcoord;
	
	//new_coord.x += sin(new_coord.y * 4.0 * 2.0 * 3.14159 + offset) / 100.0;
	
	//vec4 outColor = vec4(1.0, 1.0, 1.0, 1.0) -  ;
	
    //gl_FragColor = texture2D(u_sampler, v_texcoord);
	
	gl_FragColor =  calculateBlur ();
	
	//gl_FragColor = effect ();

}
