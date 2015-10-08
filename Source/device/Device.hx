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

/**
 * ...
 * @author Lucas Gonçalves
 */

class Device
{	
	public static var DEFAULT_SHADER_NAME:String = "defaultShader";
	
	private var glView:OpenGLView;
	
	private var frameCount:Int = 0;
	
	private var renderer:Renderer;
	
	public function new() 
	{
		if (Engine.instance != null) {
			renderer = new Renderer ();
			
			glView = new OpenGLView ();
			
			glView.render = renderLoop;
			
			GL.viewport (Std.int (Engine.canvas.stage.x), Std.int (Engine.canvas.stage.y), Std.int (Engine.canvas.stage.stageWidth), Std.int (Engine.canvas.stage.stageHeight));
			
			Engine.canvas.addChild(glView);
			
			var defaultShader = new ShaderProgram (DEFAULT_SHADER_NAME, "DefaultVertexShader", "DefaultFragmentShader", ["aVertexPosition", "aVertexColor"], ["uProjectionMatrix", "uModelViewMatrix"]);
			
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
		/*frameCount ++;
		
		if (frameCount % 10 == 0) {
			renderer.drawCallCount = Std.int(drawCalls / frameCount);
			drawCalls = 0;
			frameCount = 0;
		}*/
		
		GL.enable(GL.DEPTH_TEST);
		//GL.enable(GL.STENCIL_TEST);		
		
		GL.enable(GL.BLEND);
		GL.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA);
		GL.blendEquation(GL.FUNC_ADD);
		
		renderer.clear(Engine.instance.currentScene.backgroundColor);
		if (Engine.instance.currentScene != null) {
			//renderFrameBuffer ();
			renderer.render(Engine.instance.currentScene.activeCamera, Engine.instance.currentScene.gameObject);
			//clear();
			//renderFrameBuffer();
		}
	}	
}