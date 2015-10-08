package objects;
import com.babylonhx.math.Vector2;
import com.babylonhx.math.Vector3;
import com.babylonhx.math.Vector4;
import com.babylonhx.math.Matrix;
import events.Vec3DEvent;
import events.Vec3DEventDispatcher;
import math.Vec4D;
import openfl.events.Event;
import physics.Ray;
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
		
		if (scene != null) {
			if (scene.activeCamera == this) {
				viewMatrix = Matrix.LookAtLH(this.transform.position, this.facingPoint, Vector3.Up());
				
				projectionMatrix =  Matrix.PerspectiveFovLH(fov, Engine.canvas.stage.stageWidth / Engine.canvas.stage.stageHeight, zNear, zFar);
			}
		}
	}
	
	public function viewportToWorldCoordinates (viewPortX:Float, viewPortY:Float):Vector3 {
		var vpMatrix:Matrix = viewMatrix.multiply(projectionMatrix);
		vpMatrix.invert();
		
		//var x:Float = ((2.0 * viewPortX) / (Engine.canvas.stage.stageWidth - 1.0)) - 1.0;
		
		var x:Float = ((viewPortX  * 2 )/ (Engine.canvas.stage.stageWidth - 0)) - 1.0;
		//NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
		//var x:Float = ((viewPortX + 1) / 2 ) * Engine.canvas.stage.stageWidth  ;
		var y:Float = 1.0 - (2.0 * (viewPortY / Engine.canvas.stage.stageHeight));
		var z:Float = 1.0;
		var w:Float = 1.0;

        var vIn:Vector4 = new Vector4 (x, y, z, w);
		
		var pos:Vector4 = Vec4D.MultiplyByMatrix(vIn, vpMatrix);
		
		var worldPosition:Vector3 = new Vector3 (pos.x * pos.w, pos.y * pos.w, pos.z * pos.w);

		return worldPosition;
	}
	
	public function worldCoordinatesToViewpost (worldCoordinates:Vector3):Vector2 {
		
		
		
		var resultVector:Vector2 = new Vector2 (0, 0);
		return resultVector;
	}
	
	public function screenPointToRay (screenX:Float, screenY:Float, screenZ:Float):Ray {
		var eyePoint:Vector3 = this.transform.position.clone ();
		var worldPoint:Vector3 = this.viewportToWorldCoordinates(screenX, screenY);
		
		var relWorldPoint:Vector3 = worldPoint.subtract(eyePoint);
		
		var ray:Ray = new Ray(eyePoint, relWorldPoint.normalize(), zFar);
		return ray;
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