#ifdef MOBILE
precision mediump float;
#endif

#ifdef HTML5
#extension GL_OES_standard_derivatives : enable
precision mediump float;
#endif

varying vec4 vFragPosition;

void main (void) {
	float linearDepth = length( vFragPosition ) * 10.0;
	//float moment1 = depth;
	//float moment2 = depth * depth;

	// Adjusting moments (this is sort of bias per pixel) using partial derivative	
	//float dx = dFdx ( depth );
	//float dy = dFdy ( depth );
	//moment2 += 0.25*( dx * dx + dy * dy );
	

	gl_FragColor.r = linearDepth;
	//gl_FragColor = textureCube ( uCubemap, vTexCoords );
} 