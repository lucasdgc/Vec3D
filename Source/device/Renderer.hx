package device;

import objects.Camera;
import objects.GameObject;
import openfl.utils.Float32Array;
import utils.Color;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import com.babylonhx.math.Matrix;
import haxe.Timer;
import utils.Time;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Renderer
{
	public var drawBoundingVolumes:Bool = false;
	
	public var drawCallCount:Int = 0;
	private var frameDrawCalls:Int = 0;
	
	public function new () {
		
	}
	
	public function clear (color:Color) {
		GL.clearColor (color.r, color.g, color.b, color.a);
		GL.clear (GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
	}
	
	public function render(camera:Camera, gameObjects:Array<GameObject>) {
		var viewMatrix = camera.viewMatrix.clone ();
		var projectionMatrix = camera.projectionMatrix.clone ();
		
		GL.useProgram(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).program);
		
		for (gameObject in gameObjects) { 
			if ( !gameObject.isStatic && gameObject.isVisible && gameObject.mesh != null) {
				var mesh = gameObject.mesh;
			
				var worldMatrix:Matrix = gameObject.transform.transformMatrix;
				
				var worldViewMatrix:Matrix = worldMatrix.multiply(viewMatrix);
				
				GL.uniformMatrix4fv (mesh.shaderProgram.uniforms[0].index, false, new Float32Array (projectionMatrix.m));
				GL.uniformMatrix4fv (mesh.shaderProgram.uniforms[1].index, false, new Float32Array (worldViewMatrix.m));
				
				if (gameObject.mesh.meshBuffer == null) {
					throw "Object " + mesh.name +" has undefined vertex buffers...";
				}
				
				drawGeometry(mesh.meshBuffer.vertexBuffer, mesh.vertices.length, mesh.drawPoints,
						mesh.meshBuffer.edgeIndexBuffer, mesh.edges.length, mesh.drawEdges,
						mesh.meshBuffer.faceIndexBuffer, mesh.faces.length, mesh.drawFaces);
			}
		}
		
		if (drawBoundingVolumes) {
			//drawGeometry ();
		}
		
		GL.disableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[0].index);
		GL.disableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[1].index);
		
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		
		drawCallCount = frameDrawCalls;
	}
	
	private function drawGeometry (vertexBuffer:GLBuffer, vertexBufferSize:Int, drawVertex:Bool, 
									edgeIndexBuffer:GLBuffer, edgeBufferSize:Int, drawEdges:Bool,
									facesIndexBuffer:GLBuffer, faceBufferSize:Int, drawFaces:Bool) {
		
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		
		GL.enableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[0].index);
		GL.vertexAttribPointer(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[0].index, 3, GL.FLOAT, false, 7 * 4, 0);

		GL.enableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[1].index);
		GL.vertexAttribPointer(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[1].index, 4, GL.FLOAT, false, 7 * 4, 3 * 4);

		if (drawVertex && vertexBufferSize > 0) {
			frameDrawCalls ++;
			GL.drawArrays(GL.POINTS, 0, vertexBufferSize);
		}
		
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, edgeIndexBuffer);
		if (drawEdges && edgeBufferSize > 0) {
			frameDrawCalls ++;
			GL.drawElements(GL.LINES, edgeBufferSize * 2, GL.UNSIGNED_SHORT, 2 * 0);	
		}
		
	}
	
	public function drawFrameBuffer (frameBuffer:FrameBuffer) {
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);
		//GL.clear(GL.COLOR_BUFFER_BIT);
		GL.bindBuffer(GL.ARRAY_BUFFER, frameBuffer.vertexBuffer);
		
		//GL.disable(GL.DEPTH_TEST);
		//GL.disable(GL.STENCIL_TEST);
		
		GL.useProgram(frameBuffer.shaderProgram.program);
		
		GL.activeTexture(GL.TEXTURE0);
		GL.bindTexture(GL.TEXTURE_2D, frameBuffer.texture);

		GL.enableVertexAttribArray(frameBuffer.shaderProgram.attributes[0].index);
		GL.vertexAttribPointer(frameBuffer.shaderProgram.attributes[0].index, 2, GL.FLOAT, false, 2 * 4, 0);
		
		GL.uniform4fv(frameBuffer.shaderProgram.uniforms[1].index, Engine.instance.currentScene.backgroundColor.toFloat32Array());
		
		//GL.uniform1f(frameBuffer.shaderProgram.uniforms[1].index, Time.deltaTime * 2 * 3.14159 * .75 * 10);
		
		GL.drawArrays(GL.TRIANGLE_STRIP, 0, 4);
	}
	
	private function setDefaultShaderParams () {
		/*GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (projectionMatrix.m));
		GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (worldViewMatrix.m));
		
		GL.enableVertexAttribArray(vertexAttribute);
		GL.vertexAttribPointer(vertexAttribute, 3, GL.FLOAT, false, 7 * 4, 0);

		GL.enableVertexAttribArray(vertexColorAttribute);
		GL.vertexAttribPointer(vertexColorAttribute, 4, GL.FLOAT, false, 7 * 4, 3 * 4);*/
	}
	
	public function applyPostProcessing () {
		
	}
	
}