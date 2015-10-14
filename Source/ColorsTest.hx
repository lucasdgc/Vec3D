package;

import math.Vector3;
import rendering.Mesh;
import rendering.Primitives;
import rendering.Scene;
import objects.GameObject;
import utils.Color;

/**
 * ...
 * @author Lucas Gonçalves
 */
class ColorsTest extends Scene
{
	
	private var squareArray:Array<GameObject>;
	
	
	public function new() 
	{
		super();
		
		squareArray = new Array ();
		
		var size:Float = 0.5;
		var squareMesh:Mesh = Primitives.createSquare (size);
		
		var colorsArray:Array<Color> = new Array ();
		
		colorsArray.push (Color.red);
		colorsArray.push (Color.green);
		colorsArray.push (Color.blue);
		colorsArray.push (Color.black);
		colorsArray.push (Color.white);
		colorsArray.push (Color.orange);
		colorsArray.push (Color.brown);
		colorsArray.push (Color.pink);
		colorsArray.push (Color.cyan);
		colorsArray.push (Color.purple);
		colorsArray.push (Color.grey);
		colorsArray.push (Color.yellow);
		
		var colorsIndex:Int = 0;
		
		for ( i in -2...2 ) {
			for ( j in 0...3 ) {
				var square:GameObject = new GameObject ( "square_" + i + j, squareMesh.clone (), this );
				square.transform.position = new Vector3 ( (i * size * 1.2), (j * size * 1.2), 0 );
				
				trace (colorsArray[colorsIndex]);
				
				square.mesh.setVetexGroupColor ( 0, colorsArray [colorsIndex] );
				colorsIndex ++;
			}
		}
	}
	
}