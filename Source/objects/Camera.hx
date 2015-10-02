package objects;
import com.babylonhx.math.Vector3;
import com.babylonhx.math.Matrix;
import events.Vec3DEvent;
import events.Vec3DEventDispatcher;
import openfl.events.Event;
import rendering.Scene;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Camera extends GameObject
{
	public var facingPoint (get, null):Vector3;
	
	public var projectionMatrix (default, null):Matrix;
	public var viewMatrix (default, null):Matrix;
	
	public var fov (default, set):Float = .78;
	public var zNear (default, set):Float = .01;
	public var zFar (default, set):Float = 1000;
	
	public function new(position:Vector3, target:Vector3, name:String = "", scene:Scene = null) {
		if (scene == null && Engine.instance.currentScene != null) {
			scene = Engine.instance.currentScene;
		}
		
		if (scene != null) {
			
			if(name != ""){
				this.name = name;	
			} else {
				this.name = "camera_" + Engine.instance.currentScene.cameras.length;
			}
			
			super(name, null, scene);
			scene.cameras.push(this);
			transform.position = position;
			this.facingPoint = target;
			
			viewMatrix = Matrix.LookAtLH(this.transform.position, this.facingPoint, Vector3.Up());
			projectionMatrix =  Matrix.PerspectiveFovLH(fov, Engine.canvas.stage.stageWidth / Engine.canvas.stage.stageHeight, zNear, zFar);
			
			Vec3DEventDispatcher.instance.addEventListener(Vec3DEvent.UPDATE, update);
		} else {
			throw "Scene not instantiated...";
		}
	}
	
	public override function update (e:Event) {
		super.update(e);
		
		viewMatrix = Matrix.LookAtLH(this.transform.position, this.facingPoint, Vector3.Up());
	}
	
	private function set_fov (value:Float):Float {
		fov = value;
		projectionMatrix =  Matrix.PerspectiveFovLH(fov, Engine.canvas.stage.stageWidth / Engine.canvas.stage.stageHeight, zNear, zFar);
		
		return fov;
	}
	
	private function set_zNear (value:Float):Float {
		zNear = value;
		projectionMatrix =  Matrix.PerspectiveFovLH(fov, Engine.canvas.stage.stageWidth / Engine.canvas.stage.stageHeight, zNear, zFar);
		
		return zNear;
	}
	
	private function set_zFar (value:Float):Float {
		zFar = value;
		projectionMatrix =  Matrix.PerspectiveFovLH(fov, Engine.canvas.stage.stageWidth / Engine.canvas.stage.stageHeight, zNear, zFar);
		
		return zFar;
	}
	
	private function get_facingPoint ():Vector3 {
		facingPoint = transform.position.add(transform.forward);
		//trace("FP: " + transform.forward);
		return facingPoint;
	}
}