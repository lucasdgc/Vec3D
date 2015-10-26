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
		
mat3 transposeMat3 (in mat3 value );
mat3 inverseMat3 (in mat3 value );

void main(void) {
	gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix * vec4 (aVertexPosition, 1.0);
	
	vec3 vertexC = ( uViewMatrix * uModelMatrix * vec4 ( aVertexPosition, 1.0 ) ).xyz;
	//vec3 normalC = ( uViewMatrix * uModelMatrix * vec4 ( aVertexNormal, 1.0 ) ).xyz;
	
	#ifdef HTML5
	//vec3 normalC = normalize ( transposeMat3 ( inverseMat3 ( mat3 ( uModelMatrix ) ) ) * aVertexNormal );
	#else
	//vec3 normalC = normalize ( transpose ( inverse ( mat3 ( uModelMatrix ) ) ) * aVertexNormal );
	#endif
	
	vec3 normalC = ( uViewMatrix * uModelMatrix * vec4 ( aVertexNormal, 0.0 ) ).xyz;
	vec3 lightW = ( uViewMatrix * vec4 ( uLightPos, 1.0) ).xyz;
	
	vColor = aVertexColor;
    vFragPosition = vertexC;
	vNormal = normalC;
	vLightPos = lightW;
}

mat3 transposeMat3 (in mat3 value ) {
	mat3 returnValue;
	
	for ( int i = 0; i < 3; i++ ) {
		for ( int j = 0; j < 3; j++ ) {
			returnValue [j][i] = value [i][j];
		}
	}
	
	return returnValue;
}

mat3 inverseMat3 (in mat3 value ) {
	mat3 returnValue;
	
	returnValue[0][0] = (value[1][1] * value[2][2]) - (value[1][2] * value[2][1]);
	returnValue[0][1] = (value[1][2] * value[2][0]) - (value[1][0] * value[2][2]);
	returnValue[0][2] = (value[1][0] * value[2][1]) - (value[1][1] * value[2][0]);
	
	returnValue[1][0] = (value[2][1] * value[0][2]) - (value[2][2] * value[0][1]);
	returnValue[1][1] = (value[2][2] * value[0][0]) - (value[2][0] * value[0][2]);
	returnValue[1][2] = (value[2][0] * value[0][1]) - (value[2][1] * value[0][0]);
	
	returnValue[2][0] = (value[0][1] * value[1][2]) - (value[0][2] * value[1][1]);
	returnValue[2][1] = (value[0][2] * value[1][0]) - (value[0][0] * value[1][2]);
	returnValue[2][2] = (value[0][0] * value[1][1]) - (value[0][1] * value[1][0]);
	
	//returnValue[i][j] = (value[(float(i)+1.0)%3.0][(float(j)+1.0)%3.0] * a[(float(i)+2.0)%3.0][(float(j)+2.0)%3.0]) - 
	//(a[(float(i)+1.0)%3.0][(float(j)+2.0)%3.0] * a[(float(i)+2.0)%3.0][(float(j)+1)%3.0]));

	return returnValue;
}
