package utils;

import events.Vec3DEvent;
import events.Vec3DEventDispatcher;
import openfl.events.Event;
import haxe.Timer;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Time
{
	public static var lastFrameTime:Float;
	public static var deltaTime:Float;

	public static var instance:Time = new Time ();
	
	
	//private static 
	//private var timer:Timer;
	
	public function new() 
	{
		if (instance == null) {
			//timer = new Timer (0, 0);
			//timer.start();
			
			Vec3DEventDispatcher.instance.addEventListener(Vec3DEvent.UPDATE, update);
		} else {
			throw "Error instancing Time Class...";
		}
	}
	
	private function update (e:Event) {
		deltaTime = Timer.stamp() - lastFrameTime;
		
		lastFrameTime = Timer.stamp();
		
		//timer.reset();
	}
}