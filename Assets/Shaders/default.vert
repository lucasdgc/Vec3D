#ifdef MOBILE
precision mediump float;
#endif

#ifdef HTML5
precision mediump float;
#endif

attribute vec3 aVertexPosition;
attribute vec3 aVertexNormal;
attribute vec2 aVertexTextCoords;
attribute vec3 aVertexTangent;
attribute vec3 aVertexBitangent;

uniform samplerCube skybox;

uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;
uniform mat4 uLightSpaceMatrix; 
uniform vec3 uLightPos;
uniform vec3 uCameraPos;

varying vec2 vTexCoords;
varying vec3 vFragPosition;
varying vec3 vNormal;
varying vec3 vLightPos;
varying vec3 vEyePos;
varying vec4 vFragPositionLS;
varying mat3 vTBN;
	
void main(void) {
	gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix * vec4 (aVertexPosition, 1.0);
	
	vec3 vertexW = vec3 ( uModelMatrix * vec4 ( aVertexPosition, 1.0 ) );
	vec3 normalW = vec3 ( uModelMatrix * vec4 ( aVertexNormal, 0.0 ) );
	vec3 lightW = uLightPos;
	//vec3 eyeC = vec3 ( 0.0, 0.0, 0.0 ) - vertexC;
	vec3 eyeW = uCameraPos;
	
	vec3 T = normalize ( vec3 ( uModelMatrix * vec4 ( aVertexTangent,   0.0 )));
	vec3 B = normalize ( vec3 ( uModelMatrix * vec4 ( aVertexBitangent, 0.0 )));
	vec3 N = normalize ( vec3 ( uModelMatrix * vec4 ( aVertexNormal,    0.0 )));
	
	vTexCoords = aVertexTextCoords;
    vFragPosition = vertexW;
	vNormal = normalW;
	vLightPos = lightW;
	vEyePos = eyeW;
	vFragPositionLS = uLightSpaceMatrix * vec4 ( vFragPosition, 1.0 );
	vTBN = mat3 ( T, B, N );
}
