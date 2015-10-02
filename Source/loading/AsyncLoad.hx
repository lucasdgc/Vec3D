package loading;

import async.Build;
import rendering.Scene;


/**
 * ...
 * @author Lucas Gonçalves
 */
class AsyncLoad implements Build
{
	private static var sceneToLoad = 0;
	
	@async 
	static function _loadSceneData (sceneClass:Class<Scene>):Void {
		sceneToLoad = 1;
		//var a [] = loadSceneClass();
		
		//[ var a ] = shiteTest ();
		
		//trace ("chama async...");
		
	}
	
	
	public static function loadScene (sceneClass:Class<Scene>):Void {
		_loadSceneData(sceneClass, _startLoadedScene);
	}
	
	private static function loadSceneClass ():Scene {
		var a:Class<Scene> = null;
		
		switch (sceneToLoad) {
			case 0:
				a = LoadingScene;
			case 1:
				a = MyPhysics2;
		}
		
		
		return Type.createInstance(a, []);
	}
	
	private static function shiteTest ():String {
		return "holy shite";
	}
	
	private static function _startLoadedScene (e:Dynamic):Void {
		
	}
}