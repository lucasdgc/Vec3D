#ifdef MOBILE
precision mediump float;
#endif

#ifdef HTML5
precision mediump float;
#endif

uniform samplerCube uCubemap;

varying vec3 vTexCoords;

void main (void) {
	gl_FragColor = textureCube ( uCubemap, vTexCoords );

} 