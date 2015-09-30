package;

import input.InputAxis;
import openfl.events.Event;
import objects.GameObject;
import physics.bounding.BoundingPlane;
import physics.bounding.BoundingSphere;
import physics.RigidBody;
import physics.World;
import rendering.Mesh;
import rendering.primitives.Primitives;
import rendering.Scene;
import com.babylonhx.math.Vector3;
import com.babylonhx.math.Quaternion;
import utils.Color;
import utils.Time;


/**
 * ...
 * @author Lucas Gonçalves
 */
class MyPhysics2 extends Scene
{
	var playerSphere:GameObject;

	var targetCameraPosition:Vector3;
	var targetCameraRotation:Quaternion;
	
	var camSpeed:Float = 0.1;
	
	public function new(engine:Engine) 
	{
		super(engine);
		var w:World = new World ();
		
		var sphereMesh:Mesh = Primitives.createSphere();
		playerSphere = new GameObject ("player", sphereMesh);
		playerSphere.transform.position = new Vector3 (0, 0.49, 0);
		
		playerSphere.attachBoundingVolume(new BoundingSphere(sphereMesh.width / 2));
		playerSphere.attachRigidBody();
		
		playerSphere.rigidBody.velocity = new Vector3 (0, -.1, 0);
		
		var groundMesh:Mesh = Primitives.createPlane(32, 5);
		var ground:GameObject = new GameObject ("ground", groundMesh);
		ground.attachBoundingVolume(new BoundingPlane(Vector3.Up()));
		ground.isStatic = true;
		
		var upperWallMesh:Mesh = Primitives.createCube();
		var upperWall:GameObject = new GameObject ("upper_wall", upperWallMesh);
		upperWall.transform.scale = new Vector3 (30, 1.5, 1);
		
		ground.mesh.setVetexGroupColor(0, Color.green);
		
		targetCameraPosition = new Vector3 (0, 1.5, -10);
		
		var relPosition:Vector3 = playerSphere.transform.position.subtract(activeCamera.transform.position);
		targetCameraRotation = Quaternion.LookRotation (relPosition);
		
		mergeStaticMeshes();
		
		//RigidBody.startAllRigidBodies();
	}
	
	public override function update (e:Event) {
		super.update(e);
		
		var h:Float = InputAxis.getValue("Horizontal");
		var v:Float = InputAxis.getValue("Vertical");
		
		var speed:Float = 5 * Time.deltaTime;
		
		playerSphere.transform.translate (new Vector3 (h, 0, v).normalize().multiplyByFloats(speed, speed, speed));
		
		setCameraTarget ();
		setCameraTransform();
	}
	
	private function setCameraTarget () {
		targetCameraPosition = playerSphere.transform.position.add(new Vector3 (0, 1.5, -10));
		
		var relPosition:Vector3 = playerSphere.transform.position.subtract(activeCamera.transform.position);
		relPosition.y += 3;
		targetCameraRotation = Quaternion.LookRotation (relPosition);
	}
	
	private function setCameraTransform () {
		activeCamera.transform.position = Vector3.Lerp (activeCamera.transform.position, targetCameraPosition, camSpeed);
		
		activeCamera.transform.rotation = Quaternion.Slerp (activeCamera.transform.rotation, targetCameraRotation, camSpeed);
	}
}