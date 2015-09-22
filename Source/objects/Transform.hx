package objects;

import com.babylonhx.math.Matrix;
import com.babylonhx.math.Vector3;
import com.babylonhx.math.Quaternion;
import utils.SimpleMath;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Transform
{
	public var transformMatrix (default, null):Matrix;
	
	public var position (default, set) :Vector3;
	
	public var rotation (default, set):Quaternion;
	public var eulerAngles (get, set):Vector3;
	
	public var scale (default, set):Vector3;
	
	public var forward (default, null):Vector3;
	public var up (default, null):Vector3;
	public var right (default, null):Vector3;
	
	private var initialized:Bool = false;
	
	var tempRot:Vector3 = new Vector3 ();
	
	public function new() 
	{
		transformMatrix = Matrix.Identity();
		
		position = new Vector3 ();
		scale = new Vector3 ();
		rotation = new Quaternion ();
		
		forward = new Vector3 ();
		up = new Vector3 ();
		right = new Vector3 ();
		
		initialized = true;
		decomposeTrasformMatrix();
	}
	
	public function rotate (x:Float, y:Float, z:Float) {
		/*var newRot:Vector3 = new Vector3 (eulerAngles.x + x, eulerAngles.y + y, eulerAngles.z + z);		
		eulerAngles = newRot;*/
		tempRot.addInPlace(new Vector3 (x, y, z));
		
		tempRot = SimpleMath.toRadVector(tempRot);
		
		trace(tempRot.y);
		//transformMatrix = Matrix.RotationYawPitchRoll(newRot.y, newRot.x, newRot.z).multiply(Matrix.Translation(Engine.instance.currentScene.activeCamera.target.x, Engine.instance.currentScene.activeCamera.target.y, Engine.instance.currentScene.activeCamera.target.z));
		//Engine.instance.currentScene.activeCamera.target = SimpleMath.matrixToPosition(transformMatrix);
		
		//trace(Engine.instance.currentScene.activeCamera.target);
		//trace(rotationEulerAngles);
	}
	
	public function translate () {
		
	}
	
	public function smoothMove () {
		
	}
	
	private function decomposeTrasformMatrix () {
		transformMatrix.decompose(scale, rotation, position);
		
		forward = new Vector3 (transformMatrix.m[2], transformMatrix.m[6], transformMatrix.m[10]).normalize();
		up = new Vector3 (transformMatrix.m[0], transformMatrix.m[4], transformMatrix.m[8]).normalize();
		right = new Vector3 (transformMatrix.m[1], transformMatrix.m[5], transformMatrix.m[9]).normalize();
		//trace("new rot: " + eulerAngles);
	}
	
	private function composeTransformMatrix () {
		transformMatrix = Matrix.Compose(scale, rotation, position);
	}
	
	private function set_position (value:Vector3):Vector3 {
		if (position != null){
			position = value.clone();
			composeTransformMatrix();
			decomposeTrasformMatrix ();
		} else {
			position = value;
		}
		
		if(initialized){
			//decomposeTrasformMatrix();
		}
		
		//trace("seta???");
		return position;
	}
	
	private function set_rotation (value:Quaternion):Quaternion {
		if (rotation != null) {
			rotation = value;
			composeTransformMatrix();
			decomposeTrasformMatrix ();
		} else {
			rotation = value;
		}
		
		if(initialized){
			//decomposeTrasformMatrix();
		}
		
		return rotation;
	}
	
	public function get_eulerAngles ():Vector3 {
		return SimpleMath.toDegreeVector(rotation.toEulerAngles());
	}
	
	private function set_eulerAngles (value:Vector3):Vector3 {
		value = SimpleMath.toRadVector(value);
		rotation = value.toQuaternion();
		
		return value;
	}
	
	private function set_scale (value:Vector3):Vector3 {
		if (scale != null) {
			scale = value;
			composeTransformMatrix();
		} else {
			scale = value;
		}
		if(initialized){
			//decomposeTrasformMatrix();
		}
		
		return scale;
	}
	
	/*public function get_forward ():Vector3 {
		return new Vector3 (transformMatrix.m[2], transformMatrix.m[6], transformMatrix.m[10]).normalize();
	}
	
	public function get_right ():Vector3 {
		return new Vector3 (transformMatrix.m[1], transformMatrix.m[5], transformMatrix.m[9]).normalize();
	}
	
	public function get_up ():Vector3 {
		return  new Vector3 (transformMatrix.m[0], transformMatrix.m[4], transformMatrix.m[8]).normalize();
	}*/
}