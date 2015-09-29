package physics;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Collision
{

	private var distance:Float = 0;
	private var isColliding:Bool = false;
	
	public function new(isColliding:Bool = true, distance:Float = 0) 
	{
		this.isColliding = isColliding;
		this.distance = distance;
	}
	
}