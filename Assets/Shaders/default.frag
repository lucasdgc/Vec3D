#ifdef MOBILE
precision mediump float;
#endif

varying vec4 vColor;
varying vec3 vFragPosition;
varying vec3 vNormal;
varying vec3 vLightPos;

void main (void)  {
 
	vec3 lightDir = normalize ( vLightPos - vFragPosition );
	float diff = max ( dot ( vNormal, lightDir ), 0.0 );
	vec3 diffuse = diff * vec3 ( 0.8, 0.8, 0.8 );
	
	vec3 result = diffuse * vec3(vColor);
	gl_FragColor = vec4(result, 1.0);
}