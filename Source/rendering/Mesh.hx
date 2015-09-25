package rendering;

import com.babylonhx.math.Vector3;
import com.babylonhx.math.Matrix;
import lime.graphics.opengl.GLBuffer;
import objects.GameObject;
import openfl.Assets;
import haxe.Json;
import openfl.gl.GL;
import openfl.utils.Float32Array;
import lime.utils.UInt16Array;
import rendering.Mesh.MeshBuffer;
import utils.Color;
import utils.SimpleMath;

/**
 * ...
 * @author Lucas Gonçalves
 */

 typedef MeshBuffer = {
	var vertexBuffer:GLBuffer;
	var edgeIndexBuffer:GLBuffer;
	var faceIndexBuffer:GLBuffer;
}
 
 typedef VertexGroup = {
	 var color:Color;
	 var name:String;
	 var id:Int;
	 var verticesIndex:Array<Int>;
	 var isColorGroup:Bool;
 }
 
 /*typedef VertexGroupData = {
	 var verticesArray:Float32Array;
	 var color:utils.Color;
 }*/
 
 typedef Edge = {
	 var a:Int;
	 var b:Int;
 }
 
 typedef Face = {
	 var a:Int;
	 var b:Int;
	 var c:Int;
 }
 
class Mesh
{
	private static var meshesPath:String = "assets/Meshes/";
	private static var meshesExtension:String = ".vec3d";
	
	public static var vertexStep = 1;
	
	//public static var meshes:Array<Mesh> = new Array();
	private static var defaultMeshName:String = "mesh_";
	
	//public static var staticVertexBash:Float32Array = new Float32ArrayData ();
	
	public static var drawingEdges:Bool = true;
	public static var drawingPoints:Bool = true;
	public static var drawingFaces:Bool = true;
	
	public var name:String;
	public var vertices:Array<Vector3>;
	public var edges:Array<Edge>;
	public var faces:Array<Face>;
	
	public var vertexGroups:Array<VertexGroup>;
	
	public var relPosition:Vector3;
	public var relRotation:Vector3;
	
	public var gameObject:GameObject;
	
	public var drawEdges:Bool;
	public var drawPoints:Bool;
	public var drawFaces:Bool;
	
	public var isStatic:Bool = true;
	
	/*public var rawVertexData:Float32Array;
	public var rawEdgesData:Float32Array;
	public var rawFacesData:Float32Array;*/
	
	public var pointColor:utils.Color;
	public var edgeColor:utils.Color;
	public var faceColor:utils.Color;
	
	public var meshBuffer:MeshBuffer;
	
	public function new(name:String = "", verticesCount:Int = 0, facesCount:Int = 0, edgesCount:Int = 0, drawPoints:Bool = true, drawEdges:Bool = true, drawFaces:Bool = true) {
		//meshes.push(this);
		
		relPosition = new Vector3();
		relRotation = new Vector3();
		
		vertices = new Array<Vector3>();
		if(verticesCount > 0){
			for(i in 0...verticesCount){
				vertices.push(new Vector3(0, 0, 0));
			}
		}
		
		faces = new Array<Face>();
		if(facesCount > 0) {
			for (i in 0...facesCount) {
				var f:Face = { a : 0, b : 0, c: 0 };
				faces.push(f);
			}
		}
		
		edges = new Array<Edge>();
		if(edgesCount > 0) {
			for (i in 0...edgesCount) {
				var e:Edge = { a : 0, b : 0 };
				edges.push(e);
			}
		}
		
		vertexGroups = new Array();
		
		pointColor = utils.Color.white;
		edgeColor = utils.Color.white;
		faceColor = utils.Color.black;
		
		/*this.rawVertexData = new Float32Array(vertices);
		this.rawEdgesData = new Float32Array(edges);
		this.rawFacesData = new Float32Array(faces);*/
		
		this.drawEdges = drawEdges;
		this.drawFaces = drawFaces;
		this.drawPoints = drawPoints;
		
		if(name != ""){
			this.name = name;
		} else {
			this.name = defaultMeshName+Engine.instance.currentScene.gameObject.length;
		}
		
		isStatic = true;
	}
	
	public function bindMeshBuffers() {
		if(this.meshBuffer == null){
			initMeshBuffers ();
		}
		
		GL.bindBuffer(GL.ARRAY_BUFFER, meshBuffer.vertexBuffer);
		
		if(isStatic){
			GL.bufferData(GL.ARRAY_BUFFER, getBindVertexData(), GL.STATIC_DRAW);
		} else {
			GL.bufferData(GL.ARRAY_BUFFER, getBindVertexData(), GL.DYNAMIC_DRAW);
		}
		
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, meshBuffer.edgeIndexBuffer);
		
