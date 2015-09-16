package rendering.primitives;

import com.babylonhx.math.Vector3;
import rendering.Mesh;
/**
 * ...
 * @author Lucas Gonçalves
 */
class Cube {

	public static var cubeCount:Int = 0;
	public var mesh:rendering.Mesh;
	
	public function new() 
	{
		mesh = new rendering.Mesh("Cube_" + cubeCount, 8, 12, 13);
		cubeCount++;
		
		mesh.vertices[0] = new Vector3(-1, 1, 1);
		mesh.vertices[1] = new Vector3(1, 1, 1);
		mesh.vertices[2] = new Vector3(-1, -1, 1);
		mesh.vertices[3] = new Vector3(-1, -1, -1);
		mesh.vertices[4] = new Vector3(-1, 1, -1);
		mesh.vertices[5] = new Vector3(1, 1, -1);
		mesh.vertices[6] = new Vector3(1, -1, 1);
		mesh.vertices[7] = new Vector3(1, -1, -1);
		
		/*mesh.faces[0] = { a:0, b:1, c:2 };
		mesh.faces[1] = { a:1, b:2, c:3 };
		mesh.faces[2] = { a:1, b:3, c:6 };
		mesh.faces[3] = { a:1, b:5, c:6 };
		mesh.faces[4] = { a:0, b:1, c:4 };
		mesh.faces[5] = { a:1, b:4, c:5 };

		mesh.faces[6] = { a:2, b:3, c:7 };
		mesh.faces[7] = { a:3, b:6, c:7 };
		mesh.faces[8] = { a:0, b:2, c:7 };
		mesh.faces[9] = { a:0, b:4, c:7 };
		mesh.faces[10] = { a:4, b:5, c:6 };
		mesh.faces[11] = { a:4, b:6, c:7 };*/
		
		mesh.edges[0] = { a : 0, b : 1 };
		mesh.edges[1] = { a : 1, b : 6 };
		mesh.edges[2] = { a : 6, b : 2 };
		mesh.edges[3] = { a : 2, b : 0 };
		mesh.edges[4] = { a : 0, b : 4 };
		mesh.edges[5] = { a : 4, b : 3 };
		mesh.edges[6] = { a : 3, b : 2 };
		mesh.edges[7] = { a : 4, b : 5 };
		mesh.edges[8] = { a : 5, b : 1 };
		mesh.edges[9] = { a : 5, b : 7 };
		mesh.edges[10] = { a : 7, b : 6 };
		mesh.edges[11] = { a : 7, b : 3 };
		
		mesh.setRawData();
	}
	
}