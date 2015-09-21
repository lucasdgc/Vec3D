package utils;

/**
 * ...
 * @author Lucas Gonçalves
 */
class SimpleMath
{

	public static function Lerp (from:Float, to:Float, amount:Float):Float {
		var value:Float = (1 - amount) * from + amount * to;
		return value;
	}
	
	public static function fixedFloat(v:Float, precision:Int = 2):Float
	{
		return Math.round( v * Math.pow(10, precision) ) / Math.pow(10, precision);
	}
}