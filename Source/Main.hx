package;

import com.babylonhx.math.Vector3;
import openfl.display.BitmapData;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;

class Main extends Sprite {
	
	//var mesh = new Mesh("Cube1", 8, 12, 13);
	//var mesh2 = new Mesh("Cube2", 8, 12, 13);
	
	var cube1:GameObject;
	var cube2:Cube;
	var cube3:Cube;
	
	var monkey:GameObject;
	var icos:GameObject;
	var bullock:GameObject;
	
	var go:GameObject;
	
	var camera = new Camera();
	var device:DeviceGL;

	var monkeyArray:Array<GameObject> = new Array();
	
	public function new () {
		super ();
		var bmp:BitmapData = new BitmapData (640, 480);
		
		device = new DeviceGL(this);
		
		monkey = new GameObject("monkey", "monkey_hollow");
		monkey.mesh.drawFaces = false;
		monkey.mesh.drawPoints = true;
		monkey.mesh.drawEdges = true;
		/*icos = new GameObject("icos", "icosphere");
		icos.position = new Vector3(2.5, 0, 2.5);
		bullock = new GameObject("bullock", "bullock");
		bullock.position = new Vector3(-2.5, 0, 2.5);
		
		cube1 = new GameObject("cube01", Primitives.CUBE);
		cube1.position = new Vector3 (0, 0, 4);*/
		
		var monkeyCount:Int = 0;
		
		for (i in -4...4){
			for (j in -2...4){
				var m = new GameObject("", "monkey_hollow");
				m.position = new Vector3(i, j , j);
				monkeyArray.push(m);
				monkeyCount ++;
			}
		}
		trace(monkeyCount);
		
		
		camera.position = new Vector3(0, 0, -10);
		camera.target = Vector3.Zero();
		
		device.activeCamera = camera;
		
		var fps:FPS = new FPS(10, 10, 0xFFFFFF);
		addChild(fps);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	private function update (event:Event) {
		monkey.rotation = new Vector3 (monkey.rotation.x + 0.01, monkey.rotation.y + 0.01, monkey.rotation.z);
		/*icos.rotation = new Vector3 (icos.rotation.x + 0.01, icos.rotation.y + 0.01, icos.rotation.z);
		bullock.rotation = new Vector3 (bullock.rotation.x + 0.01, bullock.rotation.y + 0.01, bullock.rotation.z);
		cube1.rotation = new Vector3 (cube1.rotation.x - .01, cube1.rotation.y - .02, cube1.rotation.z - .01);*/
		
		for(m in monkeyArray){
			m.rotation =  new Vector3(m.rotation.x + 0.01, m.rotation.y + 0.01, m.rotation.z);
		}
	}
}