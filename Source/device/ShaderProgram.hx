package device;

import openfl.Assets;
import openfl.gl.GLProgram;
import openfl.gl.GL;
import openfl.gl.GLShader;
import openfl.gl.GLUniformLocation;

/**
 * ...
 * @author Lucas Gonçalves
 */

 typedef  ShaderAttribute = {
	var name:String;
	var index:UInt;
 }
 
 typedef ShaderUniform = {
	var name:String;
	var index:GLUniformLocation;
 }
 
class ShaderProgram
{
	private static var shaderPrograms:Array<ShaderProgram> = new Array ();
	private static var shadersPath:String = "assets/Shaders/" ;
	private static var vertExtension:String = ".vert";
	private static var fragExtension:String = ".frag";
	
	#if !desktop
	private static var defineES:String = "#define MOBILE \n";
	#else 
	private static var defineES:String = "";
	#end
	
	#if !html5
	private static var glType:String = "_OpenGL";
	#else
	private static var glType:String = "_WebGL";
	#end
	
	public var attributes:Array<ShaderAttribute>;
	public var uniforms:Array<ShaderUniform>;
	
	private static var shadersExtension:String = ".glsl";
	
	public var program:GLProgram;
	public var name:String;
	
	public function new(name:String, vertexShaderName:String, fragmentShaderName:String, attributes:Array<String>, uniforms:Array<String>, differPlatformShaders:Bool = true) 
	{
		shaderPrograms.push(this);
		
		program = GL.createProgram();
		
		var vertexShader = GL.createShader(GL.VERTEX_SHADER);
		var fragmentShader = GL.createShader(GL.FRAGMENT_SHADER);
		
		var platform:String = (differPlatformShaders) ? glType : "";
		var defEs:String = (differPlatformShaders) ? defineES : "";
		
		this.name = name;
		
		if (vertexShaderName != ""){
			var vertexShaderSource:String = Assets.getText(shadersPath + vertexShaderName + vertExtension);
			vertexShaderSource = defEs + vertexShaderSource;
			
			GL.shaderSource (vertexShader, vertexShaderSource);
			GL.compileShader (vertexShader);
			
			if (GL.getShaderParameter (vertexShader, GL.COMPILE_STATUS) == 0) {
				trace(GL.getShaderInfoLog(vertexShader));
				throw "Error compiling vertex shader";
			}
		}
		
		if (fragmentShaderName != "") {
			var fragmentShaderSource:String = Assets.getText(shadersPath + fragmentShaderName + fragExtension);
			fragmentShaderSource = defEs + fragmentShaderSource;
			
			
			GL.shaderSource (fragmentShader, fragmentShaderSource);
			GL.compileShader (fragmentShader);
			
			if (GL.getShaderParameter (fragmentShader, GL.COMPILE_STATUS) == 0) {
				trace(name + " - " + GL.getShaderInfoLog(fragmentShader));
				throw "Error compiling fragment shader";
			}
		}
		
		GL.attachShader(program, vertexShader);
		GL.attachShader(program, fragmentShader);
		
		GL.linkProgram(program);
		
		if (GL.getProgramParameter (program, GL.LINK_STATUS) == 0) {
			throw "Unable to initialize the shader program "+name;
		}
		
		this.attributes = new Array();
		
		for (i in 0...attributes.length) {
			this.attributes[i] = { name : attributes[i], index : GL.getAttribLocation(program, attributes[i])}
		}
		
		this.uniforms = new Array();
		
		for (j in 0...uniforms.length) {
			this.uniforms[j] =  { name : uniforms[j], index : GL.getUniformLocation(program, uniforms[j])};
			
		}
	}
	
	public function getAttribute (name:String):ShaderAttribute {
		for (attr in this.attributes) {
			if (attr.name == name) {
				return attr;
			}
		}
		
		return null;
	}
	
	public function getUniform (name:String):ShaderUniform {
		for (unif in this.uniforms) {
			if(unif.name == name) {
				return unif;
			}
		}
		
		return null;
	}
	
	public static function getShaderProgram (name:String):ShaderProgram {
		for (program in shaderPrograms) {
			if (program.name == name) {
				return program;
			}
		}
		
		return null;
	}
	
	public static function getShaderProgramByIndex (index:Int):ShaderProgram {
		return ShaderProgram.shaderPrograms[index];
	}
}