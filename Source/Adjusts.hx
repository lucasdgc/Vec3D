package;

import input.InputAxis;
import input.VirtualAnalogStick;
import openfl.geom.Rectangle;
import math.Matrix;
import math.Quaternion;
import math.Vector3;
import objects.GameObject;
import openfl.events.Event;
import rendering.Mesh;
import rendering.Primitives;
import rendering.Scene;
import utils.Color;
import utils.SimpleMath;
import utils.Time;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Adjusts extends Scene
{
	private var cubeArray:Array<GameObject>;
	
	private var cube1:GameObject;
	private var cube2:GameObject;
	private var cube3:GameObject;
	private var cube4:GameObject;
	
	private var sphere:GameObject;
	
	private var distance:Float = 0;
	
	private var centerPoint:Vector3;
	private var timer:Float = 0;
	
	private var previousSpherePosition:Vector3;
	
	private var isPressing:Bool = false;
	private var started:Bool = false;
	
	public function new () 
	{
		super();
		
		//var rectArea:Rectangle = new Rectangle ( Engine.canvas.stage.x, Engine.canvas.stage.y, Engine.canvas.stage.stageWidth, Engine.canvas.stage.stageHeight );
		//var a:VirtualAnalogStick = new VirtualAnalogStick (rectArea, "analogX", "analogY");
		
		cubeArray = new Array ();
		
		centerPoint = new Vector3 ( 0, 0, 0 );
		
		var cubeMesh:Mesh = Primitives.createCube();
		
		/*for ( i in -4...5 ) {
			for ( j in -3...3 ) {
				for ( k in 0...4 ) {
					var cube:GameObject = new GameObject ("cube_" + i + j, cubeMesh.clone(), this);
					cube.transform.position = new Vector3 (i, j, k);
					switch (k) {
						case 0:
							cube.mesh.setVetexGroupColor (0, Color.white);
						case 1:
							cube.mesh.setVetexGroupColor (0, Color.green);
						case 2:
							cube.mesh.setVetexGroupColor (0, Color.red);
						case 3:
							cube.mesh.setVetexGroupColor (0, Color.blue);
					}
					
					cube.transform.rotate ( new Vector3 ( 0, 0, 45) );
					cube.mesh.drawFaces = false;
					
					cubeArray.push(cube);
				}
			}
		}*/
		
		var cubeMesh:Mesh = Primitives.createCube();
		cube1 = new GameObject ( "cube1", cubeMesh, this );
		cube1.transform.position = new Vector3 (1.2, 1, 0);
		
		/*cube2 = new GameObject ( "cube2", cubeMesh.clone(), this );
		cube2.transform.position = new Vector3 (-1.2, -1, 0);
		
		cube3 = new GameObject ( "cube3", cubeMesh.clone(), this );
		cube3.transform.position = new Vector3 (-1.2, 1, 0);
		
		cube4 = new GameObject ( "cube4", cubeMesh.clone(), this );
		cube4.transform.position = new Vector3 (1.2, -1, 0);*/
		
		var sphereMesh:Mesh = Primitives.createSphere (4, 0.15);
		sphere = new GameObject ("sphere1", sphereMesh, this);
		sphere.transform.position = centerPoint.clone();
	
		//sphere.isVisible = false;
		
		previousSpherePosition = sphere.transform.position.clone (); 
		
		trace (cubeArray.length);
		//distance = Vector3.Distance (cube1.transform.position, centerPoint);
		
		Engine.canvas.stage.addEventListener ( MouseEvent.MOUSE_DOWN, onMouseDown );
		Engine.canvas.stage.addEventListener ( MouseEvent.MOUSE_UP, onMouseUp );
	}
	
	private function onMouseDown (e:MouseEvent) {
		isPressing = true;
		
		if (!started) {
			started = true;
		}
	}
	
	
	private function onMouseUp (e:MouseEvent) {
		isPressing = false;
	}
	
	override public function update ( event:Event ) 
	{
		super.update ( event );
		
		if ( isPressing ) {
			var worldPos:Vector3 = activeCamera.viewportToWorldCoordinates ( Engine.canvas.stage.mouseX, Engine.canvas.stage.mouseY );
			sphere.transform.position = new Vector3 ( worldPos.x, worldPos.y, 0 );
		}
		
		//#if !mobile
		/*var h:Float = InputAxis.getValue ( "Horizontal" );
		var v:Float = InputAxis.getValue ( "Vertical" );
		//#else
		//var h:Float = InputAxis.getValue ( "analogX" );
		//var v:Float = InputAxis.getValue ( "analogY" );
		//#end
		var arrowH:Float = InputAxis.getValue ( "CameraX" );
		var moveSpeed:Float = 1 * Time.deltaTime;
		var rotationSpeed:Float = 50 * Time.deltaTime;
		
		//cube1.transform.translate ( new Vector3 ( h, v, 0 ).multiplyByFloat( moveSpeed ) );
		
		//cube1.transform.position = cube1.transform.position.add ( new Vector3 ( h, v, 0 ).multiplyByFloat( moveSpeed ) );
		
		sphere.transform.translate ( new Vector3 ( h, v, 0 ).multiplyByFloat ( moveSpeed ) );
		
		//previousSpherePosition = sphere.transform.position.clone ();
		
		moveObject (cube1, rotationSpeed);
		moveObject (cube2, rotationSpeed);
		moveObject (cube3, rotationSpeed);
		moveObject (cube4, rotationSpeed);*/
		var rotationSpeed:Float = 50 * Time.deltaTime;
		
		moveObject ( cube1, rotationSpeed );
		
		if ( started ) {
			for ( cube in cubeArray ) {
				moveObject ( cube, rotationSpeed );
			}
		}
		previousSpherePosition = sphere.transform.position.clone ();
	}
	
	private function moveObject (obj:GameObject, rotationSpeed:Float) {
		obj.transform.rotateAroundPoint ( sphere.transform.position, Vector3.Forward (), rotationSpeed );
		//obj.transform.rotateAroundPoint ( sphere.transform.position, Vector3.Right (), rotationSpeed );
		
		//obj.transform.rotate ( new Vector3 ( 0, 3, 0 ) );
		//rotateAround ( obj );
	}
	
	private function rotateAround ( obj:GameObject ) {
		var relPosition:Vector3 =  sphere.transform.position.subtract ( obj.transform.position );
		var targetRotation:Quaternion = Quaternion.LookRotation ( relPosition );
		obj.transform.rotation =  Quaternion.Slerp ( obj.transform.rotation, targetRotation, 0.1 );
	}
}