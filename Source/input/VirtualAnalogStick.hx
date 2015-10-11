package input;

import math.Vector2;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.Assets;
import input.InputAxis;

/**
 * ...
 * @author Lucas Gonçalves
 */
class VirtualAnalogStick
{

	public static var analogSticks:Array<VirtualAnalogStick> = new Array ();
	
	public var usableArea:Rectangle;
	public var analogImage:Bitmap;
	public var analogSpot:Bitmap;
	public var xAxisValue:Float;
	public var yAxisValue:Float;
	
	private var touchPoint:Vector2;
	private var currentPoint:Vector2;
	
	public var maximumDragDistance:Float = 200;
	
	private var imageHypo:Float;
	
	public var bindAxisXName:String;
	public var bindAxisYName:String;
	
	public function new(usableArea:Rectangle, xAxisName:String, yAxisName:String) 
	{
		if (Engine.instance.currentScene != null) {
			analogSticks.push(this);
			
			var bmpData:BitmapData = Assets.getBitmapData("assets/Images/Input/Analog_Stick.png");
			
			analogImage = new Bitmap (bmpData);
			
			var bmpData2:BitmapData = Assets.getBitmapData("assets/Images/Input/Analog_Spot.png");
			
			analogSpot = new Bitmap (bmpData2);
			
			this.usableArea = usableArea;
			
			imageHypo = Math.sqrt ((analogImage.width / 2) * (analogImage.width / 2) + (analogImage.height / 2) * (analogImage.height / 2));
			
			bindAxisXName = xAxisName;
			bindAxisYName = yAxisName;
			
			bindInputAxis ();
			
			Engine.canvas.stage.addChild(analogSpot);
			Engine.canvas.stage.addChild(analogImage);
			
			analogImage.visible = false;
			analogSpot.visible = false;
			
			touchPoint = Vector2.Zero();
			
			Engine.canvas.stage.addEventListener(MouseEvent.MOUSE_DOWN, onTouchScreen);
			Engine.canvas.stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseScreen);
			Engine.canvas.stage.addEventListener(MouseEvent.MOUSE_MOVE, onTouchMove);
			
		} else {
			throw "Cannot instantiate VirtualAnalogStick Class without a valid scene...";
		}
	}
	
	private function bindInputAxis () {
		InputAxis.bindAxis (bindAxisXName, InputAxisMethod.VIRTUAL_ANALOG_STICK);
		InputAxis.bindAxis (bindAxisYName, InputAxisMethod.VIRTUAL_ANALOG_STICK);
	}
	
	private function onTouchScreen (e:MouseEvent) {
		if (usableArea.contains(e.stageX, e.stageY)) {
			analogImage.visible = true;
			analogSpot.visible = true;
			
			analogImage.x = e.stageX - analogImage.width / 2;
			analogImage.y = e.stageY - analogImage.height / 2;
			
			analogSpot.x = analogImage.x;
			analogSpot.y = analogImage.y;
			
			touchPoint = new Vector2 (analogImage.x, analogImage.y);
			currentPoint = touchPoint.clone();
			
			calculateValues();
		}
	}
	
	private function onReleaseScreen (e:MouseEvent) {
		analogImage.visible = false;
		analogSpot.visible = false;
		
		analogImage.x = touchPoint.x;
		analogImage.y = touchPoint.y;
		
		calculateValues ();
	}
	
	private function onTouchMove (e:MouseEvent) {
		if (analogImage.visible && usableArea.contains(e.stageX, e.stageY)) {
			var mouseVector:Vector2 = new Vector2 (e.stageX - analogImage.width / 2, e.stageY - analogImage.height / 2);
			var relativeVector:Vector2 = mouseVector.subtract(touchPoint);

			if (relativeVector.length() <= maximumDragDistance - imageHypo / 2) {
				analogImage.x = e.stageX - analogImage.width / 2;
				analogImage.y = e.stageY - analogImage.height / 2;
			} else {	

				var maxDistance:Vector2 = relativeVector.normalize().multiplyByFloats(maximumDragDistance, maximumDragDistance);
				
				analogImage.x = touchPoint.x + (maxDistance.x);
				analogImage.y = touchPoint.y + (maxDistance.y);
			}
			
			currentPoint = new Vector2 (analogImage.x, analogImage.y);
			
			calculateValues ();
		}
	}
	
	private function calculateValues () {
		xAxisValue = (analogImage.x - touchPoint.x) / maximumDragDistance;
		yAxisValue = (analogImage.y - touchPoint.y) / maximumDragDistance;
		
		setBoundAxisValues ();
	}
	
	private function setBoundAxisValues () {
		InputAxis.setAxisValue(bindAxisXName, xAxisValue);
		InputAxis.setAxisValue(bindAxisYName, -yAxisValue);
	}
	
	public static function removeAllAnalogButtons () {
		for (analog in analogSticks) {
			analog.destroy();
		}
	}
	
	public function destroy () {
		analogSticks.remove(this);
		
		Engine.canvas.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onTouchScreen);
		Engine.canvas.stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseScreen);
		Engine.canvas.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTouchMove);
		
		Engine.canvas.stage.removeChild(analogImage);
		Engine.canvas.stage.removeChild(analogSpot);
		
		
	}
	
	private function toggleVisibility () {
		
	}
}