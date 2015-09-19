package input;

import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.events.Event;
import utils.SimpleMath;

/**
 * ...
 * @author Lucas Gonçalves
 */
class InputAxis 
{
	public static var axis:Array<InputAxis> = new Array();
	
	public var negativeCode:UInt;
	public var positiveCode:UInt;
	
	public var speed:Float;
	
	public var name:String;
	
	public var value:Float = 0;
	
	private var targetValue:Int;
	
	private var isPressingNegative:Bool = false;
	private var isPressingPositive:Bool = false;
	
	public function new(name:String, negative:UInt, positive:UInt, speed:Float = 0.5) 
	{
		axis.push(this);
		
		this.name = name;
		
		this.negativeCode = negative;
		this.positiveCode = positive;
		
		this.speed = speed;
		
		Engine.canvas.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Engine.canvas.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		Engine.canvas.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function onEnterFrame (event:Event) {
		if(isPressingNegative){
			targetValue = -1;
		}
		
		if(isPressingPositive){
			targetValue = 1;
		}
		
		if (!isPressingNegative && !isPressingPositive) {
			targetValue = 0;
		}
		
		value = SimpleMath.Lerp(value, targetValue, speed);
		
		roundValue ();
	}
	
	private function roundValue () {
		if (isPressingPositive && value >= 0.99) {
			value = 1;
		} else if (isPressingNegative && value <= -0.99) {
			value = -1;
		} else if (!isPressingNegative && !isPressingPositive && value > -0.1 && value < 0.1) {
			value = 0;
		}
	}
	
	private function onKeyDown (key:KeyboardEvent) {
		if(key.keyCode == negativeCode){
			isPressingNegative = true;
		}
		
		if (key.keyCode == positiveCode) {
			isPressingPositive = true;
		}
	}
	
	private function onKeyUp (key:KeyboardEvent) {
		if(key.keyCode == negativeCode){
			isPressingNegative = false;
		}
		
		if (key.keyCode == positiveCode) {
			isPressingPositive = false;
		}
	}
	
	public static function bindAxis (name:String, negative:UInt, positive:UInt, speed:Float = 0.5) {
		var i = new InputAxis (name, negative, positive, speed);
	}
	
	public static function getValue (axisName:String):Float {
		for (inputAxis in axis) {
			if(inputAxis.name == axisName){
				return inputAxis.value;
			}
		}
		
		return 0;
	}
	
}