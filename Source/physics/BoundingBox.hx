package physics;
import objects.GameObject;
import rendering.primitives.Primitives;
import com.babylonhx.math.Vector3;

/**
 * ...
 * @author Lucas Gonçalves
 */
class BoundingBox extends BoundingVolume
{
	public function new( 
	{
		super();
		createBoundingBox ();
	}
	
	private function createBoundingBox () {
		var minX:Float = 0;
		var maxX:Float = 0;
		var minY:Float = 0;
		var maxY:Float = 0;
		var minZ:Float = 0;
		var maxZ:Float = 0;
		
		for (vert in gameObject.mesh.vertices) {
			if (vert.x < minX) {
				minX = vert.x;
			}
			
			if (vert.x > maxX) {
				maxX = vert.x;
			}
			
			if (vert.y < minY) {
				minY = vert.y;
			}
			
			if (vert.y > maxY) {
				maxY = vert.y;
			}
			
			if (vert.z < minZ) {
				minZ = vert.z;
			}
			
			if (vert.z > maxZ) {
				maxZ = vert.z;
			}
		}
		
		vertices.push (new Vector3 (minX, minY, minZ));
		vertices.push (new Vector3 (minX, minY, maxZ));
		vertices.push (new Vector3 (minX, maxY, minZ));
		vertices.push (new Vector3 (minX, maxY, maxZ));
		vertices.push (new Vector3 (maxX, minY, minZ));
		vertices.push (new Vector3 (maxX, minY, maxZ));
		vertices.push (new Vector3 (maxX, maxY, minZ));
		vertices.push (new Vector3 (maxX, maxY, maxZ));
	}
}