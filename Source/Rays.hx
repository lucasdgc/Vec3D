package;

import input.InputAxis;
import math.Vector3;
import objects.GameObject;
import openfl.events.Event;
import physics.bounding.BoundingBox;
import physics.bounding.BoundingSphere;
import physics.Collision;
import physics.Physics;
import physics.Ray;
import physics.World;
import rendering.Mesh;
import rendering.Primitives;
import rendering.Scene;
import utils.Time;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Rays extends Scene
{
	private var cube1:GameObject;
	private var cube2:GameObject;
	private var cube3:GameObject;
	private var cube4:GameObject;
	private var cube5:GameObject;
	private var cube6:GameObject;
	private var cube7:GameObject;
	private var cube8:GameObject;
	
	private var sphere:GameObject;
	
	private var rayX:Float = 0;
	private var rayY:Float = 0;
	
	private var curAngle:Float = 0;
	
	public function new () 
	{
		super ();
		
		new World ();
		
		var cubeMesh:Mesh = Primitives.createCube ();
		cube1 = new GameObject ( "cube1", cubeMesh, this );
		cube1.attachBoundingVolume ( BoundingBox.getMeshExtents( cube1.mesh ) );
		cube1.transform.position = new Vector3 ( 0, -1.5, 0);
		
		cube2 = new GameObject ( "cube2", cubeMesh.clone (), this );
		cube2.transform.position = new Vector3 ( 2, 1, 0 );
		cube2.attachBoundingVolume ( BoundingBox.getMeshExtents( cube2.mesh ) );
		
		cube3 = new GameObject ( "cube3", cubeMesh.clone (), this );
		cube3.transform.position = new Vector3 ( -2, -1, 0 );
		cube3.attachBoundingVolume ( BoundingBox.getMeshExtents( cube3.mesh ) );
		
		cube4 = new GameObject ( "cube4", cubeMesh.clone (), this );
		cube4.transform.position = new Vector3 ( 2, -1, 0 );
		cube4.attachBoundingVolume ( BoundingBox.getMeshExtents( cube4.mesh ) );
		
		/*cube5 = new GameObject ( "cube5", cubeMesh.clone (), this );
		cube5.transform.position = new Vector3 ( -2, 1, 0 );
		cube5.attachBoundingVolume ( BoundingBox.getMeshExtents( cube5.mesh ) );*/
		
		var sphere1:GameObject = new GameObject ( "sp2", Primitives.createSphere (), this );
		sphere1.transform.position = new Vector3 ( -2, 1, 0 );
		sphere1.attachBoundingVolume ( new BoundingSphere ( 0.5 ) );
		
		cube6 = new GameObject ( "cube6", cubeMesh.clone (), this );
		cube6.transform.position = new Vector3 ( 0, 1.5, 0 );
		cube6.attachBoundingVolume ( BoundingBox.getMeshExtents( cube6.mesh ) );
		
		cube7 = new GameObject ( "cube7", cubeMesh.clone (), this );
		cube7.transform.position = new Vector3 ( 1, 1.2, 0 );
		cube7.attachBoundingVolume ( BoundingBox.getMeshExtents( cube7.mesh ) );
		
		cube8 = new GameObject ( "cube8", cubeMesh.clone (), this );
		cube8.transform.position = new Vector3 ( -1, -1.2, 0 );
		cube8.attachBoundingVolume ( BoundingBox.getMeshExtents( cube8.mesh ) );
		
		sphere = new GameObject ( "sp1", Primitives.createSphere ( 2, 0.1 ), this );
	}
	
	override public function start() {
		super.start();
	}
	
	override public function update(event:Event) 
	{
		super.update(event);
		
		var h:Float = InputAxis.getValue ( "Horizontal" );
		var v:Float = InputAxis.getValue ( "Vertical" );
		var rayStart:Vector3 = new Vector3 ( 0, 0, 0 );
		
		
		
		rayX = Math.cos (curAngle);
		rayY = Math.sin (curAngle);
		
		curAngle += Time.deltaTime * h;
		
		if ( h != 0) {
			var ray:Ray = new Ray ( rayStart, new Vector3 ( rayX, rayY, 0 ).normalize () );
			
			var col:Collision = Physics.raycast ( ray );
			
			if ( col.isColliding ) {
				sphere.isVisible = true;
				sphere.transform.position = col.direction;
			} else {
				sphere.isVisible = false;
			}
		}
	}
	
}