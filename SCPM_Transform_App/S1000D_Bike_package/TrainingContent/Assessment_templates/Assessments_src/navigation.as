package
{
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import fl.controls.CheckBox;
	import fl.controls.RadioButton;
	
	public class navigation extends MovieClip
	{
		var btnLabel_fmt:TextFormat = new TextFormat();
		var colorFmtInactive:TextFormat = new TextFormat();
		var colorFmtActive:TextFormat = new TextFormat();
		var number_questions:int;
		var m_clicks:int = 0;
		var correct_response:String;
		var total_correct:int;
		public function navigation()
		{
			this.addEventListener(MouseEvent.CLICK, textClickHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, rolloverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, rolloutHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.submit_txt.text = "NEXT";

			colorFmtInactive.color = 0x424242;
			//var color:uint = 0xFFFF00;
			
			colorFmtActive.color = 0xCCCCCC;
		
		}
		
		public function start_nav(number_questions:int)
		{
			this.number_questions = number_questions;
			total_correct = 0;
		}
			
		function rolloverHandler(event:MouseEvent):void
		{
			//var colorFmtOver:TextFormat = new TextFormat();
			//colorFmtOver.color = 0xFFFF00;
			//this.submit_txt.setTextFormat(colorFmtOver);
			//trace("mouse is over");
		}
		
		function rolloutHandler(event:MouseEvent):void
		{
			//this.submit_txt.setTextFormat(colorFmtActive);
			//trace("mouse is out");
		}
		
		function textClickHandler(event:MouseEvent):void
		{
			
			
		}
		
		function mouseDownHandler(event:MouseEvent):void
		{
			this.alpha = .3;
			var user_response:String;
		
			MovieClip(this.parent).stem_mc.hide_ui();
		
			if(MovieClip(this.parent).mcsa_mc != null)
				{
					var mc:MovieClip = MovieClip(this.parent).mcsa_mc.getChildAt(0);;
					this.correct_response = MovieClip(this.parent).correct_response;
					trace("the_val: " + this.correct_response);
					var cnt:int = mc.numChildren;
					for(var j:int = 0;j<cnt;j++)
					{
						var rb:RadioButton = RadioButton(mc.getChildAt(j));
						var sel:Boolean = rb.selected;
						if(sel == true)
						{
							var this_response:int = j;
							user_response = String(this_response);
						
							if(user_response == correct_response)
							{
								var resp_status:Boolean = true;
								total_correct ++;
								
							}
						}
					}
					// remove the children of the clip
					
					
					MovieClip(this.parent).mcsa_mc.visible = false;
					
				}
			
			// remove multiple select
			
			if(MovieClip(this.parent).mcma_mc != null)
			{
				user_response = "";
				var mcma:MovieClip = MovieClip(this.parent).mcma_mc.getChildAt(0);
				//evaluate the response
				this.correct_response = MovieClip(this.parent).correct_response;
				//var user_response:String;
				
				for(var i:int = 0;i < mcma.numChildren;i++)
				{
					var cb:CheckBox = CheckBox(mcma.getChildAt(i));
					var cb_name:String = cb.name;
					
					if(cb.selected == true)
					{
						user_response += cb_name + ",";
					}
					
				}
				user_response = user_response.substring(0,user_response.length -1);
				trace("user_response: " + user_response)
				if(user_response == correct_response)
				{
					total_correct++;
					
				}
				MovieClip(this.parent).mcma_mc.visible = false;
				
			}
			
			if(MovieClip(this.parent).sequence_mc != null)
			{
				var steps_incorrect:int = 0;
				var correct:Boolean = true;
				var ay_answers_main:Array = MovieClip(this.parent).sequence_mc.ay_answers_src;
				var ay_steps:Array = MovieClip(this.parent).sequence_mc.ay_steps;
				var ay_response:Array = new Array();
				for(i = 0;i<ay_steps.length;i++)
				{
					ay_response[i] = ay_steps[i].textBox.text
					
				}
				for(i=0;i<ay_response.length;i++)
				{
					user_response = String(ay_response[i]);
					var the_right_response:String = String(ay_answers_main[i]);
					trace("ur: " + user_response + " rr: " + the_right_response);
					// WHAT GIVES !!!!!!!
					if( user_response.length != the_right_response.length)
					{
						steps_incorrect++;
					}
				}
				
				var mc_seq:MovieClip = MovieClip(this.parent).sequence_mc;
				if(mc_seq.numChildren > 0)
				{
					for(var k:int = 0; k < mc_seq.numChildren;k++);
						{
							mc_seq.removeChildAt(0);
							
						}
				}
				
				if(steps_incorrect == 0 && MovieClip(this.parent).sequence_mc.visible == true)
				{
					trace("inseq_tot_correct: " + total_correct);
					total_correct++;
					trace("seq_num_children: " + mc_seq.numChildren);
					
				}
				MovieClip(this.parent).sequence_mc.visible = false;
					
			}
			
			trace("totalCorrect:" + total_correct);
		
		}
		
		function mouseUpHandler(event:MouseEvent):void
		{
			this.mouseEnabled = false;
			this.alpha = 100;
			var stop_limit:int = number_questions - 2;
			if(m_clicks <= stop_limit )
			{
				m_clicks++;				
				trace("clicks " + m_clicks);
				
				MovieClip(this.parent).get_interaction(m_clicks);
				
			}
			else
			{
				this.mouseChildren = false;
				
				event.target.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				event.target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				this.removeEventListener(MouseEvent.CLICK, textClickHandler);
				this.removeEventListener(MouseEvent.MOUSE_OVER, rolloverHandler);
				this.removeEventListener(MouseEvent.MOUSE_OUT, rolloutHandler);
				
				MovieClip(this.parent).end_assessment(total_correct);
				//break;
				//MovieClip(this.parent).Remove(this);
				
			}
			
		}
		
	}
}



