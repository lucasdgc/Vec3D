package objects;
import com.babylonhx.math.Vector3;
import events.Vec3DEvent;
import events.Vec3DEventDispatcher;
import openfl.events.Event;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Camera extends GameObject
{
	public var facingPoint (get, null):Vector3;
	
	public function new(position:Vector3, target:Vector3, name:String = "") {
		if (Engine.instance.currentScene != null) {
			Engine.instance.currentScene.cameras.push(this);
			
			if(name != ""){
				this.name = name;	
			} else {
				this.name = "camera_" + Engine.instance.currentScene.cameras.length;
			}
			
			super(name);
			
			transform.position = position;
			
			this.facingPoint = target;
			
			Vec3DEventDispatcher.instance.addEventListener(Vec3DEvent.UPDATE, update);
		} else {
			throw "Scene not instantiated...";
		}
		
		
	}
	
	public override function update (e:Event) {
		super.update(e);
	}
	
	private function get_facingPoint ():Vector3 {
		facingPoint = transform.position.add(transform.forward);
		//trace("FP: " + transform.forward);
		return facingPoint;
	}
}