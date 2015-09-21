package input;

import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import utils.SimpleMath;

/**
 * ...
 * @author Lucas Gonçalves
 */
class InputButton
{

	public static var buttons:Array<InputButton> = new Array();
	public var name:String;
	
	public var value:Float;
	public var keyCode:UInt;
	
	private var isBinary:Bool;
	
	public var speed:Float;
	
	public var isPressingKey:Bool = false;
	
	private var targetValue:Float;
	
	public function new (name:String, keyCode:UInt, isBinary:Bool = true, speed:Float = 0.5) {
		buttons.push (this);
		
		this.name = name;
		this.keyCode = keyCode;
		
		this.isBinary = isBinary;
		this.speed = speed;
		
		Engine.canvas.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		Engine.canvas.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Engine.canvas.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	private function onEnterFrame (event:Event) {
		if (isPressingKey) {
			targetValue = 1;
		} else {
			targetValue = 0;
		}
		
		if (isBinary) {
			value = targetValue;
		} else {
			value = SimpleMath.Lerp (value, targetValue, speed);
		}
	}
	
	private function onKeyDown (key:KeyboardEvent) {
		if (key.keyCode == this.keyCode) {
			isPressingKey = true;
		}
	}
	
	private function onKeyUp (key:KeyboardEvent) {
		if (key.keyCode == this.keyCode) {
			isPressingKey = false;
		}
	}
	
	public static function bindButton (name:String, keyCode:UInt, isBinary:Bool = true, speed:Float = 0.5) {
		var iButton:InputButton = new InputButton (name, keyCode, isBinary, speed);
	}
	
	public static function getValue (name:String):Float {
		for (inputButton in buttons) {
			if(inputButton.name == name){
				return inputButton.value;
			}
		}
		
		return 0;
	}
}