package physics;

import com.babylonhx.math.Vector3;
import physics.BoundingVolume;

/**
 * ...
 * @author Lucas Gonçalves
 */

class BoundingSphere extends BoundingVolume
{
	//private var center:Vector3;
	private var radius:Float;
	
	public function new(radius:Float = 1) 
	{
		super();
		
		World.boundingVolumes.push(this);
		this.radius = radius;
		
		type = BoundingVolumeType.SPHERE;
		//this.center = new Vector3();
		//this.radius = radius;
	}
	
	public override function checkSphereCollision (other:BoundingSphere):Collision {
		//var collision:Collision = new Collision ();
		var radiusDistance:Float = radius + other.radius;
		var centerDistance:Float = Vector3.Distance (center, other.center);
		
		trace(centerDistance < radiusDistance);
		
		if (centerDistance < radiusDistance) {
			return new Collision (true, centerDistance - radiusDistance);
		} else {
			return new Collision (false, centerDistance - radiusDistance);
		}
		
		//return null;
	}
}