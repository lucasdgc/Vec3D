#ifdef MOBILE
precision mediump float;
#endif

#ifdef HTML5
precision mediump float;
#endif

varying vec4 vColor;
varying vec3 vFragPosition;
varying vec3 vNormal;
varying vec3 vLightPos;
varying vec3 vEyePos;

float lambertDiffuse (vec3 normal, vec3 lightDir, float distanceSqr);

float specularBlinn (vec3 normal, vec3 lightDir, vec3 eye, float distanceSqr);
float specularPhong (vec3 normal, vec3 lightDir, vec3 eye, float distanceSqr);

void main (void)  {
	vec3 normal = normalize ( vNormal );
	vec3 ld = vLightPos - vFragPosition;
	vec3 lightDir = normalize ( ld );
	float ldLength = length ( ld );
	float distanceSqr = ldLength * ldLength;
	
	vec3 lightColor = vec3 ( 0.8, 0.8, 0.6 );
	float lightPower = 10.0;

	vec3 diffuseColor = vec3 ( vColor ) * lightColor * lightPower * lambertDiffuse ( normal, lightDir, distanceSqr );
	vec3 specularColor = vec3 ( vColor ) * lightColor * lightPower * specularBlinn ( normal, lightDir, normalize ( vEyePos ), distanceSqr );
	
	vec3 result = diffuseColor + specularColor;
	gl_FragColor = vec4(result, 1.0);
}

float lambertDiffuse (vec3 normal, vec3 lightDir, float distanceSqr) {
	float diff = max ( dot ( normal, lightDir ), 0.0 );
	
	return diff / distanceSqr;
}

float specularPhong (vec3 normal, vec3 lightDir, vec3 eye, float distanceSqr) {
	vec3 r = reflect ( -lightDir, normal );
	float cosAlpha = max ( dot ( eye, r ), 0.0 );
	
	return pow ( cosAlpha, 32.0 ) / distanceSqr;
}

float specularBlinn (vec3 normal, vec3 lightDir, vec3 eye, float distanceSqr) {
	vec3 halfDir = normalize ( lightDir + eye );
	float specAngle = max ( dot ( halfDir, normal ), 0.0 );
	
	return pow ( specAngle, 32.0 ) / distanceSqr;
}