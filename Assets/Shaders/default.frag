#ifdef MOBILE
precision mediump float;
#endif

#ifdef HTML5
precision mediump float;
#endif

#define pi 3.14159265359;

varying vec4 vColor;
varying vec3 vFragPosition;
varying vec3 vNormal;
varying vec3 vLightPos;
varying vec3 vEyePos;

float lambertDiffuse ( vec3 normal, vec3 lightDir );

vec3 specularBlinn ( vec3 normal, vec3 lightDir, vec3 eye, vec3 dColor, vec3 sColor, float smoothness, float metallic );
float specularPhong  ( vec3 normal, vec3 lightDir, vec3 eye );

vec3 fresnelSchlick ( vec3 specColor, vec3 eye, vec3 halfDir );
vec3 fresnelSchlickAprox ( vec3 specColor, vec3 eye, vec3 halfDir );

void main (void)  {
	vec3 normal = normalize ( vNormal );
	vec3 ld = vLightPos - vFragPosition;
	vec3 lightDir = normalize ( ld );
	vec3 eye = normalize ( vEyePos );
	float ldLength = length ( ld );
	float distanceSqr = ldLength * ldLength;
	
	vec3 dColor = vec3 ( vColor );
	vec3 sColor = vec3 ( 1.0, 1.0, 1.0 );
	float smoothness = 1.0;
	float metallic = 1.0;
	
	vec3 lightColor = vec3 ( 0.8, 0.8, 0.6 );
	float lightPower = 8.0;

	float diffuseFactor = lambertDiffuse ( normal, lightDir );
	vec3 specularFactor = specularBlinn ( normal, lightDir, eye, dColor, sColor, smoothness, metallic );
	
	diffuseFactor = float ( ( 1.0 - specularFactor ) * diffuseFactor ); 
	
	vec3 diffuseColor = dColor * diffuseFactor;
	vec3 specularColor = dColor * specularFactor;
	//vec3 specularColor = vec3 ( vColor ) * specularPhong ( normal, lightDir, normalize ( vEyePos ) );
	//vec3 specularColor = vec3 (0.0, 0.0, 0.0);
	//diffuseColor = ( 1.0 - specularColor ) * diffuseColor; 
	
	vec3 result = ( diffuseColor + specularColor ) * lightColor * ( lightPower / distanceSqr );
	gl_FragColor = vec4(result, 1.0);
}

float lambertDiffuse ( vec3 normal, vec3 lightDir ) {
	float diff = max ( dot ( normal, lightDir ), 0.0 );
	float normalization = 1.0 / pi;
	
	return diff;
}

float specularPhong (vec3 normal, vec3 lightDir, vec3 eye) {
	vec3 r = reflect ( -lightDir, normal );
	float cosAlpha = max ( dot ( eye, r ), 0.0 );
	float power = 2048.0;
	float normalization = ( power + 1.0 ) / 2.0;
	
	return normalization * pow ( cosAlpha, power );
}

vec3 specularBlinn ( vec3 normal, vec3 lightDir, vec3 eye, vec3 dColor, vec3 sColor, float smoothness, float metallic ) {
	vec3 halfDir = normalize ( lightDir + eye );
	float specAngle = max ( dot ( halfDir, normal ), 0.0 );
	float dotNL = max ( dot ( normal, lightDir ), 0.0 );
	float power = exp2 ( 10.0 * smoothness + 1.0 );
	float normalization = ( power + 2.0 ) / 8.0;
	vec3 specColor = ( metallic * dColor ) + ( 1.0 - metallic * sColor );
	
	//return ( ( pow ( specAngle, power ) ) * dotNL ) * dColor;
	//return ( ( fresnelSchlick ( specColor, eye,  halfDir ) * normalization ) * ( pow ( specAngle, power ) ) * dotNL ); 
	return ( ( fresnelSchlickAprox ( specColor, eye,  halfDir ) * normalization ) * ( pow ( specAngle, power ) ) * dotNL ); 
}

vec3 fresnelSchlick ( vec3 specColor, vec3 eye, vec3 halfDir ) {
	return specColor + ( 1.0 - specColor ) * pow ( ( 1.0 - dot ( eye, halfDir ) ), 4.0 );
}

vec3 fresnelSchlickAprox ( vec3 specColor, vec3 eye, vec3 halfDir ) {
	float dotEH = dot ( eye, halfDir );
	return specColor + ( 1.0 - specColor ) * exp2 ( ( -5.55473 * dotEH - 6.98316 ) * dotEH );
}