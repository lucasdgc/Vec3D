package physics.bounding;
import math.Vec3D;
import objects.GameObject;
import rendering.Mesh;
import rendering.primitives.Primitives;
import math.Vector3;
import physics.bounding.BoundingVolume;

/**
 * ...
 * @author Lucas Gonçalves
 */
class BoundingBox extends BoundingVolume
{
	public var vertices:Array<Vector3>;
	
	public var minExtents:Vector3;
	public var maxExtents:Vector3;
	
	public var worldMinExtents:Vector3;
	public var worldMaxExtents:Vector3;
	
	public function new(minExt:Vector3, maxExt:Vector3)
	{
		super();
		
		type = BoundingVolumeType.BOX;
		
		minExtents = minExt;
		maxExtents = maxExt;
		
		worldMaxExtents = new Vector3 ();
		worldMinExtents = new Vector3 ();
	}
	
	public override function updateCenterPosition (refPosition:Vector3) {
		center = refPosition.add(relativeCenter);
		
		worldMinExtents = center.add(minExtents);
		worldMaxExtents = center.add(maxExtents);
	}
	
	public override function checkBoxCollision (other:BoundingBox):Collision {
		
		var differenceA:Vector3 = this.worldMinExtents.subtract(other.worldMaxExtents);
		var differenceB:Vector3 = other.worldMinExtents.subtract(this.worldMaxExtents);
		var maxDistances:Vector3 = Vec3D.maxValues(differenceA, differenceB);
		var maxDistance:Float;
		
		if (maxDistances.x > maxDistances.y) {
			maxDistance = maxDistances.x;
		} else {
			maxDistance = maxDistances.y;
		}
		
		if (maxDistances.z > maxDistance) {
			maxDistance = maxDistances.z;
		}
		
		return new Collision (maxDistance < 0, maxDistances, other);
	}
	
	public static function getMeshExtents (mesh:Mesh):BoundingBox {
		var minExt:Vector3;
		var maxExt:Vector3;
		
		minExt = mesh.vertices[0].clone();
		maxExt = mesh.vertices[0].clone();
		
		for (vert in mesh.vertices) {
			
			var vertPos:Vector3 = vert.clone ();
			
			if (mesh.gameObject != null) {
				vertPos = vert.multiplyByFloats(mesh.gameObject.transform.scale.x, mesh.gameObject.transform.scale.y, mesh.gameObject.transform.scale.z);
			}
			
			if (vertPos.x < minExt.x && vertPos.y < minExt.y && vertPos.z < minExt.z) {
				minExt = vertPos.clone();
			}
			
			if (vertPos.x > maxExt.x && vertPos.y > maxExt.y && vertPos.z > maxExt.z) {
				maxExt = vertPos.clone();
			}
		}
		
		return new BoundingBox (minExt, maxExt);
	}
}