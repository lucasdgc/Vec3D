package device;

import openfl.geom.Rectangle;
import openfl.gl.GLBuffer;
import openfl.gl.GLFramebuffer;
import openfl.gl.GLRenderbuffer;
import openfl.gl.GLTexture;
import openfl.gl.GL;
import openfl.utils.Float32Array;

/**
 * ...
 * @author Lucas Gonçalves
 */
class FrameBuffer
{
	public var frameBuffer:GLFramebuffer;
	public var texture (default, null):GLTexture;
	public var depthTexture (default, null):GLTexture;
	public var subTexture (default, null):GLTexture;
	public var vertexBuffer (default, null):GLBuffer;
	private var renderBuffer:GLRenderbuffer;
	
	public var width:Int;
	public var height:Int;
	
	public var shaderProgram (default, null):ShaderProgram;
	
	public var renderTarget:Rectangle;
		
	public function new( width:Int, height:Int, shader:ShaderProgram = null, renderTarget:Rectangle = null, isShadowBuffer:Bool = false ) 
	{
		if (Engine.instance == null) {
			throw "Cannot create framebuffer without Engine instance...";
		}
		
		this.width = width;
		this.height = height;
		
		this.shaderProgram = shader;
		
		frameBuffer = GL.createFramebuffer();
		texture = GL.createTexture();
		//subTexture = GL.createTexture();
		//if ( ! isShadowBuffer ) {
			vertexBuffer = GL.createBuffer();
			renderBuffer = GL.createRenderbuffer();
		//}

		GL.bindFramebuffer(GL.FRAMEBUFFER, frameBuffer);
		GL.bindTexture(GL.TEXTURE_2D, texture);
		
		if ( ! isShadowBuffer ) {
			GL.bindRenderbuffer(GL.RENDERBUFFER, renderBuffer);
			GL.renderbufferStorage(GL.RENDERBUFFER, GL.RGBA4, width, height);
			GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.RENDERBUFFER, renderBuffer);
			
			GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGB, width, height, 0, GL.RGB, GL.UNSIGNED_BYTE, null);
			
			GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
			GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
			GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
			GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
			
			GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture, 0);
		} else {
			//GL.bindRenderbuffer(GL.RENDERBUFFER, renderBuffer);
			//GL.renderbufferStorage(GL.RENDERBUFFER, GL.RGBA4, width, height);
			//GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.RENDERBUFFER, renderBuffer);
			//GL.texImage2D(GL.TEXTURE_2D, 0, GL.DEPTH_COMPONENT, width, height, 0, GL.DEPTH_COMPONENT, GL.FLOAT, null);
			#if html5
			var depthTextureExt = GL.getExtension("WEBGL_depth_texture");
			#end
			
			GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGB, width, height, 0, GL.RGB, GL.UNSIGNED_BYTE, null);
			GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
			GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
			GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT); 
			GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);  
			
			depthTexture = GL.createTexture ();
			GL.bindTexture(GL.TEXTURE_2D, depthTexture);
			
			GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
			GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
			GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
			GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
			GL.texImage2D(GL.TEXTURE_2D, 0, GL.DEPTH_COMPONENT, width, height, 0, GL.DEPTH_COMPONENT, GL.UNSIGNED_SHORT, null);
			
			GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture, 0);
			GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.TEXTURE_2D, depthTexture, 0);
		}
		//GL.texSubImage2D(GL.TEXTURE_2D, 0, 0, 0, Engine.canvas.stage.stageWidth, Engine.canvas.stage.stageHeight, GL.RGB, GL.UNSIGNED_BYTE, null);
		//GL.texImage2D(GL.TEXTURE_2D, 0, GL.DEPTH_COMPONENT16, width, height, 0, GL.DEPTH_COMPONENT16, GL.UNSIGNED_BYTE, null)
		
		GL.bindTexture(GL.TEXTURE_2D, null);
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);
		GL.bindRenderbuffer(GL.RENDERBUFFER, null);
		
		this.renderTarget = renderTarget;
		
		if (renderTarget != null) {
			createVertexArray();
		}
	}
	
	private function createVertexArray () {
		var minX:Float = (-1 + (2 / Engine.canvas.stage.stageWidth) * renderTarget.x);
		var maxX:Float = (-1 + (2 / Engine.canvas.stage.stageWidth) * (renderTarget.width + renderTarget.x));
		var minY:Float=  -(-1 + (2 / Engine.canvas.stage.stageHeight) * renderTarget.y);
		var maxY:Float = -(-1 + (2 / Engine.canvas.stage.stageHeight) * (renderTarget.height + renderTarget.y));
			
		//var minX:Int = Std.int ( 2 / ((Engine.canvas.stage.stageWidth) * (renderTarget.x - Engine.canvas.stage.stageWidth)) - 1 );
		//var maxX:Int = Std.int ( 2 / ((Engine.canvas.stage.stageWidth) * (renderTarget.width - Engine.canvas.stage.stageWidth)) - 1 );
		//var minY:Int = Std.int ( 2 / (Engine.canvas.stage.stageHeight * ( renderTarget.y - Engine.canvas.stage.stageHeight)));
		//var maxY:Int = Std.int ( 2 / (Engine.canvas.stage.stageHeight * ( renderTarget.height - Engine.canvas.stage.stageHeight)));
		
		
		 //newvalue= (max'-min')/(max-min)*(value-max)+max'
		
		var vertex = [ minX, maxY,  
					   minX, minY, 
					   maxX, maxY,
					   maxX, minY];
					   
		//trace ("min X:" + minX);
		//trace ("max X:" + maxX);
		//trace ("min Y:" + minY);
		//trace ("max Y:" + maxY);
		
					   
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		GL.bufferData(GL.ARRAY_BUFFER, new Float32Array (vertex), GL.STATIC_DRAW);
		
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
	}
	
	public function bind () {
		GL.bindFramebuffer (GL.FRAMEBUFFER, frameBuffer);
	}
	
	public function render (renderer:Renderer) {
		renderer.drawFrameBuffer (this);
	}
	
	public function getTexture ():GLTexture {
		return texture;
	}
}