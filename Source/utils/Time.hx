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
	public static var instance:Time = new Time ();
	
	public static var lastFrameTime:Float = 0;
	public static var deltaTime:Float = 0;

	public function new() 
	{
		if (instance == null) {
			Vec3DEventDispatcher.instance.addEventListener(Vec3DEvent.UPDATE, update);
		} else {
			throw "Error instancing Time Class...";
		}
	}
	
	private function update (e:Event) {
		deltaTime = Timer.stamp() - lastFrameTime;
		
		if (lastFrameTime == 0) {
			deltaTime = lastFrameTime;
		}
		
		lastFrameTime = Timer.stamp();
	}
}