package;
import com.babylonhx.math.Vector3;
import openfl.Assets;
import haxe.Json;
import openfl.utils.Float32Array;

/**
 * ...
 * @author Lucas Gonçalves
 */

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
	
	public static var meshes:Array<Mesh> = new Array();
	private static var defaultMeshName:String = "mesh_";
	
	public var name:String;
	public var vertices:Array<Vector3>;
	public var edges:Array<Edge>;
	public var faces:Array<Face>;
	
	public var gameObject:GameObject;
	
	public var drawEdges:Bool;
	public var drawPoints:Bool;
	public var drawFaces:Bool;
	
	public var isStatic:Bool = true;
	
	public var rawVertexData:Float32Array;
	public var rawEdgesData:Float32Array;
	public var rawFacesData:Float32Array;
	
	public function new(name:String = "", verticesCount:Int = 0, facesCount:Int = 0, edgesCount:Int = 0, drawPoints:Bool = true, drawEdges:Bool = true, drawFaces:Bool = true) {
		meshes.push(this);
		
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
		
		this.rawVertexData = new Float32Array(vertices);
		this.rawEdgesData = new Float32Array(edges);
		this.rawFacesData = new Float32Array(faces);
		
		this.drawEdges = drawEdges;
		this.drawFaces = drawFaces;
		this.drawPoints = drawPoints;
		
		if(name != ""){
			this.name = name;
		} else {
			this.name = defaultMeshName+meshes.length;
		}
	}
	
	public static function loadMeshFile(filename:String):Mesh {
		if(filename != ""){
			var meshes:Array<Mesh> = new Array();
			
			var meshData = Assets.getText(meshesPath + filename + meshesExtension);	
			
			if (meshData == null) {
				throw "Error loading mesh data "+meshesPath + filename + meshesExtension;
			}
			
			var jsonData:Dynamic = Json.parse(meshData);
			
			for(i in 0...jsonData.meshes.length) {
				var verticesArray:Dynamic =  jsonData.meshes[i].vertices;
				var facesArray:Dynamic =  jsonData.meshes[i].faces;

				var verticesCount = Std.int(verticesArray.length / (vertexStep * 3));
				var facesCount = Std.int(facesArray.length / 3);
				
				var mesh = new Mesh(jsonData.meshes[i].name, verticesCount, facesCount);
				
				for(k in 0...verticesCount){
					var x = Std.parseFloat(verticesArray[k * 3]);
					var y = Std.parseFloat(verticesArray[k * 3 + 1]);
					var z = Std.parseFloat(verticesArray[k * 3 + 2]);
					
					mesh.vertices[k] = new Vector3(x, y, z);
				}
				
				//trace("Vertex Count: " + mesh.name + " - " + verticesArray.length / vertexStep);
				trace("Vertex Count: " + mesh.name + " - " + mesh.vertices.length);
				
				for(j in 0...facesCount){
					var _a = Std.int(facesArray[j * 3]);
					var _b = Std.int(facesArray[j * 3 + 1]);
					var _c = Std.int(facesArray[j * 3 + 2]);
					
					mesh.faces[j] = { a : _a, b : _b, c : _c };
				}
				
				//trace("Face Count: " + mesh.name + " - " + facesArray.length / 3);
				trace("Face Count: " + mesh.name + " - " + mesh.faces.length);
				
				
				mesh.setRawData();
				
				return mesh;
			}
			//}
			
		} else {
			throw "Mesh path not specified...";
		}
		
		return null;
	}
	
	public static function getRawVerticesData(verticesArray:Array<Vector3>):Array<Float>{
		var array:Array<Float> = [];
		
		for(vertex in verticesArray){
			array.push(vertex.x);
			array.push(vertex.y);
			array.push(vertex.z);
		}
		
		/*array.push(verticesArray[0].x);
		array.push(verticesArray[0].y);
		array.push(verticesArray[0].z);*/
		
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
	}
	
	public function addVertex(x:Float, y:Float, z:Float){
		vertices.push(new Vector3(x, y, z));
	}
	
	public function addFace(pointA:Int, pointB:Int, pointC:Int){
		var face:Face = { a : pointA, b : pointB, c : pointC };
		faces.push(face);
	}
}