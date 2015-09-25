package objects;
import com.babylonhx.math.Vector3;
import events.Vec3DEvent;
import events.Vec3DEventDispatcher;
import openfl.events.Event;

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
		
			//this.transform.position = position;
			
			this.transform.translate(position);
			
			//transform.rotate(new Vector3(-90, 0, 0));
			//transform.rotation.y -= 0.26;
			
			//transform.rotation.
			
			if(name != ""){
				this.name = name;	
			} else {
				this.name = "camera_" + Engine.instance.currentScene.cameras.length;
			}
			
			this.facingPoint = target;
			
			Vec3DEventDispatcher.instance.addEventListener(Vec3DEvent.UPDATE, update);
		} else {
			throw "Scene not instantiated...";
		}
		
		
	}
	
	public function update (e:Event) {
		//transform.update();
	}
	
	private function get_facingPoint ():Vector3 {
		facingPoint = transform.position.add(transform.forward);
		//trace("FP: " + transform.forward);
		return facingPoint;
	}
}