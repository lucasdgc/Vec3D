package;

import objects.GameObject;
import rendering.Letters;
import rendering.Mesh;
import rendering.Scene;

/**
 * ...
 * @author Lucas Gonçalves
 */
class LettersTest extends Scene
{

	public function new() 
	{
		super ();
		
		//var a:GameObject = new GameObject ( "a", Letters.createZ(), this );
		//a.mesh.drawPoints = true;
		
		var wordMesh:Mesh = Letters.convertToMesh("veced");
		var word:GameObject = new GameObject ("word", wordMesh, this);
	}
	
}