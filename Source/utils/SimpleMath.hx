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
}