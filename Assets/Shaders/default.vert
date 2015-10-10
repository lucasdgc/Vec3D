#ifdef MOBILE
precision mediump float;
#endif

attribute vec3 aVertexPosition;
attribute vec4 aVertexColor;

uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;

varying vec4 vColor;
varying vec4 vPosition;
			
void main(void) {
	gl_PointSize = 2.5;
	gl_Position = uProjectionMatrix * uModelViewMatrix * vec4 (aVertexPosition, 1.0);
	
	vColor = aVertexColor;
	vPosition = gl_Position;
}