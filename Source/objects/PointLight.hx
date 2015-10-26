package objects;

import math.Vector3;
import rendering.Scene;
import utils.Color;

/**
 * ...
 * @author Lucas Gonçalves
 */
class PointLight
{
	public var position:Vector3;
	public var color:Color;
	public var intensity:Float;
	public var attenuation:Float;
	
	public var scene:Scene;
	
	public function new( position:Vector3, intensity:Float = 10, attenuation:Float = 3, color:Color, ?scene:Scene) 
	{
		if ( scene == null ) {
			if ( Engine.instance.currentScene != null ) {
				scene = Engine.instance.currentScene;
			} else {
				throw "Cannot create light without scene. Won't let be light... ";
			}
		}
		this.scene = scene;
		this.position = ( position != null ) ? position : Vector3.Zero () ;
		this.intensity = intensity;
		this.attenuation = attenuation;
		this.color = ( color != null ) ? color : Color.white;
		
		scene.pointLights.push ( this );
	}
	
	
}