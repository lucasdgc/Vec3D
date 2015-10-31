package;

import input.InputAxis;
import input.VirtualAnalogStick;
import math.Vector3;
import objects.GameObject;
import objects.PointLight;
import openfl.events.Event;
import openfl.geom.Rectangle;
import rendering.Cubemap;
import rendering.Mesh;
import rendering.Primitives;
import rendering.Scene;
import utils.Color;
import utils.Time;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Lighting extends Scene
{
	var cube1:GameObject;
	var monkey2:GameObject;
	var monkey3:GameObject;
	var monkey4:GameObject;
	var monkey5:GameObject;
	var pointLight:PointLight;
	
	public function new() 
	{
		super ();
		skybox = new Cubemap ( "512/negx", "512/posx", "512/negy", "512/posy", "512/negz", "512/posz" );
		//skybox = new Cubemap ( "left.jpg", "right.jpg", "bottom.jpg", "top.jpg", "back.jpg", "front.jpg" );
		
		#if mobile
		var rect:Rectangle = new Rectangle ( Engine.canvas.stage.x, Engine.canvas.stage.y, Engine.canvas.stage.stageWidth, Engine.canvas.stage.stageHeight );
		var a = new VirtualAnalogStick ( rect, "Analog X", "Analog Y" );
		#end
		//var cubeMesh:Mesh = Primitives.createCube ();
		var cubeMesh:Mesh = Mesh.loadMeshFile ( "faced_monkey" );
		//var cubeMesh:Mesh = Mesh.loadMeshFile ( "cube" );
		cubeMesh.calculateNormals ();
		cubeMesh.drawEdges = false;
		cube1 = new GameObject ( "monkey", cubeMesh, this );
		cube1.transform.scale = new Vector3 ( 0.5, 0.5, 0.5 );
		
		monkey2 = new GameObject ( "monkey2", cubeMesh.clone (), this );
		//monkey2.transform.scale = new Vector3 ( 0.5, 0.5, 0.5 );
		monkey2.transform.position = new Vector3 ( -3, 0, 3 );
		
		monkey3 = new GameObject ( "monkey2", cubeMesh.clone (), this );
		//monkey3.transform.scale = new Vector3 ( 0.5, 0.5, 0.5 );
		monkey3.transform.position = new Vector3 ( 3, 0, 3 );
		
		monkey4 = new GameObject ( "monkey2", cubeMesh.clone (), this );
		//monkey4.transform.scale = new Vector3 ( 0.5, 0.5, 0.5 );
		monkey4.transform.position = new Vector3 ( -3, 0, -3 );
		
		monkey5 = new GameObject ( "monkey2", cubeMesh.clone (), this );
		//monkey5.transform.scale = new Vector3 ( 0.5, 0.5, 0.5 );
		monkey5.transform.position = new Vector3 ( 3, 0, -3 );
		
		var floorMesh:Mesh = Mesh.loadMeshFile ( "cube" );
		floorMesh.calculateNormals ();
		var floor:GameObject = new GameObject ( "floor", floorMesh, this );
	
		floor.transform.position = new Vector3 ( 0, -1.5, 0 );
		floor.transform.scale = new Vector3 ( 5, 1, 5  );
		
		pointLight = new PointLight ( new Vector3 ( 0, 0, -1 ), 10, 3, Color.white, this );
		
		activeCamera.transform.position = new Vector3 ( 0, 10, -10 );
		activeCamera.transform.rotate ( new Vector3 ( -45, 0, 0 ) );
	}
	
	override public function update(event:Event) 
	{
		super.update(event);
		
		#if !mobile
		var h:Float = InputAxis.getValue ("Horizontal");
		var v:Float = InputAxis.getValue ("Vertical");
		#else
		var h:Float = InputAxis.getValue ("Analog X");
		var v:Float = InputAxis.getValue ("Analog Y");
		#end
		var rotationSpeed:Float = 15 * Time.deltaTime;
		var moveSpeed:Float = 10 * Time.deltaTime;
		
		pointLight.position.addInPlace ( new Vector3 ( h, 0, v ).multiplyByFloat ( moveSpeed ) );
		
		//cube1.transform.rotate ( cube1.transform.up.multiplyByFloat ( rotationSpeed ) );
		monkey2.transform.rotate ( monkey2.transform.up.multiplyByFloat ( - rotationSpeed ) );
		monkey3.transform.rotate ( monkey3.transform.up.multiplyByFloat ( rotationSpeed ) );
		monkey4.transform.rotate ( monkey4.transform.up.multiplyByFloat ( - rotationSpeed ) );
		monkey5.transform.rotate ( monkey5.transform.up.multiplyByFloat ( rotationSpeed ) );
		//cube1.transform.rotate ( cube1.transform.right.multiplyByFloat ( rotationSpeed / 2 ) );
		//activeCamera.transform.rotate ( activeCamera.transform.right.multiplyByFloat ( - rotationSpeed ) );
	}
	
}