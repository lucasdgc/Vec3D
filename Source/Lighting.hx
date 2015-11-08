package;

import input.InputAxis;
import input.VirtualAnalogStick;
import materials.Material;
import math.Vector3;
import objects.GameObject;
import objects.Light;
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
	var pointLight:Light;
	
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
		var cubeMesh:Mesh = Mesh.loadMeshFile ( "sphere" );
		//var cubeMesh:Mesh = Mesh.loadMeshFile ( "cube" );
		//cubeMesh.calculateNormals ();
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
		//floorMesh.calculateNormals ();
		var floor:GameObject = new GameObject ( "floor", floorMesh, this );
	
		floor.transform.position = new Vector3 ( 0, -1.5, 0 );
		floor.transform.scale = new Vector3 ( 5, 1, 5  );
		
		sun = new Light ( LightType.DIRECTIONAL, new Vector3 ( 0, 0, -1 ), 10, 3, Color.yellow, this );
		sun.transform.rotate ( new Vector3 ( -45, 0, 0 ) );
		var material:Material = new Material ( "bricks_a.jpg", "", "bricks_m.png", "bricks_s.png" );
		var material2:Material = new Material ( "rustmetal_a.png", "", "rustmetal_m.png", "rustmetal_s.png" );
		var material3:Material = new Material ( "tiledroad_a.png", "", "tiledroad_m.png", "tiledroad_s.png" );
		floor.mesh.bindMaterialAt ( material2 );
		cubeMesh.bindMaterialAt ( material );
		monkey2.mesh.bindMaterialAt ( material );
		monkey3.mesh.bindMaterialAt ( material2 );
		monkey4.mesh.bindMaterialAt ( material3 );
		monkey5.mesh.bindMaterialAt ( material );
		
		pointLight = new Light ( LightType.SPOT, new Vector3 ( 0, 0, -1 ), 10, 3, Color.white, this );
		pointLight.cutoff = 0.9;
		
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

		//pointLight.transform.position = pointLight.transform.position.add ( new Vector3 ( h, 0, v ).multiplyByFloat ( moveSpeed ) );
		activeCamera.transform.position = activeCamera.transform.position.add ( new Vector3 ( h, 0, v ).multiplyByFloat ( moveSpeed ) );
		
		
		//sun.transform.rotation = sun.transform.rotation.add ( new Vector3 ( 0, rotationSpeed, 0 ) );
		monkey2.transform.rotateAroundPoint ( cube1.transform.position, Vector3.Up(), rotationSpeed );
		monkey3.transform.rotateAroundPoint ( cube1.transform.position, Vector3.Up(), rotationSpeed );
		monkey4.transform.rotateAroundPoint ( cube1.transform.position, Vector3.Up(), rotationSpeed );
		monkey5.transform.rotateAroundPoint ( cube1.transform.position, Vector3.Up(), rotationSpeed );
		
		//cube1.transform.rotate ( cube1.transform.up.multiplyByFloat ( rotationSpeed ) );
		//monkey2.transform.rotate ( monkey2.transform.up.multiplyByFloat ( - rotationSpeed ) );
		//monkey3.transform.rotate ( monkey3.transform.up.multiplyByFloat ( rotationSpeed ) );
		//monkey4.transform.rotate ( monkey4.transform.up.multiplyByFloat ( - rotationSpeed ) );
		//monkey5.transform.rotate ( monkey5.transform.up.multiplyByFloat ( rotationSpeed ) );
		//cube1.transform.rotate ( cube1.transform.right.multiplyByFloat ( rotationSpeed / 2 ) );
		//activeCamera.transform.rotate ( activeCamera.transform.right.multiplyByFloat ( - rotationSpeed ) );
	}
	
}