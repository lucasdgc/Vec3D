package;

import input.InputAxis;
import math.Matrix;
import math.Quaternion;
import math.Vector3;
import objects.GameObject;
import openfl.events.Event;
import rendering.Mesh;
import rendering.primitives.Primitives;
import rendering.Scene;
import utils.SimpleMath;
import utils.Time;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Adjusts extends Scene
{
	private var cube1:GameObject;
	private var cube2:GameObject;
	private var cube3:GameObject;
	private var cube4:GameObject;
	
	private var sphere:GameObject;
	
	private var distance:Float = 0;
	
	private var centerPoint:Vector3;
	private var timer:Float = 0;
	
	public function new () 
	{
		super();
		
		trace ("isntanciantdo..");
		
		centerPoint = new Vector3 ( 0, 0, 0 );
		
		var cubeMesh:Mesh = Primitives.createCube();
		cube1 = new GameObject ( "cube1", cubeMesh, this );
		cube1.transform.position = new Vector3 (1.2, 1, 0);
		
		cube2 = new GameObject ( "cube2", cubeMesh.clone(), this );
		cube2.transform.position = new Vector3 (-1.2, -1, 0);
		
		cube3 = new GameObject ( "cube3", cubeMesh.clone(), this );
		cube3.transform.position = new Vector3 (-1.2, 1, 0);
		
		cube4 = new GameObject ( "cube4", cubeMesh.clone(), this );
		cube4.transform.position = new Vector3 (1.2, -1, 0);
		
		var sphereMesh:Mesh = Primitives.createSphere (4, 0.15);
		sphere = new GameObject ("sphere1", sphereMesh, this);
		sphere.transform.position = centerPoint.clone();
	
		distance = Vector3.Distance (cube1.transform.position, centerPoint);
		
	}
	
	override public function update ( event:Event ) 
	{
		super.update ( event );

		var h:Float = InputAxis.getValue ( "Horizontal" );
		var v:Float = InputAxis.getValue ( "Vertical" );
		var arrowH:Float = InputAxis.getValue ( "CameraX" );
		var moveSpeed:Float = 1 * Time.deltaTime;
		var rotationSpeed:Float = 50 * Time.deltaTime;
		
		//cube1.transform.translate ( new Vector3 ( h, v, 0 ).multiplyByFloat( moveSpeed ) );
		
		//cube1.transform.position = cube1.transform.position.add ( new Vector3 ( h, v, 0 ).multiplyByFloat( moveSpeed ) );
		
		sphere.transform.translate ( new Vector3 ( h, v, 0 ).multiplyByFloat ( moveSpeed ) );
		
		moveObject (cube1, rotationSpeed);
		moveObject (cube2, rotationSpeed);
		moveObject (cube3, rotationSpeed);
		moveObject (cube4, rotationSpeed);
		
	}
	
	private function moveObject (obj:GameObject, rotationSpeed:Float) {
		obj.transform.rotateAroundPoint ( sphere.transform.position, Vector3.Forward (), rotationSpeed );
		obj.transform.rotateAroundPoint ( sphere.transform.position, Vector3.Right (), rotationSpeed );
		
		rotateAround ( obj );
		//obj.transform.rotate ( new Vector3 ( 0, 15, 0 ) );
	}
	
	private function rotateAround ( obj:GameObject ) {
		var relPosition:Vector3 =  sphere.transform.position.subtract ( obj.transform.position );
		var targetRotation:Quaternion = Quaternion.LookRotation ( relPosition );
		obj.transform.rotation =  Quaternion.Slerp ( obj.transform.rotation, targetRotation, 0.1 );
	}
}