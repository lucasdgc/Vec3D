package ship_game.gameobjects;

import objects.Camera;
import math.Vector3;
import math.Quaternion;
import objects.GameObject;
import openfl.events.Event;
import rendering.Scene;

/**
 * ...
 * @author Lucas Gonçalves
 */
class PlayerCamera extends Camera
{
	public var target:GameObject;
	
	public var playerDistance:Float;
	public var smooth:Float;
	
	public var offset:Vector3;
	
	public function new(position:Vector3, target:GameObject, playerDistance:Float, smooth:Float, scene:Scene) 
	{
		super (position, "player_camera", scene);
		
		this.playerDistance = playerDistance;
		this.smooth = smooth;
		
		this.target = target;
		
		offset = this.transform.position.subtract (target.transform.position);
		
		//offset = offset.normalized().multiplyByFloats(playerDistance, playerDistance, playerDistance);
	}
	
	override public function update(e:Event) 
	{
		super.update(e);
		
		transform.position = Vector3.Lerp (transform.position, target.transform.position.add(offset), smooth);
		
		var relPostion:Vector3 = target.transform.position.subtract(transform.position);
		relPostion.y += 6;
		var targetRotation:Quaternion = Quaternion.LookRotation(relPostion, Vector3.Up());
		transform.rotation = Quaternion.Slerp (transform.rotation, targetRotation, smooth);
	}
	
}