package physics.bounding;

import com.babylonhx.math.Vector3;
import physics.bounding.BoundingVolume;

/**
 * ...
 * @author Lucas Gonçalves
 */

class BoundingSphere extends BoundingVolume
{
	//private var center:Vector3;
	public var radius:Float;
	
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
		var direction:Vector3 = other.center.subtract(this.center);
		var centerDistance:Float = direction.length();
		
		return new Collision (centerDistance < radiusDistance, direction, other);
	}
	
	public override function checkPlaneCollision (other:BoundingPlane):Collision {
		var centerDistance:Float = Vector3.Dot(other.normal.normalize(), this.center) + other.distance;
		centerDistance = Math.abs(centerDistance);
		var distanceFromObj = centerDistance - this.radius;
		
		return new Collision (distanceFromObj < 0, other.normal.multiplyByFloats(distanceFromObj, distanceFromObj, distanceFromObj), other);
	}
}