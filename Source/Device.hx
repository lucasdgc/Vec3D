package;
import com.babylonhx.math.Matrix;
import com.babylonhx.math.Vector2;
import com.babylonhx.math.Vector3;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.events.Event;
/**
 * ...
 * @author Lucas Gonçalves
 */
class Device
{
	public var backBuffer:BitmapData;
	public var bmp:BitmapData;
	
	public var renderFrame:Bitmap;
	
	private var backRectangleClear:Rectangle;
	
	private var canvas:Sprite;
	
	public var activeCamera:Camera;
	
	public function new(bmpData:BitmapData, _canvas:Sprite) 
	{
		this.bmp = bmpData;
		backBuffer = new BitmapData(bmpData.width, bmpData.height);
		backRectangleClear = new Rectangle(0, 0, backBuffer.width - .01, backBuffer.height - .01);
		
		//bmp = new Bitmap(backBuffer);
		
		canvas = _canvas;
		
		renderFrame = new Bitmap(bmp);
		renderFrame.width = canvas.stage.stageWidth;
		renderFrame.height = canvas.stage.stageHeight;
		
		canvas.addChild(renderFrame);
		
		//activeCamera = Camera.mainCamera;
		
		canvas.addEventListener(Event.ENTER_FRAME, renderLoop);
	}
	
	public function clear (color:UInt) {
		backBuffer.fillRect(backRectangleClear, color);
		
		//backBuffer.
		//backBuffer.floodFill(0, 0, color);
		
		//trace(backBuffer.height);
	}
	
	public function present() {
		bmp.copyPixels(backBuffer.clone(), backBuffer.rect, new Point(0, 0));
		
		renderFrame.bitmapData = bmp;
		
		//bmp.copyPixels(backBuffer.clone(), backRectangleClear, new Point(0, 0)); 
		
		//bmp.draw(backBuffer.clone());
		
		//bmp = backBuffer.clone();
	}
	
	public function putPixel(x:Int, y:Int, color:UInt){
		backBuffer.setPixel32(x, y, color);
	}
	
	public function project(coord:Vector3, transMat:Matrix):Vector2{
		
		var point = Vector3.TransformCoordinates(coord, transMat);
		
		var x = point.x * bmp.width + bmp.width / 2;
		var y = -point.y * bmp.height + bmp.height / 2;
		
		return new Vector2(x, y);
	}
	
	public function drawPoint(point:Vector2){
		if (point.x >= 0 && point.y >= 0 && point.x < bmp.width && point.y < bmp.height)
		{
			putPixel(Std.int(point.x), Std.int(point.y), 0xFFFFFFFF);
		}
	}
	
	public function drawLine (point1:Vector2, point2:Vector2){
		var dist = point2.subtract(point1).length();
		
		if (dist < 2)
		return;
		
		var middlePoint:Vector2 = point1.add((point2.subtract(point1)).scale(0.5));
		
		this.drawPoint(middlePoint);
		
		this.drawLine(point1, middlePoint);
		this.drawLine(middlePoint, point2);
	}
	
	public function render(camera:Camera, meshes:Array<Mesh> ) {
	
		var viewMatrix = Matrix.LookAtLH(camera.position, camera.target, Vector3.Up());
		var projectionMatrix = Matrix.PerspectiveFovLH(.78, bmp.width / bmp.height, .01, 1);
		
		for (mesh in meshes) {
			
			var worldMatrix = Matrix.RotationYawPitchRoll(mesh.rotation.y, mesh.rotation.x, mesh.rotation.z) .multiply(Matrix.Translation(mesh.position.x, mesh.position.y, mesh.position.z));
			
			var transformMatrix = worldMatrix.multiply(viewMatrix).multiply(projectionMatrix);
			
			for (i in 0...mesh.vertices.length-1){
				var point0 = project(mesh.vertices[i] , transformMatrix);
				var point1 = project(mesh.vertices[i + 1], transformMatrix);
				
				drawLine(point0, point1);
			}
		}
	}
	
	private function renderLoop(event:Event){
		clear(0xFF000000);
		
		render(activeCamera, Mesh.meshes);
		
		present();
	}
}