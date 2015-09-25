package events;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Vec3DEventDispatcher extends EventDispatcher
{

	public static var instance:Vec3DEventDispatcher = new Vec3DEventDispatcher ();
	
	private var isInstanced:Bool = false;
	
	public function new() 
	{
		super ();
		
		
		if( isInstanced) {
			throw "Error instancing event dispatcher...";
		} else {
			isInstanced = true;
		}
		
	}
	
	public function dispatchUpdateEvent () {
		dispatchEvent (new Vec3DEvent(Vec3DEvent.UPDATE));
	}
}