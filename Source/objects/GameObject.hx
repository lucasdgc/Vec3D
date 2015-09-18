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
	//public static var gameObjectsList:Array<GameObject> = new Array();
	
	public var isVisible:Bool = true;
	
	public var name:String;
	public var position:Vector3;
	public var rotation:Vector3;
	
	public var mesh:rendering.Mesh;
	
	public var scene:Scene;
	
	public function new(name:String = "", mesh:String = "", position:Vector3 = null, rotation:Vector3 = null) {
		if(Engine.instance.currentScene != null) {
			Engine.instance.currentScene.gameObject.push(this);
			
			scene = Engine.instance.currentScene;
			
			if(name != ""){
				this.name = name;
			} else {
				this.name = "gameObject_";// + gameObjectsList.length;
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
			
			if (mesh != "") {
				if(mesh == rendering.primitives.Primitives.CUBE){
					this.mesh = new rendering.primitives.Cube ().mesh;
				}
				else {
					this.mesh = Mesh.loadMeshFile(mesh);
					//this.mesh.drawFaces = false;
					//this.mesh.drawEdges = false;
					//this.mesh.drawPoints = true;
				}
				
				this.mesh.gameObject = this;
			}
		} else {
			throw "Scene not instantiated...";
		}
		
	}
	
}