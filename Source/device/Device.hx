package device;

import device.ShaderProgram;
import events.Vec3DEvent;
import rendering.Scene;
import objects.Camera;
import openfl.display.OpenGLView;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.gl.GLProgram;
import openfl.utils.Float32Array;
import objects.GameObject;
import openfl.events.Event;
import events.Vec3DEventDispatcher;
import utils.Color;
import utils.SimpleMath;

/**
 * ...
 * @author Lucas Gonçalves
 */

class Device
{	
	public static var DEFAULT_SHADER_NAME:String = "defaultShader";
	public static var DEFAULT_FRAMEBUFFER_SHADER_NAME:String = "defaultFrameBufferShader";
	
	private var glView:OpenGLView;
	
	private var frameCount:Int = 0;
	
	private var renderer:Renderer;
	
	private var blurFrameBuffer:FrameBuffer;
	
	public function new() 
	{
		if (Engine.instance != null) {
			renderer = new Renderer ();
			
			glView = new OpenGLView ();
			
			glView.render = renderLoop;
			
			GL.viewport (Std.int (Engine.canvas.stage.x), Std.int (Engine.canvas.stage.y), Std.int (Engine.canvas.stage.stageWidth), Std.int (Engine.canvas.stage.stageHeight));
			
			Engine.canvas.addChild(glView);
			
			var defaultShader = new ShaderProgram (DEFAULT_SHADER_NAME, "default", "default", ["aVertexPosition", "aVertexNormal", "aVertexColor"], ["uProjectionMatrix", "uModelMatrix", "uViewMatrix", "uCameraPos", "uLightPos"]);
			//var defaultFrameBufferShader = new ShaderProgram (DEFAULT_FRAMEBUFFER_SHADER_NAME, "frameBuffer", "frameBuffer", ["a_position"], ["u_sampler", "u_screenWidth", "u_screenHeight"]);
			//var bloomShader = new ShaderProgram ("bloomShader", "frameBuffer", "bloom", ["a_position"], ["u_sampler", "u_backgroundColor", ]);

			//var rect:Rectangle = new Rectangle (Engine.canvas.stage.stageWidth / 4, Engine.canvas.stage.stageHeight / 2, Engine.canvas.stage.stageWidth / 4, Engine.canvas.stage.stageHeight / 4);
			var rect:Rectangle = new Rectangle (Engine.canvas.stage.x, Engine.canvas.stage.y, Engine.canvas.stage.stageWidth, Engine.canvas.stage.stageHeight);
			//sceneFrameBuffer = new FrameBuffer (2048, 1024, defaultFrameBufferShader, rect);
			
			//blurFrameBuffer = new FrameBuffer (SimpleMath.getCloserPow2(Engine.canvas.stage.stageWidth), SimpleMath.getCloserPow2(Engine.canvas.stage.stageHeight), defaultFrameBufferShader, rect);
			
			//trace ();
			
		} else {
			throw "Cannot instantiate Device without Engine...";
		}
	}
	
	public function update (e:Event) {

		if (Engine.instance.currentScene != null) {
			Engine.instance.currentScene.update(e);
		}
		
		Vec3DEventDispatcher.instance.dispatchUpdateEvent();
	}
	
	
	private function renderLoop(rect:Rectangle) {
		//GL.enable(GL.BLEND);
		//GL.disable ( GL.CULL_FACE );
		//GL.depthMask(false);
		//GL.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
		//GL.enable (GL.pol);
		//GL.cullFace ( GL.BACK );
		//GL.enable ( GL.CULL_FACE );
		//GL.enable (GL.DEPTH_TEST);
		
		if (Engine.instance.currentScene != null) {
			#if mobile
				lowPerformanceRender();
				//highPerformanceRender();
			#else
				//highPerformanceRender();
				lowPerformanceRender();
			#end
		}
	}
	
	private function lowPerformanceRender () {
		renderer.clear(Engine.instance.currentScene.backgroundColor);
		renderer.render(Engine.instance.currentScene.activeCamera, Engine.instance.currentScene.gameObject);
		
	}
	
	private function highPerformanceRender () {
		blurFrameBuffer.bind();
		renderer.clear(Engine.instance.currentScene.backgroundColor);
		GL.enable(GL.DEPTH_TEST);
		renderer.render(Engine.instance.currentScene.activeCamera, Engine.instance.currentScene.gameObject);
		GL.disable(GL.DEPTH_TEST);
		renderer.drawFrameBuffer(blurFrameBuffer);
	}
}