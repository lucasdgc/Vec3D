package events;

import openfl.events.Event;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Vec3DEvent extends Event
{

	public static inline var UPDATE:String = "Update";
	public static inline var PHYSICS_UPDATE:String = "Physics_Update";
	public static inline var ENGINE_READY:String = "Engine_Ready";
	public static inline var SCENE_LOADED:String = "Scene_Loaded";
	public static inline var SCENE_INSTANTIATED:String = "Scene_Instantiated";

	public var data:String;
	
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false) 
	{
		super (type, bubbles, cancelable);
	}
	
}