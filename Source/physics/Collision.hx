package physics;

import math.Vector3;
import physics.bounding.BoundingVolume;
/**
 * ...
 * @author Lucas Gonçalves
 */
class Collision
{
	public var distance (get, null):Float;
	public var isColliding:Bool = false;
	
	public var direction:Vector3;
	
	public var other:BoundingVolume;
	
	public function new(isColliding:Bool = false, direction:Vector3 = null, other:BoundingVolume = null) 
	{
		this.isColliding = isColliding;
		this.direction = direction;
		
		this.other = other;
	}
	
	private function get_distance():Float{
		return direction.length();
	}
}