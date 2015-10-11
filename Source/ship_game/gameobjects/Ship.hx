package ship_game.gameobjects;

import input.InputAxis;
import math.Vec3D;
import math.Quaternion;
import math.Vector3;
import objects.GameObject;
import openfl.events.Event;
import openfl.geom.Vector3D;
import rendering.Mesh;
import rendering.Scene;
import utils.SimpleMath;
import utils.Time;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Ship extends GameObject
{
	public var turnSpeed:Float = 32.0;
	public var moveSpeed:Float = 50.0;
	public var maxRotationZ:Float;
	
	public var defaultRotation:Vector3;
	
	public var maxFloat:Float = 0.01;
	public var minFloat:Float = -0.01;
	
	private var isFloatingUp:Bool = false;
	private var floatingTarget:Float;
	private var floatSpeed:Float = 0.1;
	
	private var defaultY:Float;
	
	public function new(scene:Scene) 
	{
		var shipMesh:Mesh = Mesh.loadMeshFile("ship");
		
		super("player", shipMesh, scene);
		
		defaultRotation = transform.eulerAngles;
		
		defaultY = transform.position.y;
	}
	
	override public function update(e:Event) 
	{
		super.update(e);
		
		var h:Float = InputAxis.getValue ( "Horizontal");
		var v:Float = InputAxis.getValue ( "Vertical" );
	
		var newRot:Vector3;
		
		if ( h != 0 ) {
			newRot = new Vector3 ( 0, h, 0 );
		} else {
			//newRot = new Vector3 ( 0, 0, ( defaultRotation.z - transform.eulerAngles.z ) );
			//newRot = new Vector3 ( 0, ( defaultRotation.y - transform.eulerAngles.y ), 0 );
			newRot = new Vector3 ();
		}
		newRot = newRot.multiplyByFloats ( turnSpeed * Time.deltaTime, turnSpeed * Time.deltaTime, turnSpeed * Time.deltaTime );
		
		transform.rotate ( newRot );
		
		transform.translate ( transform.forward.multiplyByFloats (v * Time.deltaTime * moveSpeed, v * Time.deltaTime * moveSpeed, v * Time.deltaTime * moveSpeed ) );
		
		floatShip ();
	}
	
	private function floatShip () {
		var newFloat:Float = 0;
		
		if ( isFloatingUp ) {
			newFloat = Math.random () * maxFloat;
		} else {
			newFloat = Math.random () * minFloat;
		}
	
		trace (isFloatingUp);
		
		transform.position = Vector3.Lerp ( transform.position, new Vector3 ( transform.position.x, transform.position.y + newFloat, transform.position.z ), floatSpeed );
		
		if ( isFloatingUp && transform.position.y + defaultY >= maxFloat) {
			isFloatingUp = false;
		} else if ( !isFloatingUp && transform.position.y - defaultY <= minFloat) {
			isFloatingUp = true;
		}
		
	}
	
}