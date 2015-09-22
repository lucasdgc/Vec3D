package objects;
import com.babylonhx.math.Vector3;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Camera
{
	public var facingPoint (get, null):Vector3;
	
	public var name:String;
	public var transform:Transform;
	
	public function new(position:Vector3, target:Vector3, name:String = "") {
		if(Engine.instance.currentScene != null){
			Engine.instance.currentScene.cameras.push(this);
			
			transform = new Transform ();
		
			this.transform.position = position;
			
			transform.rotate(-90, 0, 0);
			
			if(name != ""){
				this.name = name;	
			} else {
				this.name = "camera_" + Engine.instance.currentScene.cameras.length;
			}
			
			this.facingPoint = target;
		} else {
			throw "Scene not instantiated...";
		}
	}
	
	private function get_facingPoint ():Vector3 {
		facingPoint = transform.position.add(transform.forward.multiplyByFloats(10, 10, 10));
		return facingPoint;
	}
}