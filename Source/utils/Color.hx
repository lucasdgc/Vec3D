package utils;

import openfl.utils.Float32Array;

/**
 * ...
 * @author Lucas Gonçalves
 */

 
class Color
{
	public static var RED_NAME:String = "red";
	public static var GREEN_NAME:String = "green";
	public static var BLUE_NAME:String = "blue";
	public static var BLACK_NAME:String = "black";
	public static var WHITE_NAME:String = "white";
	public static var YELLOW_NAME:String = "yellow";
	public static var BROWN_NAME:String = "brown";
	public static var ORANGE_NAME:String = "orange";
	public static var CYAN_NAME:String = "cyan";
	public static var PURPLE_NAME:String = "purple";
	public static var PINK_NAME:String = "pink";
	public static var GREY_NAME:String = "grey";
	
	public static var RED_HEX:UInt = 0xFFFF0000;
	public static var GREEN_HEX:UInt = 0xFF00FF00;
	public static var BLUE_HEX:UInt = 0xFF0000FF;
	public static var BLACK_HEX:UInt = 0xFF000000;
	public static var WHITE_HEX:UInt = 0xFFFFFFFF;
	public static var YELLOW_HEX:UInt = 0xFFFFFF00;
	public static var BROWN_HEX:UInt = 0xFFA52A2A;
	public static var ORANGE_HEX:UInt = 0xFFFFA500;
	public static var CYAN_HEX:UInt = 0xFF00FFFF;
	public static var PURPLE_HEX:UInt = 0xFF800080;
	public static var PINK_HEX:UInt = 0xFFFF00FF;
	public static var GREY_HEX:UInt = 0xFFC0C0C0;
		
	public static var red:Color = new Color(RED_HEX);
	public static var green:Color = new Color(GREEN_HEX);
	public static var blue:Color = new Color(BLUE_HEX);
	public static var black:Color = new Color (BLACK_HEX);
	public static var white:Color = new Color(WHITE_HEX);
	public static var yellow:Color = new Color(YELLOW_HEX);
	public static var brown:Color = new Color(BROWN_HEX);
	public static var orange:Color = new Color(ORANGE_HEX);
	public static var cyan:Color = new Color(CYAN_HEX);
	public static var purple:Color = new Color(PURPLE_HEX);
	public static var pink:Color = new Color(PINK_HEX);
	public static var grey:Color = new Color(GREY_HEX);
	
	private static var isInitializedColors:Bool = false;
	
	public var r:Float;
	public var g:Float;
	public var b:Float;
	
	public var a:Float;
	
	public var hexValue:UInt;
	
	public function new(?hex:UInt) 
	{
		if (!isInitializedColors) { 
			isInitializedColors = true;
			//initializeColors();
		}
		
		if(hex != null){
			hexValue = hex;
			toRGBA();
		}

	}
	
	private function toRGBA(){
		a = hexValue >> 24 & 255;
		r = hexValue >> 16 & 255;
		g = hexValue >> 8 & 255;
		b = hexValue >> 0 & 255;
	}
	
	public function toFloat32Array ():Float32Array {
		var array:Array<Float> = new Array();
		
		array.push(r);
		array.push(g);
		array.push(b);
		array.push(a);
		
		return new Float32Array (array);
	}
	
	public function toNormalizedFloat32Array ():Float32Array {
		var array:Array<Float> = new Array ();
		
		array.push( r / 255 );
		array.push( g / 255 );
		array.push( b / 255 );
		array.push( a / 255 );
		
		return new Float32Array (array);
	}
	
	private static function initializeColors() {
		Color.red = new Color(RED_HEX);
		Color.green = new Color(GREEN_HEX);
		Color.blue = new Color(BLUE_HEX);
		Color.black = new Color(BLACK_HEX);
		Color.white = new Color(WHITE_HEX);
		
		Color.red.toRGBA();
		Color.green.toRGBA();
		Color.blue.toRGBA();
		Color.black.toRGBA();
		Color.white.toRGBA();
	}
	
	public static function getColorHexByName(colorName:String):Color {
		var returnColor:Color;
		
		switch(colorName){
			case Color.BLUE_NAME:
				returnColor = Color.blue;
			case Color.RED_NAME:
				returnColor = Color.red;
			case Color.GREEN_NAME:
				returnColor = Color.green;
			case Color.BLACK_NAME:
				returnColor = Color.black;
			case Color.WHITE_NAME:
				returnColor = Color.white;
			case Color.YELLOW_NAME:
				returnColor = Color.yellow;
			case Color.BROWN_NAME:
				returnColor = Color.brown;
			case Color.ORANGE_NAME:
				returnColor = Color.orange;
			case Color.CYAN_NAME:
				returnColor = Color.cyan;
			case Color.PURPLE_NAME:
				returnColor = Color.purple;
			case Color.PINK_NAME:
				returnColor = Color.pink;
			case Color.GREY_NAME:
				returnColor = Color.grey;
			default: 
				returnColor = Color.white;
		}
		
		return returnColor;
	}
	
	public function clone ():Color {
		return new Color (this.hexValue);
	}
	
}