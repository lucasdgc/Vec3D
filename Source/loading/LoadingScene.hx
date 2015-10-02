package loading;

import input.InputAxis;
import input.InputButton;
import openfl.events.Event;
import objects.GameObject;
import com.babylonhx.math.Vector3;
import rendering.Mesh;
import rendering.primitives.Primitives;
import rendering.Scene;
import utils.Color;
import utils.Time;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Lucas Gonçalves
 */
class LoadingScene extends Scene
{
	public var cube:GameObject;
	
	public function new() 
	{
		super ();
		
		name = "loadingScene";
		
		var cubeMesh:Mesh = Primitives.createCube();
		cube = new GameObject ("Cube01", cubeMesh, this);
		cube.mesh.setVetexGroupColor (0, Color.green);
		
		sceneLoaded ();
		
		//Engine.canvas.stage.addEventListener (MouseEvent.CLICK, onClick);
	}
	
	public function onClick (_) {
		Engine.canvas.stage.removeEventListener (MouseEvent.CLICK, onClick);
		Engine.instance.loadScene(MyPhysics2);
	}
	
	public override function update (e:Event) {
		super.update(e);
		
		var speed:Float = 25 * Time.deltaTime;
		
		cube.transform.rotate(cube.transform.up.multiplyByFloats(speed, speed, speed));
		
		if (InputButton.getValue("Jump") > 0) {
			Engine.instance.loadScene(MyPhysics2);
		}
	}
	
}