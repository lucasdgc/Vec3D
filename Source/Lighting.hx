package;

import input.InputAxis;
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
class Lighting extends Scene
{
	var cube1:GameObject;
	
	public function new() 
	{
		super ();
		
		//var cubeMesh:Mesh = Primitives.createCube ();
		var cubeMesh:Mesh = Mesh.loadMeshFile ( "faced_monkey" );
		//var cubeMesh:Mesh = Mesh.loadMeshFile ( "cube" );
		cubeMesh.calculateNormals ();
		cube1 = new GameObject ( "monkey", cubeMesh, this );
		cube1.transform.scale = new Vector3 ( 0.5, 0.5, 0.5 );
		
		
		var floorMesh:Mesh = Mesh.loadMeshFile ( "cube" );
		floorMesh.calculateNormals ();
		var floor:GameObject = new GameObject ( "floor", floorMesh, this );
	
		floor.transform.position = new Vector3 ( 0, -2, 0 );
		floor.transform.scale = new Vector3 ( 5, 1, 5  );
	}
	
	override public function update(event:Event) 
	{
		super.update(event);
		
		var h:Float = InputAxis.getValue ("Horizontal");
		var v:Float = InputAxis.getValue ("Vertical");
		
		var rotationSpeed:Float = 15 * Time.deltaTime;
		var moveSpeed:Float = 10 * Time.deltaTime;
		
		cube1.transform.translate ( new Vector3 ( h, 0, v ).multiplyByFloat ( moveSpeed ) );
		
		cube1.transform.rotate ( cube1.transform.up.multiplyByFloat ( rotationSpeed ) );
		//cube1.transform.rotate ( cube1.transform.right.multiplyByFloat ( rotationSpeed / 2 ) );
	}
	
}