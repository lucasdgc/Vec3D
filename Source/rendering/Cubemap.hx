package rendering;

import device.ShaderProgram;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.gl.GLBuffer;
import openfl.gl.GL;
import openfl.gl.GLTexture;
import openfl.utils.ByteArray;
import openfl.utils.Float32Array;
import openfl.utils.UInt8Array;
import utils.ImageOperations;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Cubemap
{
	private static var cubemapAssetsDirectory:String = "assets/Images/Cubemaps/";
	private static var mimapNumbers:Int = 8;
	public static var defaultCubemapShader:ShaderProgram;
	
	public var vertexBuffer:GLBuffer;
	
	public var cubemapTexture:GLTexture;
	
	public var shaderProgram:ShaderProgram = defaultCubemapShader;
	
	public function new( negX:String, posX:String, negY:String, posY:String, negZ:String, posZ:String ) 
	{
		if ( defaultCubemapShader == null) {
			defaultCubemapShader = new ShaderProgram ( "cubemap", "cubemap", "cubemap", ["aVertexPosition"], ["uProjectionMatrix", "uViewMatrix"] );
		}
		shaderProgram = defaultCubemapShader;
		
		cubemapTexture = GL.createTexture ();
		GL.bindTexture ( GL.TEXTURE_CUBE_MAP, cubemapTexture );
		loadImages ( [posX, negX, posY, negY, posZ, negZ] );
		
		GL.bindTexture ( GL.TEXTURE_CUBE_MAP, null );
		
		createBuffers ();
	}
	
	private function createBuffers () {
		vertexBuffer = GL.createBuffer ();
		
		var vertexData:Array<Float> = [ -1.0,  1.0, -1.0,
										-1.0, -1.0, -1.0,
										 1.0, -1.0, -1.0,
										 1.0, -1.0, -1.0,
										 1.0,  1.0, -1.0,
										-1.0,  1.0, -1.0,

										-1.0, -1.0,  1.0,
										-1.0, -1.0, -1.0,
										-1.0,  1.0, -1.0,
										-1.0,  1.0, -1.0,
										-1.0,  1.0,  1.0,
										-1.0, -1.0,  1.0,

										 1.0, -1.0, -1.0,
										 1.0, -1.0,  1.0,
										 1.0,  1.0,  1.0,
										 1.0,  1.0,  1.0,
										 1.0,  1.0, -1.0,
										 1.0, -1.0, -1.0,

										-1.0, -1.0,  1.0,
										-1.0,  1.0,  1.0,
										 1.0,  1.0,  1.0,
										 1.0,  1.0,  1.0,
										 1.0, -1.0,  1.0,
										-1.0, -1.0,  1.0,

										-1.0,  1.0, -1.0,
										 1.0,  1.0, -1.0,
										 1.0,  1.0,  1.0,
										 1.0,  1.0,  1.0,
										-1.0,  1.0,  1.0,
										-1.0,  1.0, -1.0,

										-1.0, -1.0, -1.0,
										-1.0, -1.0,  1.0,
										 1.0, -1.0, -1.0,
										 1.0, -1.0, -1.0,
										-1.0, -1.0,  1.0,
										 1.0, -1.0,  1.0 ];
							 
		GL.bindBuffer ( GL.ARRAY_BUFFER, vertexBuffer );
		GL.bufferData ( GL.ARRAY_BUFFER, new Float32Array ( vertexData ), GL.STATIC_DRAW );
		GL.bindBuffer ( GL.ARRAY_BUFFER, null );
		
	}
	
	private function loadImages ( images:Array<String> ) {
		var imageBD:BitmapData;
		var imgData:UInt8Array;
		
		GL.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
		GL.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_MIN_FILTER, GL.LINEAR_MIPMAP_LINEAR);
		GL.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);		
		
		for ( i in 0...images.length ) {
				imageBD = Assets.getBitmapData ( cubemapAssetsDirectory + images[i] + ".jpg" );
				imgData = ImageOperations.rgbBitmapDataToUIntArray8 ( imageBD );
				GL.texImage2D ( GL.TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, GL.RGB, imageBD.width, imageBD.height, 0, GL.RGB, GL.UNSIGNED_BYTE, imgData );		
				
				//GL.generateMipmap ( GL.TEXTURE_CUBE_MAP_POSITIVE_X + i );
				imageBD.dispose ();
				imgData = null;
				//loadMipMaps ( GL.TEXTURE_CUBE_MAP_POSITIVE_X + i, cubemapAssetsDirectory + images[i], i );
		}	
		GL.generateMipmap ( GL.TEXTURE_CUBE_MAP );
	}
	
	private function loadMipMaps ( slot:Int, path:String, i:Int ) {
		var mipmapBD:BitmapData;
		var imgData:UInt8Array;
		
		for ( mipLevel in 0...mimapNumbers ) {
			mipmapBD = Assets.getBitmapData ( cubemapAssetsDirectory + "512/512" + "_m0" + mipLevel + "_" + "c0" + i + ".jpg" );
			//trace (cubemapAssetsDirectory + "512/512" + "_m0" + mipLevel + "_" + "c0" + i + ".jpg");
			//trace ( "Loaded CubeMap mipmap level: " + ( mipLevel + 1 ) );
			trace ( mipmapBD.width );
			trace ( mipmapBD.height );
			imgData = ImageOperations.rgbBitmapDataToUIntArray8 ( mipmapBD );
			GL.texImage2D ( slot, mipLevel + 1, GL.RGB, mipmapBD.width, mipmapBD.height, 0, GL.RGB, GL.UNSIGNED_BYTE, imgData );
			
			mipmapBD.dispose ();
		}
	}
}