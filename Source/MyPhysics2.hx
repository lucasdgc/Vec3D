package;

import input.InputAxis;
import input.VirtualAnalogStick;
import objects.Terrain;
import openfl.events.Event;
import objects.GameObject;
import openfl.geom.Rectangle;
import physics.bounding.BoundingBox;
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
	
	public function new() 
	{
		super();
		
		name = "My Psysics 2";
		
		var w:World = new World ();
		var analogRect:Rectangle = new Rectangle (Engine.canvas.stage.x, Engine.canvas.stage.y, 
												   Engine.canvas.stage.stageWidth / 2, Engine.canvas.stage.stageHeight);
		
		var analog:VirtualAnalogStick = new VirtualAnalogStick (analogRect, "analogX", "analogY");
		var analog2:VirtualAnalogStick = new VirtualAnalogStick (analogRect, "analogX", "analogY");
		
		var sphereMesh:Mesh = Primitives.createSphere();
		playerSphere = new GameObject ("player", sphereMesh, this);
		playerSphere.transform.position = new Vector3 (0, 12, 0);
		
		playerSphere.attachBoundingVolume(new BoundingSphere(sphereMesh.width / 2));
		playerSphere.attachRigidBody();
		
		//playerSphere.rigidBody.velocity = new Vector3 (0, -.1, 0);
		
		var groundMesh:Mesh = Primitives.createPlane(32, 5);
		var ground:GameObject = new GameObject ("ground", groundMesh, this);
		ground.attachBoundingVolume(new BoundingPlane(Vector3.Up()));
		//ground.isStatic = true;
		
		var upperWallMesh:Mesh = Primitives.createCube();
		var upperWall:GameObject = new GameObject ("upper_wall", upperWallMesh, this);
		upperWall.transform.scale = new Vector3 (30, 1.5, 1);
		upperWall.transform.position = new Vector3 (0, 0.5, 32);
		//upperWall.attachBoundingVolume(BoundingBox.getMeshExtents(upperWall.mesh));
		
		var sphereMehs2:Mesh = Primitives.createSphere(8, 0.8);
		var sphere2:GameObject = new GameObject ("sphere2", sphereMehs2, this);
		sphere2.attachBoundingVolume(new BoundingSphere(0.8));
		sphere2.transform.position = new Vector3 (-3, 0, 0);
		
		ground.mesh.setVetexGroupColor(0, Color.green);
		
		targetCameraPosition = new Vector3 (0, 1.5, -10);
		
		var terrain:GameObject = new Terrain ("heightmap_128.png", this);
		terrain.transform.position = new Vector3 (0, -40, 0);
		
		var relPosition:Vector3 = playerSphere.transform.position.subtract(activeCamera.transform.position);
		targetCameraRotation = Quaternion.LookRotation (relPosition);
		
		//mergeStaticMeshes();
		
		RigidBody.startAllRigidBodies();
		
		sceneLoaded ();
	}
	
	public override function update (e:Event) {
		super.update(e);
		
		var h:Float = InputAxis.getValue("Horizontal");
		var v:Float = InputAxis.getValue("Vertical");
		
		var analogX:Float = InputAxis.getValue("analogX");
		var analogY:Float = InputAxis.getValue("analogY");
		
		var speed:Float = 3 * Time.deltaTime;
		
		var inputX:Float = h;
		var inputY:Float = v;
		
		if (inputX == 0) {
			inputX = analogX;
		}
		
		if (inputY == 0) {
			inputY = analogY;
		}
		
		var moveDirection:Vector3 = new Vector3 (inputX, 0, inputY).normalize().multiplyByFloats(speed, speed, speed);
		
		//var inputX:Float = Math.max (h, analogX);
		//var inputY:Float = Math.max (v, analogY); 
		
		//playerSphere.transform.translate (new Vector3 (h, 0, v).normalize().multiplyByFloats(speed, speed, speed));
		//playerSphere.transform.translate (new Vector3 (inputX, 0, inputY).normalize().multiplyByFloats(speed, speed, speed));
		
		//playerSphere.rigidBody.velocity = new Vector3 (inputX, 0, inputY).normalize().multiplyByFloats(speed, speed, speed);
		
		playerSphere.rigidBody.addForce(moveDirection);
		
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