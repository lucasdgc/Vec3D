package rendering;

import events.Vec3DEvent;
import events.Vec3DEventDispatcher;
import lime.utils.UInt16Array;
import lime.utils.UInt32Array;
import objects.GameObject;
import objects.Camera;
import objects.Light;
import openfl.utils.Float32Array;
import math.Vector3;
import physics.World;
import utils.Color;
import openfl.gl.GL;
import rendering.Mesh;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import objects.PointLight;

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
	public var lights:Array<Light>;
	public var spotLights:Array<Light>;
	public var pointLights:Array<Light>;
	
	public var sun:Light;
	
	public var staticMeshBuffer:MeshBuffer;
	
	public var backgroundColor:Color = Color.black;
	public var skybox:Cubemap;
	
	public var staticMesh:Mesh;
	
	public var staticVertexSize:Int;
	public var staticEdgeSize:Int;
	public var staticFaceSize:Int;
	
	public var drawStaticPoints:Bool = false;
	public var drawStaticEdges:Bool = true;
	public var drawStaticFaces:Bool = false;
	
	private var isFirstStaticMerge:Bool = true;
	
	public var name (default, null):String;
	
	public function new() 
	{
		//this.engine = engine;
		
		gameObject = new Array();
		cameras = new Array();
		
		//engine.currentScene = this;
		activeCamera = new Camera (new Vector3(0, 0, -10), "main_camera", this);
		lights = new Array ();
		spotLights = new Array ();
		pointLights = new Array ();
		
		staticMeshBuffer = { vertexBuffer : GL.createBuffer(), edgeIndexBuffer : GL.createBuffer(), faceIndexBuffer : GL.createBuffer() };
		
		staticMesh = new Mesh("static_mesh");
		staticMesh.isStatic = true;
		staticMesh.bindMeshBuffers();
		
		var staticGO:GameObject = new GameObject ("static_gameobject", staticMesh, this);
		
		Vec3DEventDispatcher.instance.addEventListener (Vec3DEvent.SCENE_INSTANTIATED, onSceneInstantiated);
		//staticGO.isStatic = true;
	}
	
	private function sceneLoaded () {
		Vec3DEventDispatcher.instance.dispatchSceneLoadedEvent();
	}
	
	public function onSceneInstantiated (e:Event) {
		Vec3DEventDispatcher.instance.removeEventListener (Vec3DEvent.SCENE_INSTANTIATED, onSceneInstantiated);
		Vec3DEventDispatcher.instance.dispatchSceneLoadedEvent();
		start ();
	}
	
	private function load () {
		Vec3DEventDispatcher.instance.addEventListener (Vec3DEvent.SCENE_INSTANTIATED, onSceneInstantiated);
	}
	
	public function start () {
		
	}
	
	public function mergeStaticMeshes () {
		var staticCount:Int = 0;
		var notStaticCount:Int = 0;
		
		trace ("Merging static meshes...");
		var i:Int = 2;
		while (i < gameObject.length) {
			if (gameObject[i].isStatic) {
				if (gameObject[i].mesh != null) {
					staticMesh.merge(gameObject[i].mesh);
					staticCount ++;
				}
			} else {
				if (gameObject[i].mesh != null) {
					notStaticCount ++;
				}
				i ++;
			}
		}
		
		trace (staticCount+" static meshes merged...");
		trace (notStaticCount+" NOT static meshes NOT merged...");
		
		staticMesh.bindMeshBuffers ();
	}
	
	public function update (event:Event) {
		
		//activeCamera.update();
		
		
		
	}
	
	public function dispose () {
		while (gameObject.length > 0) {
			gameObject[0].destroy();
		}
		
		trace("Disposing scene: " + name);
		
		World.clearWorld();
	}
	
	
	public function reset () {
		
	}
	/*public function bindStaticMeshBuffer () {
		
		GL.bindBuffer(GL.ARRAY_BUFFER, staticMeshBuffer.vertexBuffer);
		GL.bufferData(GL.ARRAY_BUFFER, getVertexColorBatch(), GL.STATIC_DRAW);
		
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, staticMeshBuffer.edgeIndexBuffer);
		GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, getEdgesBatch(), GL.STATIC_DRAW);
		
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, staticMeshBuffer.faceIndexBuffer);
		GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, getFacesBatch(), GL.STATIC_DRAW);
		
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	}
	
	public function getVertexColorBatch():Float32Array{
		var batch:Array<Float> = new Array();
		
		trace("Batching static meshes...");
		
		var batchedCount:Int = 0;
		var notBatchedCount:Int = 0;
		
		for(go in gameObject) {
			var mesh = go.mesh;
			if (go.isStatic) {
				batchedCount ++;
				
				if(mesh.meshBuffer != null){
					GL.deleteBuffer(mesh.meshBuffer.vertexBuffer);
					GL.deleteBuffer(mesh.meshBuffer.edgeIndexBuffer);
					GL.deleteBuffer(mesh.meshBuffer.faceIndexBuffer);
				}
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
						vertexColor = mesh.pointColor;
					}
					
					batch.push(vertexColor.r);
					batch.push(vertexColor.g);
					batch.push(vertexColor.b);
					batch.push(vertexColor.a);
				}
			} else {
				notBatchedCount ++;
			}
		}
		
		trace(batchedCount + " meshes batched...");
		trace(notBatchedCount + " meshes NOT batched...");
		
		staticVertexSize = Std.int(batch.length / 7);
		
		trace("Vertices batched: "+staticVertexSize);
		
		var returnBatch:Float32Array = new Float32Array(batch);
		return returnBatch;
	}
	
	public function getEdgesBatch():UInt16Array{
		var batch:Array<Float> = new Array();
		
		var prevVerticesTotal:Int = 0;
		for(go in gameObject) {
			var mesh = go.mesh;
			if(go.isStatic) {
				for(edge in mesh.edges) {
					batch.push(edge.a + prevVerticesTotal);
					batch.push(edge.b + prevVerticesTotal);
				}
				prevVerticesTotal += mesh.vertices.length;
				//trace("prevVertices: "+prevVerticesTotal);
			}
		}
		
		staticEdgeSize = Std.int(batch.length / 2);
		trace("Edges batched: "+staticEdgeSize);
		
		var returnBatch = new UInt16Array (batch);
		return returnBatch;
	}
	
	public function getFacesBatch ():UInt32Array {
		var batch:Array<Int> = new Array();
		
		for(go in gameObject) {
			var mesh = go.mesh;
			if(go.isStatic) {
				for(face in mesh.faces) {
					batch.push(face.a);
					batch.push(face.b);
					batch.push(face.c);
				}
			}
		}
		
		staticFaceSize = Std.int(batch.length / 2);
		trace("Faces batched: "+staticFaceSize);
		
		var returnBatch:UInt32Array = new UInt32Array (batch);
		return returnBatch;
		
	}
	
	public function getStaticVertexBatch():Float32Array{
		var batch:Array<Float> = new Array();
		
		//trace(gameObject[0].mesh.name);
		
		for(go in gameObject) {
			var mesh = go.mesh;
			if(go.isStatic) {
				for(vert in mesh.vertices){
					batch.push(vert.x + go.position.x);
					batch.push(vert.y + go.position.y);
					batch.push(vert.z + go.position.z);
				}
			}
		}
		
		var returnBatch = new Float32Array (batch);
		
		return returnBatch;
	}*/
}