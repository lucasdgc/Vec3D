package device;

import materials.Material;
import math.Quaternion;
import math.Vector3;
import objects.Camera;
import objects.GameObject;
import objects.Light;
import objects.PointLight;
import objects.Transform;
import openfl.gl.GLTexture;
import openfl.utils.Float32Array;
import rendering.Cubemap;
import rendering.Mesh;
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
	public static var lightsCount:UInt = 8;
	public var drawBoundingVolumes:Bool = false;
	
	public var drawCallCount:Int = 0;
	private var frameDrawCalls:Int = 0;
	
	private var lightSpaceMatrix:Matrix;
	
	public function new () {
		
	}
	
	public function clear (color:Color) {
		GL.clearColor (color.r, color.g, color.b, color.a);
		GL.clear (GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
	}
	
	public function render( camera:Camera, gameObjects:Array<GameObject>, shadowMapTexture:GLTexture = null ) {
		var viewMatrix = camera.viewMatrix.clone ();
		var projectionMatrix = camera.projectionMatrix.clone ();
		
		GL.enable ( GL.CULL_FACE );
		GL.enable ( GL.DEPTH_TEST );
		
		GL.useProgram(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).program);
		
		for (gameObject in gameObjects) { 
			if ( !gameObject.isStatic && gameObject.isVisible && gameObject.mesh != null ) {
				var mesh = gameObject.mesh;
			
				var worldMatrix:Matrix = gameObject.transform.transformMatrix;
				
				//var worldViewMatrix:Matrix = worldMatrix.multiply(viewMatrix);
				//MVP Matrices
				GL.uniformMatrix4fv (mesh.shaderProgram.uniforms[0].index, false, new Float32Array (projectionMatrix.m));
				GL.uniformMatrix4fv (mesh.shaderProgram.uniforms[1].index, false, new Float32Array (worldMatrix.m));
				GL.uniformMatrix4fv (mesh.shaderProgram.uniforms[2].index, false, new Float32Array (viewMatrix.m));
				//Camera Pos
				GL.uniform3f ( mesh.shaderProgram.uniforms[3].index, camera.transform.position.x, camera.transform.position.y, camera.transform.position.z );
				//Directional Light direction, power and color
				var sun:Light = Engine.instance.currentScene.sun;
				if ( sun != null ) {
					GL.uniform3f ( mesh.shaderProgram.uniforms[4].index, sun.direction.x, sun.direction.y, sun.direction.z );
					GL.uniform3f ( mesh.shaderProgram.uniforms[5].index, sun.color.r / 255, sun.color.g / 255, sun.color.b / 255 );
					GL.uniform1f ( mesh.shaderProgram.uniforms[6].index, sun.power );
				}
				//Point Lights
				GL.uniform1i ( mesh.shaderProgram.uniforms[7].index, gameObject.scene.pointLights.length );
				var pointLightStartingIndex:Int = 8;
				for ( i in 0...gameObject.scene.pointLights.length ) {
					var pl:Light = gameObject.scene.pointLights[i];

					GL.uniform3f ( mesh.shaderProgram.uniforms[pointLightStartingIndex + i * 3].index, pl.transform.position.x, pl.transform.position.y, pl.transform.position.z );
					GL.uniform3f ( mesh.shaderProgram.uniforms[pointLightStartingIndex + i * 3 + 1].index, pl.color.r / 255, pl.color.g / 255, pl.color.b / 255 );
					GL.uniform1f ( mesh.shaderProgram.uniforms[pointLightStartingIndex + i * 3 + 2].index, pl.power);
				}
				//Spot Lights
				var spotLightStartingIndex:Int = pointLightStartingIndex + lightsCount * 3;
				GL.uniform1i ( mesh.shaderProgram.uniforms[spotLightStartingIndex].index, gameObject.scene.spotLights.length );
				spotLightStartingIndex ++;
				
				for ( j in 0...gameObject.scene.spotLights.length ) {
					var sl:Light = gameObject.scene.spotLights[j];

					GL.uniform3f ( mesh.shaderProgram.uniforms[spotLightStartingIndex + j * 5].index, sl.transform.position.x, sl.transform.position.y, sl.transform.position.z );
					GL.uniform3f ( mesh.shaderProgram.uniforms[spotLightStartingIndex + j * 5 + 1].index, sl.transform.forward.x, sl.transform.forward.y, sl.transform.forward.z );
					GL.uniform3f ( mesh.shaderProgram.uniforms[spotLightStartingIndex + j * 5 + 2].index, sl.color.r / 255, sl.color.g / 255, sl.color.b / 255 );
					GL.uniform1f ( mesh.shaderProgram.uniforms[spotLightStartingIndex + j * 5 + 3].index, sl.power );
					GL.uniform1f ( mesh.shaderProgram.uniforms[spotLightStartingIndex + j * 5 + 4].index, sl.cutoff );
				}
				
				if (gameObject.mesh.meshBuffer == null) {
					throw "Object " + mesh.name +" has undefined vertex buffers...";
				}
				
				var materialUniformIndex:UInt = spotLightStartingIndex + lightsCount * 5;
				for ( matBinding in mesh.materials ) {
					matBinding.material.bindMaterialTextures ( );
					
					GL.uniform1i ( mesh.shaderProgram.uniforms[ materialUniformIndex ].index, 0 );
					GL.uniform1i ( mesh.shaderProgram.uniforms[ materialUniformIndex + 1].index, 1 );
					GL.uniform1i ( mesh.shaderProgram.uniforms[ materialUniformIndex + 2].index, 2 );
					GL.uniform1i ( mesh.shaderProgram.uniforms[ materialUniformIndex + 3].index, 3 );
				}
				
				if ( shadowMapTexture != null ) {
					GL.activeTexture ( GL.TEXTURE4 );
					GL.bindTexture ( GL.TEXTURE_2D, shadowMapTexture );
					GL.uniform1i ( mesh.shaderProgram.uniforms[ materialUniformIndex + 4].index, 4 );
					GL.uniformMatrix4fv (mesh.shaderProgram.uniforms[ materialUniformIndex + 5 ].index, false, new Float32Array (lightSpaceMatrix.m));
				}
				
				drawGeometry(mesh.meshBuffer.vertexBuffer, mesh.vertices.length, mesh.drawPoints,
						mesh.meshBuffer.edgeIndexBuffer, mesh.edges.length, mesh.drawEdges,
						mesh.meshBuffer.faceIndexBuffer, mesh.faces.length, mesh.drawFaces);
						
				Material.unbindMaterialTextures ();
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
		GL.disableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[3].index);
		GL.disableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[4].index);
		
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		
		drawCallCount = frameDrawCalls;
	}
	
	private function drawGeometry (vertexBuffer:GLBuffer, vertexBufferSize:Int, drawVertex:Bool, 
									edgeIndexBuffer:GLBuffer, edgeBufferSize:Int, drawEdges:Bool,
									facesIndexBuffer:GLBuffer, faceBufferSize:Int, drawFaces:Bool) {
		
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		
		GL.enableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[0].index);
		GL.vertexAttribPointer(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[0].index, 3, GL.FLOAT, false, 14 * 4, 0);

		GL.enableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[1].index);
		GL.vertexAttribPointer(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[1].index, 3, GL.FLOAT, false, 14 * 4, 3 * 4);

		GL.enableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[2].index);
		GL.vertexAttribPointer(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[2].index, 2, GL.FLOAT, false, 14 * 4, 6 * 4);
		
		GL.enableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[3].index);
		GL.vertexAttribPointer(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[3].index, 3, GL.FLOAT, false, 14 * 4, 8 * 4);
		
		GL.enableVertexAttribArray(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[4].index);
		GL.vertexAttribPointer(ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME).attributes[4].index, 3, GL.FLOAT, false, 14 * 4, 11 * 4);
		
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
	
	public function drawShadowMaps ( shadowBuffer:FrameBuffer, lightTransform:Transform, gameObjects:Array<GameObject>, isOrthogonal:Bool = true ) {
		GL.viewport ( 0, 0, shadowBuffer.width, shadowBuffer.height );
		GL.bindFramebuffer( GL.FRAMEBUFFER, shadowBuffer.frameBuffer );
		GL.clear( GL.DEPTH_BUFFER_BIT | GL.COLOR_BUFFER_BIT );
		GL.useProgram( shadowBuffer.shaderProgram.program );
		GL.enable( GL.DEPTH_TEST );
		GL.cullFace ( GL.FRONT );
		
		var lightProjection:Matrix = Matrix.OrthoOffCenterLH ( -5, 5, -8, 3, 0.01, 10 ); 
		//var lightProjection:Matrix = Matrix.OrthoLH ( 10, 10, 0.01, 10 ); 
		var lightView:Matrix = Matrix.LookAtLH ( lightTransform.forward.negate(), Vector3.Zero(), Vector3.Up() );
		lightSpaceMatrix = lightProjection.multiply ( lightView );
		
		GL.uniformMatrix4fv (shadowBuffer.shaderProgram.uniforms[0].index, false, new Float32Array (lightSpaceMatrix.m));
		for ( go in gameObjects ) {
			if ( go.isVisible && go.mesh != null ) {
				if ( go.mesh.castShadows ) {
					GL.uniformMatrix4fv (shadowBuffer.shaderProgram.uniforms[1].index, false, new Float32Array ( go.transform.transformMatrix.m ));
					GL.bindBuffer( GL.ARRAY_BUFFER, go.mesh.meshBuffer.vertexBuffer );
					GL.enableVertexAttribArray( shadowBuffer.shaderProgram.attributes[0].index );
					GL.vertexAttribPointer( shadowBuffer.shaderProgram.attributes[0].index, 3, GL.FLOAT, false, 14 * 4, 0 );
					
					GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, go.mesh.meshBuffer.faceIndexBuffer );
					
					GL.drawElements ( GL.TRIANGLES, go.mesh.faces.length * 3, GL.UNSIGNED_SHORT, 0 );
				}
			}
		}
		GL.cullFace ( GL.BACK );
		
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
		GL.activeTexture ( GL.TEXTURE0 );
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
	
	public function renderToShadowBuffers ( buffer:FrameBuffer ) {
		
		
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