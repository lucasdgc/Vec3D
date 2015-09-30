package physics.bounding;

import com.babylonhx.math.Vector3;
import objects.GameObject;
import physics.bounding.BoundingBox;
import physics.bounding.BoundingMesh;
import physics.bounding.BoundingPlane;
import physics.bounding.BoundingSphere;

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
	//public var rigidBody:RigidBody;
	//public var vertices:Array<Vector3>;
	public var gameObject:GameObject;
	
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
		//this.rigidBody = rigidBody;
		
		//rigidBody.attachBoundingVolume(this);
	}
	
	public function setGameObject (gameObject:GameObject) {
		this.gameObject = gameObject;
		
		//gameObject.attachBoundingVolume(this);
	}
	
	public function updateCenterPosition (referencePosition:Vector3) {}
	
	public function onCollision (collision:Collision) { 
		//trace (collision.other.rigidBody.gameObject.name);
		//rigidBody.velocity = Vector3.Zero();
	}
	
	public function checkSphereCollision (other:BoundingSphere):Collision { throw "CheckSphereCollision must be overriden for all BoundingVolume Types..."; }

	public function checkBoxCollision (other:BoundingBox):Collision { throw "checkBoxCollision must be overriden for all BoundingVolume Types..."; }

	public function checkPlaneCollision (other:BoundingPlane):Collision { throw "checkPlaneCollision must be overriden for all BoundingVolume Types...";  }

	public function checkMeshCollision (other:BoundingMesh):Collision { throw "checkMeshCollision must be overriden for all BoundingVolume Types..."; }
}