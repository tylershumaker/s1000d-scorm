package
{
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import fl.controls.CheckBox;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	
	public class mcsa extends MovieClip
	{
		var arrChoices:Array;
		var m_ay_answers:Array;
		var rbg:RadioButtonGroup;
		var qHolder:MovieClip;
		public function mcsa()
		{
			//this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
		}
		
		public function init(ay_answers:Array)
		{
			var i:int = 0;
			/*for(i = 0; i<rbg.numRadioButtons; i++)
				{
					rbg.removeRadioButton(rbg.getRadioButtonAt(i));
				}*/
			if(this.numChildren > 0)
			{
				
				for(i = 0; i < this.numChildren;i++);
					{
						removeChildAt(0);
						
					}
			}
			qHolder = new MovieClip();
			qHolder.name = "radio_buttons";
			qHolder.x = 30;
			//qHolder.y = MovieClip(this.parent).stem_mc.y + 10;
			//qHolder.width = 500;
			this.addChild(qHolder);
			var qHeight:Number = 50; 
			var qWidth:Number = 600; 
			var aHeight:Number = 30; 
			var aWidth:Number = qWidth; 
			var qSize:Number = 16;
			var qColor:uint = 0x000000;

			var tf:TextFormat = new TextFormat();
			tf.size = 14; 
			var spacer:int = 70;
			arrChoices = new Array(ay_answers.length);
			m_ay_answers = ay_answers;
			//rbg = new RadioButtonGroup("rbg");
			
			for(i = 0;i<ay_answers.length;i++)
			{
				arrChoices[i] = new RadioButton();
				//arrChoices[i].name = "rb" + i;
				arrChoices[i].setStyle("textFormat",tf);
				arrChoices[i].label = ay_answers[i];
				arrChoices[i].width = 600;
				//arrChoices[i].group = rbg;
				arrChoices[i].x = qHolder.x + 10;
				//move(70,spacer)
			    arrChoices[i].y = qHolder.y + qHeight + (aHeight+5)*(i); 
				qHolder.addChild(arrChoices[i]);
				//spacer = spacer + 30;
				

				
			}
			
		}
		
		public function reset_buttons(to_select:int)
		{
			//var rbDummy:RadioButton=new RadioButton();
				
				//rbDummy.selected = true;
			/*rbDummy = RadioButton(this.qHolder.getChildAt(1));
			rbDummy.selected = true;*/
													  
		}
	}
}
		