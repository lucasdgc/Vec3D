package objects;

import math.Vector3;
import rendering.Scene;
import utils.Color;

/**
 * ...
 * @author Lucas Gonçalves
 */

enum LightType {
	DIRECTIONAL;
	POINT;
	SPOT;
}
 
class Light
{
	public var transform:Transform;
	public var color:Color;
	public var power:Float;
	
	public var cutoff:Float;
	
	public var scene:Scene;
	public var type:LightType;
	public var direction (get, null):Vector3;
	
	public function new( type:LightType = null, position:Vector3 = null, power:Float = 10, attenuation:Float = 3, color:Color, ?scene:Scene ) 
	{
		if ( scene == null ) {
			if ( Engine.instance.currentScene != null ) {
				scene = Engine.instance.currentScene;
			} else {
				throw "Cannot create light without scene. Won't let be light... ";
			}
		}
		
		this.scene = scene;
		this.transform = new Transform ();
		this.power = power;
		this.color = ( color != null ) ? color : Color.white;
		this.type = ( type != null ) ? type : LightType.POINT;
		
		if ( position != null ) {
			this.transform.position = position;
		}
		
		scene.lights.push ( this );
		
		switch (this.type) {
			case LightType.DIRECTIONAL:
				scene.sun = this;
			case  LightType.POINT:
				scene.pointLights.push ( this );
			case LightType.SPOT:
				scene.spotLights.push ( this );
		}
	}
	
	private function get_direction ():Vector3 {
		return transform.forward;
	}
}