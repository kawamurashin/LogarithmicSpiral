package
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Jaiko
	 */
	[SWF(width = "465", height = "465", backgroundColor = "0xFFFFFF", frameRate = "60")]
	public class Main extends Sprite
	{
		public static var cx:Number;
		public static var cy:Number;
		private var container:Sprite;
		private var center:Sprite;
		private var pointList:Array;
		private var controlPanel:ControlPanel;
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			layout();
		}
		
		private function layout():void
		{
			var g:Graphics;
			//
			cx = stage.stageWidth * 0.5;
			cy = stage.stageHeight * 0.5;
			//
			center = new Sprite();
			addChild(center);
			center.x = cx;
			center.y = cy;
			
			container = new Sprite();
			addChild(container);
			/**/
			controlPanel = new ControlPanel();
			addChild(controlPanel);
			controlPanel.addEventListener(Event.CHANGE, controlPanelChangeHandler);
			
			
			draw();
			/**/
			addEventListener(Event.COMPLETE, ballCompleteHandler);
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
			
		}
		
		private function ballCompleteHandler(e:Event):void 
		{
			var square:Square = Square(e.target);
			container.removeChild(square);	
		}
		
		private function controlPanelChangeHandler(e:Event):void 
		{
			draw();
		}
		private function clickHandler(e:MouseEvent):void 
		{
			var square:Square = new Square();
			container.addChild(square);
			square.speed = controlPanel.speedNumber;
			square.start(pointList);
		}
		private function draw():void
		{
			var i:int;
			var n:int;
			var g:Graphics;
			var radius:Number;
			var thetaMath:Number;
			var theta:Number;
			var rest:Number;
			var _x:Number;
			var _y:Number;
			var a:Number;
			var b:Number;
			//
			a = 1;
			b = Math.log(controlPanel.radiusNumber / a ) / (2 * Math.PI * controlPanel.rotationNumber);
			//
			g = center.graphics
			g.clear();
			g.beginFill(0x000000, 0.1);
			g.drawCircle(0, 0, controlPanel.radiusNumber);
			
			g = container.graphics;
			g.clear();
			g.lineStyle(2, 0x000000);
			
			//
			pointList = [];
			rest = controlPanel.rotationNumber - Math.floor(controlPanel.rotationNumber);
			n = Math.floor(controlPanel.rotationNumber * 360);
			for (i = n; i >= 0; i--)
			{
				theta = (i * Math.PI / 180);
				radius = a *  Math.pow(Math.E, b * theta);
				thetaMath = ((i - Math.floor(360 * rest)) * Math.PI  / 180 ) * controlPanel.clockwiseNumber + controlPanel.thetaNumber;
				_x = cx + radius * Math.cos(thetaMath);
				_y = cy + radius * Math.sin(thetaMath);
				if (i == n)
				{
					g.moveTo(_x, _y);
				}
				else
				{
					g.lineTo(_x, _y);
				}
				pointList.push(new Point(_x, _y));
			}
		}
	}
}

import adobe.utils.CustomActions;
import com.bit101.components.HSlider;
import com.bit101.components.Label;
import com.bit101.components.RadioButton;
import flash.display.Sprite;
import flash.events.Event;

/**
 * ...
 * @author Jaiko
 */
class ControlPanel extends Sprite 
{
	private const RADIUS_MAX:Number = 250;
	private const RADIUS_MIN:Number = 100;
	
	private const ROTATION_MAX:Number = 30;
	private const ROTATION_MIN:Number = 1;
	
	private const THETA_MAX:Number = 360;
	private const THETA_MIN:Number = 0;
	
	private const SPEED_MAX:Number = 30;
	private const SPEED_MIN:Number = 1;
	
