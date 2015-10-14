package loading;

import haxe.ds.Vector;
import input.InputAxis;
import input.InputButton;
import openfl.events.Event;
import objects.GameObject;
import math.Vector3;
import physics.bounding.BoundingBox;
import physics.Collision;
import physics.Physics;
import physics.Ray;
import physics.World;
import rendering.Mesh;
import rendering.Primitives;
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
		
		cube.mesh.drawPoints = true;
		
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