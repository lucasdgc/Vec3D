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
	private var vertexBuffer:GLBuffer;
	private var vertexAttribute:Int;
	
	private var vertexArrayObj:Int;
	
	private var staticVertexBuffer:GLBuffer;
	private var staticIndexBuffer:GLBuffer;
	private var staticVertexAttribute:Int;
	private var staticIndexAttribute:Int;
	private var staticVertexColorAttribute:Int;
	private var staticBufferSize:Int;
	private var staticIndexSize:Int;
	
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
	
	var staticGambi:Float32Array;
	
	public function new(_canvas:Sprite) 
	{
		if(instance == null){
			instance = this;
		}
		
		canvas = _canvas;
		
		glView = new OpenGLView();
		
		createBuffers();
		createProgram();
		
		glView.render = renderLoop;
		
		backgroundColor = Color.black;
		
		var input:Input = new Input();
		
		canvas.addChild(input);
		
		canvas.addChild(glView);
		
		GL.viewport (Std.int (canvas.stage.x), Std.int (canvas.stage.y), Std.int (canvas.stage.stageWidth), Std.int (canvas.stage.stageHeight));
	}
	
	public function bindStaticBufferData() {
		
		var staticBufferBatch:Float32Array = currentScene.getVertexColorBatch();
		
		GL.bindBuffer(GL.ARRAY_BUFFER, staticVertexBuffer);
		GL.bufferData(GL.ARRAY_BUFFER, staticBufferBatch, GL.STATIC_DRAW);
		
		GL.enableVertexAttribArray(staticVertexAttribute);
		GL.vertexAttribPointer(staticVertexAttribute, 3, GL.FLOAT, false, 7 * 4, 0);
		
		GL.enableVertexAttribArray(materialColorAttrib);
		GL.vertexAttribPointer(materialColorAttrib, 4, GL.FLOAT, false, 7 * 4, 4 * 4);
		
		staticBufferSize = Std.int(staticBufferBatch.length / 7);
		
		var staticBufferIndex = currentScene.getEdgesBatch();
		
		//GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, staticIndexBuffer);
		//GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, staticBufferIndex, GL.STATIC_DRAW);
		
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, staticIndexBuffer);
		GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, staticBufferIndex, GL.STATIC_DRAW);
		
		staticIndexSize = Std.int(staticBufferIndex.length / 2);
		
		trace("Static Vertex Size: " + staticBufferSize);
		trace("Static Edges Size: " + staticIndexSize);
		
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		//GL.disableVertexAttribArray(0);
	
		/*for(i in 0...staticIndexSize){
			trace(staticBufferIndex[i]);
		}*/
		
	}
	
	private function createBuffers () {
		vertexBuffer = GL.createBuffer();
		//GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		
		staticVertexBuffer = GL.createBuffer();
		staticIndexBuffer = GL.createBuffer();
		
		//GL.bindBuffer(GL.ARRAY_BUFFER, staticVertexBuffer);
		
		//GL.GenVertexArra(
		
		//GL.enable(GL.STENCIL_TEST
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
		
		staticVertexAttribute = GL.getAttribLocation (shaderProgram, "aVertexPosition");
		staticVertexColorAttribute = GL.getAttribLocation (shaderProgram, "aVertexColor");
	}
	
	public function clear () {
		
		GL.clearColor (backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
		GL.clear (GL.COLOR_BUFFER_BIT);
	}
	
	/*public function render(camera:Camera, gameObjects:Array<GameObject> ) {
		
		//
		
		var colorArray:Array<Float> = [0, 1, 0, 1];
		GL.uniform4fv(materialColorUniform, new Float32Array(colorArray));
		
		var viewMatrix = Matrix.LookAtLH(camera.position, camera.target, Vector3.Up());
		var projectionMatrix = Matrix.PerspectiveFovLH(.78, canvas.stage.stageWidth / canvas.stage.stageHeight, .01, 1000);
		
		for (gameObject in gameObjects) {
			var mesh:Mesh = gameObject.mesh;
			
			if(mesh != null && mesh.gameObject.isVisible) {
				var worldMatrix = Matrix.RotationYawPitchRoll(mesh.gameObject.rotation.y, mesh.gameObject.rotation.x, mesh.gameObject.rotation.z) 
				.multiply(Matrix.Translation(mesh.gameObject.position.x, mesh.gameObject.position.y, mesh.gameObject.position.z));
				var worldViewMatrix = worldMatrix.multiply(viewMatrix);

				if (mesh.drawFaces && mesh.faces.length > 0) {
					var facesData = mesh.rawFacesData;
					
					draw(facesData, DrawFormat.LINE, projectionMatrix, worldViewMatrix);
				}
				
				if (mesh.drawEdges && mesh.edges.length > 0 ) {
					
					if(mesh.edgeGroupBatch.length > 0) {
						for(edgesGroup in mesh.edgeGroupBatch){
							var colorArray:Array<Float> = [edgesGroup.color.r, edgesGroup.color.g, edgesGroup.color.b, edgesGroup.color.a];
							GL.uniform4fv(materialColorUniform, new Float32Array(colorArray));
							
							var edgesData = edgesGroup.verticesArray;
							draw(edgesData, DrawFormat.LINE, projectionMatrix, worldViewMatrix);
						}
					} else {
						var colorArray:Array<Float> = [mesh.edgeColor.r, mesh.edgeColor.g, mesh.edgeColor.b, mesh.edgeColor.a];
						GL.uniform4fv(materialColorUniform, new Float32Array(colorArray));
						
						var edgesData = mesh.rawEdgesData;
						draw(edgesData, DrawFormat.LINE, projectionMatrix, worldViewMatrix);
					}
				}
				
				if(mesh.drawPoints && mesh.vertices.length > 0){
					
					if(mesh.vertexGroupBatch.length > 0){
						for (pointsGroup in mesh.vertexGroupBatch) {
							var colorArray:Array<Float> = [pointsGroup.color.r, pointsGroup.color.g, pointsGroup.color.b, pointsGroup.color.a];
							GL.uniform4fv(materialColorUniform, new Float32Array(colorArray));
							
							var points = pointsGroup.verticesArray;
							draw(new Float32Array (points), DrawFormat.POINT, projectionMatrix, worldViewMatrix);
						}
					} else {
						var colorArray:Array<Float> = [mesh.pointColor.r, mesh.pointColor.g, mesh.pointColor.b, mesh.pointColor.a];
						GL.uniform4fv(materialColorUniform, new Float32Array(colorArray));
						
						var points = mesh.rawVertexData;
						draw(new Float32Array (points), DrawFormat.POINT, projectionMatrix, worldViewMatrix);
					}
					//var points = mesh.rawVertexData;
					
					//var points = Mesh.getRawVerticesData(mesh.vertices);
					
					
				}
				
				
			} 
		}
	}*/
	
	private function draw(vertices:Float32Array, drawFormat:DrawFormat, projectionMatrix:Matrix, worldViewMatrix:Matrix) {
		
		//GL.useProgram(shaderProgram);
		GL.enableVertexAttribArray(vertexAttribute);

		GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		GL.bufferData(GL.ARRAY_BUFFER, vertices, GL.STATIC_DRAW);
		
		GL.vertexAttribPointer(vertexAttribute, 3, GL.FLOAT, false, 0, 0);

		GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (projectionMatrix.m));
		GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (worldViewMatrix.m));

		//GL.enable(GL.CULL_FACE);
		
		if (drawFormat == DrawFormat.POINT) {
			GL.drawArrays(GL.POINTS, 0, Std.int(vertices.length / 3));
		} else if (drawFormat == DrawFormat.LINE) {
			GL.drawArrays(GL.LINES, 0, Std.int(vertices.length / 3));
		} else if (drawFormat == LINE_LOOP) {
			GL.drawArrays(GL.LINE_LOOP, 0, Std.int(vertices.length/ 3));
		} else if (drawFormat == TRIANGLES) {
			GL.drawArrays(GL.TRIANGLES, 0, Std.int(vertices.length/3));
		}
		
		GL.bindBuffer (GL.ARRAY_BUFFER, null);
		GL.disableVertexAttribArray(vertexAttribute);
	}
	
	private function newRender(camera:Camera) {
		
		var viewMatrix = Matrix.LookAtLH(camera.position, camera.target, Vector3.Up());
		var projectionMatrix = Matrix.PerspectiveFovLH(.78, canvas.stage.stageWidth / canvas.stage.stageHeight, .01, 1000);
		
		if(currentScene.staticVertexSize > 0){
			
			var worldViewMatrix:Matrix = Matrix.Identity().multiply(viewMatrix);
		
			GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (projectionMatrix.m));
			GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (worldViewMatrix.m));

			drawGeometry(currentScene.staticMeshBuffer.vertexBuffer, currentScene.staticVertexSize, currentScene.drawStaticPoints,
						currentScene.staticMeshBuffer.edgeIndexBuffer, currentScene.staticEdgeSize, currentScene.drawStaticEdges,
						currentScene.staticMeshBuffer.faceIndexBuffer, currentScene.staticFaceSize, currentScene.drawStaticFaces);
		}
		
		for(gameObject in currentScene.gameObject) { 
			if ( !gameObject.isStatic && gameObject.isVisible ) {
				var mesh = gameObject.mesh;
				
				var worldMatrix = Matrix.RotationYawPitchRoll(gameObject.rotation.y, gameObject.rotation.x, gameObject.rotation.z) 
				.multiply(Matrix.Translation(gameObject.position.x, gameObject.position.y, gameObject.position.z));
				
				var worldViewMatrix:Matrix = worldMatrix.multiply(viewMatrix);
		
				GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (projectionMatrix.m));
				GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (worldViewMatrix.m));
				
				drawGeometry(mesh.meshBuffer.vertexBuffer, mesh.vertices.length, mesh.drawPoints,
						mesh.meshBuffer.edgeIndexBuffer, mesh.edges.length, mesh.drawEdges,
						mesh.meshBuffer.faceIndexBuffer, mesh.faces.length, mesh.drawFaces);
				
			}
		}
		
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		/*GL.bindBuffer(GL.ARRAY_BUFFER, staticVertexBuffer);
		
		GL.enableVertexAttribArray(staticVertexAttribute);
		GL.vertexAttribPointer(staticVertexAttribute, 3, GL.FLOAT, false, 7 * 4, 0);
		
		GL.enableVertexAttribArray(staticVertexColorAttribute);
		GL.vertexAttribPointer(staticVertexColorAttribute, 4, GL.FLOAT, false, 7 * 4, 3 * 4);
		
		GL.drawArrays(GL.POINTS, 0, staticBufferSize);
		
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, staticIndexBuffer);

		GL.drawElements(GL.LINES, staticIndexSize * 2, GL.UNSIGNED_SHORT, 2 * 0);*/
		
	}
	
	private function drawGeometry (vertexBuffer:GLBuffer, vertexBufferSize:Int, drawVertex:Bool, 
									edgeIndexBuffer:GLBuffer, edgeBufferSize:Int, drawEdges:Bool,
									facesIndexBuffer:GLBuffer, faceBufferSize:Int, drawFaces:Bool) {
									GL.bindBuffer(GL.ARRAY_BUFFER, staticVertexBuffer);
		
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
									
		GL.enableVertexAttribArray(staticVertexAttribute);
		GL.vertexAttribPointer(staticVertexAttribute, 3, GL.FLOAT, false, 7 * 4, 0);
		
		GL.enableVertexAttribArray(staticVertexColorAttribute);
		GL.vertexAttribPointer(staticVertexColorAttribute, 4, GL.FLOAT, false, 7 * 4, 3 * 4);
		
		if (drawVertex) {
			drawCalls ++;
			GL.drawArrays(GL.POINTS, 0, vertexBufferSize);
		}
		
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, edgeIndexBuffer);
		if (drawEdges) {
			drawCalls ++;
			GL.drawElements(GL.LINES, edgeBufferSize * 2, GL.UNSIGNED_SHORT, 2 * 0);	
		}
		
	}
	
	private function renderLoop(rect:Rectangle) {
		//drawCallCount = 0;
		frameCount ++;
		
		if (frameCount % 30 == 0) {
			drawCallCount = Std.int(drawCalls / frameCount);
			drawCalls = 0;
			frameCount = 0;
		}
		
		GL.useProgram(shaderProgram);
	
		clear();
		if(currentScene != null){
			//render(currentScene.activeCamera, currentScene.gameObject);
			newRender(currentScene.activeCamera);
			//newRender2(currentScene.activeCamera);
		}
	}	
}