	private var _radiusNumber:Number = 200;
	private var _rotationNumber:Number = 10;
	private var _thetaNumber:Number = 0;
	private var _clockwiseNumber:Number = -1;
	private var _speedNumber:Number = 10;
	//
	private var rotationLabel:Label;
	private var radiusLabel:Label;
	private var thetaLabel:Label;
	private var speedLabel:Label;
	//
	public function ControlPanel() 
	{
		super();
		if (stage) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event = null):void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		//
		layout();
	}
	
	private function layout():void 
	{
		var _y:Number;
		var _x:Number;
		
		_x = 50;
		_y = 10;
		var radiusName:Label = new Label(this, _x - 40, _y -4, "radius");
		var radiusHSlider:HSlider = new HSlider(this, _x, _y, radiusHSliderHandler);
		radiusLabel = new Label(this, _x + 100, _y - 4);
		radiusHSlider.value = (_radiusNumber -1 * RADIUS_MIN ) * (100 / (RADIUS_MAX - RADIUS_MIN));
		drawRadiusLabel();

		_y = 25;
		var rotationName:Label = new Label(this, _x - 40, _y -4, "rotation");
		var rotationHSlider:HSlider = new HSlider(this, _x, _y, rotationHSliderHandler);
		rotationLabel = new Label(this, _x + 100, _y - 4);
		rotationHSlider.value =  (_rotationNumber -1 * ROTATION_MIN ) * (100 / (ROTATION_MAX - ROTATION_MIN));
		drawRotationLabel();
		
		_y = 40;
		var thetaName:Label = new Label(this, _x - 40, _y -4, "theta");
		var thetaHSlider:HSlider = new HSlider(this, _x, _y, thetaHSliderHandler);
		thetaLabel = new Label(this, _x + 100, _y - 4);
		thetaHSlider.value =  (_thetaNumber -1 * THETA_MIN ) * (100 / (THETA_MAX - THETA_MIN));
		drawThetaLable();
		
		_x = 250;
		_y = 10;
		var clockwiseRadioButton:RadioButton = new RadioButton(this, _x, _y, "clockwise", true, clockwiseHandler);
		var anticlockwiseRadioButton:RadioButton = new RadioButton(this, _x + 70, _y, "anticlockwise", false, clockwiseHandler);
		
		_y = 25;
		var speedName:Label = new Label(this, _x - 40, _y -4, "speed");
		var speedHSlider:HSlider = new HSlider(this, _x, _y, speedHSliderHandler);
		speedHSlider.value = (_speedNumber -1 * SPEED_MIN ) * (100 / (SPEED_MAX - SPEED_MIN));
		speedLabel = new Label(this, _x + 100, _y - 4);
		drawSpeedLable();
	}
	
	private function radiusHSliderHandler(event:Event):void
	{
		var hSlider:HSlider = HSlider(event.currentTarget);
		_radiusNumber = Math.floor((hSlider.value * (RADIUS_MAX - RADIUS_MIN) / 100) + RADIUS_MIN);
		drawRadiusLabel();
		
		var changeEvent:Event = new Event(Event.CHANGE);
		dispatchEvent(changeEvent);
	}
	private function drawRadiusLabel():void
	{
		radiusLabel.text = String(_radiusNumber);
	}
	
	private function rotationHSliderHandler(event:Event):void
	{
		var hSlider:HSlider = HSlider(event.currentTarget);
		//_rotationNumber = Math.floor((hSlider.value * (ROTATION_MAX -  ROTATION_MIN)/100)+ ROTATION_MIN)
		_rotationNumber = (hSlider.value * (ROTATION_MAX -  ROTATION_MIN) / 100) + ROTATION_MIN;
		_rotationNumber = Math.floor(_rotationNumber * 100) / 100;
		drawRotationLabel();
		
		var changeEvent:Event = new Event(Event.CHANGE);
		dispatchEvent(changeEvent);
	}
	private function drawRotationLabel():void
	{
		rotationLabel.text = String(_rotationNumber);
	}
	private function thetaHSliderHandler(event:Event):void
	{
		var hSlider:HSlider = HSlider(event.currentTarget);
		_thetaNumber = Math.floor((hSlider.value * (THETA_MAX - THETA_MIN) / 100) + THETA_MIN);
		drawThetaLable();
		
		var changeEvent:Event = new Event(Event.CHANGE);
		dispatchEvent(changeEvent);
	}
	private function drawThetaLable():void
	{
		thetaLabel.text = String(_thetaNumber)+ "°";
	}
	private function speedHSliderHandler(event:Event):void
	{
		var hSlider:HSlider = HSlider(event.currentTarget);
		_speedNumber = Math.floor((hSlider.value * (SPEED_MAX - SPEED_MIN) / 100) + SPEED_MIN);
		drawSpeedLable();
	}
	private function drawSpeedLable():void
	{
		speedLabel.text = String(_speedNumber);
	}
	private function clockwiseHandler(event:Event):void
	{
		var radioButton:RadioButton = RadioButton(event.currentTarget);
		if ( radioButton.label == "clockwise" )
		{
			_clockwiseNumber = -1;
		}
		else
		{
			_clockwiseNumber = 1;
		}
		
		var changeEvent:Event = new Event(Event.CHANGE);
		dispatchEvent(changeEvent);
	}
	
	public function get radiusNumber():Number 
	{
		return _radiusNumber;
	}
	
	public function get rotationNumber():Number 
	{
		return _rotationNumber;
	}
	
	public function get thetaNumber():Number 
	{
		return _thetaNumber * Math.PI / 180;
	}
	
	public function get clockwiseNumber():Number 
	{
		return _clockwiseNumber;
	}
	
	public function get speedNumber():Number 
	{
		return _speedNumber;
	}
}

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.geom.Vector3D;

