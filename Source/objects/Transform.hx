package objects;

import math.Matrix;
import math.Vector3;
import math.Quaternion;
import math.Vec3D;
import objects.GameObject;
import utils.SimpleMath;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Transform
{
	public var transformMatrix (default, set):Matrix;
	
	public var position (default, set) :Vector3;
	public var rotation (default, set):Quaternion;
	public var eulerAngles (default, default):Vector3;
	private var eulerAnglesRad:Vector3;
	public var scale (default, set):Vector3;
	
	public var forward (default, null):Vector3;
	public var up (default, null):Vector3;
	public var right (default, null):Vector3;
	
	public var localPosition:Vector3;
	public var localRotation:Quaternion;
	public var localScale:Vector3;
	public var localEulerAngles:Vector3;
	public var localTransformMatrix:Matrix;
	
	public var pivotPoint:Vector3;
	
	private var initialized:Bool = false;
	
	public var gameObject:GameObject;
	
	public function new(gameObj:GameObject = null) 
	{
		transformMatrix = Matrix.Identity();
		
		position = new Vector3 ();
		scale = new Vector3 ();
		rotation = new Quaternion ();
		
		eulerAnglesRad = new Vector3 ();
		eulerAngles = new Vector3 ();
		
		forward = new Vector3 ();
		up = new Vector3 ();
		right = new Vector3 ();
		
		localRotation = new Quaternion ();
		localPosition = new Vector3 ();
		localScale = new Vector3 ();
		localEulerAngles = new Vector3();
		localTransformMatrix = Matrix.Identity();
		
		pivotPoint = new Vector3 ();
		
		this.gameObject = gameObj;
		
		initialized = true;
		decomposeTrasformMatrix();
	}
	
	public function rotate (angles:Vector3) {
		
		var previousPosition = position.clone();
		
		//translate(position.negate());
		transformMatrix.setTranslation(Vector3.Zero());
		
		var anglesRad:Vector3 = SimpleMath.toRadVector(angles);
		
		var rotationMatrix:Matrix = Matrix.RotationYawPitchRoll(anglesRad.y, anglesRad.x, anglesRad.z);
		
		transformMatrix = transformMatrix.multiply(rotationMatrix);
		
		transformMatrix.setTranslation(previousPosition);

		decomposeTrasformMatrix();
	
	}
	
	public function translate (translation:Vector3) {
		
		if ( translation.equals( Vector3.Zero() ) ) {
			return;
		}
		
		var rotQuaternion:Quaternion = Quaternion.Inverse (rotation);
		//var rotQuaternion:Quaternion = rotation.clone();
		
		var newPosition:Vector3 = rotQuaternion.multVector(translation);
		
		//trace(newPosition);
		
		var translationMatrix:Matrix = Matrix.Translation(newPosition.x, newPosition.y, newPosition.z);
		
		transformMatrix = transformMatrix.multiply(translationMatrix);
		
		decomposeTrasformMatrix();
	}
	
	public function smoothMove () {
		
		
		
	}
	
	public function update () {
		//trace(position);
	}
	
	public function rotateAroundPoint (point:Vector3, axis:Vector3, degrees:Float) {
		
		var previousPosition = position.clone ();		
		var previousRotation = rotation.clone();
		
		transformMatrix.setTranslation(point);
		
		var rotationInRad:Vector3 = SimpleMath.toRadVector (axis.multiplyByFloats(degrees, degrees, degrees));
		
		//rotate(rotationInRad);
		
		var rotMatrix:Matrix = Matrix.RotationYawPitchRoll (rotationInRad.y, rotationInRad.x, rotationInRad.z);
		
		rotMatrix.setTranslation (previousPosition);
		
		transformMatrix = transformMatrix.multiply(rotMatrix);
		
		//translate(previousPosition.subtract(point).negate());
		//transformMatrix.setTranslation(previousPosition);
		//translate.setRotation
		//transformMatrix = Matrix.Compose(scale, previousRotation, position);
		
		//trace(Vector3.Distance(point, previousPosition));
		
		decomposeTrasformMatrix();
	}
	
	public function updateChildTransform () {
		
		position = localPosition.add(gameObject.parent.transform.position);
		rotation = localRotation.multiply(gameObject.parent.transform.rotation);
		scale = localScale.add(gameObject.parent.transform.scale);
		
		composeTransformMatrix();
		
		decomposeTrasformMatrix();
	}
	
	public function decomposeTrasformMatrix () {
		transformMatrix.decompose(scale, rotation, position);
		
		if (gameObject != null) {
			if(gameObject.parent != null) {
				localTransformMatrix.decompose(localScale, localRotation, localPosition);
			}
		}
		
		forward = new Vector3 (transformMatrix.m[2], transformMatrix.m[6], transformMatrix.m[10]).normalize();
		right = new Vector3 (transformMatrix.m[0], transformMatrix.m[4], transformMatrix.m[8]).normalize();
		up = new Vector3 (transformMatrix.m[1], transformMatrix.m[5], transformMatrix.m[9]).normalize();
		eulerAnglesRad = rotation.toEulerAngles();
		eulerAngles = SimpleMath.toDegreeVector(rotation.toEulerAngles());
		
		pivotPoint = position.clone();

		if (gameObject != null) {
			if (gameObject.children != null) {
				for (child in gameObject.children) {
					child.transform.updateChildTransform ();
				}
			}
			
			gameObject.updateBoundingVolumesTransform ();
		}
		
		var inverseTransform:Matrix = transformMatrix.clone();
		inverseTransform.invert();
		
		//localTransformMatrix = transformMatrix.multiply(inverseTransform);
	}
	
	public function initiateLocalTransform () {
		localPosition = position.subtract(gameObject.parent.transform.position);
		localScale = scale.subtract(gameObject.parent.transform.scale);
		localRotation = rotation.multiply(gameObject.parent.transform.rotation);
		
		composeLocalTransformMatrix ();
	}
	
	private function composeTransformMatrix () {
		transformMatrix = Matrix.Compose(scale, rotation, position);
	}
	
	private function composeLocalTransformMatrix () {
		localTransformMatrix = Matrix.Compose (localScale, localRotation, localPosition);
	}
	
	private function set_position (value:Vector3):Vector3 {
		if (position != null){
			position = value.clone();
			composeTransformMatrix();
			decomposeTrasformMatrix();
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
	
	/*private function set_eulerAngles (value:Vector3):Vector3 {
		rotation = SimpleMath.toRadVector(value).toQuaternion();
		
		return _eulerAngles;
	}*/
	
	private function get_eulerAngles ():Vector3 {
		return eulerAngles;
	}

	private function set_scale (value:Vector3):Vector3 {
		if (scale != null) {
			scale = value;
			composeTransformMatrix();
			decomposeTrasformMatrix ();
		} else {
			scale = value;
		}
		if(initialized){
			//decomposeTrasformMatrix();
		}
		
		return scale;
	}
	
	private function set_transformMatrix (value:Matrix):Matrix {
		transformMatrix = value;
		
		if (transformMatrix != null && initialized){
			//decomposeTrasformMatrix ();
		}
		
		return transformMatrix;
	}
	
	private function multiplyByTransformMatrix (vector:Vector3):Vector3 {
		var result:Vector3 = new Vector3 ();
		
		var x:Float = vector.x * transformMatrix.m[0] + vector.y * transformMatrix.m [4] + vector.z + transformMatrix.m[8];
		var y:Float = vector.x * transformMatrix.m[1] + vector.y * transformMatrix.m [5] + vector.z + transformMatrix.m[9];
		var z:Float = vector.x * transformMatrix.m[2] + vector.y * transformMatrix.m [6] + vector.z + transformMatrix.m[10];
		//var w:Float = transformMatrix.m[3] + transformMatrix.m[7] + transformMatrix.m[11] + transformMatrix.m[15];
		
		result.x = x ;
		result.y = y ;
		result.z = z ;
		
		return result;
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