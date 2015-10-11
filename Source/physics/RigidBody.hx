package physics;

import haxe.ds.Vector;
import objects.GameObject;
import objects.Transform;
import events.Vec3DEventDispatcher;
import events.Vec3DEvent;
import openfl.events.Event;
import math.Vector3;
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
	public var mass:Float = 1;
	public var drag:Float = 1;
	
	public var massCenter:Vector3;
	
	public var velocity:Vector3;
	
	private var previousPosition:Vector3;
	
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
			
			previousPosition = new Vector3 ();
			
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
						var newPos:Vector3 = new Vector3 ();
						
						if (col.direction.x != 0) {
							newPos.x = previousPosition.x;
						} else {
							newPos.x = transform.position.x;
						}
						
						if (col.direction.y != 0) {
							newPos.y = previousPosition.y;
						} else {
							newPos.y = transform.position.y;
						}
						
						if (col.direction.z != 0) {
							newPos.z = previousPosition.z;
						} else {
							newPos.z = transform.position.z;
						}

						this.transform.position = newPos.clone();
						
						//this.transform.position = 
						//thisCollider.gameObject.rigidBody.velocity = Vector3.Zero();
						//otherCollider.gameObject.rigidBody.velocity = col.direction.negate();
						
						World.collisionsToHandle.push(col);
						thisCollider.onCollision(col);
					}
				}
			}
		}
		
		//gameObject.physicsUpdate();
	}
	
	public function addForce (force:Vector3) {
		velocity.addInPlace(force);
	}
	
	private function updateTransform () {
		previousPosition = transform.position.clone ();
		var stepForce:Vector3 = velocity.add(World.gravity);
		
		transform.translate(stepForce);
		
		decayVelocity();
	}
	
	private function updateBoundingVolumesTransform () {
		//for (bVolume in boundingVolumes) {
		//	bVolume.updateCenterPosition (transform.position);
		//}
	}
	
	private function decayVelocity () {
		//trace(v);
		
		var decay:Float = drag / 10;
		velocity = velocity.multiplyByFloats (decay, decay, decay);
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