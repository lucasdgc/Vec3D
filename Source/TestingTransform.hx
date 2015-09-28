package;
import input.InputAxis;
import input.VirtualAnalogStick;
import openfl.geom.Rectangle;
import openfl.events.Event;
import objects.GameObject;
import rendering.Mesh;
import rendering.primitives.Primitives;
import rendering.Scene;
import utils.Color;
import com.babylonhx.math.Vector3;
import openfl.events.EventDispatcher;
import utils.Time;

/**
 * ...
 * @author Lucas Gonçalves
 */
class TestingTransform extends Scene
{

	private var cube:GameObject;
	private var cameraHost:GameObject;
	private var monkey:GameObject;
	
	private var monkey2:GameObject;
	
	public function new(engine:Engine) 
	{
		super(engine);
		
		var cubeMesh:Mesh = Primitives.createCube();
		//cube.mesh.vertexGroups[0].color = Color.blue;
		
		var rose:Mesh = Primitives.createRose(1000, 3 / 4);
		cubeMesh.merge(rose);
		
		cube = new GameObject ("maria", cubeMesh);
		
		cube.mesh.setVetexGroupColor(0, Color.blue);
		
		var cube2:GameObject = new GameObject ("cube2", cubeMesh.clone());
		cube2.transform.position = new Vector3 (-2, 0, 1);
		
		var cube3:GameObject = new GameObject ("cube3", cubeMesh.clone());
		cube3.transform.position = new Vector3 (2, 0, 1);
		//trace(cube.mesh.vertexGroups[0].color);
		
		cube3.parent = cube;
		cube2.parent = cube;
		
		var plane:Mesh = Primitives.createPlane(32, 5);
		var planeObj:GameObject = new GameObject ("plane", plane);
		planeObj.transform.position = new Vector3 (0, -2, 0);
		
		var plane2:Mesh = Primitives.createPlane(32, 5);
		var planeObj2:GameObject = new GameObject ("plane2", plane2);
		
		planeObj2.transform.position = new Vector3 (0, 2, 0);
		//planeObj2.rotation = new Vector3 (1, 0, 0);
		
		planeObj2.mesh.setVetexGroupColor (0, Color.green);
		
		cube.transform.position = new Vector3 (0, 0, 20);
		
		var camCube:Mesh = Primitives.createCube();
		cameraHost = new GameObject ("myCam", camCube);
		
		cameraHost.transform.position = activeCamera.transform.position.clone();
		
		//cube.parent = cameraHost;
		
		var monkeyMesh:Mesh = Mesh.loadMeshFile("monkey");
		monkey = new GameObject ("monkey", monkeyMesh);
		monkey.transform.position = new Vector3 (-5, 0, 8);
		
		monkey2 = new GameObject ("monkey2", monkeyMesh.clone());
		monkey2.transform.position = new Vector3 (5, 0, 8);
		
		activeCamera.parent = cameraHost;
		
		var analog:VirtualAnalogStick = new VirtualAnalogStick (new Rectangle(Engine.canvas.stage.x, Engine.canvas.stage.y, 
											Engine.canvas.stage.stageWidth / 2, Engine.canvas.stage.stageHeight), "analogX", "analogY");
											
		var analog2:VirtualAnalogStick = new VirtualAnalogStick (new Rectangle(Engine.canvas.stage.x + Engine.canvas.stage.stageWidth / 2, Engine.canvas.stage.y, 
											Engine.canvas.stage.stageWidth / 2, Engine.canvas.stage.stageHeight), "analog2X", "analog2Y");
		//mergeStaticMeshes();
	}
	
	override public function update(event:Event) 
	{
		super.update(event);
		
		var h:Float = InputAxis.getValue ("Horizontal");
		var v:Float = InputAxis.getValue ("Vertical");
		
		var cameraX:Float = InputAxis.getValue ("CameraX");
		var cameraY:Float = InputAxis.getValue ("CameraY");
		
		var analogX:Float = InputAxis.getValue ("analogX");
		var analogY:Float = InputAxis.getValue ("analogY");
		
		var analog2X:Float = InputAxis.getValue ("analog2X");
		var analog2Y:Float = InputAxis.getValue ("analog2Y");
		
		var speed:Float = Time.deltaTime * 5;
		
		cameraHost.transform.translate (new Vector3(analogX, 0, -analogY).multiplyByFloats(speed, speed, speed));
		//cameraHost.transform.rotate(new Vector3 (-cameraY, cameraX, 0));
		cameraHost.transform.rotate(new Vector3 (0, analog2X, 0).multiplyByFloats(speed, speed, speed));
		activeCamera.transform.rotate(new Vector3 (analog2Y, 0, 0).multiplyByFloats(speed, speed, speed));
		
		
		//activeCamera.transform.rotate (new Vector3(cameraY, cameraX, 0));
		//activeCamera.transform.rotateAroundPoint(activeCamera.transform.position, Vector3.Up(), cameraX);
		
		cube.transform.rotateAroundPoint(new Vector3(2, 2, 0), Vector3.Up(), 15);
		
		
		monkey.transform.rotate(new Vector3 (0, 0.5, 0));
		monkey2.transform.rotate(new Vector3 (0, -0.5, 0));
		//trace(cube.transform.rotation);
	}
	
	
	
}