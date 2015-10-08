package;

import events.Vec3DEvent;
import loading.LoadingScene;
import rendering.Scene;
import openfl.display.Sprite;
import openfl.events.Event;
import events.Vec3DEventDispatcher;
import device.Device;

/**
 * ...
 * @author Lucas Gonçalves
 */

class Engine
{
	public static var canvas:Sprite;
	public static var instance:Engine;
	public static var bakeOnCompile:Bool = true;
	
	public var currentScene (default, null):Scene;
	private var nextScene (default, set):Scene;
	
	private var loadingScene:loading.LoadingScene;
	
	private var started:Bool = false;
	
	private var device:Device;
	
	public function new(_canvas:Sprite) 
	{
		if(instance == null){
			instance = this;
		} else {
			throw "Cannot instantiate Engine twice...";
		}
		
		canvas = _canvas;
		
		device = new Device();
		
		loadingScene = new loading.LoadingScene();
		
		currentScene = loadingScene;
		
		canvas.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		Vec3DEventDispatcher.instance.dispatchEngineReadyEvent();
	}
	
	private function onEnterFrame (event:Event) {
		
		//device.update();
		
		//trace(currentScene.name);
		if (currentScene != null) {
			currentScene.update(event);
		}
		Vec3DEventDispatcher.instance.dispatchUpdateEvent();
		
		if (!started) {
			started = true;
			//Vec3DEventDispatcher.instance.dispatchEngineReadyEvent();
		}
	}
	
	public function loadScene (sceneClass:Class<Scene>) {
		currentScene.dispose();
		if (currentScene != loadingScene) {
			currentScene = loadingScene;
		}
		Vec3DEventDispatcher.instance.addEventListener (Vec3DEvent.SCENE_LOADED, onSceneLoaded);		
		nextScene = Type.createInstance(sceneClass, []);
	}
	
	private function set_nextScene (value:Scene):Scene {
		nextScene = value;
		Vec3DEventDispatcher.instance.dispatchSceneInstantiatedEvent();
		return nextScene;
	}
	
	private function onSceneLoaded (e:Event) {
		Vec3DEventDispatcher.instance.removeEventListener (Vec3DEvent.SCENE_LOADED, onSceneLoaded);
		currentScene = nextScene;
	}
}