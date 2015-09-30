package physics;

import objects.GameObject;
import objects.Transform;
import events.Vec3DEventDispatcher;
import events.Vec3DEvent;
import openfl.events.Event;
import com.babylonhx.math.Vector3;
import physics.bounding.BoundingBox;
import physics.bounding.BoundingSphere;
import physics.bounding.BoundingVolume;
import physics.bounding.BoundingPlane;

/**
 * ...
 * @author Lucas Gonçalves
 */
class RigidBody
{
	public var mass:Float;
	public var drag:Float;
	
	public var massCenter:Vector3;
	
	public var velocity:Vector3;
	
	public var isKinematic:Bool = false;
	public var lockRotationX:Bool = false;
	public var lockRotationY:Bool = false;
	public var lockRotationZ:Bool = false;
	
	public var lockPositionX:Bool = false;
	public var lockPositionY:Bool = false;
	public var lockPositionZ:Bool = false;
	
	//public var boundingVolumes:Array<BoundingVolume>;
	
	public var transform:Transform;
	
	public var gameObject:GameObject;
	
	public var isGrounded (default, null):Bool = false;
	
	public var isSimulating (default, null):Bool = false;
	
	public function new(gameObject:GameObject = null) 
	{			
		if (World.instance != null) {
			World.rigidBodies.push(this);
			
			//boundingVolumes = new Array ();
			//this.gameObject = gameObject;
			if (gameObject != null) {
				attachGameObject(gameObject);
				//gameObject.attachRigidBody(this);
			}
			
			
			massCenter = new Vector3 ();
			velocity = new Vector3 ();
			
			Vec3DEventDispatcher.instance.addEventListener (Vec3DEvent.PHYSICS_UPDATE, step);
		} else {
			throw "Cannot instantiate RigidBody without a World instance...";
		}
	}
	
	private function step (r:Event) {
		if (gameObject != null) {
			//updatePosition();

			//gameObject.physicsUpdate ();
		}
	}
	
	public function simulate () {
		updateTransform ();
		
		//updateBoundingVolumesTransform ();
		
		gameObject.physicsUpdate();
	}
	
	public function checkCollisions () {
		for (thisCollider in gameObject.boundingVolumes) {
			for (otherCollider in World.boundingVolumes) {
				if (otherCollider.gameObject != this.gameObject) {
					var col:Collision = new Collision();
					switch (otherCollider.type) {
						case BoundingVolumeType.SPHERE:
							col = thisCollider.checkSphereCollision(cast(otherCollider, BoundingSphere));
						case BoundingVolumeType.BOX:
							col = thisCollider.checkBoxCollision(cast(otherCollider, BoundingBox));
						case BoundingVolumeType.MESH:
							
						case BoundingVolumeType.PLANE:
							col = thisCollider.checkPlaneCollision(cast(otherCollider, BoundingPlane));
						default:
							col = thisCollider.checkBoxCollision(cast(otherCollider, BoundingBox));
					}
					
					if (col.isColliding) {
						thisCollider.gameObject.rigidBody.velocity = Vector3.Zero();
						//otherCollider.gameObject.rigidBody.velocity = col.direction.negate();
						
						World.collisionsToHandle.push(col);
						thisCollider.onCollision(col);
					}
				}
			}
		}
	}
	
	private function updateTransform () {
		//var stepForce:Vector3 = velocity.add(World.gravity);
		
		var stepForce:Vector3 = velocity.clone ();
		
		//trace (velocity);
		
		transform.translate(stepForce);
		
		decayVelocity();
	}
	
	private function updateBoundingVolumesTransform () {
		//for (bVolume in boundingVolumes) {
		//	bVolume.updateCenterPosition (transform.position);
		//}
	}
	
	private function decayVelocity () {
		//velocity = velocity.multiplyByFloats ();
	}
	
	public function attachBoundingVolume (boundingVolume:BoundingVolume) {
		//boundingVolumes.push(boundingVolume);
	}
	
	public function attachGameObject (gameObject:GameObject) {
		this.gameObject = gameObject;
		
		transform = new Transform ();
				
		transform.transformMatrix = gameObject.transform.transformMatrix.clone();
		transform.decomposeTrasformMatrix ();
	}
	
	public function startSimulation () {
		isSimulating = true;
	}
	
	public static function startAllRigidBodies () {
		for (rb in World.rigidBodies) {
			rb.startSimulation ();
		}
	}
}