#ifdef MOBILE
precision mediump float;
#endif

#ifdef HTML5
precision mediump float;
#endif

#define pi 3.14159265359;

uniform samplerCube skybox;

varying vec4 vColor;
varying vec3 vFragPosition;
varying vec3 vNormal;
varying vec3 vLightPos;
varying vec3 vEyePos;

float lambertDiffuse ( vec3 normal, vec3 lightDir );

float specularBlinn ( vec3 normal, vec3 halfDir, float smoothness );
float specularPhong  ( vec3 normal, vec3 lightDir, vec3 eye, float smoothness );

vec3 fresnelSchlick ( vec3 specColor, vec3 eye, vec3 halfDir );
vec3 fresnelSchlickAprox ( vec3 specColor, vec3 eye, vec3 halfDir );

float fresnelFloat ( vec3 eye, vec3 normal, float f0 );

vec3 ambientSpecular ( float power, float dotNL, vec3 normal, vec3 eye );

void main (void)  {
	vec3 normal = normalize ( vNormal );
	vec3 ld = vLightPos - vFragPosition;
	vec3 lightDir = normalize ( ld );
	vec3 eye = normalize ( vEyePos - vFragPosition );
	vec3 halfDir = normalize ( lightDir + eye );
	float ldLength = length ( ld );
	float distanceSqr = ldLength * ldLength;
	float dotNL = dot ( lightDir, normal );
	
	//vec3 dColor = vec3 ( vColor );
	vec3 dColor = vec3 ( 0.0, 0.0, 0.7 );
	vec3 sColor = vec3 ( 0.7, 0.7, 0.7 );
	float smoothness = 0.4;
	float metallic = 1.0;
	
	vec3 lightColor = vec3 ( 0.5, 0.4, 0.1 );
	float lightPower = 80.0;

	vec3 directLighting = lightColor * ( lightPower / distanceSqr ) ;
	
	float diffuseFactor = dotNL;
	float specularFactor = specularBlinn ( normal, halfDir, smoothness );
	float fresnelFactor = fresnelFloat ( eye, normal, 0.0 );
	
	vec3 directDiffuse = dColor * diffuseFactor;
	
	vec3 specularColor = mix ( sColor, dColor, metallic );
	vec3 directFresnel = mix ( vec3 ( 0, 0, 0 ), lightColor, fresnelFactor );
	vec3 directSpecular = ( specularColor * specularFactor ) + directFresnel;
	
	//vec3 skyboxR = reflect ( - eye, normalize ( vNormal ) );
	
	vec3 result = directDiffuse + directSpecular;
	
	gl_FragColor = vec4 (result, 1.0 );
}

float lambertDiffuse ( vec3 normal, vec3 lightDir ) {
	float diff = max ( dot ( normal, lightDir ), 0.0 );
	float normalization = 1.0 / pi;
	
	return diff;
}

float specularPhong ( vec3 normal, vec3 lightDir, vec3 eye, float smoothness ) {
	vec3 r = reflect ( -lightDir, normal );
	float cosAlpha = max ( dot ( eye, r ), 0.0 );
	float power = exp2 ( 10.0 * smoothness + 1.0 );
	float normalization = ( power + 1.0 ) / 2.0;
	
	return pow ( cosAlpha, power );
}

float specularBlinn ( vec3 normal, vec3 halfDir, float smoothness ) {
	float specAngle = max ( dot ( halfDir, normal ), 0.0 );
	float power = exp2 ( 10.0 * smoothness + 1.0 );
	float normalization = ( power + 2.0 ) / 8.0;
	
	float specular = pow ( specAngle, power );
	
	return specular * normalization;
}

vec3 fresnelSchlick ( vec3 specColor, vec3 eye, vec3 halfDir ) {
	//float base = 1.0 - dot ( eye, halfDir );
	//float exp = pow ( base, 4.0 );
	//float ior = 1.0;
	//float f0 = ( ior - 1.0 ) / ( ior + 1.0 );
	
	return specColor + ( vec3 ( 1.0, 1.0, 1.0 ) - specColor ) * pow ( 1.0 - dot ( eye, halfDir ), 5.0 );
	
	//return specColor + ( 1.0 - specColor ) * pow ( 1.0 - max ( dot ( eye, halfDir ), 0.0 ), 4.0 );
	//return exp + specColor * f0 * ( 1.0 - exp );
}

float fresnelFloat ( vec3 eye, vec3 normal, float f0 ) {
	return f0 + ( 1.0 - f0 ) * pow ( 1.0 - dot ( normal, eye ), 4.0 );
}

vec3 fresnelSchlickAprox ( vec3 specColor, vec3 eye, vec3 halfDir ) {
	float dotEH = dot ( eye, halfDir );
	return specColor + ( 1.0 - specColor ) * exp2 ( ( -5.55473 * dotEH - 6.98316 ) * dotEH );
}

vec3 ambientSpecular ( float power, float dotNL, vec3 normal, vec3 eye ) {
	float pie = pi;
	float normalization = ( power + 2.0 ) / ( 2.0 * pie );
	vec3 skyboxR = reflect ( - eye, normalize ( normal ) );
	
	//return normalization * pow ( dotNL, power ) * dotNL * vec3 ( textureCube ( skybox, skyboxR ) );
	vec3 pfColor = dotNL * vec3 ( textureCube ( skybox, skyboxR ) );
	
	return pfColor;
}