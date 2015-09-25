package;
import rendering.Scene;
import objects.Camera;
import openfl.display.OpenGLView;
import com.babylonhx.math.Matrix;
import com.babylonhx.math.Vector3;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.gl.GLBuffer;
import openfl.gl.GL;
import openfl.gl.GLProgram;
import openfl.gl.GLUniformLocation;
import openfl.utils.Float32Array;
import openfl.Assets;
import rendering.Mesh;
import utils.Color;
import input.Input;
import objects.GameObject;
import utils.SimpleMath;
import openfl.events.Event;

/**
 * ...
 * @author Lucas Gonçalves
 */
enum DrawFormat{
	POINT;
	LINE;
	LINE_LOOP;
	TRIANGLES;
}
 
typedef MeshBuffer= {
	var buffer:GLBuffer;
	var size:Int;
}

class Engine
{
	public static var canvas:Sprite;
	public static var instance:Engine;
	
	public var currentScene:Scene;
	
	private var glView:OpenGLView;

	private var vertexAttribute:Int;	
	private var vertexColorAttribute:Int;
	
	/*private var staticVertexAttribute:Int;
	private var staticIndexAttribute:Int;
	private var staticVertexColorAttribute:Int;
	private var staticBufferSize:Int;
	private var staticIndexSize:Int;*/
	
	private var modelViewMatrixAttribute:Int;
	private var projectionMatrixAttribute:Int;
	
	private var modelViewMatrixUniform:GLUniformLocation;
	private var projectionMatrixUniform:GLUniformLocation;
	private var materialColorUniform:GLUniformLocation;
	private var materialColorAttrib:Int;
	
	private var shaderProgram:GLProgram;
	
	public var drawCallCount:Int = 0;
	private var drawCalls:Int = 0;
	
	private var frameCount:Int = 0;
	
	public var backgroundColor:Color;
	
	private var vertexAttributesEnabled:Bool = false;
	
	var staticGambi:Float32Array;
	
	public function new(_canvas:Sprite) 
	{
		if(instance == null){
			instance = this;
		}
		
		canvas = _canvas;
		glView = new OpenGLView();
		createProgram();
		
		glView.render = renderLoop;
		backgroundColor = Color.black;
		var input:Input = new Input();
		
		canvas.addChild(input);
		canvas.addChild(glView);
		
		GL.viewport (Std.int (canvas.stage.x), Std.int (canvas.stage.y), Std.int (canvas.stage.stageWidth), Std.int (canvas.stage.stageHeight));
		canvas.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function onEnterFrame (event:Event) {
		currentScene.update(event);
	}
	
	private function createProgram ():Void {
		#if html5
		var vertexShaderSource:String = Assets.getText("assets/Shaders/VertexShader_WebGL.txt");
		#end
		
		#if !html5
		var vertexShaderSource:String = Assets.getText("assets/Shaders/VertexShader_OpenGL.txt");
		#end
		
		var vertexShader = GL.createShader (GL.VERTEX_SHADER);
		GL.shaderSource (vertexShader, vertexShaderSource);
		GL.compileShader (vertexShader);
		
		if (GL.getShaderParameter (vertexShader, GL.COMPILE_STATUS) == 0) {
			trace(GL.getShaderInfoLog(vertexShader));
			throw "Error compiling vertex shader";
		}
		
		#if html5
		var fragmentShaderSource:String = Assets.getText("assets/Shaders/FragmentShader_WebGL.txt");
		#end
		
		#if !html5
		var fragmentShaderSource:String = Assets.getText("assets/Shaders/FragmentShader_OpenGL.txt");
		#end
		
		
		var fragmentShader = GL.createShader (GL.FRAGMENT_SHADER);
		GL.shaderSource (fragmentShader, fragmentShaderSource);
		GL.compileShader (fragmentShader);
		
		if (GL.getShaderParameter (fragmentShader, GL.COMPILE_STATUS) == 0) {
			trace (GL.getShaderInfoLog(fragmentShader));
			
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
		
		vertexAttribute = GL.getAttribLocation (shaderProgram, "aVertexPosition");
		vertexColorAttribute = GL.getAttribLocation (shaderProgram, "aVertexColor");
	}
	
	public function clear () {
		
		GL.clearColor (backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
		GL.clear (GL.COLOR_BUFFER_BIT);
	}

	private function render(camera:Camera) {
		
		var viewMatrix = Matrix.LookAtLH(camera.transform.position, camera.facingPoint, Vector3.Up());
		var projectionMatrix = Matrix.PerspectiveFovLH(.78, canvas.stage.stageWidth / canvas.stage.stageHeight, .01, 1000);
			
		for(gameObject in currentScene.gameObject) { 
			if ( !gameObject.isStatic && gameObject.isVisible && gameObject.mesh != null) {
				var mesh = gameObject.mesh;
				
				//var worldMatrix = Matrix.RotationYawPitchRoll(gameObject.rotation.y, gameObject.rotation.x, gameObject.rotation.z) 
				//.multiply(Matrix.Translation(gameObject.position.x, gameObject.position.y, gameObject.position.z));
				
				var worldMatrix:Matrix = gameObject.transform.transformMatrix;
				
				var worldViewMatrix:Matrix = worldMatrix.multiply(viewMatrix);
		
				GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (projectionMatrix.m));
				GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (worldViewMatrix.m));
				
				if (gameObject.mesh.meshBuffer == null) {
					throw "Object " + mesh.name +" has undefined vertex buffers...";
				}
				
				drawGeometry(mesh.meshBuffer.vertexBuffer, mesh.vertices.length, mesh.drawPoints,
						mesh.meshBuffer.edgeIndexBuffer, mesh.edges.length, mesh.drawEdges,
						mesh.meshBuffer.faceIndexBuffer, mesh.faces.length, mesh.drawFaces);
			}
		}
		
		GL.disableVertexAttribArray(vertexAttribute);
		GL.disableVertexAttribArray(vertexColorAttribute);
		
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		
	}
	
	private function drawGeometry (vertexBuffer:GLBuffer, vertexBufferSize:Int, drawVertex:Bool, 
									edgeIndexBuffer:GLBuffer, edgeBufferSize:Int, drawEdges:Bool,
									facesIndexBuffer:GLBuffer, faceBufferSize:Int, drawFaces:Bool) {
		
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
			
		GL.enableVertexAttribArray(vertexAttribute);
		GL.vertexAttribPointer(vertexAttribute, 3, GL.FLOAT, false, 7 * 4, 0);

		GL.enableVertexAttribArray(vertexColorAttribute);
		GL.vertexAttribPointer(vertexColorAttribute, 4, GL.FLOAT, false, 7 * 4, 3 * 4);

		if (drawVertex && vertexBufferSize > 0) {
			drawCalls ++;
			GL.drawArrays(GL.POINTS, 0, vertexBufferSize);
		}
		
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, edgeIndexBuffer);
		if (drawEdges && edgeBufferSize > 0) {
			drawCalls ++;
			GL.drawElements(GL.LINES, edgeBufferSize * 2, GL.UNSIGNED_SHORT, 2 * 0);	
		}
		
	}
	
	private function renderLoop(rect:Rectangle) {
		frameCount ++;
		
		if (frameCount % 30 == 0) {
			drawCallCount = Std.int(drawCalls / frameCount);
			drawCalls = 0;
			frameCount = 0;
		}
		
		GL.useProgram(shaderProgram);
	
		clear();
		if(currentScene != null){
			render(currentScene.activeCamera);
		}
	}	
}