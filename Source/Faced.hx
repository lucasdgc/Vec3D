package;
import input.InputAxis;
import math.Quaternion;
import math.Vector3;
import objects.GameObject;
import openfl.events.Event;
import rendering.Mesh;
import rendering.Primitives;
import rendering.Scene;
import utils.Color;
import utils.Time;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Faced extends Scene
{
	var cube1:GameObject;
	var squareArray:Array<GameObject>;
	
	public function new() 
	{
		super ();
		
		var cubeMesh:Mesh = Primitives.createCube ();
		cube1 = new GameObject ( "cube1", cubeMesh, this );
		cube1.mesh.drawEdges = false;
		cube1.mesh.drawPoints = true;
		cube1.mesh.drawFaces = true;
		var b:Color = new Color ( Color.BLUE_HEX );
		
		b.a = 150;
		
		cube1.mesh.setVetexGroupColor ( 0, b );
		//cube1.transform.position = new Vector3 ( 1, 1, -20 );
		
		var squareMesh:Mesh = Primitives.createSquare ( 0.1 );
		squareArray = new Array ();
		
		//activeCamera.transform.position = new Vector3 ( 0, 3, -10 );
		
		for ( i in -4...4 ) {
			for ( j in -3...3 ) {
				for ( k in 0...6 ) {
					var sq:GameObject = new GameObject ( "sq_"+i+"_"+j+"_"+k, squareMesh.clone (), this );
					sq.transform.position = new Vector3 ( i, j, k );
					squareArray.push ( sq );
				}
			}
		}
		
		trace ( cube1.mesh.vertexGroups[0] );
	}
	
	override public function update(event:Event) 
	{
		super.update(event);
		
		var h:Float = InputAxis.getValue ( "Horizontal" );
		var v:Float = InputAxis.getValue ( "Vertical" );
		
		var camX:Float = InputAxis.getValue ( "Camera X" );
		var camY:Float = InputAxis.getValue ( "Camera Y" );
		
		var rotationSpeed:Float = 15 * Time.deltaTime;
		var moveSpeed:Float = 10 * Time.deltaTime;
		
		//cube1.transform.translate ( new Vector3 ( h, 0, v ).multiplyByFloat ( moveSpeed ) );
		//activeCamera.transform.rotate ( activeCamera.transform.forward.multiplyByFloat (  rotationSpeed ) );
		//cube1.transform.rotate ( new Vector3 ( camY, - camX, 0 ).multiplyByFloat ( rotationSpeed ) );
		//activeCamera.transform.rotate ( new Vector3 ( camY, - camX, 0 ).multiplyByFloat ( rotationSpeed ) );
		//activeCamera.transform.translate ( new Vector3 ( h, 0, v ).multiplyByFloat ( moveSpeed ) );
		
		
		//cube1.transform.rotate ( new Vector3 ( v, h, 0 ).multiplyByFloat (rotationSpeed)  );
		activeCamera.transform.translate ( new Vector3 ( h, 0, v ).multiplyByFloat ( moveSpeed ) );
		cube1.transform.rotate ( new Vector3 ( camY, 0, 0 ).multiplyByFloat ( rotationSpeed ) );
		cube1.transform.rotateAroundPoint ( cube1.transform.position, Vector3.Up (), rotationSpeed * - camX );
		
		//activeCamera.transform.position = activeCamera.transform.position.add ( new Vector3 ( h, v, 0 ).multiplyByFloat ( moveSpeed ) );
		//rotateCamera ();
		/*for ( sq in squareArray ) {
			rotateObject ( sq );
		}
		rotateObject ( cube1 );*/
		//
		//moveCube ();
	}
	
	private function rotateCamera () {
		var relPosition:Vector3 = cube1.transform.position.subtract ( activeCamera.transform.position );
		var targetRotation:Quaternion = Quaternion.LookRotation ( relPosition );
		activeCamera.transform.rotation = Quaternion.Slerp ( activeCamera.transform.rotation, targetRotation, 1 * Time.deltaTime );
	}
	
	private function rotateObject ( obj:GameObject ) {
		var relPosition:Vector3 = activeCamera.transform.position.subtract ( obj.transform.position );
		var targetRotation:Quaternion = Quaternion.LookRotation ( relPosition );
		obj.transform.rotation = Quaternion.Slerp ( obj.transform.rotation, targetRotation, 1 * Time.deltaTime );
	}
	
	private function moveCube () {
		var targetPos:Vector3 = new Vector3 ( cube1.transform.position.x, activeCamera.transform.position.y, cube1.transform.position.z );
		cube1.transform.position = Vector3.Lerp ( cube1.transform.position, targetPos, 0.1 );
		rotateObject ( cube1 );
		
	}
}