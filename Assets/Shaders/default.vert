#ifdef MOBILE
precision mediump float;
#endif

#ifdef HTML5
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
varying vec3 vEyePos;
		
mat3 transposeMat3 (in mat3 value );
mat3 inverseMat3 (in mat3 value );

void main(void) {
	gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix * vec4 (aVertexPosition, 1.0);
	
	vec3 vertexC = ( uViewMatrix * uModelMatrix * vec4 ( aVertexPosition, 1.0 ) ).xyz;
	vec3 normalC = ( uViewMatrix * uModelMatrix * vec4 ( aVertexNormal, 0.0 ) ).xyz;
	vec3 lightW = ( uViewMatrix * vec4 ( uLightPos, 1.0) ).xyz;
	vec3 eyeC = vec3 ( 0.0, 0.0, 0.0 ) - vertexC;
	
	vColor = aVertexColor;
    vFragPosition = vertexC;
	vNormal = normalC;
	vLightPos = lightW;
	vEyePos = eyeC;
}
