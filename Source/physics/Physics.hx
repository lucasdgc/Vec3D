package physics;

import physics.bounding.BoundingBox;
import physics.bounding.BoundingSphere;
import physics.bounding.BoundingVolume;
import physics.Ray;
import com.babylonhx.math.Vector3;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Physics
{

	public static function raycast (ray:Ray):Collision {
		
		//trace("bVolumes: "+World.boundingVolumes.length);
		for (bVolume in World.boundingVolumes) {
			if (Vector3.Distance(ray.origin, bVolume.center) < ray.length) {
				var collision = checkBoundingVolumeIntersection (ray, bVolume);
				if (collision.isColliding) {
					return collision;
				}
			}
		}
		
		return new Collision ();
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