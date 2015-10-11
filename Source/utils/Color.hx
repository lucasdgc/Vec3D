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
	
	public static var RED_HEX:UInt = 0xFFFF0000;
	public static var GREEN_HEX:UInt = 0xFF00FF00;
	public static var BLUE_HEX:UInt = 0xFF0000FF;
	public static var BLACK_HEX:UInt = 0xFF000000;
	public static var WHITE_HEX:UInt = 0xFFFFFFFF;
	public static var YELLOW_HEX:UInt = 0xFFFFFF00;
	
	
	public static var red:Color = new Color(RED_HEX);
	public static var green:Color = new Color(GREEN_HEX);
	public static var blue:Color = new Color(BLUE_HEX);
	public static var black:Color = new Color (BLACK_HEX);
	public static var white:Color = new Color(WHITE_HEX);
	public static var yellow:Color = new Color(YELLOW_HEX);
	
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
	
	public function toRGBA(){
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
			default: 
				returnColor = Color.white;
		}
		
		return returnColor;
	}
	
}