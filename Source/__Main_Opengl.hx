package;

import lime.graphics.opengl.GLUniformLocation;
import openfl.display.FPS;
import openfl.display.OpenGLView;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.utils.Float32Array;
import openfl.geom.Matrix3D;
import com.babylonhx.math.Matrix;
import com.babylonhx.math.Vector3;

class Main extends Sprite {
	
	private var view:OpenGLView;
	
	private var vertexBuffer:GLBuffer;
	private var vertexAttribute:Int;
	private var shaderProgram:GLProgram;
	
	private var modelViewMatrixUniform:GLUniformLocation;
	private var projectionMatrixUniform:GLUniformLocation;
	//private var triangleVertices:
	
	public function new () {
		super ();
		
		view = new OpenGLView();
		
		createBuffers();
		createShaders();
		
		view.render = renderLoop;
		
		addChild(view);
		
		var fps:FPS = new FPS(10, 10, 0xFF0000);
		addChild(fps);
	}
	
	private function createBuffers(){
		
		var vertices = [ 
			0.0, 0.0, 0,
			0.5, 0.0, 0, 
			0.5, 0.5, 0,
 
			0.0, 0.0, 0,
			0.0, 0.5, 0,
			-0.5, 0.5, 0,
  
			0.0, 0.0, 0,
			-0.5, 0.0, 0,
			-0.5, -0.5, 0,
 
			0.0, 0.0, 0,
			0.0, -0.5, 0,
			0.5, -0.5, 0,
		];
		
		vertexBuffer = GL.createBuffer();
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		GL.bufferData(GL.ARRAY_BUFFER, new Float32Array (vertices), GL.STATIC_DRAW);
		
	}
	
	private function createShaders(){
		var vertexShaderSource = 
			"attribute vec3 aVertexPosition;
			
			uniform mat4 uModelViewMatrix;
			uniform mat4 uProjectionMatrix;
			
			void main(void) {
				gl_Position = uProjectionMatrix * uModelViewMatrix * vec4 (aVertexPosition, 1.0);
			}";
		
		var vertexShader = GL.createShader (GL.VERTEX_SHADER);
		GL.shaderSource (vertexShader, vertexShaderSource);
		GL.compileShader (vertexShader);
		
		if (GL.getShaderParameter (vertexShader, GL.COMPILE_STATUS) == 0) {
			throw "Error compiling vertex shader";
		}
		
		var fragmentShaderSource = 
			"void main (void)  
				{     
				   gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);  
				} ";
		
		var fragmentShader = GL.createShader (GL.FRAGMENT_SHADER);
		GL.shaderSource (fragmentShader, fragmentShaderSource);
		GL.compileShader (fragmentShader);
		
		if (GL.getShaderParameter (fragmentShader, GL.COMPILE_STATUS) == 0) {
			
			throw "Error compiling fragment shader";
			
		}
		
		shaderProgram = GL.createProgram();
		
		GL.attachShader(shaderProgram, vertexShader);
		GL.attachShader(shaderProgram, fragmentShader);
		GL.linkProgram(shaderProgram);
		
		if (GL.getProgramParameter (shaderProgram, GL.LINK_STATUS) == 0) {
			throw "Unable to initialize the shader program.";
		}
		
		projectionMatrixUniform = GL.getUniformLocation (shaderProgram, "uProjectionMatrix");
		modelViewMatrixUniform = GL.getUniformLocation (shaderProgram, "uModelViewMatrix");
	}
	
	private function renderLoop(rect:Rectangle) {
		
		GL.viewport(Std.int(rect.x), Std.int(rect.y), Std.int(rect.width), Std.int(rect.height));
		
		GL.clearColor(0, 0, 0.4, 1);
		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
		
		var positionX = 0;
		var positionY = 0;
		
		var projectionMatrix = Matrix.PerspectiveFovLH(0.78, 
                                           stage.stageWidth / stage.stageHeight, 0.01, 100);
		
		var viewMatrix = Matrix.LookAtLH(new Vector3(0, 0, 0), Vector3.Zero(), Vector3.Up());
										  
		var modelMatrix = Matrix.Translation(0, 0, 0);
		
		var modelViewMatrix = viewMatrix.multiply(modelMatrix);
		
		//var modelViewMatrix = modelMatrix.multiply(viewMatrix);
										   
		/*var viewMatrix = Matrix.LookAtLH(new Vector3(4,3,3), new Vector3(), Vector3.Up());
										   
		var modelMatrix = Matrix.Identity();
										   
		var modelViewMatrix = viewMatrix.multiply(modelMatrix);*/
		
		//var projectionMatrix = Matrix.OrthoLH (rect.width, rect.height, .01, 1000);
		//var modelViewMatrix = Matrix3D.create2D (positionX, positionY, 1, 0);
		//var viewMatrix = Matrix.lookA;
		//viewMatrix.(new Vector3D(4, 3, 3), new Vector3D(), Vector3D.Y_AXIS);
		
		//var modelMatrix = new Matrix ().identity;
		
		//var modelViewMatrix = viewMatrix;
		
		//GL.
		
		//var projMatrix = 
		
		GL.useProgram(shaderProgram);
		GL.enableVertexAttribArray(vertexAttribute);
		
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		GL.vertexAttribPointer(vertexAttribute, 3, GL.FLOAT, false, 0, 0);
		
		GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (projectionMatrix.m));
		GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (modelViewMatrix.m));
		
		//GL.point
		
		GL.drawArrays(GL.TRIANGLE_FAN, 0, 12);
		
		GL.bindBuffer (GL.ARRAY_BUFFER, null);
		GL.disableVertexAttribArray(vertexAttribute);
		
		//trace("loop");
		
	}
}