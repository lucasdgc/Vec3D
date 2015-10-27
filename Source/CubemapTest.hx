package;
import input.InputAxis;
import openfl.events.Event;
import rendering.Cubemap;
import rendering.Scene;
import utils.Time;

/**
 * ...
 * @author Lucas Gonçalves
 */
class CubemapTest extends Scene
{

	public function new() 
	{
		super ();
		
		skybox = new Cubemap ( "2048/negx.jpg", "2048/posx.jpg", "2048/negy.jpg", "2048/posy.jpg", "2048/negz.jpg", "2048/posz.jpg" );
		//skybox = new Cubemap ( "512/negx.jpg", "512/posx.jpg", "512/negy.jpg", "512/posy.jpg", "512/negz.jpg", "512/posz.jpg" );
	}
	
	override public function update(event:Event) 
	{
		super.update(event);
		
		var h:Float = InputAxis.getValue ( "Horizontal" ); 
		
		var rotationSpeed:Float = Time.deltaTime * 15;
		
		activeCamera.transform.rotate ( activeCamera.transform.up.multiplyByFloat ( rotationSpeed * h ) );
	}
}