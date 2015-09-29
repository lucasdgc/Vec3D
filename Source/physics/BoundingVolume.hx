package physics;

import com.babylonhx.math.Vector3;

/**
 * ...
 * @author Lucas Gonçalves
 */
class BoundingVolume
{
	public var rigidBody:RigidBody;
	public var vertices:Array<Vector3>;
	
	public function new(rigidBody:RigidBody) 
	{
		this.rigidBody = rigidBody;
	}
}