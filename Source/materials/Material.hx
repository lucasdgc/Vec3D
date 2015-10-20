package materials;
import openfl.display.Bitmap;
import utils.Color;

/**
 * ...
 * @author Lucas Gonçalves
 */
class Material
{
	public var diffuseColor:Color;
	public var diffuseTexture:Bitmap;
	
	public var metallic:Float;
	public var metallicTexture:Bitmap;
	
	public var roughness:Float;
	public var roughnessTexture:Bitmap;
	
	public var specular:Float;
	public var specularTexture:Bitmap;
	
	public function new() 
	{
		
	}
	
}