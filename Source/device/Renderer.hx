package device;

import math.Quaternion;
import math.Vector3;
import objects.Camera;
import objects.GameObject;
import objects.PointLight;
import openfl.utils.Float32Array;
import rendering.Cubemap;
import utils.Color;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import math.Matrix;
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
		
		GL.enable ( GL.CULL_FACE );
		GL.enable ( GL.DEPTH_TEST );
		
		GL.useProgram(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).program);
		
		for (gameObject in gameObjects) { 
			if ( !gameObject.isStatic && gameObject.isVisible && gameObject.mesh != null) {
				var mesh = gameObject.mesh;
			
				var worldMatrix:Matrix = gameObject.transform.transformMatrix;
				
				//var worldViewMatrix:Matrix = worldMatrix.multiply(viewMatrix);
				
				GL.uniformMatrix4fv (mesh.shaderProgram.uniforms[0].index, false, new Float32Array (projectionMatrix.m));
				GL.uniformMatrix4fv (mesh.shaderProgram.uniforms[1].index, false, new Float32Array (worldMatrix.m));
				GL.uniformMatrix4fv (mesh.shaderProgram.uniforms[2].index, false, new Float32Array (viewMatrix.m));
				
				GL.uniform3f ( mesh.shaderProgram.uniforms[3].index, camera.transform.position.x, camera.transform.position.y, camera.transform.position.z );
				
				GL.uniform3f ( mesh.shaderProgram.uniforms[4].index, 0.3, -1, 0 );
				
				if ( gameObject.scene.pointLights.length > 0 ) {
					var pl:PointLight = gameObject.scene.pointLights[0];
					GL.uniform3f ( mesh.shaderProgram.uniforms[5].index, pl.position.x, pl.position.y, pl.position.z );
					GL.uniform3f ( mesh.shaderProgram.uniforms[6].index, -pl.position.x, -pl.position.y, -pl.position.z );
				}
				
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
		
		GL.disable ( GL.CULL_FACE );
		if (Engine.instance.currentScene.skybox != null) {
			drawCubemap ( Engine.instance.currentScene.skybox, projectionMatrix, viewMatrix );
		}
		
		
		GL.disableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[0].index);
		GL.disableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[1].index);
		GL.disableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[2].index);
		
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		
		drawCallCount = frameDrawCalls;
	}
	
	private function drawGeometry (vertexBuffer:GLBuffer, vertexBufferSize:Int, drawVertex:Bool, 
									edgeIndexBuffer:GLBuffer, edgeBufferSize:Int, drawEdges:Bool,
									facesIndexBuffer:GLBuffer, faceBufferSize:Int, drawFaces:Bool) {
		
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		
		GL.enableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[0].index);
		GL.vertexAttribPointer(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[0].index, 3, GL.FLOAT, false, 10 * 4, 0);

		GL.enableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[1].index);
		GL.vertexAttribPointer(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[1].index, 3, GL.FLOAT, false, 10 * 4, 3 * 4);

		GL.enableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[2].index);
		GL.vertexAttribPointer(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[2].index, 4, GL.FLOAT, false, 10 * 4, 6 * 4);
		
		if ( Engine.instance.currentScene.skybox != null ) {
			GL.bindTexture ( GL.TEXTURE_CUBE_MAP, Engine.instance.currentScene.skybox.cubemapTexture );
		}
		
		if (drawVertex && vertexBufferSize > 0) {
			frameDrawCalls ++;
			GL.drawArrays(GL.POINTS, 0, vertexBufferSize);
		}
		
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, edgeIndexBuffer);
		if (drawEdges && edgeBufferSize > 0) {
			frameDrawCalls ++;
			GL.drawElements(GL.LINES, edgeBufferSize * 2, GL.UNSIGNED_SHORT, 2 * 0);	
		}
		
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, facesIndexBuffer);
		if (drawFaces && faceBufferSize > 0) {
			frameDrawCalls ++;
			GL.drawElements(GL.TRIANGLES, faceBufferSize * 3, GL.UNSIGNED_SHORT, 3 * 0);	
		}
		
	}
	
	public function drawFrameBuffer (frameBuffer:FrameBuffer) {
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);

		GL.bindBuffer(GL.ARRAY_BUFFER, frameBuffer.vertexBuffer);
		
		GL.useProgram(frameBuffer.shaderProgram.program);
		
		GL.activeTexture(GL.TEXTURE0);
		GL.bindTexture(GL.TEXTURE_2D, frameBuffer.texture);

		GL.enableVertexAttribArray(frameBuffer.shaderProgram.attributes[0].index);
		GL.vertexAttribPointer(frameBuffer.shaderProgram.attributes[0].index, 2, GL.FLOAT, false, 2 * 4, 0);

		GL.uniform1i(frameBuffer.shaderProgram.uniforms[1].index, Engine.canvas.stage.stageWidth);
		GL.uniform1i(frameBuffer.shaderProgram.uniforms[2].index, Engine.canvas.stage.stageHeight);
		
		//GL.uniform1f(frameBuffer.shaderProgram.uniforms[1].index, Time.deltaTime * 2 * 3.14159 * .75 * 10);
		
		GL.drawArrays(GL.TRIANGLE_STRIP, 0, 4);
	}
	
	public function drawCubemap ( cubemap:Cubemap, projection:Matrix, view:Matrix ) {
		GL.bindBuffer ( GL.ARRAY_BUFFER, cubemap.vertexBuffer );
		GL.useProgram ( cubemap.shaderProgram.program );
		GL.bindTexture ( GL.TEXTURE_CUBE_MAP, cubemap.cubemapTexture );
		
		GL.enableVertexAttribArray ( cubemap.shaderProgram.attributes[0].index );
		GL.vertexAttribPointer( cubemap.shaderProgram.attributes[0].index, 3, GL.FLOAT, false, 3 * 4, 0);
		
		var uView:Float32Array = Matrix.GetAsRotationMatrix4x4 ( view );
		
		GL.uniformMatrix4fv ( cubemap.shaderProgram.uniforms[0].index, false, new Float32Array ( projection.m ) );
		GL.uniformMatrix4fv ( cubemap.shaderProgram.uniforms[1].index, false, uView );
		
		GL.drawArrays ( GL.TRIANGLES, 0, 36 );		
		
		GL.bindBuffer ( GL.ARRAY_BUFFER, null );
		GL.bindTexture ( GL.TEXTURE_CUBE_MAP, null );
	}
	
	private function setDefaultShaderParams () {
		/*GL.uniformMatrix4fv (projectionMatrixUniform, false, new Float32Array (projectionMatrix.m));
		GL.uniformMatrix4fv (modelViewMatrixUniform, false, new Float32Array (worldViewMatrix.m));
		
		GL.enableVertexAttribArray(vertexAttribute);
		GL.vertexAttribPointer(vertexAttribute, 3, GL.FLOAT, false, 7 * 4, 0);

		GL.enableVertexAttribArray(vertexColorAttribute);
		GL.vertexAttribPointer(vertexColorAttribute, 4, GL.FLOAT, false, 7 * 4, 3 * 4);*/
	}
	
}