package math;

import com.babylonhx.math.Vector4;
import com.babylonhx.math.Matrix;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Vec4D extends Vector4
{

	
	public static inline function MultiplyByMatrix (vector4:Vector4, matrix:Matrix):Vector4 {
		var vec4:Vector4 = vector4.clone ();
		var m:Matrix = matrix.clone ();
		
		var vecAsArray:Array<Float> = [4];
		vecAsArray[0] = vec4.x;
		vecAsArray[1] = vec4.y;
		vecAsArray[2] = vec4.z;
		vecAsArray[3] = vec4.w;
	
		var resultArray:Array<Float> = [4];
		
		for (i in 0...4) {
			resultArray[i] = 0;
			for (j in 0...16) {
				resultArray[i] += m.m[j] * vecAsArray[i];
			}
		}
		
		var result:Vector4 = new Vector4 (resultArray[0], resultArray[1], resultArray[2], resultArray[3]);
		return result;
	}
}