package utils;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;
import openfl.utils.Float32Array;
import openfl.utils.UInt8Array;


/**
 * ...
 * @author Lucas Gonçalves
 */
class ImageOperations
{
	public static function rgbBitmapDataToUIntArray8 ( bd:BitmapData ):UInt8Array {
		var a:Array<UInt> = [];
		trace ("getting byte array...");
		var pixelData:ByteArray = bd.getPixels ( bd.rect );
		trace ("done...");
		
		trace ("getting pixel data...");
		for ( i in 0...bd.width * bd.height ) {
			//Three times for RGB
			
			pixelData.readUnsignedByte ();
			a.push ( pixelData.readUnsignedByte () );
			a.push ( pixelData.readUnsignedByte () );
			a.push ( pixelData.readUnsignedByte () );
		}
		trace ("done...");
		return new UInt8Array ( a );
	}
	
	public static function argbBitmapDataToUIntArray8 ( bd:BitmapData ):UInt8Array {
		var a:Array<UInt> = [];
		trace ("getting byte array...");
		var pixelData:ByteArray = bd.getPixels ( bd.rect );
		trace ("done...");
		
		trace ("getting pixel data...");
		for ( i in 0...bd.width * bd.height ) {
			//Three times for RGB
			
			a.push ( pixelData.readUnsignedByte () );
			a.push ( pixelData.readUnsignedByte () );
			a.push ( pixelData.readUnsignedByte () );
			a.push ( pixelData.readUnsignedByte () );
		}
		trace ("done...");
		return new UInt8Array ( a );
	}
	
	public static function greyScaleBitmapDataToFloat32Array ( bd:BitmapData ):Float32Array {
		var a:Array<Float> = [];
		var sum:Float = 0;
		trace ("getting byte array...");
		var pixelData:ByteArray = bd.getPixels ( bd.rect );
		trace ("done...");
		
		trace ("getting pixel data...");
		for ( i in 0...bd.width * bd.height ) {
			//Three times for RGB
			
			pixelData.readUnsignedByte ();
			sum += pixelData.readUnsignedByte ();
			sum += pixelData.readUnsignedByte ();
			sum += pixelData.readUnsignedByte ();
			
			sum = sum / ( 255 * 3 );
			
			a.push ( sum );
			sum = 0;
		}
		trace ("done...");
		return new Float32Array ( a );
	}
}