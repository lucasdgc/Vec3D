package;
import input.InputAxis;
import input.InputButton;
import objects.GameObject;
import objects.Terrain;
import oimohx.math.Vec3;
import oimohx.physics.collision.shape.BoxShape;
import oimohx.physics.collision.shape.Shape;
import oimohx.physics.collision.shape.ShapeConfig;
import rendering.Mesh;
import rendering.primitives.Primitives;
import rendering.Scene;
import oimohx.physics.dynamics.World;
import oimohx.physics.dynamics.RigidBody;
import openfl.events.Event;
import com.babylonhx.math.Vector3;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import utils.Color;
/**
 * ...
 * @author Lucas Gonçalves
 */
class PhysicsScene extends Scene
{
	public var world:World;
	public var rigidBody:RigidBody;
	
	public var sc:ShapeConfig;
	public var body:RigidBody;
	
	public var floorBody:RigidBody;
	
	var floor:GameObject;
	
	var cube:GameObject;
	
	var physicsScale:Float = 2000;
	
	public var cameraSpeed:Float = 1;
	
	public var cameraSmooth:Float = 0.2;
	
	private var cameraTargetPosition:Vector3;
	
	private var startingCameraPos:Vector3 = new Vector3();
	
	public function new(engine:Engine) 
	{
		super(engine);
		
		InputAxis.bindAxis("Horizontal", Keyboard.LEFT, Keyboard.RIGHT);
		InputAxis.bindAxis("Vertical", Keyboard.DOWN, Keyboard.UP);
		
		InputButton.bindButton ("Jump", Keyboard.SPACE);
		
		activeCamera.position.z -= 30;
		
		trace("inicia...");
		
		/*cube = new GameObject("cube", "cube");
		cube.position = new Vector3(0, 2, 0);
		
		cube.scale = new Vector3 (3, 2, 2);
		
		floor = new GameObject("floor", "cube");
		floor.position = new Vector3 (-0.2, -2.4, 0);*/
		
		/*var myCube:GameObject = new GameObject ("myCube", Primitives.CUBE);
		myCube.scale = new Vector3 (3, 3, 3);*/
		
		var line:Mesh = Primitives.createSphere(8, 1);
		line.translate(new Vector3(0, 2, 0));
		
		var tree:Mesh = Primitives.createCube(1);
		tree.scale(new Vector3(1, 3, 1));
		tree.merge(line);
		//line.rotate(new Vector3(0, 0, 15));
		//line.scale(new Vector3(3, 3, 3));
		var myLine:GameObject = new GameObject ("myLine", tree);
		myLine.position = new Vector3 (-4, 0, 1);
		
		myLine.mesh.vertexGroups[0].color = Color.green;
		myLine.mesh.vertexGroups[1].color = Color.yellow;
		
		myLine.mesh.bindMeshBuffers();
		
		myLine.isStatic = true;
		

		
		var monkey:Mesh = Mesh.loadMeshFile("monkey");
		var monkeyGO:GameObject = new GameObject("monkey", monkey);
	
		monkeyGO.isStatic = true;
		
		//var cube
		
		
		//myLine.scene.mergeStaticMeshes();
		
				
		var monkey2:Mesh = Mesh.loadMeshFile("monkey");
		var monkeyGO2:GameObject = new GameObject("monkey2", monkey2);
		monkeyGO2.position = new Vector3 (2, 0, 2);
		
		monkeyGO2.isStatic = true;
		
		monkeyGO2.scene.mergeStaticMeshes();
		
		
		//var planeMesh:Mesh = Primitives.createPlane(32);
		//var plane:GameObject = new GameObject("plane", planeMesh);
		
		var plane:Terrain = new Terrain ("heightmap_32.png");
		
		plane.position = new Vector3 (0, -4, 0);
		plane.rotation.x += 15;

		plane.scene.mergeStaticMeshes();
		
		world = new World();
		
		//World.WORLD_SCALE = 1000;
		
		world.gravity = new Vec3(0, -10, 0);
		
		//world.worldscale
		
		sc = new ShapeConfig();
		
		body = new RigidBody(0, 2, 0);
		floorBody = new RigidBody(-0.2, -2.4, 0);
		
		body.addShape(new BoxShape(sc, 100, 100, 100));
		floorBody.addShape(new BoxShape(sc, 100, 100, 100));
		
		body.setupMass();
		floorBody.setupMass();
		
		world.addRigidBody(body);
		world.addRigidBody(floorBody);
		//body.isStatic = true;
		floorBody.isStatic = true;
		floorBody.isDynamic = false;
		
		cameraTargetPosition = activeCamera.position.clone();
				
		startingCameraPos = activeCamera.position.clone();
		
		Engine.canvas.addEventListener(Event.ENTER_FRAME, update);
		Engine.canvas.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		
	}
	
	private function update(event:Event) {
		/*world.step(60);
		cube.position = new Vector3(body.position.x / physicsScale , body.position.y / physicsScale , body.position.z / physicsScale );
		floor.position = new Vector3(floorBody.position.x / physicsScale , floorBody.position.y / physicsScale, floorBody.position.z / physicsScale);
		trace(cube.position.y);*/
		
		var h = InputAxis.getValue("Horizontal");
		var v = InputAxis.getValue("Vertical");
		
		/*trace("H: " + h);
		trace("V: " + v);
		trace ("Jump: " + InputButton.getValue("Jump"));
		*/
		var moveDirection:Vector3 = new Vector3 (h, 0, v);
		
		cameraTargetPosition = activeCamera.position.addInPlace(moveDirection.multiplyByFloats(cameraSpeed, cameraSpeed, cameraSpeed));
		
		activeCamera.position = Vector3.Lerp(activeCamera.position, cameraTargetPosition, cameraSmooth);
		
		activeCamera.target = new Vector3 (activeCamera.position.x, activeCamera.position.y, activeCamera.position.z + 10);
	}
	
	private function onKeyPress (key:KeyboardEvent) {

	/*	if(key.keyCode == Keyboard.SPACE){
			world.step(60 * 0.001);
			cube.position = new Vector3(body.position.x, body.position.y, body.position.z );
			floor.position = new Vector3(floorBody.position.x, floorBody.position.y, floorBody.position.z);
			trace(cube.position.y);
		}*/
		
		/*if(key.keyCode == Keyboard.W) {
			cameraTargetPosition.z += cameraSpeed;
		}
		
		if (key.keyCode == Keyboard.S) {
			cameraTargetPosition .z -= cameraSpeed;
		}
		
		if(key.keyCode == Keyboard.A) {
			cameraTargetPosition.x -= cameraSpeed;
		}
		
		if (key.keyCode == Keyboard.D) {
			cameraTargetPosition.x += cameraSpeed;
		}
		
		if (key.keyCode == Keyboard.R) {
			trace(startingCameraPos.x);
			cameraTargetPosition = startingCameraPos.clone();
		}*/
	}
}