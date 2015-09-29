package;

import openfl.events.Event;
import objects.GameObject;
import physics.BoundingSphere;
import physics.RigidBody;
import physics.World;
import rendering.Mesh;
import rendering.primitives.Primitives;
import rendering.Scene;
import utils.Color;
import com.babylonhx.math.Vector3;

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
		
		sphere1.transform.position = new Vector3 (0.1, 0, 0);
		sphere2.transform.position = new Vector3 (0.2, 0, 0);
		
		var bs1:BoundingSphere = new BoundingSphere (sphere1.mesh.width / 2);
		var rb1:RigidBody = new RigidBody(sphere1);
		bs1.setRigidBody(rb1);
		
		var bs2:BoundingSphere = new BoundingSphere (sphere2.mesh.width / 2);
		var rb2:RigidBody = new RigidBody(sphere2);
		bs2.setRigidBody(rb2);
		
		rb1.startSimulation();
		rb2.startSimulation();
	}
	
	public override function update (e:Event) {
		super.update (e);
		
		
	}
	
}