package rendering.primitives;

import rendering.Mesh;
import com.babylonhx.math.Vector3;
import com.babylonhx.math.Matrix;
import utils.Color;

/**
 * @author Lucas Gonçalves
 */
class Primitives 
{
	public static var CUBE:String = "primitive_cube";
	public static var SPHERE:String = "primitive_sphere";
	public static var LINE:String = "primitive_line";
	public static var curve:String = "primitive_curve";
	
	public static function createCube (size:Float = 1):Mesh {
		var cube:Mesh = new Mesh ();
		
		if ( size <= 0 ){
			size = 1;
		}
		
		var posValue =  -0.5 * size;
		var posZ = posValue;
		
		var vertexIndex:Int = 0;
		for (z in 0...2) { 
			var posY = posValue;
			for (y in 0...2) {
				var posX = posValue;
				for (x in 0...2) {
					cube.addVertex (posX, posY, posZ);
					if (vertexIndex > 0 ){
					}
					posX += Math.abs( posValue * 2);
				}
				posY += Math.abs( posValue * 2);
			}
			posZ +=Math.abs( posValue * 2);
		}
		
		cube.addEdge (0, 1);
		cube.addEdge (0, 2);
		cube.addEdge (0, 4);
		cube.addEdge (1, 3);
		cube.addEdge (1, 5);
		cube.addEdge (2, 6);
		cube.addEdge (2, 3);
		cube.addEdge (3, 7);
		cube.addEdge (4, 5);
		cube.addEdge (4, 6);
		cube.addEdge (5, 7);
		cube.addEdge (6, 7);
		
		finishMesh (cube);
		
		return cube;
	}
	
	public static function createSphere (segments:Int = 8, radius:Float = 0.5, horizontalEdges:Bool = true, verticalEdges:Bool = true) {
		var sphere:Mesh = new Mesh ();
		
		var zRotationSteps = 2 + segments;
		var yRotationSteps = 2 * zRotationSteps;
		
		for (zRotStep in 0...zRotationSteps + 1) {
			var normalizedZ = zRotStep / zRotationSteps;
			var angleZ = (normalizedZ * Math.PI);
			
			for (yRotationStep in 0...yRotationSteps + 1) {
				var normalizedY = yRotationStep / yRotationSteps;
				
				var angleY = normalizedY * Math.PI * 2;
				
				var rotationZ = Matrix.RotationZ(-angleZ);
				var rotationY = Matrix.RotationY(angleY);
				var afterRotZ = Vector3.TransformCoordinates(Vector3.Up(), rotationZ);
				var complete = Vector3.TransformCoordinates(afterRotZ, rotationY);
				
				var vertex = complete.scale(radius);
				var normal = Vector3.Normalize(vertex);
				
				sphere.addVertex(vertex.x, vertex.y, vertex.z);
				//positions.push(vertex.y);
				//positions.push(vertex.z);
				/*normals.push(normal.x);
				normals.push(normal.y);
				normals.push(normal.z);
				uvs.push(normalizedZ);
				uvs.push(normalizedY);*/
			}
			
			if (zRotStep > 0) {
                var verticesCount =sphere.vertices.length;
				var firstIndex:Int = Std.int(verticesCount - 2 * (yRotationSteps + 1));
				while((firstIndex + yRotationSteps + 2) < verticesCount) {                
                    /*indices.push((firstIndex));
                    indices.push((firstIndex + 1));
                    indices.push(firstIndex + totalYRotationSteps + 1);
					
                    indices.push((firstIndex + totalYRotationSteps + 1));
                    indices.push((firstIndex + 1));
                    indices.push((firstIndex + totalYRotationSteps + 2));*/
					if (horizontalEdges) {
						sphere.addEdge (firstIndex, firstIndex + 1);
					}
					
					if (verticalEdges) {
						sphere.addEdge (firstIndex, firstIndex + yRotationSteps + 1);
					}
					
					
					firstIndex++;
                }
            }
			
		}
		
		finishMesh(sphere);
		
		return sphere;
	}
	
	public static function createLine (segments:Int = 1, size:Float = 1) {
		var line:Mesh = new Mesh ();
		
		if (size <= 0) {
			size = 0;
		}
		
		var posValue = -0.5 * size;
		
		for (i in 0...segments + 1) {
			line.addVertex (posValue, 0, 0);
			posValue += Math.abs (posValue * 2);
		}
		
		for (i in 0...segments) {
			line.addEdge (i, i + 1);
		}
		
		finishMesh(line);
		
		return line;
	}
	
	public static function createCircle (segments:Int = 10, radius:Float = 0.5) {
		var circle:Mesh = new Mesh ();
		if (radius <= 0) {
			radius = 0.5;
		}
		
		var theta:Float = 0;
		var thetaStep:Float = 360 / segments;
		
		for (i in 0...segments) {
			var x = radius * Math.cos(theta);
			var y = radius * Math.sin(theta);
			
			circle.addVertex (x, y, 0);
			theta += thetaStep;
			
			if (i > 3) {
				circle.addEdge (i-4, i);
			} else if (i > 0) {
				
			}
		}
		
		//circle.addEdge (0, circle.vertices.length - 1);
		
		finishMesh(circle);
		return circle;
	}
	
	public static function createSquare (size:Float = 1) {
		var square:Mesh = new Mesh ();
		
		if (size <= 0) {
			size = 1;
		}
		
		var posValue = -0.5 * size;
		
		var posX = posValue;
		for (x in 0...2) {
			var posY = posValue;
			for (y in 0...2) {
				square.addVertex (posX, posY, 0);
				posY += Math.abs(posValue * 2);
			}
			posX += Math.abs (posValue * 2);
		}
		
		square.addEdge (0, 1);
		square.addEdge (0, 2);
		square.addEdge (3, 1);
		square.addEdge (3, 2);
		
		finishMesh (square);
		
		return square;
	}
	
	private static function createVertexGroup (mesh:Mesh):VertexGroup {
		var vIndex:Array<Int> = new Array();
		for (i in 0...mesh.vertices.length) {
			vIndex.push(i);
		}
		
		var vertexGroup:VertexGroup = { color : Color.white, name : "vertex_group_0", 
										id : 0, verticesIndex : vIndex, isColorGroup : true };
		return vertexGroup;
	}
	
	private static function finishMesh (mesh:Mesh) {
		mesh.vertexGroups.push(createVertexGroup(mesh));
		mesh.bindMeshBuffers();
	}
}