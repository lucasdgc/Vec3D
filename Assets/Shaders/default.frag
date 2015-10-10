#ifdef MOBILE
precision mediump float;
#endif

varying vec4 vColor;
varying vec4 vPosition;
			
void main (void)  {     
   gl_FragColor = vColor; 
}