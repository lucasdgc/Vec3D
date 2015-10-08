attribute vec3 aVertexPosition;
attribute vec4 aVertexColor;

uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;

varying lowp vec4 vColor;
varying lowp vec4 vPosition;
			
void main(void) {
	gl_PointSize = 5.5;
	gl_Position = uProjectionMatrix * uModelViewMatrix * vec4 (aVertexPosition, 1.0);
	
	vColor = aVertexColor;
	vPosition = gl_Position;
}