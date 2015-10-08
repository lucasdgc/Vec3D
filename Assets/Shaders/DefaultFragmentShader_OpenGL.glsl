varying vec4 vColor;
varying vec4 vPosition;
			
void main (void)  
{     
   float distance = length((vPosition.x - gl_FragCoord.x) + (vPosition.y - gl_FragCoord.y));
   float attenuation = (1.5 / distance);
   vec4 color = vec4(attenuation, attenuation, attenuation, attenuation) * vec4(vColor);

   gl_FragColor = color; 
}