package physics;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Collision
{
	public var distance:Float = 0;
	public var isColliding:Bool = false;
	
	public var other:BoundingVolume;
	
	public function new(isColliding:Bool = false, distance:Float = 0, other:BoundingVolume = null) 
	{
		this.isColliding = isColliding;
		this.distance = distance;
		
		this.other = other;
	}
	
}