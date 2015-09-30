package physics.bounding;
import objects.GameObject;
import rendering.Mesh;
import com.babylonhx.math.Vector3;

/**
 * ...
 * @author Lucas Gonçalves
 */
class BoundingMesh extends BoundingVolume
{
	var vertices:Array<Vector3>;
	
	public function new() 
	{
		super();
		
		vertices = new Array ();
	}
	
	private function createBoundingMesh (mesh:Mesh):BoundingMesh {
		var bMesh:BoundingMesh = new BoundingMesh ();
		
		for (vert in mesh.vertices) {
			bMesh.vertices.push (vert.clone());
		}
		
		return bMesh;
	}
}