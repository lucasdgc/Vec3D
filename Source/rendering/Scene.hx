package rendering;

import lime.utils.UInt16Array;
import lime.utils.UInt32Array;
import objects.GameObject;
import objects.Camera;
import openfl.geom.Vector3D;
import openfl.utils.Float32Array;
import com.babylonhx.math.Vector3;
import utils.Color;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Scene
{
	var engine:Engine;

	public var gameObject:Array<GameObject>;
	
	public var cameras:Array<Camera>;
	public var activeCamera:Camera;
	
	public function new(engine:Engine, loadOnCreate:Bool = true ) 
	{
		this.engine = engine;
		
		gameObject = new Array();
		cameras = new Array();
		
		//if(loadOnCreate) {
		engine.currentScene = this;
		activeCamera = new Camera (new Vector3(0, 0, -10), Vector3.Zero(), "main_camera");
		//}
	}
	
	public function getVertexColorBatch():Float32Array{
		var batch:Array<Float> = new Array();
		
		trace("Batching static meshes...");
		
		var batchedCount:Int = 0;
		
		for(go in gameObject) {
			var mesh = go.mesh;
			if (mesh.isStatic) {
				batchedCount ++;
				for (vert in 0...mesh.vertices.length) {
					batch.push(mesh.vertices[vert].x + go.position.x);
					batch.push(mesh.vertices[vert].y + go.position.y);
					batch.push(mesh.vertices[vert].z + go.position.z);
					var isInGroup = false;
					var vertexColor:Color = new Color();
					for (vGroup in mesh.vertexGroups) {
						if (vGroup.isColorGroup) {
							for (vertIndex in vGroup.verticesIndex) {
								if (vertIndex == vert) {
									isInGroup = true;
									vertexColor = vGroup.color;
									break;
								}
							}
						}
					}
					
					if(!isInGroup) {
						vertexColor = Color.white;
					}
					
					batch.push(vertexColor.r);
					batch.push(vertexColor.g);
					batch.push(vertexColor.b);
					batch.push(vertexColor.a);
				}
			}
		}
		
		trace(batchedCount + " meshes batched...");
		
		var returnBatch:Float32Array = new Float32Array(batch);
		return returnBatch;
	}
	
	public function getEdgesBatch():UInt16Array{
		var batch:Array<Float> = new Array();
		
		var prevVerticesTotal:Int = 0;
		for(go in gameObject) {
			var mesh = go.mesh;
			if(mesh.isStatic) {
				for(edge in mesh.edges) {
					batch.push(edge.a + prevVerticesTotal);
					batch.push(edge.b + prevVerticesTotal);
				}
				prevVerticesTotal += mesh.vertices.length;
				trace("prevVertices: "+prevVerticesTotal);
			}
		}
		var returnBatch = new UInt16Array (batch);
		return returnBatch;
	}
	
	public function getFacesBatch ():UInt32Array {
		var batch:Array<Int> = new Array();
		
		for(go in gameObject) {
			var mesh = go.mesh;
			if(mesh.isStatic) {
				for(face in mesh.faces) {
					batch.push(face.a);
					batch.push(face.b);
					batch.push(face.c);
				}
			}
		}
		
		var returnBatch:UInt32Array = new UInt32Array (batch);
		return returnBatch;
		
	}
	
	public function getStaticVertexBatch():Float32Array{
		var batch:Array<Float> = new Array();
		
		//trace(gameObject[0].mesh.name);
		
		for(go in gameObject) {
			var mesh = go.mesh;
			if(mesh.isStatic) {
				for(vert in mesh.vertices){
					batch.push(vert.x + go.position.x);
					batch.push(vert.y + go.position.y);
					batch.push(vert.z + go.position.z);
				}
			}
		}
		
		var returnBatch = new Float32Array (batch);
		
		return returnBatch;
	}
}