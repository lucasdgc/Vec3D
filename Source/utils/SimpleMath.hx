package utils;

import com.babylonhx.math.Vector3;
import com.babylonhx.math.Matrix;

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
	
	public static function matrixToEulerAngles (value:Matrix):Vector3 {
		var eulerAngles:Vector3 = new Vector3();
		
		var x:Float;
		var y:Float;
		var z:Float;
		if (value.m[0] == 1.0)
        {
            y = Math.atan2(value.m[2], value.m[11]);
            x = 0;
            z = 0;

        }else if (value.m[0] == -1.0)
        {
            y = Math.atan2(value.m[2], value.m[11]);
            x = 0;
            z = 0;
        }else 
        {

            y = Math.atan2(-value.m[8], value.m[0]);
            x = Math.asin(value.m[4]);
            z = Math.atan2(-value.m[6], value.m[5]);
        }
		
		eulerAngles.x = x;
		eulerAngles.y = y;
		eulerAngles.z = z;
		
		return eulerAngles;
	}
}