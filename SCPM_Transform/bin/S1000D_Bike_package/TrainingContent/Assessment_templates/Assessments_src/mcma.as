package
{
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import fl.controls.CheckBox;
	import fl.controls.RadioButton;
	
	public class mcma extends MovieClip
	{
		
		var m_ay_answers:Array;
		public function mcma()
		{
			//this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.name="mcma";
		}
		
		public function init(ay_answers:Array)
		{
			var i:int = 0;
			if(this.numChildren > 0)
			{
				for(i = 0; i < this.numChildren;i++);
					{
						this.removeChildAt(0);
					}
			}
			var qHolder:MovieClip = new MovieClip();
			qHolder.name = "questionBlock";
			qHolder.x = 30;
			//qHolder.y = MovieClip(this.parent).stem_mc.y + 10;
			//qHolder.width=400;
			this.addChild(qHolder);
			var qHeight:Number = 50; 
			var qWidth:Number = 500; 
			var aHeight:Number = 30; 
			var aWidth:Number = qWidth; 
			var qSize:Number = 16;
			var qColor:uint = 0x000000;
			var tf:TextFormat = new TextFormat();
			tf.size = 14; 


			var arrChoices:Array = new Array(ay_answers.length);
			m_ay_answers = ay_answers;
			
			for(i = 0;i<ay_answers.length;i++)
			{
				arrChoices[i] = new CheckBox();
				arrChoices[i].setStyle("textFormat",tf);
				arrChoices[i].name = String(i);
				arrChoices[i].label = ay_answers[i];
				arrChoices[i].width = 500;
				arrChoices[i].x = qHolder.x + 10;
				arrChoices[i].y = qHolder.y + qHeight + (aHeight+5)*(i); 
				qHolder.addChild(arrChoices[i]);
				//arrChoices[i].selected = false;
				
			}
			
		}
		//function mouseUpHandler(event:MouseEvent):void
//		{
			/*this.checked = !this.checked;

			if(this.checked){
			checkbox.gotoAndStop(2);
			
			var theNum = this.name.split("check")[1];
		
			for(var i = 1; i <= parentnumAnswerItems; i++)
			{
				if(i != theNum)
				{
					var obj = this._parent["check" + i];
				
					obj.checkbox.gotoAndStop(1);
					
					obj.checked = false;
				}
			}
		}
		else
		{
			checkbox.gotoAndStop(1);
		}*/
		//}
		
	}
}