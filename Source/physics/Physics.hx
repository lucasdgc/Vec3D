package physics;

import physics.bounding.BoundingBox;
import physics.bounding.BoundingSphere;
import physics.bounding.BoundingVolume;
import physics.Ray;
import math.Vector3;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Physics
{

	public static function raycast (ray:Ray):Collision {
		var collisions:Array<Collision> = new Array ();
		
		for (bVolume in World.boundingVolumes) {
			if (Vector3.Distance(ray.origin, bVolume.center) < ray.length) {
				var collision = checkBoundingVolumeIntersection (ray, bVolume);
				if (collision.isColliding) {
					collisions.push ( collision );
					//return collision;
				}
			}
		}
		
		if ( collisions.length == 0 ) {
			return new Collision ();
		} else {
			var minDistance:Float = Math.POSITIVE_INFINITY;
			var curCollision:Collision = new Collision ();
			
			for ( col in collisions ) {
				var colDistance:Float = Vector3.Distance ( ray.origin, col.direction );
				if ( colDistance < minDistance ) {
					minDistance = colDistance;
					curCollision = col;
				}
			}
			
			return curCollision;
		}
		
		//return new Collision ();
	}
	
	private static function checkBoundingVolumeIntersection (ray:Ray, bVolume:BoundingVolume):Collision {
		switch (bVolume.type) {
			case BoundingVolumeType.BOX:
				return ray.intersectsBox (cast (bVolume, BoundingBox));
			case BoundingVolumeType.SPHERE:
				return ray.intersectsSphere( cast (bVolume, BoundingSphere));
			default:
		}
		
		return new Collision();
	}
}