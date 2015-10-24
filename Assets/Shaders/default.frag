#ifdef MOBILE
precision mediump float;
#endif

varying vec4 vColor;
varying vec3 vFragPosition;
varying vec3 vNormal;
varying vec3 vLightPos;

void main (void)  {
 
	vec3 normal = normalize ( vNormal );
	
	vec3 lightDir = normalize ( vLightPos - vFragPosition );
	float lightPower = 60.0;
	
	//float diff = max ( dot ( normal, lightDir ), 0.0 );
	float diff = dot ( normal, lightDir );
	float distanceSqr = abs ( ((vLightPos.x - vFragPosition.x) * (vLightPos.x - vFragPosition.x)) 
						 + ((vLightPos.y - vFragPosition.y) * (vLightPos.y - vFragPosition.y))
						 + ((vLightPos.z - vFragPosition.z) * (vLightPos.z - vFragPosition.z)) );
	//vec3 diffuse = diff * vec3 ( 0.8, 0.8, 0.8 );
	vec3 lightColor = vec3 ( 0.8, 0.8, 0.8 );
	
	//vec3 result = vec3(vColor) * lightColor * lightPower * diff / distanceSqr;
	vec3 result = vec3(vColor) * diff;
	gl_FragColor = vec4(result, 1.0);
}