#ifdef MOBILE
precision mediump float;
#endif

#ifdef HTML5
precision mediump float;
#endif

#define pi 3.14159265359;

struct material {
	sampler2D albedo;
	sampler2D normal;
	sampler2D smoothness;
	sampler2D metallic;
};

struct directionalLight {
	vec3 direction;
	vec3 color;
	vec3 power;
};

struct pointLight {
	vec3 position;
	vec3 color;
	float power;
};

struct spotLight {
	vec3 position;
	vec3 direction;
	vec3 color;
	float power;
	float cutoff;
};

uniform samplerCube skybox;

uniform directionalLight uDirLight;
uniform int uPointLightCount;
uniform pointLight uPointLights[8];
uniform int uSpotLightCount;
uniform spotLight uSpotLights[8];
uniform material uMaterial;

varying vec3 vFragPosition;
varying vec3 vNormal;
varying vec3 vLightPos;
varying vec3 vEyePos;
varying vec2 vTexCoords;

vec3 calcLightFactors ( vec3 lightDir, vec3 normal, vec3 eye, float smoothness, float metallic );

vec3 getDirectLightContribution ( float diffuseFactor, float specularFactor, float fresnelFactor, vec3 diffuseColor, vec3 specColor );

float lambertDiffuse ( vec3 normal, vec3 lightDir );

float specularBlinn ( vec3 normal, vec3 halfDir, float smoothness );
float specularPhong  ( vec3 normal, vec3 lightDir, vec3 eye, float smoothness );

vec3 fresnelSchlick ( vec3 specColor, vec3 eye, vec3 halfDir );
vec3 fresnelSchlickAprox ( vec3 specColor, vec3 eye, vec3 halfDir );

float fresnelFloat ( vec3 eye, vec3 normal, float f0 );

vec3 ambientSpecular ( float power, float dotNL, vec3 normal, vec3 eye );

void main (void)  {
	//Fragment attributes
	vec3 normal = normalize ( vNormal );
	vec3 eye = normalize ( vEyePos - vFragPosition );
	//Material attributes
	vec3 dColor = vec3 ( 0.7, 0.7, 0.7 );
	vec3 sColor = vec3 ( 0.7, 0.7, 0.7 );
	float smoothness = 0.0;
	float metallic = 1.0;

	vec3 fragColor = vec3 ( 0, 0, 0 );
	
	//vec3 lightColor = vec3 ( 0.5, 0.4, 0.1 );
	//float lightPower = 80.0;
	//vec3 directLighting = lightColor * ( 1.0 / distanceSqr ) ;
	
	vec3 specColor = mix ( sColor, dColor, metallic );
	//Directional Light Contribbution
	vec3 dirLightAttr = calcLightFactors ( normalize ( -uDirLight.direction ), normal, eye, smoothness, metallic );
	vec3 directionalContribution = getDirectLightContribution ( dirLightAttr.x, dirLightAttr.y, dirLightAttr.z, dColor, specColor );
	fragColor += directionalContribution;
	//Point Lights Contribbution
	for ( int i = 0; i < 8; i++ ) {
		if ( i == uPointLightCount ) {
			break;
		}
		vec3 plDirection = uPointLights[i].position - vFragPosition;
		vec3 pointLightAttr = calcLightFactors ( normalize ( plDirection ), normal, eye, smoothness, metallic );
		vec3 pointContribution = getDirectLightContribution ( pointLightAttr.x, pointLightAttr.y, pointLightAttr.z, dColor, specColor );
		fragColor += pointContribution;
	}
	//Spot lights conttribution
	for ( int j = 0; j < 8; j++ ) {
		if ( j == uSpotLightCount ) {
			break;
		}
		vec3 spotDirection = normalize ( uSpotLights[j].position - vFragPosition );
		float theta = dot ( spotDirection, -uSpotLights[j].direction );		
		if ( theta > uSpotLights[j].cutoff ) { 
			float outerCutoff = 0.95;
			float epsilon = 1.0 - uSpotLights[j].cutoff;
			float intensity = clamp ( (theta - outerCutoff) / epsilon, 0.0, 1.0 );   
			vec3 spotLightAttr = calcLightFactors ( spotDirection, normal, eye, smoothness, metallic );
			vec3 spotContribution = getDirectLightContribution ( spotLightAttr.x, spotLightAttr.y, spotLightAttr.z, dColor, specColor );
			fragColor += spotContribution * intensity;
		}
	}
	
	gl_FragColor = vec4 ( fragColor, 1.0 );
}

vec3 calcLightFactors ( vec3 lightDir, vec3 normal, vec3 eye, float smoothness, float metallic ) {
	lightDir = lightDir;
	vec3 halfDir = normalize ( lightDir + eye );
	float dotNL = dot ( normal, lightDir );
	
	float diffuseFactor = max ( dotNL, 0.0 );
	float specularFactor = max ( specularBlinn ( normal, halfDir, smoothness ) * dotNL, 0.0 );
	float fresnelFactor = max ( fresnelFloat ( eye, normal, 0.0 ) * smoothness, 0.0 );
	
	return vec3 ( diffuseFactor, specularFactor, fresnelFactor );
}

vec3 getDirectLightContribution ( float diffuseFactor, float specularFactor, float fresnelFactor, vec3 diffuseColor, vec3 specColor ) {
	vec3 diffuse = diffuseFactor * diffuseColor;
	vec3 fresnel = mix ( vec3 ( 0, 0, 0), vec3 ( 0.7, 0.7, 0.7 ), fresnelFactor );
	vec3 specular = ( specularFactor * specColor ) + fresnel;
	
	return diffuse + specular;
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