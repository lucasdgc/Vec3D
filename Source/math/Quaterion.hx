package math;

import com.babylonhx.math.Quaternion;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Quaterion extends Quaternion;
{

	public function new(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 1) 
	{
		super(x, y, z, w);
	}
	
	public function convertToEuler () {
		var returnEuler:Vec3D = new Vec3D ();
	}
}