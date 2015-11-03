package rendering;

import materials.Material;
import math.Vector2;
import math.Vector3;
import math.Matrix;
import device.Device;
import device.ShaderProgram;
import lime.graphics.opengl.GLBuffer;
import objects.GameObject;
import openfl.Assets;
import haxe.Json;
import openfl.gl.GL;
import openfl.utils.Float32Array;
import lime.utils.UInt16Array;
import rendering.Mesh.MeshBuffer;
import rendering.Mesh.Vertex;
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
 
  typedef MaterialBinding = {
	 var material:Material;
	 var name:String;
	 var id:Int;
	 var verticesIndex:Array<Int>;
 }
 
 typedef Vertex = {
	var position:Vector3;
	var normal:Vector3;
	var uv:Vector2;
 }
 
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
	//public var vertices:Array<Vector3>;
	public var vertices:Array<Vertex>;
	public var edges:Array<Edge>;
	public var faces:Array<Face>;
	
	public var materials ( default, null ):Array<MaterialBinding>;
	
	public var vertexGroups:Array<VertexGroup>;
	
	public var relPosition:Vector3;
	public var relRotation:Vector3;
	
	public var gameObject:GameObject;
	
	public var drawEdges:Bool;
	public var drawPoints:Bool;
	public var drawFaces:Bool;
	
	public var isStatic:Bool = true;
	
	public var shaderProgram:ShaderProgram;
	
	/*public var rawVertexData:Float32Array;
	public var rawEdgesData:Float32Array;
	public var rawFacesData:Float32Array;*/
	
	public var pointColor:utils.Color;
	public var edgeColor:utils.Color;
	public var faceColor:utils.Color;
	
	public var meshBuffer:MeshBuffer;
	
	public var width:Float;
	public var height:Float;
	public var depth:Float;
	
	public function new(name:String = "", verticesCount:Int = 0, facesCount:Int = 0, edgesCount:Int = 0, drawPoints:Bool = false, drawEdges:Bool = false, drawFaces:Bool = true) {
		//meshes.push(this);
		
		relPosition = new Vector3();
		relRotation = new Vector3();
		
		vertices = new Array<Vertex>();
		/*if(verticesCount > 0){
			for(i in 0...verticesCount){
				vertices.push(new Vector3(0, 0, 0));
			}
		}*/
		
		faces = new Array<Face>();
		/*if(facesCount > 0) {
			for (i in 0...facesCount) {
				var f:Face = { a : 0, b : 0, c: 0 };
				faces.push(f);
			}
		}*/
		
		edges = new Array<Edge>();
		/*if(edgesCount > 0) {
			for (i in 0...edgesCount) {
				var e:Edge = { a : 0, b : 0 };
				edges.push(e);
			}
		}*/
		
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
		} else if (Engine.instance.currentScene != null) {
			this.name = defaultMeshName+Engine.instance.currentScene.gameObject.length;
		} else {
			this.name = "no_name";
		}
		
		materials = new Array ();
		
		shaderProgram = ShaderProgram.getShaderProgram(Device.DEFAULT_SHADER_NAME);
		
		isStatic = true;
	}
	
	public function bindMeshBuffers() {
		if(this.meshBuffer == null){
			initMeshBuffers ();
		}
		
		GL.bindBuffer (GL.ARRAY_BUFFER, meshBuffer.vertexBuffer);
		
		if(isStatic){
			GL.bufferData(GL.ARRAY_BUFFER, getBindVertexData(), GL.STATIC_DRAW);
		} else {
			GL.bufferData(GL.ARRAY_BUFFER, getBindVertexData(), GL.DYNAMIC_DRAW);
		}
		
		GL.bindBuffer (GL.ELEMENT_ARRAY_BUFFER, meshBuffer.edgeIndexBuffer);
		
		if(isStatic){
			GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, getBindEdgeData(), GL.STATIC_DRAW);
		} else {
			GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, getBindEdgeData(), GL.DYNAMIC_DRAW);
		}
		
		GL.bindBuffer (GL.ELEMENT_ARRAY_BUFFER, meshBuffer.faceIndexBuffer);
		
		if(isStatic){
			GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, getBindFaceData(), GL.STATIC_DRAW);
		} else {
			GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, getBindFaceData(), GL.DYNAMIC_DRAW);
		}
		
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		
		getMeshSize ();
	}
	
	private function getMeshSize () {
		var minX:Float = 0;
		var maxX:Float = 0;
		var minY:Float = 0;
		var maxY:Float = 0;
		var minZ:Float = 0;
		var maxZ:Float = 0;
		
		for (vert in vertices) {
			if (vert.position.x < minX) {
				minX = vert.position.x;
			}
			
			if (vert.position.x > maxX) {
				maxX = vert.position.x;
			}
			
			if (vert.position.y < minY) {
				minY = vert.position.y;
			}
			
			if (vert.position.y > maxY) {
				maxY = vert.position.y;
			}
			
			if (vert.position.z < minZ) {
				minZ = vert.position.z;
			}
			
			if (vert.position.z > maxZ) {
				maxZ = vert.position.z;
			}
		}
		
		width = Math.abs(maxX - minX);
		height = Math.abs(maxY - minY);
		depth = Math.abs(maxZ - minZ);
		
	}
	
	public function getBindVertexData():Float32Array{
		var batch:Array<Float> = new Array();
		
		for(i in 0...vertices.length){
			batch.push(vertices[i].position.x);
			batch.push(vertices[i].position.y);
			batch.push(vertices[i].position.z);
			
			var isInGroup = false;
			var vertexColor:Color = new Color();
			
			batch.push ( vertices[i].normal.x );
			batch.push ( vertices[i].normal.y );
			batch.push ( vertices[i].normal.z );
			
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
			
			batch.push(vertexColor.r / 255);
			batch.push(vertexColor.g / 255);
			batch.push(vertexColor.b / 255);
			batch.push(vertexColor.a / 255);
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
				var hasUv:Dynamic = jsonData.meshes[i].hasUV;

				var vGroups:Dynamic = jsonData.meshes[i].vertexGroups;
				var vertexGroupCount = vGroups.length;
				var vertexStructSize:UInt = ( hasUv ) ? 8 : 6;
				var verticesCount = Std.int(verticesArray.length / (vertexStep * vertexStructSize));
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
					var x = Std.parseFloat(verticesArray[k * vertexStructSize]);
					var y = Std.parseFloat(verticesArray[k * vertexStructSize + 1]);
					var z = Std.parseFloat(verticesArray[k * vertexStructSize + 2]);
					
					var normalX:Float = Std.parseFloat(verticesArray[k * vertexStructSize + 3]);
					var normalY:Float = Std.parseFloat(verticesArray[k * vertexStructSize + 4]);
					var normalZ:Float = Std.parseFloat(verticesArray[k * vertexStructSize + 5]);
					
					var uvU:Float = 0;
					var uvV:Float = 0;

					if ( hasUv ) {
						uvU = Std.parseFloat(verticesArray[k * vertexStructSize + 6]);
						uvV = Std.parseFloat(verticesArray[k * vertexStructSize + 7]);
					}
					
					if(i == 0){
						mesh.vertices[k] = { position : new Vector3(x, y, z), normal : new Vector3 ( normalX, normalY, normalZ ), uv : new Vector2 (uvU,uvV) };
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
	
	public function calculateNormals () {
		var faceNormals:Array<Vector3> = new Array ();
		
		var v1:Vector3;
		var v2:Vector3;
		var fn:Vector3;
		
		for ( f in 0...faces.length ) {
			v1 = vertices[faces[f].a].position.subtract( vertices[faces[f].b].position );
			v2 = vertices[faces[f].a].position.subtract( vertices[faces[f].c].position );
			fn = Vector3.Cross ( v1, v2 ).normalize ();
			
			faceNormals.push ( fn.negate () );
		}
		
		for ( i in 0...vertices.length ) {
			var vertexFaceNormals:Array<Vector3> = new Array ();
			
			for ( f in 0...faces.length ) {
				if ( faces[f].a == i || faces[f].b == i || faces[f].c == i  ) {
					vertexFaceNormals.push ( faceNormals [f] );
				}
			}
			
			var normalsSum:Vector3 = new Vector3 ();
			for ( vfn in vertexFaceNormals ) {
				normalsSum = normalsSum.add ( vfn );
			}
			
			vertices[i].normal = normalsSum.normalize ();
		}
	}
	
	public function bindMaterialAt ( material:Material, index:UInt = 0 ) {
		materials[index].material = material;
	}
	
	public function addVertex(x:Float, y:Float, z:Float) {
		var newVertex:Vertex = { position : new Vector3(x, y, z), normal : new Vector3 (), uv : new Vector2 (0,0) }
		
		vertices.push(newVertex);
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
			
			if ( newMesh.gameObject != null ) {
				goX = newMesh.gameObject.transform.position.x;
				goY = newMesh.gameObject.transform.position.y;
				goZ = newMesh.gameObject.transform.position.z;
			} else if ( ! newMesh.relPosition.equals ( Vector3.Zero () ) ) {
				goX = newMesh.relPosition.x;
				goY = newMesh.relPosition.y;
				goZ = newMesh.relPosition.z;
			}
			
			this.addVertex (vert.position.x + goX, vert.position.y + goY, vert.position.z + goZ);
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
			vert.position.x += value.x;
			vert.position.y += value.y;
			vert.position.z += value.z;
		}
		this.bindMeshBuffers ();
	}
	
	public function rotate (value:Vector3) {		
		for (vert in this.vertices) {
					
			var rotationMatrix:Matrix = Matrix.RotationYawPitchRoll(value.y, value.x, value.z).multiply(Matrix.Zero());
			var newRot:Vector3 = SimpleMath.matrixToEulerAngles(rotationMatrix);
			
			vert.position.x += newRot.x;
			vert.position.y += newRot.y;
			vert.position.z += newRot.z;
		}
		
		
		this.bindMeshBuffers ();
	}
	
	public function setVetexGroupColor (index:Int = 0, newColor:Color) {
		
		vertexGroups[index].color = newColor;
		
		bindMeshBuffers ();
	}
	
	public function scale (value:Vector3) {
		for (vert in this.vertices) {
			vert.position.x *= value.x;
			vert.position.y *= value.y;
			vert.position.z *= value.z;
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
	
	public function clone ():Mesh {
		var returnMesh:Mesh = new Mesh();
		
		for (vert in vertices) {
			returnMesh.vertices.push(vert);
		}
		
		for (edge in edges) {
			returnMesh.edges.push(edge);
		}
		
		for (face in faces) {
			returnMesh.faces.push(face);
		}
		
		returnMesh.isStatic = isStatic;
		
		returnMesh.vertexGroups = vertexGroups;
		
		returnMesh.bindMeshBuffers();
		
		return returnMesh;
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