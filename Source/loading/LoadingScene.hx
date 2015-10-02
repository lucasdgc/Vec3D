package loading;

import haxe.ds.Vector;
import input.InputAxis;
import input.InputButton;
import openfl.events.Event;
import objects.GameObject;
import com.babylonhx.math.Vector3;
import physics.bounding.BoundingBox;
import physics.Collision;
import physics.Physics;
import physics.Ray;
import physics.World;
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
	public var cube2:GameObject;
	
	public function new() 
	{
		super ();
		
		var w = new World ();
		
		name = "loadingScene";
		
		var cubeMesh:Mesh = Primitives.createCube();
		cube = new GameObject ("Cube01", cubeMesh, this);
		cube.mesh.setVetexGroupColor (0, Color.green);
		cube.attachBoundingVolume(BoundingBox.getMeshExtents(cube.mesh));
		
		cube2 = new GameObject ("Cube02", cube.mesh.clone(), this);
		cube2.mesh.setVetexGroupColor (0, Color.blue);
		cube2.attachBoundingVolume(BoundingBox.getMeshExtents(cube2.mesh));
		
		cube.transform.position = new Vector3 (-2, 0, 0);
		
		sceneLoaded ();
		
		Engine.canvas.stage.addEventListener (MouseEvent.CLICK, onClick);
		Engine.canvas.stage.addEventListener (MouseEvent.MOUSE_MOVE, onMouseMove);
	}
	
	public function onClick (_) {
		//Engine.canvas.stage.removeEventListener (MouseEvent.CLICK, onClick);
		//Engine.instance.loadScene(MyPhysics2);
		
		trace("screenPos: " + Engine.canvas.stage.mouseX + " - " + Engine.canvas.stage.mouseY);
		
		trace("worldPos: " + activeCamera.viewportToWorldCoordinates(Engine.canvas.stage.mouseX, Engine.canvas.stage.mouseY));
		
		var pos:Vector3 = activeCamera.viewportToWorldCoordinates(Engine.canvas.stage.mouseX, Engine.canvas.stage.mouseY);
		
		//var ray:Ray = new Ray (pos, pos.add(activeCamera.transform.forward).multiplyByFloats(100, 100, 100));
		
		var ray:Ray = activeCamera.screenPointToRay(Engine.canvas.stage.mouseX, Engine.canvas.stage.mouseY, 0);
		
		var rayhit:Collision = Physics.raycast(ray);
		
		//trace("2: " + cube2.boundingVolumes[0].center);
		
		if (rayhit.isColliding) {
			trace(rayhit.other.gameObject.name);
			
			var c:GameObject = new GameObject ("oc", cube.mesh.clone());
			c.transform.position = rayhit.direction;
		} else {
			trace ("bosta nenhuma");
		}
		
		
		//trace("screenPos: " + Engine.canvas.stage.mouseX + " - " + Engine.canvas.stage.mouseY);
	}
	
	private function onMouseMove (_) {
		
		//cube.transform.position = activeCamera.viewportToWorldCoordinates(Engine.canvas.stage.mouseX, Engine.canvas.stage.mouseY);
		
		//var pos:Vector3 = activeCamera.viewportToWorldCoordinates(Engine.canvas.stage.mouseX, Engine.canvas.stage.mouseY);
		
		//var ray:Ray = new Ray (pos, cube.transform.position.subtract(pos));
		
		//trace 
		
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