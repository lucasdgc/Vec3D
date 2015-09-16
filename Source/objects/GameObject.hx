package objects;

import com.babylonhx.math.Vector3;
import rendering.Mesh;
import rendering.primitives.Cube;
import rendering.primitives.Primitives;
/**
 * ...
 * @author Lucas Gonçalves
 */
class GameObject
{
	public static var gameObjectsList:Array<GameObject> = new Array();
	
	public var isVisible:Bool = true;
	
	public var name:String;
	public var position:Vector3;
	public var rotation:Vector3;
	
	public var mesh:rendering.Mesh;
	
	public function new(name:String = "", mesh:String = "", position:Vector3 = null, rotation:Vector3 = null) {
		gameObjectsList.push(this);
		
		if(name != ""){
			this.name = name;
		} else {
			this.name = "gameObject_" + gameObjectsList.length;
		}
		
		if (position != null){
			this.position = position;
		} else {
			this.position = new Vector3();
		}
		
		if (rotation != null){
			this.rotation = rotation;
		} else {
			this.rotation = new Vector3();
		}
		
		if (mesh != "") {
			if(mesh == rendering.primitives.Primitives.CUBE){
				this.mesh = new rendering.primitives.Cube ().mesh;
			}
			else {
				this.mesh = rendering.Mesh.loadMeshFile(mesh);
			}
			
			this.mesh.gameObject = this;
		}
		
		
	}
	
}