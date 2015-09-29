package physics;
import openfl.events.Event;
import events.Vec3DEventDispatcher;
import com.babylonhx.math.Vector3;
import openfl.utils.Timer;
import openfl.events.TimerEvent;
import utils.Time;

/**
 * ...
 * @author Lucas Gonçalves
 */
class World
{
	public static var instance:World;
	public static var rigidBodies:Array<RigidBody> = new Array ();
	
	public static var gravity:Vector3;
	
	public static var stepTime:Float = 1000 / 59.9;
	
	private var timer:Timer;
	
	private var ppsTimer:Timer;
	
	private var stepCount:Int;
	
	public static var pps:Int = 0;
	
	public function new () 
	{
		if (Engine.instance != null && instance == null) {
			gravity = new Vector3 (0, -0.01, 0);
			instance = this;
			
			#if html5
			Engine.canvas.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			#end
			
			#if !html5
			//Engine.canvas.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			timer = new Timer (stepTime);
			timer.addEventListener (TimerEvent.TIMER, onPhysicsStep);
			#end
			
			ppsTimer = new Timer (1000);
			ppsTimer.addEventListener (TimerEvent.TIMER, onSecondCount);
			
			#if !html5
			timer.start();
			#end
			
			ppsTimer.start ();

			
			trace(stepTime);
		} else {
			throw "Cannot instantiate physics world before Engine Device...";
		}
	}
	
	private function onPhysicsStep (e:TimerEvent) {
		stepCount ++;
		Vec3DEventDispatcher.instance.dispatchPhysicsUpdateEvent();
	}
	
	private function onEnterFrame (e:Event) {
		stepCount ++;
		Vec3DEventDispatcher.instance.dispatchPhysicsUpdateEvent();
	}
	
	private function onSecondCount (e:TimerEvent) {
		pps = stepCount;
		stepCount = 0;
	}
	
	public static function removeRigidBody (rigidBody:RigidBody) {
		rigidBodies.remove(rigidBody);
	}
	
	public static function clearWorld () {
		while (rigidBodies.length > 0) {
			rigidBodies.pop();
		}
	}
}