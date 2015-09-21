package objects;

import com.babylonhx.math.Vector3;
import rendering.Mesh;
import rendering.primitives.Cube;
import rendering.primitives.Primitives;
import rendering.Scene;
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
	
	public function new(name:String = "", mesh:Mesh = null, isStatic:Bool = false, position:Vector3 = null, rotation:Vector3 = null) {
		if(Engine.instance.currentScene != null) {
			Engine.instance.currentScene.gameObject.push(this);
			
			scene = Engine.instance.currentScene;
			
			this.isStatic = isStatic;
			
			if(name != ""){
				this.name = name;
			} else {
				this.name = "gameObject_"+scene.gameObject.length;
			}
			
			if (position != null){
				this.position = position;
			} else {
				this.position = Vector3.Zero();
			}
			
			if (rotation != null){
				this.rotation = rotation;
			} else {
				this.rotation = Vector3.Zero();
			}
			
			this.mesh = mesh;
			
			if (this.mesh != null) {
				this.mesh.gameObject = this;
				
				this.mesh.bindMeshBuffers();
			}
			
			/*if (mesh != "") {
				//trace("mesh+string: " + mesh);
				if (mesh == Primitives.CUBE) {
					this.mesh = Primitives.buildCube();
				}
				else {
					this.mesh = Mesh.loadMeshFile(mesh, this);
					if(this.mesh != null && this.isStatic) {
						this.mesh.drawPoints = true;
						this.mesh.drawEdges = true;
						this.mesh.drawFaces = false;
					}
				}
			}*/
		} else {
			throw "Scene not instantiated...";
		}
		
	}
	
	public function destroy () {
		scene.gameObject.remove(this);
		
		scene = null;
		
		if (this.mesh != null) {
			mesh.destroy();
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
	
}