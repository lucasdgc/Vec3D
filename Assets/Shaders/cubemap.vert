#ifdef MOBILE
precision mediump float;
#endif

attribute vec3 aVertexPosition;

uniform mat4 uProjectionMatrix;
uniform mat4 uViewMatrix;

varying vec3 vTexCoords;

void main (void) {
	vec4 pos = uProjectionMatrix * uViewMatrix * vec4 ( aVertexPosition, 1.0 );
	gl_Position = pos.xyww;
	vTexCoords = aVertexPosition;
}