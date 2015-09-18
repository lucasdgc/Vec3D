package objects;
import com.babylonhx.math.Vector3;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Camera
{
	//public static var camerasList:Array<Camera> = new Array();
	//public static var mainCamera:
	
	public var position:Vector3;
	public var target:Vector3;
	
	public var name:String;
	
	public function new(position:Vector3, target:Vector3, name:String = "") {
		if(Engine.instance.currentScene != null){
			Engine.instance.currentScene.cameras.push(this);
		
			if(name != ""){
				this.name = name;	
			} else {
				this.name = "camera_" + Engine.instance.currentScene.cameras.length;
			}
			
			this.position = position;
			this.target = target;
		} else {
			throw "Scene not instantiated...";
		}
	}
	
}