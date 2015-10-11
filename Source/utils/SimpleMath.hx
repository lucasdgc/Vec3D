package utils;

import math.Vector3;
import math.Matrix;

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
	
	public static function getCloserPow2 (value:Float):Int {
		var pow2 = 2;
		
		while ( pow2 < value ) {
			pow2 *= 2;
		}
		
		return pow2;
	}
	
	public static function fixedFloat(v:Float, precision:Int = 2):Float
	{
		return Math.round( v * Math.pow(10, precision) ) / Math.pow(10, precision);
	}
	
	public static function toRadVector (degreeVector:Vector3):Vector3 {
		//trace(degreeVector.y);
		return new Vector3 (degreeVector.x * (Math.PI / 180), degreeVector.y * (Math.PI / 180), degreeVector.z * (Math.PI / 180));
	}
	
	public static function toDegreeVector (radVector:Vector3):Vector3 {
		//trace(radVector.y);
		return new Vector3 (radVector.x * (180 / Math.PI), radVector.y * (180 / Math.PI), radVector.z * (180 / Math.PI));
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
	
	public static function matrixToPosition (value:Matrix):Vector3 {
		var position:Vector3 = new Vector3(value.m[3], value.m[7], value.m[11]);
		
		return position;
	}
}