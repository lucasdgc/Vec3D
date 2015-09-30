package physics;

import com.babylonhx.math.Vector3;

/**
 * ...
 * @author Lucas Gonçalves
 */
enum BoundingVolumeType {
	BOX;
	SPHERE;
	PLANE;
	MESH;
}
 
class BoundingVolume
{
	public var rigidBody:RigidBody;
	//public var vertices:Array<Vector3>;
	public var center:Vector3;
	public var relativeCenter:Vector3;
	public var type:BoundingVolumeType;
	
	public var isTrigger:Bool = false;
	
	public function new() 
	{
		if (World.instance != null) {
			World.boundingVolumes.push(this);
			
			center = new Vector3 ();
			relativeCenter = new Vector3 ();
			
			//this.rigidBody = rigidBody;
		} else {
			throw "Cannot create Bounding Volume without a World...";
		}
	}
	
	public function setRigidBody (rigidBody:RigidBody) {
		this.rigidBody = rigidBody;
		
		rigidBody.attachBoundingVolume(this);
	}
	
	public function updateCenterPosition (referencePosition:Vector3) {}
	
	public function onCollision (collision:Collision) { 
		//trace (collision.other.rigidBody.gameObject.name);
		//rigidBody.velocity = Vector3.Zero();
	}
	
	public function checkSphereCollision (other:BoundingSphere):Collision { return new Collision (false); }

	public function checkBoxCollision (other:BoundingBox):Collision { return new Collision (false); }

	public function checkPlaneCollision (other:BoundingPlane):Collision { return new Collision (false);  }

	public function checkMeshCollision (other:BoundingMesh):Collision { return new Collision (false); }
}