#ifdef MOBILE
precision mediump float;
#endif

attribute vec3 aVertexPosition;
attribute vec3 aVertexNormal;
attribute vec4 aVertexColor;

uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;
uniform vec3 uLightPos;

varying vec4 vColor;
varying vec3 vFragPosition;
varying vec3 vNormal;
varying vec3 vLightPos;
			
void main(void) {
	//gl_PointSize = 2.5;
	gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix * vec4 (aVertexPosition, 1.0);
	
	vec3 vertexW = (uModelMatrix * vec4 (aVertexPosition, 1.0)).xyz;
	
	vColor = aVertexColor;
    vFragPosition = ( uModelMatrix * vec4 ( aVertexPosition, 1.0 ) ).xyz;
	vNormal = ( uModelMatrix * vec4 ( aVertexNormal, 1.0) ).xyz;
	vLightPos = uLightPos;
}