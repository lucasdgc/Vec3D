package materials;

import openfl.utils.Float32Array;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.gl.GLTexture;
import openfl.gl.GL;
import openfl.utils.UInt8Array;
import utils.Color;
import openfl.Assets;
import utils.ImageOperations;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Material
{
	private static var defaultTexturePath:String = "assets/Images/Textures/";
	
	public var albedoColor:Color;
	private var albedoTexture:GLTexture;
	
	private var normalTexture:GLTexture;
	
	public var metallic:Float;
	private var metallicTexture:GLTexture;
	
	public var smoothness:Float;
	private var smoothnessTexture:GLTexture;
	
	public function new( albedoPath:String = "", normalPath:String = "", metallicPath:String = "", smoothnessPath:String = "" ) 
	{
		var bd:BitmapData;
		
		if ( albedoPath != "" ) {
			bd = Assets.getBitmapData ( defaultTexturePath + albedoPath );
			if ( bd != null ) {
				albedoTexture = createTexture ( bd );
			}
		}
		
		if ( normalPath != "" ) {
			bd = Assets.getBitmapData ( defaultTexturePath + normalPath );
			if ( bd != null ) {
				normalTexture = createTexture ( bd );
			}
		}
		
		if ( smoothnessPath != "" ) {
			bd = Assets.getBitmapData ( defaultTexturePath + smoothnessPath );
			if ( bd != null ) {
				smoothnessTexture = createTexture ( bd, true );
			}
		}
		
		if ( metallicPath != "" ) {
				bd = Assets.getBitmapData ( defaultTexturePath + metallicPath );
			if ( bd != null ) {
				metallicTexture = createTexture ( bd, true );
			}
		}
		
		//bd.dispose ();
	}
	
	private function createTexture ( bData:BitmapData, isGresScale:Bool = false ):GLTexture {
		var texture:GLTexture = GL.createTexture ();
	
		GL.bindTexture ( GL.TEXTURE_2D, texture );
		
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR_MIPMAP_LINEAR);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
		if ( !isGresScale ) {
			var pixelData:UInt8Array = ImageOperations.rgbBitmapDataToUIntArray8 ( bData );
			GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGB, bData.width, bData.height, 0, GL.RGB, GL.UNSIGNED_BYTE, pixelData );
		} else {
			var pixelData:UInt8Array = ImageOperations.rgbBitmapDataToUIntArray8 ( bData );
			GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGB, bData.width, bData.height, 0, GL.RGB, GL.UNSIGNED_BYTE, pixelData );
		}
		
		GL.generateMipmap(GL.TEXTURE_2D);
		
		GL.bindTexture ( GL.TEXTURE_2D, null );
		bData.dispose ();
		
		return texture;
	}
	
	public function bindMaterialTextures () {
		if ( albedoTexture != null ) {
			GL.activeTexture (GL.TEXTURE0);
			GL.bindTexture ( GL.TEXTURE_2D, albedoTexture );
		}
		
		if ( normalTexture != null ) {
			GL.activeTexture (GL.TEXTURE1);
			GL.bindTexture ( GL.TEXTURE_2D, normalTexture );
		}
		
		if ( smoothnessTexture != null ) {
			GL.activeTexture (GL.TEXTURE2);
			GL.bindTexture ( GL.TEXTURE_2D, smoothnessTexture );
		}
		
		if ( metallicTexture != null ) {
			GL.activeTexture (GL.TEXTURE3);
			GL.bindTexture ( GL.TEXTURE_2D, metallicTexture );
		}
	}
	
	public static function unbindMaterialTextures () {
		GL.activeTexture (GL.TEXTURE0);
		GL.bindTexture ( GL.TEXTURE_2D, null );
		
		GL.activeTexture (GL.TEXTURE1);
		GL.bindTexture ( GL.TEXTURE_2D, null );
		
		GL.activeTexture (GL.TEXTURE2);
		GL.bindTexture ( GL.TEXTURE_2D, null );
		
		GL.activeTexture (GL.TEXTURE3);
		GL.bindTexture ( GL.TEXTURE_2D, null );
	}
}