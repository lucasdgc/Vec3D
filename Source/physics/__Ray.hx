package physics;

import math.Vec3D;

/**
 * ...
 * @author Lucas Gonçalves
 */
class __Ray
{
	private var start:Vec3D;
	private var direction:Vec3D;
	
	private var distance:Float;
	
	private var rayVector:Vec3D;
	
	public function new(start, direction, distance) 
	{
		this.start = start;
		this.direction = direction;
		this.distance = distance;
		
		var rayV:Vec3D = this.direction.subtract(this.start);
		rayVector = rayV.clampToSize(distance);
	}
	
	public static inline function rayFromDistance (start:Vec3D, distance:Float):__Ray {
		var direction:Vec3D = start.clone().normalize();
		direction = direction.clampToSize(distance);
		
		var ray:__Ray = new __Ray (start, direction,distance);
		return ray;
	}
	
	public static inline function rayBetweenTwoPoints (start:Vec3D, end:Vec3D):__Ray {
		var relVector:Vec3D = end.subtract(start);
		var distance:Float = relVector.length();
		
		var ray:__Ray = new __Ray (start, end, distance);
		return ray;
	}
	
}