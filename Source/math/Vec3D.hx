package math;

import math.Vector3;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Vec3D extends Vector3
{

	public function new(x:Float = 0, y:Float = 0, z:Float = 0) 
	{
		super(x, y, z);
	}
	
	
	public function clampToSize (size:Float):Vec3D {
		var returnVec:Vec3D = new Vec3D ();
		var clampedVec = this.clone().normalize().multiplyByFloats(size, size, size);
		returnVec.x = clampedVec.x;
		returnVec.y = clampedVec.y;
		returnVec.z = clampedVec.z;
		return returnVec;
	}
	
		
	public function toRadVector ():Vec3D {
		//trace(degreeVector.y);
		return new Vec3D (this.x * (Math.PI / 180), this.y * (Math.PI / 180), this.z * (Math.PI / 180));
	}
	
	public function toDegreeVector ():Vec3D {
		//trace(radVector.y);
		return new Vec3D (this.x * (180 / Math.PI), this.y * (180 / Math.PI), this.z * (180 / Math.PI));
	}
	
	public static function maxValues (vector1:Vector3, vector2:Vector3) {
		var maxX:Float;
		var maxY:Float;
		var maxZ:Float;
		
		if (vector1.x > vector2.x) {
			maxX = vector1.x;
		} else {
			maxX = vector2.x;
		}
		
		if (vector1.y > vector2.y) {
			maxY = vector1.y;
		} else {
			maxY = vector2.y;
		}
		
		if (vector1.z > vector2.z) {
			maxZ = vector1.z;
		} else {
			maxZ = vector2.z;
		}
		
		return new Vector3 (maxX, maxY, maxZ);
	}
}