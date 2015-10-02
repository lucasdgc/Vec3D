package objects;

import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import rendering.Mesh;
import openfl.Assets;
import rendering.primitives.Primitives;
import openfl.gl.GL;
import rendering.Scene;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Terrain extends GameObject
{
	public static var terrainDirectory:String = "assets/Images/Terrain/";
	
	//public var heightMap:BitmapData;
	
	public var height:Float = 3;
	public var size:Float = 4;
	
	public function new(heightMapPath:String, scene:Scene) 
	{
		var heightMap:BitmapData = Assets.getBitmapData (terrainDirectory + heightMapPath);
		
		if(heightMap != null){
			mesh = Primitives.createPlane (heightMap.width, this.size);
			
			shapeTerrain (heightMap);
			
			super("terrain_", mesh, scene);
		} else {
			throw "Error loading heightmap...";
		}
	}
	
	private function shapeTerrain (heightMap:BitmapData) {
		var pixelData:ByteArray = heightMap.getPixels (new Rectangle (0, 0, heightMap.width, heightMap.height) );
		
		var sum:Float = 0;
		for (i in 0...Std.int(heightMap.width * heightMap.width * 4)) {
			var height:Float = pixelData.readUnsignedByte();
			height *= .05;
			sum += height;
			
			if (i % 4 == 0) {
				mesh.vertices[Std.int(i/4)].y = sum;
				sum = 0;
			}
		}
		heightMap = null;
		
		mesh.bindMeshBuffers();
	}
	
}