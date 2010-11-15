package
{
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import fl.controls.CheckBox;
	import fl.controls.RadioButton;
	import flash.text.TextFormat;
	
	public class kc_navigation extends MovieClip
	{
		var btnLabel_fmt:TextFormat = new TextFormat();
		var colorFmtInactive:TextFormat = new TextFormat();
		var colorFmtActive:TextFormat = new TextFormat();
		var number_questions:int;
		var m_clicks:int = 0;
		var correct_response:String;
		var user_response:String;
		var total_correct:int;
		var tries:int;
		public function kc_navigation()
		{
			this.addEventListener(MouseEvent.CLICK, textClickHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, rolloverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, rolloutHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.submit_txt.text = "CHECK";

			colorFmtInactive.color = 0x424242;
			//var color:uint = 0xFFFF00;
			
			colorFmtActive.color = 0xCCCCCC;
		
		}
		
		public function start_nav()
		{
			total_correct = 0;
			tries = 0;
			
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
				this.x = this.x+1;
				this.y = this.y+1;
				this.x = this.x-1;
				this.y = this.y-1;
				
				var clipName:String = "";//MovieClip(this.parent).stem_mc.name;
				
			
		
			//MovieClip(this.parent).stem_mc.hide_ui();
		
			if(MovieClip(this.parent).mcsa_mc.numChildren > 0)
				{
					j = 0;
					clipName = MovieClip(this.parent).mcsa_mc.name;
					var mc:MovieClip = MovieClip(this.parent).mcsa_mc.getChildAt(0);//.getChildAt(0);
					correct_response = MovieClip(this.parent).correct_response;
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
								total_correct ++;
								MovieClip(this.parent).end_assessment(total_correct, clipName);
								var resp_status:Boolean = true;
								var tfcorrect:TextFormat = new TextFormat();
								tfcorrect.color = 0x006400;
								tfcorrect.bold = true;
								tfcorrect.size = 20;
								rb.setStyle("textFormat",tfcorrect);
								
							}
							else
							{
								total_correct = 0;
								MovieClip(this.parent).end_assessment(0, clipName);
								var rb_correct:RadioButton = RadioButton(mc.getChildAt(int(correct_response)));
								//rb_correct.selected = true;
								var tf:TextFormat = new TextFormat();
								tf.color =  0x006400;
								tf.bold = true;
								tf.size =18;
								rb_correct.setStyle("textFormat",tf);
								
								var tfmt:TextFormat = new TextFormat();
								tfmt.color =  0xFF0000;
								tfmt.size = 12;
								tfmt.bold = false;
								rb.setStyle("textFormat",tfmt);
							
							}
						}
					}
					//var mc:MovieClip = MovieClip(this.parent).mcsa_mc.getChildAt(0);
					mc.mouseChildren = false;
					this.mouseChildren = false;
			
					
				}
			
			// remove multiple select
			
			if(MovieClip(this.parent).mcma_mc.numChildren > 0)
			{
				
				eval_mcma_response();
				/*clipName = MovieClip(this.parent).mcsa_mc.name;
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
						//cb.selected = false;
					}
					
				}
				user_response = user_response.substring(0,user_response.length -1);
				trace("user_response: " + user_response)
				if(user_response == correct_response)
				{
					total_correct++;
					// 0xFF0000
					
				}*/
				
			}
			
			if(MovieClip(this.parent).sequence_mc.numChildren > 0)
			{
				var i:int = 0;
				clipName = MovieClip(this.parent).mcsa_mc.name;
					
				var split_correct:Array = MovieClip(this.parent).correct_response.split(",");
				
				var correct:Boolean = true;
			   	var ay_answers_main:Array = MovieClip(this.parent).sequence_mc.ay_answers_src;
				var ay_steps:Array = MovieClip(this.parent).sequence_mc.ay_steps;
				var ay_response:Array = new Array();
				for(i = 0;i<ay_steps.length;i++)
				{
					ay_response[i] = ay_steps[i].textBox.text;
				}
				for(i=0;i<ay_response.length;i++)
				{
					user_response = String(ay_response[i]);
					var the_right_response:String = String(ay_answers_main[i]);
					trace("ur: " + user_response + " rr: " + the_right_response);
					// WHAT GIVES !!!!!!! Values are the same but don't evaluate that way - had o use length instead
					if( user_response.length != the_right_response.length)
					{
						correct = false;
						break;
					}
				}
				if(correct == true)
					{
						
						total_correct++;
						MovieClip(this.parent).end_assessment(total_correct, clipName);
						
					}
					else
					{
						MovieClip(this.parent).end_assessment(total_correct, clipName);
						
					}
			}
			
			
			
			
		}
		
		function eval_mcma_response()
		{
			var j:int;
			var i:int = 0;
			var cb:CheckBox;
			var cb_name:String = "";
			var cb_split_name:String = "";
			var clipName = MovieClip(this.parent).mcma_mc.name;
				var mc:MovieClip = MovieClip(this.parent);
				var split_correct:Array = mc.correct_response.split(",");
				user_response = "";
				var mcma:MovieClip = MovieClip(this.parent).mcma_mc.getChildAt(0);
				//evaluate the response
				this.correct_response = MovieClip(this.parent).correct_response;
				
				for(i = 0;i < mcma.numChildren;i++)
				{
					cb = CheckBox(mcma.getChildAt(i));
					cb_name = cb.name;
					
					if(cb.selected == true)
					{
						user_response += cb_name + ",";
						
					}
					
				}
				user_response = user_response.substring(0,user_response.length -1);
				trace("user_response: " + user_response)
				if(user_response == correct_response)
				{
					var the_cb:CheckBox = new CheckBox;
					total_correct++;
					MovieClip(this.parent).end_assessment(total_correct, clipName);
					var tfcorrect:TextFormat = new TextFormat();
								tfcorrect.color = 0x006400;
								tfcorrect.bold = true;
								tfcorrect.size = 18;
					for(i = 0;i < mcma.numChildren;i++)
					{
					
						cb = CheckBox(mcma.getChildAt(i));
						var cb_correct_name:String = String(split_correct[i]);
						if(cb.selected == true)
						{
							
							
							cb.setStyle("textFormat",tfcorrect);
						}
						
					}
								
				}
				else
				{
					MovieClip(this.parent).end_assessment(total_correct, clipName);
					tfcorrect = new TextFormat();
						tfcorrect.color = 0x006400;
						tfcorrect.bold = true;
						tfcorrect.size = 18;
					var tfincorrect:TextFormat = new TextFormat();
						tfincorrect.color =  0xFF0000;
						tfincorrect.size = 12;
						
						
						var  counter:int = 0;
						
						for(i=0;i< mc.numChildren;i++)
						{
							cb = CheckBox(mcma.getChildAt(i));
							counter = 0;
							if(cb.selected == true)
							{
								for(j = 0; j < split_correct.length;j++)
								{
									if(cb.name == split_correct[j])
									{
										counter++;
										
									}
								}
								
								if(counter == 0)
								{
									cb.setStyle("textFormat",tfincorrect);
								}
								else
								{
									cb.setStyle("textFormat",tfcorrect);
								}
								
							}
							for(j = 0; j < split_correct.length;j++)
							{
								if(cb.name == split_correct[j])
								{
									cb.setStyle("textFormat",tfcorrect);
								
								}
							}
						
							
						}
						
						
						
					
				}
		}
		
		
		
		function mouseUpHandler(event:MouseEvent):void
		{
			
				
				
				
				//this.mouseEnabled = false;
				
				event.target.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				event.target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				this.removeEventListener(MouseEvent.CLICK, textClickHandler);
				this.removeEventListener(MouseEvent.MOUSE_OVER, rolloverHandler);
				this.removeEventListener(MouseEvent.MOUSE_OUT, rolloutHandler);
				
		}
			
	}
		
	}