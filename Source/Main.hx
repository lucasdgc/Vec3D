package;

import math.Vector3;
import events.Vec3DEvent;
import events.Vec3DEventDispatcher;
import input.InputAxis;
import input.InputButton;
import rendering.Scene;
import openfl.display.Sprite;
import utils.debug.FPS_Mem;
import openfl.ui.Keyboard;
import ship_game.ShipRace;
import utils.SimpleMath;
import openfl.events.Event;

class Main extends Sprite {
	
	var engine:Engine;
	
	public function new () {
		super ();
		
		Vec3DEventDispatcher.instance.addEventListener (Vec3DEvent.ENGINE_READY, onEngineReady);
		
		engine = new Engine(this);
		Engine.bakeOnCompile = true;
		
		InputAxis.bindAxis("Horizontal", InputAxisMethod.KEYBOARD, Keyboard.A, Keyboard.D);
		InputAxis.bindAxis("Vertical", InputAxisMethod.KEYBOARD, Keyboard.S, Keyboard.W);
		
		InputAxis.bindAxis("CameraX", InputAxisMethod.KEYBOARD, Keyboard.LEFT, Keyboard.RIGHT);
		//InputAxis.bindAxis("CameraY", InputAxisMethod.KEYBOARD, Keyboard.DOWN, Keyboard.UP);
		
		InputButton.bindButton ("Jump", Keyboard.SPACE);
		
		var fpsMem:FPS_Mem= new FPS_Mem (10, 10, 0x00FF00);
		addChild(fpsMem);
	}
	
	private function onEngineReady (e:Event) {
		Vec3DEventDispatcher.instance.removeEventListener (Vec3DEvent.ENGINE_READY, onEngineReady);
		
		//trace (SimpleMath.getCloserPow2(360));
		
		Engine.instance.loadScene (ColorsTest);
	}
}