package;
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
 
class DeviceGL
{
	private var canvas:Sprite;
	
	public var activeCamera:Camera;
	
	private var glView:OpenGLView;
	private var vertexBuffer:GLBuffer;
	private var vertexAttribute:Int;
	
	private var modelViewMatrixUniform:GLUniformLocation;
	private var projectionMatrixUniform:GLUniformLocation;
	private var materialColorUniform:GLUniformLocation;
	
	private var shaderProgram:GLProgram;
	
	private var drawCallCount:Int;
	
	public function new(_canvas:Sprite) 
	{
		canvas = _canvas;
		
		glView = new OpenGLView();
		
		createBuffers();
		createProgram();
		
		glView.render = renderLoop;
		
		canvas.addChild(glView);
	}
	
	private function createBuffers () {
		vertexBuffer = GL.createBuffer();
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
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
		materialColorUniform = GL.getUniformLocation (shaderProgram, "uMaterialColorv4");
	}
	
	public function clear (color:UInt) {
		
		GL.clearColor (color >>> 16 & 0xFF, color >>>  8 & 0xFF ,  color & 0xFF,  color >>> 24);
		GL.clear (GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
	}
	
	public function render(camera:Camera, meshes:Array<Mesh> ) {
		
		GL.useProgram(shaderProgram);
		
		var colorArray:Array<Float> = [0, 1, 0, 1];
		GL.uniform4fv(materialColorUniform, new Float32Array(colorArray));
		
		var viewMatrix = Matrix.LookAtLH(camera.position, camera.target, Vector3.Up());
		var projectionMatrix = Matrix.PerspectiveFovLH(.78, canvas.stage.stageWidth / canvas.stage.stageHeight, .01, 1000);
		
		for (mesh in meshes) {
			if(mesh != null && mesh.gameObject != null && mesh.gameObject.isVisible) {
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
	}
	
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
	
	private function renderLoop(rect:Rectangle) {
	
		//trace(rect.width);
		GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
	
		clear(0xFF000000);
		
		render(activeCamera, Mesh.meshes);
	}	
}