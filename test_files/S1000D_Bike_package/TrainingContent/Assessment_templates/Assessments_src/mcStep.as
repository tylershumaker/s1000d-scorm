package
{
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.geom.ColorTransform;
	public class mcStep extends MovieClip
	{
		
		public function mcStep()
		{
				//this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				/*var mc:MovieClip = MovieClip(this.filler);
				var tempColor:ColorTransform = mc.transform.colorTransform;
				tempColor.color = 0xCCCCCC;
				
				mc.transform.colorTransform = tempColor; */
		}
		
		public function set_default_fill()
		{
			var mc:MovieClip = MovieClip(this.filler);
				var tempColor:ColorTransform = mc.transform.colorTransform;
				tempColor.color = 0xCCCCCC;
				mc.transform.colorTransform = tempColor; 
				//trace("filling");
		}
		public function set_highlight_fill()
		{
			var mc:MovieClip = MovieClip(this.filler);
				var tempColor:ColorTransform = mc.transform.colorTransform;
				tempColor.color = 0xFFFF00;
				mc.transform.colorTransform = tempColor; 
				//trace("highlighting");
		}
		function mouseDownHandler(event:MouseEvent):void
		{
			
			/*var mc:MovieClip = MovieClip(this.filler);
			var tempColor:ColorTransform = mc.transform.colorTransform;
			tempColor.color = 0xFFFF00;
			
			mc.transform.colorTransform = tempColor; */
				
			
		}
		function rolloverHandler(event:MouseEvent):void
		{
		}
		function rolloutHandler(event:MouseEvent):void
		{
		}
		function mouseUpHandler(event:MouseEvent):void
		{
			trace(event.target.name);
		}
		
	}
}