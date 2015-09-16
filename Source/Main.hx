package;

import com.babylonhx.math.Vector3;
import objects.Camera;
import objects.GameObject;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import rendering.primitives.Cube;

class Main extends Sprite {
	
	//var mesh = new Mesh("Cube1", 8, 12, 13);
	//var mesh2 = new Mesh("Cube2", 8, 12, 13);
	
	var cube1:objects.GameObject;
	var cube2:rendering.primitives.Cube;
	var cube3:rendering.primitives.Cube;
	
	var monkey:objects.GameObject;
	var icos:objects.GameObject;
	var bullock:objects.GameObject;
	
	var go:objects.GameObject;
	
	var camera = new objects.Camera();
	var device:Engine;

	var monkeyArray:Array<objects.GameObject> = new Array();
	
	public function new () {
		super ();
		device = new Engine(this);
		
		monkey = new objects.GameObject("monkey", "monkey");
		monkey.mesh.drawFaces = false;
		monkey.mesh.drawPoints = false;
		monkey.mesh.drawEdges = true;
		
		monkey.rotation.z += 0.2;
		monkey.rotation.x += 0.2;
		
		/*icos = new GameObject("icos", "icosphere");
		icos.position = new Vector3(2.5, 0, 2.5);
		bullock = new GameObject("bullock", "bullock");
		bullock.position = new Vector3(-2.5, 0, 2.5);
		
		cube1 = new GameObject("cube01", Primitives.CUBE);
		cube1.position = new Vector3 (0, 0, 4);*/
		
		/*var monkeyCount:Int = 0;
		
		for (i in -4...4){
			for (j in -2...4){
				var m = new GameObject("", "monkey_hollow");
				m.position = new Vector3(i, j , j);
				monkeyArray.push(m);
				monkeyCount ++;
			}
		}
		trace(monkeyCount);*/
		
		
		camera.position = new Vector3(0, 5, -10);
		camera.target = Vector3.Zero();
		
		device.activeCamera = camera;
		
		var fps:FPS = new FPS(10, 10, 0xFFFFFF);
		addChild(fps);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	private function update (event:Event) {
		//monkey.rotation = new Vector3 (monkey.rotation.x, monkey.rotation.y + 0.01, monkey.rotation.z);
		/*icos.rotation = new Vector3 (icos.rotation.x + 0.01, icos.rotation.y + 0.01, icos.rotation.z);
		bullock.rotation = new Vector3 (bullock.rotation.x + 0.01, bullock.rotation.y + 0.01, bullock.rotation.z);
		cube1.rotation = new Vector3 (cube1.rotation.x - .01, cube1.rotation.y - .02, cube1.rotation.z - .01);*/
		
		/*for(m in monkeyArray){
			m.rotation =  new Vector3(m.rotation.x + 0.01, m.rotation.y + 0.01, m.rotation.z);
		}*/
	}
}