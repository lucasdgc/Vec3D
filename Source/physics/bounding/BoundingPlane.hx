package physics.bounding;

import math.Vector3;
import physics.bounding.BoundingVolume;
/**
 * ...
 * @author Lucas Gonçalves
 */
class BoundingPlane extends BoundingVolume
{
	public var normal:Vector3;
	public var distance:Float;
	
	public function new(normal:Vector3, distance:Float = 0) 
	{
		super ();
		
		type = BoundingVolumeType.PLANE;
		this.normal = normal;
		this.distance = distance;
	}
	
	public override function updateCenterPosition (refPosition:Vector3) {
		center = refPosition.add(relativeCenter);
		
		distance = center.length ();
	}
	
	public override function checkSphereCollision (other:BoundingSphere):Collision {
		var centerDistance:Float = Vector3.Dot(normal.normalize(), other.center) + distance;
		centerDistance = Math.abs(centerDistance);
		var distanceFromObj = centerDistance - other.radius;
		
		return new Collision (distanceFromObj < 0, normal.multiplyByFloats(distanceFromObj, distanceFromObj, distanceFromObj), other);
	}
}