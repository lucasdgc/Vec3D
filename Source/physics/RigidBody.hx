package physics;

import objects.GameObject;
import objects.Transform;
import events.Vec3DEventDispatcher;
import events.Vec3DEvent;
import openfl.events.Event;
import com.babylonhx.math.Vector3;
import physics.BoundingVolume;

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
	
	public var boundingVolumes:Array<BoundingVolume>;
	
	public var transform:Transform;
	
	public var gameObject:GameObject;
	
	public var isGrounded (default, null):Bool = false;
	
	public var isSimulating (default, null):Bool = false;
	
	public function new(gameObject:GameObject = null) 
	{			
		if (World.instance != null) {
			World.rigidBodies.push(this);
			
			boundingVolumes = new Array ();
			this.gameObject = gameObject;
			if (this.gameObject != null) {
				transform = new Transform (this.gameObject);
				gameObject.attachRigidBody(this);
				
				transform.transformMatrix = gameObject.transform.transformMatrix.clone();
				transform.decomposeTrasformMatrix ();
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
		
		updateBoundingVolumesTransform ();
	}
	
	public function checkCollisions () {
		for (thisCollider in boundingVolumes) {
			for (otherCollider in World.boundingVolumes) {
				if (otherCollider.rigidBody != this) {
					switch (otherCollider.type) {
						case BoundingVolumeType.SPHERE:
							thisCollider.checkSphereCollision(cast(otherCollider, BoundingSphere));
						case BoundingVolumeType.BOX:
							
						case BoundingVolumeType.MESH:
							
						case BoundingVolumeType.PLANE:
							
						default:
							
					}
				}
			}
		}
	}
	
	private function updateTransform () {
		var stepForce:Vector3 = velocity.add(World.gravity);
		
		transform.translate(stepForce);
	}
	
	private function updateBoundingVolumesTransform () {
		for (bVolume in boundingVolumes) {
			//bVolume.center.addInPlace(transform.position);
			//bVolume.center = bVolume.center.add (transform.position);
			bVolume.center = transform.position.add(bVolume.relativeCenter);
		}
	}
	
	private function decayVelocity () {
		
	}
	
	public function attachBoundingVolume (boundingVolume:BoundingVolume) {
		boundingVolumes.push(boundingVolume);
	}
	
	public function startSimulation () {
		isSimulating = true;
	}
}