package;

import input.InputAxis;
import math.Vector3;
import objects.GameObject;
import openfl.events.Event;
import rendering.Mesh;
import rendering.primitives.Primitives;
import rendering.Scene;
import utils.Time;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Adjusts extends Scene
{
	private var cube1:GameObject;
	private var ms:Float = 0;
	
	public function new () 
	{
		super();
		
		trace ("isntanciantdo..");
		
		var cubeMesh:Mesh = Primitives.createCube();
		cube1 = new GameObject ( "cube1", cubeMesh, this );
		
		//sceneLoaded ();
		//load();
	}
	
	override public function update ( event:Event ) 
	{
		super.update ( event );
		
		trace ( cube1.transform.position );
		
		var h:Float = InputAxis.getValue ( "Horizontal" );
		var v:Float = InputAxis.getValue ( "Vertical" );
		var arrowH:Float = InputAxis.getValue ( "CameraX" );
		var moveSpeed:Float = 0.5 * Time.deltaTime;
		var rotationSpeed:Float = 50 * Time.deltaTime;
		
		if ( h != 0 ) {
			ms = 1;
		}

		cube1.transform.rotate ( new Vector3 ( 0, 0, rotationSpeed ) );
		//cube1.transform.translate ( new Vector3 (1, 0, 0).multiplyByFloats(moveSpeed, moveSpeed, moveSpeed) );

		trace ( cube1.transform.position );
	}
}