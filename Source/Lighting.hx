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
		var cubeMesh:Mesh = Mesh.loadMeshFile ( "monkey" );
		//var cubeMesh:Mesh = Mesh.loadMeshFile ( "cube" );
		cubeMesh.calculateNormals ();
		cube1 = new GameObject ( "cube1", cubeMesh, this );
		
		
		//cube1.mesh.setVetexGroupColor ( 0, Color.green );
		//cube1.mesh.drawEdges = true;
		//cube1.mesh.drawPoints = true;
	}
	
	override public function update(event:Event) 
	{
		super.update(event);
		
		var h:Float = InputAxis.getValue ("Horizontal");
		var v:Float = InputAxis.getValue ("Vertical");
		
		var rotationSpeed:Float = 15 * Time.deltaTime;
		var moveSpeed:Float = 10 * Time.deltaTime;
		
		//cube1.transform.translate ( new Vector3 ( h, 0, v ).multiplyByFloat ( moveSpeed ) );
		
		cube1.transform.rotate ( cube1.transform.up.multiplyByFloat ( rotationSpeed ) );
		//cube1.transform.rotate ( cube1.transform.right.multiplyByFloat ( rotationSpeed / 2 ) );
	}
	
}