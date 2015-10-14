package;

import math.Vector3;
import objects.GameObject;
import openfl.events.Event;
import rendering.Letters;
import rendering.Mesh;
import rendering.Primitives;
import rendering.Scene;

/**
 * ...
 * @author Lucas Gonçalves
 */
class LettersTest extends Scene
{

	var word:GameObject;
	
	public function new() 
	{
		super ();
		
		//var a:GameObject = new GameObject ( "a", Letters.createZ(), this );
		//a.mesh.drawPoints = true;
		
		var wordMesh:Mesh = Letters.convertToMesh ( "best.engine.ever" );
		word = new GameObject ("word", wordMesh, this);
		
		var square:Mesh = Primitives.createRectangle ( wordMesh.width + 0.2, wordMesh.height + 0.2 );
		//square.scale( new Vector3 ( 1, 1 / wordMesh.width, 0) );
		
		//var sqr:GameObject = new GameObject ("square", square, this);
		
	}
	
	override public function update(event:Event) 
	{
		super.update(event);
		
		//word.transform.rotate ( new Vector3 ( 0, 0, 0.5) );
	}
	
}