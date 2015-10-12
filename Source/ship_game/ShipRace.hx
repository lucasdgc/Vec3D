package ship_game;

import math.Vec3D;
import math.Vector3;
import objects.GameObject;
import openfl.events.Event;
import rendering.Mesh;
import rendering.primitives.Primitives;
import rendering.Scene;
import ship_game.gameobjects.PlayerCamera;
import ship_game.gameobjects.Ship;
import utils.Time;

/**
 * ...
 * @author Lucas Gonçalves
 */
class ShipRace extends Scene
{
	private var playerShip:Ship;
	
	public function new() 
	{
		super();
		
		name = "Ship Race";
		
		playerShip = new Ship(this);
		playerShip.transform.position = new Vector3 (0, 1, 0);
		
		var floorMesh:Mesh = Primitives.createPlane (100, 1);
		floorMesh.drawEdges = false;
		floorMesh.drawPoints = true;
		var floor:GameObject = new GameObject ("floor", floorMesh, this);
		
		activeCamera = new PlayerCamera (new Vector3 (0, 4, -17), playerShip, 12.0, 0.3, this);
		
		//activeCamera.transform.rotate.
		
	}

	override public function update(event:Event) 
	{
		//super.update(event);
		 
		//var rotation:Vec3D = new Vec3D (12 * Time.deltaTime, 20 * Time.deltaTime, 10 * Time.deltaTime);
		
		//playerShip.transform.rotate(rotation);
	}
	
}