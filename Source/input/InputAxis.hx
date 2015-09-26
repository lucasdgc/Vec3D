package input;

import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.events.MouseEvent;
import openfl.events.Event;
import utils.SimpleMath;

/**
 * ...
 * @author Lucas Gonçalves
 */

enum InputAxisMethod {
	KEYBOARD;
	MOUSE_X;
	MOUSE_Y;
	JOYSTICK_X;
	JOYSTICK_Y;
	ACCELEROMETER;
	VIRTUAL_ANALOG_STICK;
}
 
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
	
	private var prevAxisValue:Float;
	
	public var inputMethod:InputAxisMethod;
	
	private var isUsingInput:Bool = false;
	
	private var usingInputFrame:Int = 0;
	
	private var isAnalog:Bool = false;
	
	public function new(name:String, method:InputAxisMethod = null, negative:UInt = 0, positive:UInt = 0, speed:Float = 0.5) 
	{
		axis.push(this);
		
		this.name = name;
		
		this.negativeCode = negative;
		this.positiveCode = positive;
		
		this.speed = speed;
		
		inputMethod = method;
		
		if(inputMethod == null){
			inputMethod = InputAxisMethod.KEYBOARD;
		}
		
		switch (inputMethod){
			case InputAxisMethod.KEYBOARD:
				Engine.canvas.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				Engine.canvas.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			case InputAxisMethod.MOUSE_X:
				Engine.canvas.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			case InputAxisMethod.MOUSE_Y:
				Engine.canvas.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			case InputAxisMethod.VIRTUAL_ANALOG_STICK:
				isAnalog = true;
			
			default:
				
		}

		Engine.canvas.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function onEnterFrame (event:Event) {
		if(!isAnalog){
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
		}
		
		roundValue ();
		
		if ((inputMethod == InputAxisMethod.MOUSE_X || inputMethod == InputAxisMethod.MOUSE_Y) && targetValue != 0) {
			usingInputFrame ++;
			
			if (usingInputFrame >= 15) {
				usingInputFrame = 0;
				isPressingPositive = false;
				isPressingNegative = false;
			}
		}
		
		if(inputMethod == InputAxisMethod.MOUSE_X || inputMethod == InputAxisMethod.MOUSE_Y) {
			isUsingInput = false;
		}
		
	}
	
	private function setKeyboardValues () {

	}
	
	private function setMouseXValues () {
		//prevAxisValue = MouseEvent.stage
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
	
	private function onMouseMove (mouse:MouseEvent) {
		isUsingInput = true;
		if (inputMethod == InputAxisMethod.MOUSE_X) {
			if (mouse.stageX > prevAxisValue) {
				isPressingPositive = true;
			} else if (mouse.stageX < prevAxisValue) {
				isPressingNegative = true;
			}
			prevAxisValue = mouse.stageX;
		} else {
			if (mouse.stageY < prevAxisValue) {
				isPressingPositive = true;
			} else if (mouse.stageY > prevAxisValue) {
				isPressingNegative = true;
			}
			prevAxisValue = mouse.stageY;
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
	
	public static function bindAxis (name:String = "",  method:InputAxisMethod = null, negative:UInt = 0, positive:UInt = 0, speed:Float = 0.5) {
		var i = new InputAxis (name, method, negative, positive, speed);
	}
	
	public static function setAxisValue (axisName:String, value:Float) {
		for (inputAxis in axis) {
			if (inputAxis.name == axisName) {
				inputAxis.value = value;
			}
		}
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