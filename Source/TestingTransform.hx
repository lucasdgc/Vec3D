package;
import input.InputAxis;
import openfl.events.Event;
import objects.GameObject;
import rendering.Mesh;
import rendering.primitives.Primitives;
import rendering.Scene;
import utils.Color;
import com.babylonhx.math.Vector3;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author Lucas Gonçalves
 */
class TestingTransform extends Scene
{

	public function new(engine:Engine) 
	{
		super(engine);
		
		var cubeMesh:Mesh = Primitives.createCube();
		var cube:GameObject = new GameObject ("cube_01", cubeMesh);
		//cube.mesh.vertexGroups[0].color = Color.blue;
		
		var cana:Mesh = Primitives.createRose(1000, 3 / 4);
		var c:GameObject = new GameObject ("maria", cana);
		c.isStatic = true;
		cube.isStatic = true;
		
		cube.mesh.setVetexGroupColor(0, Color.blue);
		
		trace(cube.mesh.vertexGroups[0].color);
		
		mergeStaticMeshes();
	}
	
	override public function update(event:Event) 
	{
		super.update(event);
		
		var h:Float = InputAxis.getValue ("Horizontal");
		var v:Float = InputAxis.getValue ("Vertical");
		
		var cameraX:Float = InputAxis.getValue ("CameraX");
		var cameraY:Float = InputAxis.getValue ("CameraY");
		
		activeCamera.transform.translate (new Vector3(h, 0, v));
		activeCamera.transform.rotate (new Vector3(cameraY, cameraX, 0));
	}
	
	
	
}