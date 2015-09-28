package math;

import com.babylonhx.math.Vector2;
/**
 * ...
 * @author Lucas Gonçalves
 */
class Vec2D extends Vector2
{

	public function new(x:Float = 0, y:Float = 0) 
	{
		super (x, y);
	}
	
	public function clampToSize (size:Float):Vec2D {
		var returnVec:Vec2D = new Vec2D ();
		var clampedVec = this.clone().normalize().multiplyByFloats(size, size);
		returnVec.x = clampedVec.x;
		returnVec.y = clampedVec.y;
		return returnVec;
	}
	
}