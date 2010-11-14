package
{
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import fl.controls.ComboBox;
	import fl.controls.TextArea;
	
	public class matching extends MovieClip
	{
		var m_ay_answers:Array;
		public function init(ay_answers:Array)
		{
			var qHolder:MovieClip = new MovieClip();
			qHolder.x = 30;
			qHolder.y = 50;
			this.addChild(qHolder);
			var qHeight:Number = 50; 
			var qWidth:Number = 600; 
			var aHeight:Number = 30; 
			var aWidth:Number = qWidth; 
			var qSize:Number = 16;
			var qColor:uint = 0x000000;


			var arrChoices:Array = new Array(ay_answers.length);
			m_ay_answers = ay_answers;
			
			for(var i:int = 0;i<ay_answers.length;i++)
			{
				var arrCombo:MovieClip = new MovieClip();
				arrCombo[i] = new ComboBox();
				//arrChoices[i].label = ay_answers[i];
				arrCombo[i].width = 200;;
				arrCombo[i].x = qHolder.x + 10;
				arrCombo[i].y = qHolder.y + qHeight + (aHeight+5)*(i); 
				for(var j:int = 0; j < ay_answers.length;j++)
				{
					arrCombo[i].addItem({label:ay_answers[j]});
				}
				qHolder.addChild(arrChoices[i]);
				
			}
		}
		
	}

}