		if(isStatic){
			GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, getBindEdgeData(), GL.STATIC_DRAW);
		} else {
			GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, getBindEdgeData(), GL.DYNAMIC_DRAW);
		}
		
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		
	}
	
	public function getBindVertexData():Float32Array{
		var batch:Array<Float> = new Array();
		
		for(i in 0...vertices.length){
			batch.push(vertices[i].x);
			batch.push(vertices[i].y);
			batch.push(vertices[i].z);
			
			var isInGroup = false;
			var vertexColor:Color = new Color();
			
			for(vGroup in vertexGroups){
				for (vGroup in vertexGroups) {
					if (vGroup.isColorGroup) {
						for (vertIndex in vGroup.verticesIndex) {
							if (vertIndex == i) {
								isInGroup = true;
								vertexColor = vGroup.color;
								break;
							}
						}
					}
				}
			}
			if(!isInGroup) {
				vertexColor = this.pointColor;
			}
			batch.push(vertexColor.r);
			batch.push(vertexColor.g);
			batch.push(vertexColor.b);
			batch.push(vertexColor.a);
		}
		
		var returnBatch:Float32Array = new Float32Array (batch);
		return returnBatch;
	}
	
	public function getBindEdgeData():UInt16Array {
		var batch:Array<Int> = new Array();
		
		for( edge in edges ){
			batch.push(edge.a);
			batch.push(edge.b);
		}
		
		var returnBatch:UInt16Array = new UInt16Array (batch);
		return returnBatch;
	}
	
	public function getBindFaceData():UInt16Array {
		var batch:Array<Int> = new Array();
		
		for( face in faces ){
			batch.push(face.a);
			batch.push(face.b);
			batch.push(face.c);
		}
		
		var returnBatch:UInt16Array = new UInt16Array (batch);
		return returnBatch;
	}
	
	public function initMeshBuffers(){
		meshBuffer = { vertexBuffer : GL.createBuffer(), edgeIndexBuffer : GL.createBuffer(), faceIndexBuffer : GL.createBuffer() } ;
	}
	
	public static function loadMeshFile(filename:String, _isStatic:Bool = true):Mesh {
		if(filename != ""){
			var meshes:Array<Mesh> = new Array();
			
			var meshData = Assets.getText(meshesPath + filename + meshesExtension);	
			
			if (meshData == null) {
				throw "Error loading mesh data "+meshesPath + filename + meshesExtension;
			}
			
			var jsonData:Dynamic = Json.parse(meshData);
			
			//var mesh:Mesh = new Mesh();
			
			for(i in 0...jsonData.meshes.length) {
				var verticesArray:Dynamic =  jsonData.meshes[i].vertices;
				var facesArray:Dynamic =  jsonData.meshes[i].faces;
				var edgesArray:Dynamic = jsonData.meshes[i].edges;
				
				var vGroups:Dynamic = jsonData.meshes[i].vertexGroups;
				var vertexGroupCount = vGroups.length;
				
				var verticesCount = Std.int(verticesArray.length / (vertexStep * 3));
				var facesCount = Std.int(facesArray.length / 3);
				var edgesCount = Std.int(edgesArray.length / 2);
				
				/*if(i == 0){
					//mesh = new Mesh(jsonData.meshes[i].name, verticesCount, facesCount, edgesCount);
				} else {
					//mesh = mesh;
				}*/
				
				var mesh = new Mesh(jsonData.meshes[i].name, verticesCount, facesCount, edgesCount);
				//mesh.gameObject = gameObject;
				
				mesh.isStatic = _isStatic;
				
				var pos:Vector3 = new Vector3(jsonData.meshes[i].position[0], jsonData.meshes[i].position[1], jsonData.meshes[i].position[2]);
				
				//relPosition = pos;
				
				var rot:Vector3 = new Vector3(jsonData.meshes[i].rotation[0], jsonData.meshes[i].rotation[1], jsonData.meshes[i].rotation[2]);
				
				//mesh.relRotation = rot;
				
				for(v in 0...vertexGroupCount){
					var _id = vGroups[v].id;
					var _name:String = vGroups[v].name;
					
					var _isColorGroup:Bool = false;
					
					var _color:utils.Color = utils.Color.white;
					
					var _vertices:Array<Int> = new Array();
					
					var vgd:Dynamic = vGroups[v].items;
					
					for(vgi in 0...vgd.length){
						_vertices.push(vgd[vgi]);
					}
					
					var nameLower:String = _name.toLowerCase();
					
					var nameSplit = nameLower.split('_');
					
					if(nameSplit.length > 0){
						if (nameSplit[0] == "color") {	
							_isColorGroup = true;
							_color = utils.Color.getColorHexByName(nameSplit[1]);
						}
					}
					
					var vGroup:VertexGroup = { id : _id, name : _name, color : _color, verticesIndex : _vertices, isColorGroup : _isColorGroup};
					
					mesh.vertexGroups.push(vGroup);
					
					//trace(mesh.vertexGroups.length);
				}
				
				for(k in 0...verticesCount){
					var x = Std.parseFloat(verticesArray[k * 3]);
					var y = Std.parseFloat(verticesArray[k * 3 + 1]);
					var z = Std.parseFloat(verticesArray[k * 3 + 2]);
					
					if(i == 0){
						mesh.vertices[k] = new Vector3(x, y, z);
					} /*else {
						mesh.vertices[mesh.vertices.length] = new Vector3(x + pos.x, y + pos.y, z + pos.z);
					}*/
				}
				
				trace("Successfully loaded mesh: " + mesh.name);
				trace(mesh.name +" Vertex Count: " + mesh.vertices.length);
				
				for(j in 0...facesCount){
					var _a = Std.int(facesArray[j * 3]);
					var _b = Std.int(facesArray[j * 3 + 1]);
					var _c = Std.int(facesArray[j * 3 + 2]);
					
					mesh.faces[j] = { a : _a, b : _b, c : _c };
				}
				
				//trace("Face Count: " + mesh.name + " - " + facesArray.length / 3);
				trace(mesh.name + " Face Count: " + mesh.faces.length);
				
				for(l in 0...edgesCount){
					var _a = Std.int(edgesArray[l * 2]);
					var _b = Std.int(edgesArray[l * 2 + 1]);
				
					mesh.edges[l] = { a : _a, b : _b };
				}
				
				trace(mesh.name + " Edges Count: " + mesh.edges.length);
				
				/*if (mesh.isStatic) {
					//mesh.setRawData();
					//mesh.setGroupBatches();
				}
				
				if(mesh != null && !gameObject.isStatic){
					//mesh.bindMeshBuffers();
				}*/
				
				return mesh;
			}
			
		} else {
			throw "Mesh path not specified...";
		}
		
		return null;
	}
	
	/*public function setGroupBatches(){
		setVertexGroupsBatch();
		
		setEdgeGroupBatch();
	}
	
	public function setVertexGroupsBatch() {
		var vGroupArray:Array<VertexGroupData> = new Array();
		
		var groupedVertexIndexes:Array<Int> = new Array();
		
		for (vGroup in vertexGroups) {
			if(vGroup.isColorGroup){
				var vgIndexArray:Array<Float> = new Array();
				
				var vgColor:utils.Color = vGroup.color;
				
				for (vgIndex in vGroup.verticesIndex) {
					vgIndexArray.push(vertices[vgIndex].x);
					vgIndexArray.push(vertices[vgIndex].y);
					vgIndexArray.push(vertices[vgIndex].z);
					
					groupedVertexIndexes.push(vgIndex);
				}
				
				//trace(vGroup.color);
				
				var vgArrayData:Float32Array = new Float32Array(vgIndexArray);
				
				var vg:VertexGroupData = { color : vgColor, verticesArray : vgArrayData };
				
				vGroupArray.push(vg);
			}
		}
		
		var nonGroupedVertex:Array<Float> = new Array();
		var nonGroupedVertexColor = pointColor;
		
		if(vGroupArray.length > 0){
			for (vertIndex in 0...vertices.length) {
				var alreadySaved:Bool = false;
				for(vGroup in vertexGroups){
					for(vgIndex in vGroup.verticesIndex){
						if(vertIndex == vgIndex){
							alreadySaved = true;
						}
					}
				}
				if(!alreadySaved){
					nonGroupedVertex.push(vertices[vertIndex].x);
					nonGroupedVertex.push(vertices[vertIndex].y);
					nonGroupedVertex.push(vertices[vertIndex].z);
					
					groupedVertexIndexes.push(vertIndex);
				}
			}
		}
		
		if (nonGroupedVertex.length > 0) {
			var vgVerts = new Float32Array (nonGroupedVertex);
			
			var vgData:VertexGroupData = { color : nonGroupedVertexColor, verticesArray : vgVerts };
			vGroupArray.push(vgData);
		}
		
		vertexGroupBatch = vGroupArray;
	}
	
	public function setEdgeGroupBatch() {
		var edgeBatch:Array<VertexGroupData> = new Array();
		var savedEdges:Array<Edge>= new Array();
		
		for (vGroup in vertexGroups) {
			var edgeInfo:Array<Float> = new Array();
			for(edge in edges){
				var edgeA = edge.a;
				var edgeB = edge.b;
				
				var foundA:Bool = false;
				var foundB:Bool = false;
				for (vgIndex in vGroup.verticesIndex) {
					if(vgIndex == edgeA){
						foundA = true;
						for(vIndexB in vGroup.verticesIndex){
							if(vIndexB == edgeB){
								foundB = true;
								edgeInfo.push(vertices[edge.a].x);
								edgeInfo.push(vertices[edge.a].y);
								edgeInfo.push(vertices[edge.a].z);
								
								edgeInfo.push(vertices[edge.b].x);
								edgeInfo.push(vertices[edge.b].y);
								edgeInfo.push(vertices[edge.b].z);
								
								savedEdges.push(edge);
							}
						}
					}
				}
			}
			
			if(edgeInfo.length > 0){
				var _color = vGroup.color;
				var _edgeArray = new Float32Array(edgeInfo);
				
				var _edgeData:VertexGroupData = { color : _color, verticesArray : _edgeArray };
				
				edgeBatch.push(_edgeData);
			}
		}
		
		var nonSavedEdges:Array<Float> = new Array();
		var nonSavedColor:utils.Color = edgeColor;
		
		if (edgeBatch.length > 0){
			for (edge in edges) {
				var saved:Bool = false;
				for(savedEdge in savedEdges){
					if(edge == savedEdge){
						saved = true;
						break;
					}
				}
				
				if(!saved){
					nonSavedEdges.push(vertices[edge.a].x);
					nonSavedEdges.push(vertices[edge.a].y);
					nonSavedEdges.push(vertices[edge.a].z);
					
					nonSavedEdges.push(vertices[edge.b].x);
					nonSavedEdges.push(vertices[edge.b].y);
					nonSavedEdges.push(vertices[edge.b].z);
				}
			}
		}
		
		if (nonSavedEdges.length > 0) {
			var nsEdges = new Float32Array (nonSavedEdges);
			
			var nonSavedbatch:VertexGroupData = { color : nonSavedColor, verticesArray : nsEdges };
			
			edgeBatch.push(nonSavedbatch);
		}
		
		edgeGroupBatch = edgeBatch;
	}
	
	public static function getRawVerticesData(verticesArray:Array<Vector3>):Array<Float>{
		var array:Array<Float> = [];
		
		for(vertex in verticesArray){
			array.push(vertex.x);
			array.push(vertex.y);
			array.push(vertex.z);
		}
		
		return array;
	}
	
	public function setRawData(){
		var vertexArray:Array<Float> = new Array();
		for(vertex in this.vertices){
			vertexArray.push(vertex.x);
			vertexArray.push(vertex.y);
			vertexArray.push(vertex.z);
		}
		
		var edgesArray:Array<Float> = new Array();
		for(edge in this.edges){
			edgesArray.push(vertices[edge.a].x);
			edgesArray.push(vertices[edge.a].y);
			edgesArray.push(vertices[edge.a].z);
			
			edgesArray.push(vertices[edge.b].x);
			edgesArray.push(vertices[edge.b].y);
			edgesArray.push(vertices[edge.b].z);
		}
		
		var facesArray:Array<Float> = new Array();
		for(face in this.faces){
			facesArray.push(vertices[face.a].x);
			facesArray.push(vertices[face.a].y);
			facesArray.push(vertices[face.a].z);
			
			facesArray.push(vertices[face.b].x);
			facesArray.push(vertices[face.b].y);
			facesArray.push(vertices[face.b].z);
			
			facesArray.push(vertices[face.b].x);
			facesArray.push(vertices[face.b].y);
			facesArray.push(vertices[face.b].z);
			
			facesArray.push(vertices[face.c].x);
			facesArray.push(vertices[face.c].y);
			facesArray.push(vertices[face.c].z);
			
			facesArray.push(vertices[face.c].x);
			facesArray.push(vertices[face.c].y);
			facesArray.push(vertices[face.c].z);
			
			facesArray.push(vertices[face.a].x);
			facesArray.push(vertices[face.a].y);
			facesArray.push(vertices[face.a].z);
		}
		
		rawVertexData = new Float32Array (vertexArray);
		rawEdgesData = new Float32Array (edgesArray);
		rawFacesData = new Float32Array (facesArray);
	}*/
	
	public function addVertex(x:Float, y:Float, z:Float){
		vertices.push(new Vector3(x, y, z));
	}
	
	public function addFace(pointA:Int, pointB:Int, pointC:Int){
		var face:Face = { a : pointA, b : pointB, c : pointC };
		faces.push(face);
	}
	
	public function addEdge (pointA:Int, pointB:Int) {
		var edge:Edge = { a : pointA, b : pointB };
		edges.push (edge);
	}
	
	public function merge (newMesh:Mesh) {
		var previousVerticesLength:Int = this.vertices.length;
		
		for (vert in newMesh.vertices) {
			var goX:Float = 0;
			var goY:Float = 0;
			var goZ:Float = 0;
			
			if (newMesh.gameObject != null) {
				goX = newMesh.gameObject.position.x;
				goY = newMesh.gameObject.position.y;
				goZ = newMesh.gameObject.position.z;
			}
			
			this.addVertex (vert.x + goX, vert.y + goY, vert.z + goZ);
		}
		
		for (edge in newMesh.edges) {
			this.addEdge (edge.a + previousVerticesLength, edge.b + previousVerticesLength);
		}
		
		for (face in newMesh.faces) {
			this.addFace (face.a + previousVerticesLength, face.b + previousVerticesLength, face.c + previousVerticesLength);
		}
		
		var vGroupIndex:Int = 1;
		for (vGroup in newMesh.vertexGroups) {
			vGroup.name += Std.string(vGroupIndex);
			for (index in 0...vGroup.verticesIndex.length) {
				vGroup.verticesIndex[index] = vGroup.verticesIndex[index] + previousVerticesLength;
			}
			vGroupIndex ++;
			this.vertexGroups.push(vGroup);
		}
		
		newMesh.destroy(true);
		
		this.bindMeshBuffers();
	}
	
	public function translate (value:Vector3) {
		for (vert in this.vertices) {
			vert.x += value.x;
			vert.y += value.y;
			vert.z += value.z;
		}
		this.bindMeshBuffers ();
	}
	
	public function rotate (value:Vector3) {		
		for (vert in this.vertices) {
					
			var rotationMatrix:Matrix = Matrix.RotationYawPitchRoll(value.y, value.x, value.z).multiply(Matrix.Zero());
			var newRot:Vector3 = SimpleMath.matrixToEulerAngles(rotationMatrix);
			
			for (i in 0...rotationMatrix.m.length) {
				trace ("i: "+i+" value: "+ rotationMatrix.m[i]);
			}
			
			vert.x += newRot.x;
			vert.y += newRot.y;
			vert.z += newRot.z;
			
			trace(vert);
		}
		
		
		this.bindMeshBuffers ();
	}
	
	public function setVetexGroupColor (index:Int = 0, newColor:Color) {
		
		vertexGroups[index].color = newColor;
		
		bindMeshBuffers ();
	}
	
	public function scale (value:Vector3) {
		for (vert in this.vertices) {
			vert.x *= value.x;
			vert.y *= value.y;
			vert.z *= value.z;
		}
		this.bindMeshBuffers ();
	}
	
	public static function toggleAllEdges() {
		Mesh.drawingEdges = !Mesh.drawingEdges;
		for(go in Engine.instance.currentScene.gameObject){
			go.mesh.drawEdges = Mesh.drawingEdges;
		}
	}
	
	public static function toggleAllPoints() {
		Mesh.drawingPoints = !Mesh.drawingPoints;
		for(go in Engine.instance.currentScene.gameObject){
			go.mesh.drawPoints = Mesh.drawingPoints;
		}
	}
	
	public function destroy (isRecursive:Bool = false) {
		this.vertices = null;
		this.edges = null;
		this.faces = null;
		
		this.vertexGroups = null;
	
		disposeMeshBuffer();
		
		if (gameObject != null) {
			gameObject.mesh = null;
			
			if (isRecursive) {
				gameObject.destroy();
			}
		}
		
	}
	
	public function disposeMeshBuffer () {
		GL.deleteBuffer(this.meshBuffer.vertexBuffer);
		GL.deleteBuffer(this.meshBuffer.edgeIndexBuffer);
		GL.deleteBuffer(this.meshBuffer.faceIndexBuffer);
	}
}