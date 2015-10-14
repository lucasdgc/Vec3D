package objects;

import math.Vector3;
import math.Matrix;
import events.Vec3DEvent;
import events.Vec3DEventDispatcher;
import openfl.events.Event;
import physics.RigidBody;
import rendering.Mesh;
import rendering.primitives.Cube;
import rendering.primitives.Primitives;
import rendering.Scene;
import physics.bounding.BoundingVolume;

/**
 * ...
 * @author Lucas Gonçalves
 */
 
class GameObject
{
	public var isVisible:Bool = true;
	
	public var isStatic:Bool;
	
	public var name:String;
	public var position:Vector3;
	public var rotation:Vector3;
	public var scale  (default, set) :Vector3;
	
	public var mesh:Mesh;
	
	public var scene:Scene;
	
	public var parent (default, set):GameObject;
	
	public var children:Array<GameObject>;
	
	public var transform:Transform;
	
	public var rigidBody (get, null):RigidBody;
	
	public var boundingVolumes:Array<BoundingVolume>;
	
	public function new(name:String = "", mesh:Mesh = null, scene:Scene = null, isStatic:Bool = false) {
		if (scene == null && Engine.instance.currentScene != null) {
			scene = Engine.instance.currentScene;
		}
		
		if (scene != null) {
			
			this.scene = scene;
			
			this.scene.gameObject.push(this);
			
			this.isStatic = isStatic;
			
			if(name != ""){
				this.name = name;
			} else {
				this.name = "gameObject_"+scene.gameObject.length;
			}
			
			position = new Vector3 ();
			
			rotation = new Vector3 ();
			
			this.mesh = mesh;
			
			if (this.mesh != null) {
				this.mesh.gameObject = this;
				
				this.mesh.bindMeshBuffers();
			}

			parent = null;
			children = new Array();
			
			transform = new Transform(this);
			
			boundingVolumes = new Array ();
			
			//trace("bounding array ok for: "+name);
			
			Vec3DEventDispatcher.instance.addEventListener (Vec3DEvent.UPDATE, update);
		} else {
			
			throw name +" Scene not instantiated...";
		}
		
		rigidBody = null;
	}
	
	public function destroy () {
		scene.gameObject.remove(this);
		
		scene = null;
		
		if (this.mesh != null) {
			mesh.destroy();
		}
	}
	
	private function set_parent (value:GameObject):GameObject {
		
		parent = value;
		
		if (parent != null) {
			trace ("set parent...");
			
			parent.children.push(this);	
			transform.initiateLocalTransform ();
		}
		
		return value;
	}
	
	public function update (e:Event) {
		for (bVolue in boundingVolumes) {
			bVolue.updateCenterPosition (transform.position);
		}
	}
	
	public function physicsUpdate () {
		if (this.rigidBody != null) {
			this.transform.transformMatrix = rigidBody.transform.transformMatrix.clone();
			this.transform.decomposeTrasformMatrix ();
		}
	}
	
	public function updateBoundingVolumesTransform () {
		if (boundingVolumes != null) {
			for (bVolume in boundingVolumes) {
				bVolume.updateCenterPosition (transform.position);
			}
		}
	}
	
	public function set_scale (value:Vector3):Vector3 {
		if (value.x < 1) {
			value.x = 1;
		}
		
		if (value.y < 1) {
			value.y = 1;
		}
		
		if (value.z < 1) {
			value.z = 1;
		}
		
		this.scale = value.clone ();
		
		scaleObjectMesh ();
		
		return this.scale;
	}
	
	public function scaleObjectMesh () {
		for (vert in mesh.vertices) {
			vert.x = vert.x * scale.x;
			vert.y = vert.y * scale.y;
			vert.z = vert.z * scale.z;
		}
		
		mesh.bindMeshBuffers();
	}
	
	public function attachRigidBody () {
		this.rigidBody = new RigidBody ();
		
		this.rigidBody.attachGameObject(this);
	}
	
	private function get_rigidBody ():RigidBody {
		return this.rigidBody;
	}
	
	public function attachBoundingVolume (bVolume:BoundingVolume) {
		boundingVolumes.push(bVolume);
		
		bVolume.setGameObject(this);
	}
}