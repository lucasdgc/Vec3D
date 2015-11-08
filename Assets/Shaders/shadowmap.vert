#ifdef MOBILE
precision mediump float;
#endif

attribute vec3 aVertexPosition;

uniform mat4 uLightSpaceMatrix;
uniform mat4 uModelMatrix;

varying vec4 vFragPosition;

void main()
{
  gl_Position = uLightSpaceMatrix * uModelMatrix * vec4( aVertexPosition, 1.0 );
  vFragPosition = gl_Position;
} 