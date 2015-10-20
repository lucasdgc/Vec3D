package;
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
	
	
	public function new() 
	{
		super ();
		
		var cubeMesh:Mesh = Primitives.createCube ();
		cube1 = new GameObject ( "cube1", cubeMesh, this );
		cube1.mesh.drawEdges = true;
		cube1.mesh.drawFaces = true;
		
		cube1.mesh.setVetexGroupColor ( 0, Color.blue );
	}
	
	override public function update(event:Event) 
	{
		super.update(event);
		
		var rotationSpeed:Float = 15 * Time.deltaTime;
		
		cube1.transform.rotate ( cube1.transform.up.multiplyByFloat ( rotationSpeed ) );
	}
	
}