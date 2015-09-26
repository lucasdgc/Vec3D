package;

import com.babylonhx.math.Vector3;
import input.Input;
import input.InputAxis;
import input.InputButton;
import objects.Camera;
import objects.GameObject;
import rendering.Scene;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import rendering.primitives.Cube;
import utils.Color;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.events.MouseEvent;
import openfl.ui.Keyboard;
import rendering.Mesh;
import com.kircode.debug.FPS_Mem;

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
	
	//var camera = new Camera();
	var engine:Engine;

	var monkeyArray:Array<objects.GameObject> = new Array();
	
	public function new () {
		super ();
		engine = new Engine(this);
		var scene = new TestingTransform(engine);
		
		InputAxis.bindAxis("Horizontal", InputAxisMethod.KEYBOARD, Keyboard.A, Keyboard.D);
		InputAxis.bindAxis("Vertical", InputAxisMethod.KEYBOARD, Keyboard.S, Keyboard.W);
		
		InputAxis.bindAxis("CameraX", InputAxisMethod.KEYBOARD, Keyboard.LEFT, Keyboard.RIGHT);
		InputAxis.bindAxis("CameraY", InputAxisMethod.KEYBOARD, Keyboard.DOWN, Keyboard.UP);
		
		
		
		InputButton.bindButton ("Jump", Keyboard.SPACE);
		//Vector3.Back()
		
		//var 
		
		/*monkey = new objects.GameObject("monkey", "monkey");
		monkey.mesh.drawFaces = false;
		monkey.mesh.drawPoints = true;
		monkey.mesh.drawEdges = true;
		
		monkey.rotation.z += 0.2;
		monkey.rotation.x += 0.2;*/
		
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
		
		
		//camera.position = new Vector3(0, 5, -10);
		//camera.target = Vector3.Zero();
		
		//engine.activeCamera = camera;
		
		/*var fps:FPS = new FPS(10, 10, 0xFFFFFF);
		addChild(fps);*/
		
		var fpsMem:FPS_Mem= new FPS_Mem (10, 10, 0x00FF00);
		addChild(fpsMem);
		
		//stage.mouseEnabled = true;
		//stage.mouseChildren = true;
		
		//addEventListener(Event.ENTER_FRAME, update);
		/*stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyEnter);
		stage.addEventListener(TouchEvent.TOUCH_TAP, onTouchBegin);
		stage.addEventListener(MouseEvent.CLICK, onClick);*/
	}
	
	private function update (event:Event) {
		monkey.rotation = new Vector3 (monkey.rotation.x, monkey.rotation.y + 0.01, monkey.rotation.z);
		/*icos.rotation = new Vector3 (icos.rotation.x + 0.01, icos.rotation.y + 0.01, icos.rotation.z);
		bullock.rotation = new Vector3 (bullock.rotation.x + 0.01, bullock.rotation.y + 0.01, bullock.rotation.z);
		cube1.rotation = new Vector3 (cube1.rotation.x - .01, cube1.rotation.y - .02, cube1.rotation.z - .01);*/
		
		/*for(m in monkeyArray){
			m.rotation =  new Vector3(m.rotation.x + 0.01, m.rotation.y + 0.01, m.rotation.z);
		}*/
	}
	
	private function onClick (click:MouseEvent){
		trace("clica clica");
		Mesh.toggleAllEdges();
	}
	
	private function onTouchBegin (touch:TouchEvent) {
		trace("aperta...");
		Mesh.toggleAllEdges();
	}
	
	private function onKeyEnter (key:KeyboardEvent) {
		//trace(key.keyCode == KeyboardEvent.ke);
		if(key.keyCode == Keyboard.E){
			Mesh.toggleAllEdges();
		}
		
		if(key.keyCode == Keyboard.P){
			Mesh.toggleAllPoints();
		}
	}
}