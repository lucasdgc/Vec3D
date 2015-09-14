package;
import com.babylonhx.math.Vector3;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Camera
{
	public static var camerasList:Array<Camera> = new Array();
	
	public var position:Vector3;
	public var target:Vector3;
	
	public var name:String;
	
	public function new(){
		//camerasList.push(this);
		
		//trace(camerasList.length);
	}
	
}