class Square extends Sprite 
{
	private var _speed:Number = 10;
	private var pointList:Array;
	private var count:uint;
	private var distance:Number;
	private var prePoint:Point;
	//
	private const SQUARE_LENGTH:Number = 50;
	private var degreeX:Number = 0;
	private var degreeY:Number = 0;
	private var degreeZ:Number = 0;
	private var wx:Number;
	private var wy:Number;
	private var wz:Number;
	private var w:Number = 0;
	private var pivot:Vector3D = new Vector3D(0, 0, 0);
	private var vertexList:Array;
	//
	public function Square() 
	{
		super();
		if (stage) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
	}
	public function start(list:Array):void
	{
		var point:Point;
		pointList = list;
		//
		count = 0;
		point = pointList[count];
		this.x = point.x;
		this.y = point.y;
		prePoint = point.clone();
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	private function init(e:Event = null):void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		//
		layout();
	}
	
	private function layout():void 
	{
		var vertex:Vector3D;
		
		var i:uint;
		var n:uint;
		//
		var u1:Number = 2 * Math.PI * Math.random();
		var u2:Number = 2 * Math.PI * Math.random();
		wx = Math.cos(u2) * Math.cos(u1);
		wy = Math.cos(u2) * Math.sin(u1);
		wz = Math.sin(u2);
		w = 5;
		//
		vertexList = [];
		n = 4;
		for (i = 0; i < n; i++)
		{
			vertex = new Vector3D();
			if (i == 0 || i == 3)
			{
				vertex.x = -0.5 * SQUARE_LENGTH;
			}
			else
			{
				vertex.x = 0.5 * SQUARE_LENGTH;
			}
			vertex.y = -0.5 * SQUARE_LENGTH + SQUARE_LENGTH * Math.floor(i / 2);
			vertexList.push(vertex);
		}
		draw();
	}
	

	
	private function enterFrameHandler(e:Event):void 
	{
		var point:Point;
		//
		distance = 0;
		point = setPoint();
		this.x = point.x;
		this.y = point.y;
		
		draw();
		
	}
	
	private function setPoint():Point 
	{
		var point:Point;
		count++;
		if (pointList.length <= count)
		{
			point = pointList[pointList.length-1]
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			var event:Event = new Event(Event.COMPLETE, true);
			dispatchEvent(event);
		}
		else
		{
			point = pointList[count];
			distance += Point.distance(prePoint, point);
			prePoint = point.clone();
			if (distance < _speed)
			{
				point = setPoint();
			}
		}
		return point;
	}
	private function draw():void 
	{
		var vector3D:Vector3D;
		var vertex:Vector3D;
		var matrix:Matrix3D;
		var i:uint;
		var n:uint;
		var g:Graphics;
		var d:Number;
		g = this.graphics;
		g.clear();
		g.beginFill(0xFF0000);
		//
		d = Math.sqrt(Math.pow(this.x - Main.cx, 2) + Math.pow(this.y - Main.cy, 2));
		this.scaleX = 
		this.scaleY = (d / (465 * 0.5))  + 0.2;
		w = (1 + 1 * (1 - (d / (465 * 0.5))))*_speed*0.5;
		
		
		degreeX += wx * w;
		if (degreeX > 360)
		{
			degreeX -= 360;
		}
		degreeY += wy * w;
		if (degreeY > 360)
		{
			degreeY -= 360;
		}
		degreeZ += wz * w;
		if (degreeZ > 360)
		{
			degreeZ -= 360;
		}
		matrix = new Matrix3D();
		matrix.appendRotation(degreeX, Vector3D.X_AXIS, pivot);
		matrix.appendRotation(degreeY, Vector3D.Y_AXIS, pivot);
		matrix.appendRotation(degreeZ, Vector3D.Z_AXIS, pivot);
		n = vertexList.length;
		for (i = 0; i < n; i++)
		{
			vertex = vertexList[i];
			vector3D = matrix.transformVector(vertex);
			if (i == 0)
			{
				g.moveTo(vector3D.x, vector3D.y);
			}
			else
			{
				g.lineTo(vector3D.x, vector3D.y);
			}
		}
	}

	public function set speed(value:Number):void 
	{
		_speed = value;
	}
}

