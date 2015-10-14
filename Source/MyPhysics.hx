package;

import openfl.events.Event;
import objects.GameObject;
import physics.bounding.BoundingBox;
import physics.bounding.BoundingPlane;
import physics.bounding.BoundingSphere;
import physics.RigidBody;
import physics.World;
import rendering.Mesh;
import rendering.Primitives;
import rendering.Scene;
import utils.Color;
import math.Vector3;

/**
 * ...
 * @author Lucas Gonçalves
 */
class MyPhysics extends Scene
{
	private var sphere1:GameObject;
	private var sphere2:GameObject;
	
	public function new(engine:Engine) 
	{
		super(engine);
		
		var world:World = new World ();
		
		var sphereMesh:Mesh = Primitives.createSphere();
		sphere1 = new GameObject ("sphere1", sphereMesh);
		
		sphere2 = new GameObject ("sphere2", sphereMesh.clone());
		
		sphere1.mesh.setVetexGroupColor(0, Color.red);
		sphere2.mesh.setVetexGroupColor(0, Color.blue);
		
		sphere1.transform.position = new Vector3 (-0.7, 2, 0);
		sphere2.transform.position = new Vector3 (0.5, 2, 0);
		
		sphere1.attachBoundingVolume(new BoundingSphere (sphere1.mesh.width / 2));
		sphere1.attachRigidBody(new RigidBody());
		
		sphere2.attachBoundingVolume(new BoundingSphere(sphere2.mesh.width / 2));
		
		//var bs1:BoundingSphere = new BoundingSphere (sphere1.mesh.width / 2);
		//var rb1:RigidBody = new RigidBody(sphere1);
		//bs1.setRigidBody(rb1);
		
		/*var bs2:BoundingSphere = new BoundingSphere (sphere2.mesh.width / 2);
		var rb2:RigidBody = new RigidBody(sphere2);
		bs2.setRigidBody(rb2);*/
		
		sphere1.rigidBody.startSimulation();
		//rb2.startSimulation();
		
		/*var planeMesh:Mesh = Primitives.createPlane();
		var plane:GameObject = new GameObject ("plane", planeMesh);
		plane.transform.position = new Vector3 (0, 0, 0);
		
		var bp:BoundingPlane = new BoundingPlane (Vector3.Up());
		var rb3:RigidBody = new RigidBody(plane);
		bp.setRigidBody(rb3);*/
		
		//sphere1.rigidBody.velocity = new Vector3 (0, -.1, 0);
		//rb2.velocity = new Vector3 (0, -.1, 0);
		
		//rb3.isKinematic = true;
		
		//rb3.startSimulation ();
		
		//sphere1.rigidBody.velocity = new Vector3 (0.1, 0, 0);
		
		/*var cubeMesh:Mesh = Primitives.createCube();
		var cube1 = new GameObject ("cube1", cubeMesh);
		
		var cube2 = new GameObject ("cube2", cubeMesh.clone());
		
		cube1.mesh.setVetexGroupColor(0, Color.red);
		cube2.mesh.setVetexGroupColor(0, Color.blue);
		
		cube1.transform.position = new Vector3 (.2, -.3, .6);
		cube2.transform.position = new Vector3 (.4, .3, .1);
		
		var bb1:BoundingBox = BoundingBox.getMeshExtents(cube1.mesh);
		var rb1:RigidBody = new RigidBody(cube1);
		bb1.setRigidBody(rb1);
		
		var bb2:BoundingBox = BoundingBox.getMeshExtents(cube2.mesh);
		var rb2:RigidBody = new RigidBody(cube2);
		bb2.setRigidBody(rb2);
		
		rb1.startSimulation();
		rb2.startSimulation();*/
	}
	
	public override function update (e:Event) {
		super.update (e);
		
		
	}
	
}