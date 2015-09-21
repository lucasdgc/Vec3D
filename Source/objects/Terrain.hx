package objects;

import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import rendering.Mesh;
import openfl.Assets;
import rendering.primitives.Primitives;
import openfl.gl.GL;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Terrain extends GameObject
{
	public static var terrainDirectory:String = "assets/Images/Terrain/";
	
	public var heightMap:BitmapData;
	
	public var height:Float = 3;
	public var size:Float = 4;
	
	public function new(heightMapPath:String) 
	{

		//heightMap = Assets.loadBitmapData(terrainDirectory + heightMapPath);
		
		//heightMap = new BitmapData (32, 32);
		
		heightMap = Assets.getBitmapData (terrainDirectory + heightMapPath);
		
		trace(terrainDirectory + heightMapPath);
		
		//Assets.loadBitmapData (terrainDirectory + heightMapPath);
		
		if(heightMap != null){
			mesh = Primitives.createPlane (heightMap.width, this.size);
			
			shapeTerrain ();
			
			super("terrain_", mesh, true);
		} else {
			throw "Error loading heightmap...";
		}
	}
	
	private function shapeTerrain () {
		var pixelData:ByteArray = heightMap.getPixels (new Rectangle (0, 0, heightMap.width, heightMap.height) );
		
		var sum:Float = 0;
		for (i in 0...Std.int(heightMap.width * heightMap.width * 4)) {
			var height:Float = pixelData.readUnsignedByte();
			height *= .01;
			sum += height;
			
			if (i % 4 == 0) {
				mesh.vertices[Std.int(i/4)].y = sum;
				sum = 0;
			}
		}
		
		mesh.bindMeshBuffers();
	}
	
}