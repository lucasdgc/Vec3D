package tools;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Tools
{

	inline public static function Sign(value:Dynamic):Int {
		if (value == 0) {
			return 0;
		}
			
		return value > 0 ? 1 : -1;
	}
	
}