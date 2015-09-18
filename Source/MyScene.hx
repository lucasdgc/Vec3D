package;

import objects.GameObject;
import rendering.Scene;
import com.babylonhx.math.Vector3;
import openfl.events.Event;
import openfl.events.MouseEvent;
import rendering.Mesh;
/**
 * ...
 * @author Lucas Gonçalves
 */
class MyScene extends Scene
{

	var monkey:GameObject;
	
	public function new(engine:Engine) 
	{
		super(engine);
		
		monkey = new GameObject("monkey", "cube");
		
		var monkeyArray:Array<GameObject> = new Array();
		
		var cube2:GameObject = new GameObject("cube", "cube");
		cube2.position = new Vector3(-2, 0, 2);
		
		var cube3:GameObject = new GameObject("cube", "cube");
		cube3.position = new Vector3(2, 0, 2);
		
		var cube4:GameObject = new GameObject("cube", "cube");
		cube4.position = new Vector3(0, 0, 4);
		
		var monkeyCount:Int = 0;
		
		for (i in -4...4){
			for (j in -4...4){
				var m = new GameObject("", "monkey");
				m.position = new Vector3(i, j , j);
				monkeyArray.push(m);
				monkeyCount ++;
			}
		}
		trace(monkeyCount);
		Engine.instance.bindStaticBufferData();
		
		Engine.canvas.mouseEnabled = true;
		
		Engine.canvas.addEventListener(Event.ENTER_FRAME, update);
		Engine.canvas.addEventListener(MouseEvent.CLICK, onClick);
	}
	
	private function update(event:Event){
		//monkey.rotation = new Vector3 (monkey.rotation.x, monkey.rotation.y + 0.01, monkey.rotation.z);
	}
	
	private function onClick (click:MouseEvent){
		trace("clica clica");
		Mesh.toggleAllEdges();
	}
	
}