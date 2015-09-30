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
		this.radius = radius;
		
		type = BoundingVolumeType.SPHERE;
		//this.center = new Vector3();
		//this.radius = radius;
	}
	
	public override function updateCenterPosition (referencePosition:Vector3) {
		center = referencePosition.add(relativeCenter);
	}
	
	public override function checkSphereCollision (other:BoundingSphere):Collision {
		//var collision:Collision = new Collision ();
		var radiusDistance:Float = radius + other.radius;
		var centerDistance:Float = Vector3.Distance (center, other.center);
		
		return new Collision (centerDistance < radiusDistance, centerDistance - radiusDistance);
	}
}