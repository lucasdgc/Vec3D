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
	public static var boundingVolumes:Array<BoundingVolume> = new Array ();
	public static var rigidBodies:Array<RigidBody> = new Array ();
	
	public static var collisionsToHandle:Array<Collision> = new Array ();
	
	public static var gravity:Vector3 = new Vector3 (0, -.1, 0);
	
	public static var stepTime:Float = 1000 / 59.9;
	
	private var timer:Timer;
	
	private var ppsTimer:Timer;
	
	private var stepCount:Int;
	
	public static var pps:Int = 0;
	
	public function new () 
	{
		if (Engine.instance != null && instance == null) {
			//gravity = new Vector3 (0, 0, 0);
			instance = this;
			
			#if html5
			Engine.canvas.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			#end
			
			#if !html5
			//Engine.canvas.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			timer = new Timer (stepTime);
			timer.addEventListener (TimerEvent.TIMER, onCountedStep);
			#end
			
			ppsTimer = new Timer (1000);
			ppsTimer.addEventListener (TimerEvent.TIMER, onSecondCount);
			
			#if !html5
			timer.start();
			#end
			
			ppsTimer.start ();
		} else {
			throw "Cannot instantiate physics world before Engine Device...";
		}
	}
	
	private function onCountedStep (e:TimerEvent) {
		step ();
	}
	
	private function onEnterFrame (e:Event) {
		step ();
	}
	
	private function step () {
		stepCount ++;
		Vec3DEventDispatcher.instance.dispatchPhysicsUpdateEvent();
		
		simulateRigidBodies ();
		
		checkCollisions ();
		
		handleCollisions ();
	}
	
	private static function simulateRigidBodies () {
		for (rb in rigidBodies) {
			if (rb.isSimulating && !rb.isKinematic) {
				rb.simulate ();
			}
		}
	}
	
	private static function checkCollisions () {
		for (bVolume in boundingVolumes) {
			
		}
		
		for (rb in rigidBodies) {
			rb.checkCollisions ();
		}
	}
	
	
	private function handleCollisions () {
		for (col in collisionsToHandle) {
			collisionsToHandle.remove(col);
		}
	}
	
	private function onSecondCount (e:TimerEvent) {
		pps = stepCount;
		stepCount = 0;
	}
	
	public static function removeRigidBody (rigidBody:RigidBody) {
		rigidBodies.remove(rigidBody);
	}
	
	public static function removeBoundingVolume (boundingVolume:BoundingVolume) {
		boundingVolumes.remove(boundingVolume);
	}
	
	public static function clearWorld () {
		while (rigidBodies.length > 0) {
			rigidBodies.pop();
		}
		
		while (boundingVolumes.length > 0) {
			boundingVolumes.pop();
		}
	}
}