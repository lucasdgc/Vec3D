package physics;
import objects.GameObject;

/**
 * ...
 * @author Lucas Gonçalves
 */
class BoundingMesh extends BoundingVolume
{

	public function new(rigidBody:RigidBody) 
	{
		super(rigidBody);
	}
	
	private function createBoundingMesh () {
		for (vert in gameObject.mesh.vertices) {
			vertices.push (vert);
		}
	}
}