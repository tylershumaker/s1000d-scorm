package
{
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextFormat;
	import flash.geom.ColorTransform;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.*;

	
	import utils.*;
	
	
	public class sequence extends MovieClip
	{
		
		public var ay_steps:Array;
		var mc_selected_step:MovieClip;
		var ay_positions:Array; 
		var btn_up;
		var btn_down;
		public var ay_answers_src;
		//var ay_answers:Array;

	
		public function init(ay_answers:Array)
		{
			 ay_steps = new Array();
			 ay_positions = new Array();
			trace("seq_ansers: " + ay_answers.length)
			ay_answers_src = new Array();
			var chilcount:int = this.numChildren;
			
			if(this.numChildren > 0)
			{
				for(var i:int = 0; i < this.numChildren;i++);
					{
						this.removeChildAt(0);
						
					}
			}
			
			trace("child count: " + chilcount);
			
			for(var j = 0;j<ay_answers.length;j++)
			{
				ay_answers_src[j] = ay_answers[j];
			}
			
			var fillColor:String = "0xCCCCCC"; //initial fill color & non-highlight	
			var highlightColor:String = "0xFFFF00"; //highlighted color on click

			var align:Align = new Align();
			ay_answers = shuffle(ay_answers);
			var tf:TextFormat = new TextFormat();
			tf.size = 14; 
			for(i = 0;i < ay_answers.length;i++)
			{
				var seq_mc:MovieClip = new mcStep();
				//seq_mc.name = String(i);
				
				addChild(seq_mc);
				ay_steps[i] = seq_mc;
				//ay_steps[i].setStyle("textFormat",tf);
				ay_steps[i].x = stage.stageWidth / 2 - ay_steps[i].width / 2;
				ay_steps[i].y = (i * 50);
				//ay_answers[i] = format_text(ay_answers[i]);
				ay_steps[i].textBox.text = ay_answers[i];
				ay_steps[i].addEventListener(MouseEvent.CLICK, textClickHandler);
				ay_steps[i].addEventListener(MouseEvent.MOUSE_OVER, rolloverHandler);
				ay_steps[i].addEventListener(MouseEvent.MOUSE_OUT, rolloutHandler);
				ay_steps[i].addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				ay_steps[i].addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				ay_steps[i].name = i;
				//trace(ay_steps[i].name)
				ay_steps[i].txt_index.text = i;
				ay_positions[i] = ay_steps[i].y;
				//trace(ay_positions[i]);
				
			}
			//trace("num: " + this.numChildren);
			btn_up = new seq_btn_up();
			addChild(btn_up);
			btn_up.x = ay_steps[0].x - 40;
			btn_up.y = ay_steps[0].y + 30;
			btn_up.name = "btn_up";
			btn_up.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			btn_down = new seq_btn_down();
			addChild(btn_down);
			btn_down.x = ay_steps[1].x - 40;
			btn_down.y = btn_up.y + 60;
			btn_down.name = "btn_down";
			btn_down.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
		}
		
		
		function textClickHandler(event:MouseEvent):void
		{
		}
		function rolloverHandler(event:MouseEvent):void
		{
		}
		function rolloutHandler(event:MouseEvent):void
		{
		}
		function mouseUpHandler(event:MouseEvent):void
		{
			mc_selected_step.set_highlight_fill();
			set_button_states();
			
			if(event.target.name == "btn_up")
			{
				for(var j:int = 0; j <= ay_steps.length; j++)
				{
					trace(ay_positions[j]);
					trace("sel y: " + mc_selected_step.y +  " posY: " + ay_positions[j]);
					if(mc_selected_step.y == ay_positions[j])
					{
						var targetClip:MovieClip = ay_steps[j - 1];
						var targetY:int = targetClip.y;
						var selectedY:int = mc_selected_step.y;
						var myTween1:Object = new Tween(mc_selected_step, "y", Regular.easeInOut, selectedY, targetY, .3, true);
	
						var myTween2:Object = new Tween(targetClip, "y", Regular.easeInOut, targetY, selectedY, .3, true);
						ay_steps[j] = targetClip;
						ay_steps[j-1] = mc_selected_step;
						
						break;
					}
				}
			}
		}
		
		private function set_button_states()
		{
			//trace("y = " + mc_selected_step.y);
			if(mc_selected_step.y == ay_positions[0])
				{
					btn_up.enabled = false;

				}
				else
				{
					btn_up.enabled = true;
					
				}
				if(mc_selected_step.y == ay_positions[ay_positions.length - 1])
				{
					//disable down function
					
					btn_down.enabled = false;
				}
				else
				{
					btn_down.enabled = true;
				}
				trace(btn_up.enabled + "  " + btn_down.enabled);
				
		}
		
		
		function mouseDownHandler(event:MouseEvent):void
		{
			if(event.target.name == "textBox")
			{
				mc_selected_step = MovieClip(event.target.parent);
				set_button_states();
				var clip_step_index:int = int(mc_selected_step.name.split("_")[1]);
				for(var i:int = 0;i<ay_steps.length;i++)
				{
					var mc:MovieClip = MovieClip(ay_steps[i]);
					mc.set_default_fill();
				}
			}

			if(event.target.name == "btn_down")
			{
				set_button_states();
				for(var j:int = 0; j <= ay_steps.length; j++)
				{	
					if(mc_selected_step.y == ay_positions[j])
					{
						var targetClip:MovieClip = ay_steps[j + 1];
						var targetY:int = targetClip.y;
						var selectedY:int = mc_selected_step.y;
						var myTween1:Object = new Tween(mc_selected_step, "y", Regular.easeInOut, selectedY, targetY, .3, true);
	
						var myTween2:Object = new Tween(targetClip, "y", Regular.easeInOut, targetY, selectedY, .3, true);
						ay_steps[j] = targetClip;
						ay_steps[j+1] = mc_selected_step;
					
						break;
					}
				}
				
						
				
			}
			
				
		}
		
		
		private function shuffle(arr:Array):Array
		{
			var arr2:Array = []; 
 			while (arr.length > 0) 
			{
				arr2.push(arr.splice(Math.round(Math.random() * (arr.length - 1)), 1)[0]); 
			}
			return arr2;
		}
	}

}


// from question_ordering frame 1
//************************************************//////////////////////////////
//			 DO NOT EDIT THIS PAGE				                          /////
//     Content should be added on the init layer	                     /////
//   (This layer MUST be higher than content that uses these functions) /////
//********************************************//////////////////////////////
	
////////// Formatting //////////

// Title Format
/*var titleFont 		= "Arial";
var titleSize		= 14;
var titleColor		= 0x000000;
var titleMargins 	= 0;

// Content Format
var contentFont 	= "Arial";
var contentSize		= 14;
var contentColor	= 0x000000;
var contentMargins 	= 0;

// Content Format
var feedbackFont 	= "Arial";
var feedbackSize	= 14;
var feedbackColor	= 0x000000;
var feedbackMargins	= 0;
	

/////////// TITLE ////////////////////////////////
// Create a TextFormat Object for the myTitle	
var title_fmt:TextFormat 	= new TextFormat();	
title_fmt.bold 				= true;				
title_fmt.leftMargin 		= titleMargins;
title_fmt.rightMargin	 	= titleMargins;
title_fmt.font 				= titleFont;
title_fmt.color 			= titleColor;
title_fmt.size 				= titleSize;
/////////// CONTENT ////////////////////////////
// Create a TextFormat Object for the myContent
var content_fmt:TextFormat 	= new TextFormat();
content_fmt.bold 			= true;
content_fmt.leftMargin 		= contentMargins;
content_fmt.rightMargin		= contentMargins;
content_fmt.font 			= contentFont;
content_fmt.color 			= contentColor;
content_fmt.size 			= contentSize;
/////////// CONTENT ////////////////////////////
// Create a TextFormat Object for the myContent
var feedback_fmt:TextFormat 	= new TextFormat();
feedback_fmt.bold 			= true;
feedback_fmt.italic			= true;
feedback_fmt.leftMargin 	= feedbackMargins;
feedback_fmt.rightMargin	= feedbackMargins;
feedback_fmt.font 			= feedbackFont;
feedback_fmt.color 			= feedbackColor;
feedback_fmt.size 			= feedbackSize;
////////////////////////////////////////////////


// Funciton to add HTML	support BEFORE populating TextAreas
function pre3MFormat(txtToFmt:Object)
{
	txtToFmt.html = true;
	txtToFmt.wordWrap = true;
	txtToFmt.multiline = true;
}

function post3MFormat(txtToFmt:Object, style:String)
{
//	style.toLowerCase();
	switch(style)
	{
		case 'title':
			// Apply the format
			txtToFmt.setTextFormat(title_fmt);
		break;
	
		case 'content':
			// Apply the format
			txtToFmt.setTextFormat(content_fmt);
			//Apply Color for bullets
			var tempColor:Color = new flash.geom.ColorTransform(txtToFmt);
			tempColor.setRGB(contentColor);
		break;
		
		case 'feedback':
			// Apply the format
			txtToFmt.setTextFormat(feedback_fmt);
		break;
	}
}*/

// from question ordering frame 2 - init
/*import mx.xpath.XPathAPI;

////////////////////////////////////

pre3MFormat(instructionTxt);
/////////////////////////////////////////////

var stepArray:Array = new Array();
//load data

function Init()
{
	var theNode = this.parent.parent._questionNodes[this.parent.parent._currentQuestion-1];
	var theStepNodes =  XPathAPI.selectNodeList(theNode, "lcInteraction/lcSequencing/lcSequenceOptionGroup/lcSequenceOption");
	for(var i:Number = 0; i < theStepNodes.length; i++)
	{
		stepArray[i] = theStepNodes[i].firstChild.firstChild.firstChild.firstChild.nodeValue;
	}
	PopulateContent();
}

////////////////////////////////


var fillColor:String = "0xCCCCCC"; //initial fill color & non-highlight
var highlightColor:String = "0xFFFF00"; //highlighted color on click
var correctColor:String = "0x8BDA14"; //color when correct
var feedbackCorrect:String = "Correct!";
var feedbackFirstIncorrect:String = "Incorrect. Please try again.";
var feedbackSecondIncorrect:String = "Incorrect.";


//stepArray[0] = "Replace and Secure A5A3";
//stepArray[1] = "Reconnect Connectors";
//stepArray[2] = "Reinstall A5W2 and A5W3";
//stepArray[3] = "Close A5 ";
//stepArray[4] = "ORTS Test";


////////////////////////////////////////////
post3MFormat(instructionTxt, "title");
post3MFormat(questionTxt,"content");

//.........................................


var currentSelection:Number;

var posArray:Array = new Array; //used to hold initial y properties of step movie clips

var numberOfSteps:Number;

var numTries:Number = 2;

function HideChecks():void
{
	for(var i in mcSteps)
	{
		if(i.indexOf("mcStep")==0)
		{
			mcSteps[i].chk.visible = false;
		}
	}
}

HideChecks();


function InitFunc()
{
	mcMask.visible = false;
	PopulateContent();
}

function HighlightSelection():void
{
	myColor = new flash.geom.ColorTransform(this.fill); 
	
 	myColor.setRGB(highlightColor); 
	
	var newSelection = this.name.split("_")[1];
	
	//deselect other steps
	
	if(currentSelection != undefined && currentSelection != newSelection)
	{
		var previousClip:MovieClip = this.parent["mcStep_" + currentSelection];
		
		myColor = new flash.geom.ColorTransform(previousClip.fill); 
			
		myColor.setRGB(fillColor);
	}
	
	currentSelection = newSelection;
	
	ActivateButtons();
}

function ActivateButtons():void
{
	var clip:MovieClip = mcSteps["mcStep_" + currentSelection];
	
	if(clip.y == posArray[0])
	{
		invBtnUp.enabled = false;
	}
	else
	{
		invBtnUp.enabled = true;
	}
	
	if(clip.y == posArray[numberOfSteps-1])
	{
		//disable down function
		
		invBtnDown.enabled = false;
	}
	else
	{
		invBtnDown.enabled = true;
	}
}

function PopulateContent():void
{
	
	//hide all steps
	
	for(var ii:Number=1; ii<=7; ii++)
	{
		var clip:MovieClip = this.mcSteps["mcStep_"+ii];
		clip.visible = false;
	}

	numberOfSteps = stepArray.length;
	
	//add onRelease event to step movie clips
		
	for(var i:Number = 1; i <= numberOfSteps; i++)
	{
		this["step" + i] = stepArray[i-1];
		
		var clip:MovieClip = this.mcSteps["mcStep_"+i];
		clip.visible = true;

		clip.onRelease = HighlightSelection;
	}
	
	//populate text and create position array - steps are randomized
	
	var theArray:Array = ArrayRandomList(numberOfSteps);
	
	for(var i = 1; i <= theArray.length; i++)
	{
		var clip:MovieClip = this.mcSteps["mcStep_" + i];
		
		pre3MFormat(clip.textBox); // Set up HTML support
		clip.textBox.htmlText = this["step"+theArray[i-1]];
		post3MFormat(clip.textBox, "content"); // Apply 'content' style' test formating
		
		posArray[i-1] = clip.y;
	}
}

function ArrayRandomList(numSteps:Number):Array
{
    a = new Array();
	
    for (i=1; i<=numSteps; i++)
	{
        a.push(i);
    }
	
    a1 = [];
	
    while (a.length>0)
	{
        a1.push(a.splice(random(a.length), 1));
    }
	return a1;
} 

*/
/*
from question_ordering frame 3
import mx.transitions.Tween;

import mx.transitions.easing.*;

function Check():void
{
	NoHighlight();
	
	currentSelection = undefined;
	
	// Setup HTML/Multi-line/wrdWrap support for feedback text
	pre3MFormat(feedbackTxt);
	
	switch(btnCheck.btnLabel.text.toLowerCase())
	{		
		case "check": 
		
			numTries--;
			
			if(IsAllCorrect())
			{
				feedbackTxt.htmlText = feedbackCorrect;
				
				DisableAllButtons();
			}
			else
			{
				if(numTries == 0)
				{
					btnCheck.btnLabel.text = "ANSWER";
					
					feedbackTxt.htmlText = feedbackSecondIncorrect;
					
					for(var i in mcSteps)
					{
						if(i.indexOf("mcStep")==0)
						{
							
							mcSteps[i].enabled = false;
						}
					}
				}
				else
				{
					feedbackTxt.htmlText = feedbackFirstIncorrect;
				}
			}

		
		break;
		
		case "answer": //out of tries
		
			feedbackTxt.htmlText = "";
			
			DisableAllButtons();
		
			ShowAnswer();
			
			//we're done
		
		break;
	}
	
	// Color/style formating for feedback text
	post3MFormat(feedbackTxt, "feedback");
}

function DisableAllButtons():void
{
	btnCheck.enabled = false;
	
	btnCheck.onRollOut();
	
	for(var i in this)
	{
		if(i.indexOf("invBtn")==0)
		{
			this[i].enabled = false;
		}
	}
	
	for(var i in mcSteps)
	{
		if(i.indexOf("mcStep")==0)
		{
			
			mcSteps[i].enabled = false;
		}
	}
}

function ShowAnswer():void
{
	for(var i:Number = 1; i <= numberOfSteps; i++)
	{
		var movieClip:MovieClip = mcSteps["mcStep_" + i];
		
		for(var I:Number = 0; I < posArray.length; I++)
		{
			if(movieClip.textBox.text == this["step"+(I+1)])
			{
				var clipY:Number = movieClip.y;
				
				var targetY:Number = posArray[I];
				
				if(clipY != posArray[I])
				{
				
					movieClip.swapDepths(mcSteps.getNextHighestDepth());
				
					var myTween1:Object = new Tween(movieClip, "y", Regular.easeInOut, clipY, targetY, .3, true);
				}
			}

		}
	}
}

function FindTargetClip(theDirection:String, yPosIndex:Number):MovieClip
{
	var targetMovieClip:MovieClip;
	
	switch(theDirection.toLowerCase())
	{
		case "up":
		
			for(var i:Number = yPosIndex - 1; i >= 0; i--)
			{
				for(var I:Number = 1; I <= numberOfSteps; I++)
				{
					var theClip = mcSteps["mcStep_" + I];
					
					if(theClip.y == posArray[i] && theClip.enabled)
					{
						targetMovieClip = theClip;
						
						return targetMovieClip;
					}
				}
			}
		
		break;
		
		case "down":
		
			for(var i:Number = yPosIndex + 1; i <= numberOfSteps-1; i++)
			{
				for(var I:Number = 1; I <= numberOfSteps; I++)
				{
					var theClip = mcSteps["mcStep_" + I];
					
					if(theClip.y == posArray[i] && theClip.enabled)
					{
						targetMovieClip = theClip;
						
						return targetMovieClip;
					}
				}
			}
		
		break;
	}
	
	return targetMovieClip;

}

//these next two methods should really be combined into one

function MoveUp():void
{
	//let's tween

	var movieClip:MovieClip = mcSteps["mcStep_" + currentSelection];
	
	var targetMovieClip:MovieClip;
	
	var targetClipY:Number;
	
	//target above clip
	
	var clipY:Number = movieClip.y;
	
	for(var i:Number = 0; i < posArray.length; i++)
	{
		if(clipY == posArray[i])
		{
			targetMovieClip = FindTargetClip("up",i);
			
			targetClipY = targetMovieClip.y;
		}
	}
	
	var myTween1:Object = new Tween(movieClip, "y", Regular.easeInOut, clipY, targetClipY, .3, true);
	
	var myTween2:Object = new Tween(targetMovieClip, "y", Regular.easeInOut, targetClipY, clipY, .3, true);
	
	invBtnUp.enabled = false;
	
	invBtnDown.enabled = false;
	
	myTween1.onMotionFinished = function()
	{
		ActivateButtons();
	}
	
}

function MoveDown()
{
	
	//let's tween

	var movieClip:MovieClip = mcSteps["mcStep_" + currentSelection];
	
	var targetMovieClip:MovieClip;
	
	var targetClipY:Number;
	
	//target clip below
	
	var clipY:Number = movieClip.y;
	
	for(var i:Number = 0; i < posArray.length; i++)
	{
		if(clipY == posArray[i])
		{
			targetMovieClip = FindTargetClip("down",i);
			
			targetClipY = targetMovieClip.y;
		}
	}
	
	var myTween1:Object = new Tween(movieClip, "y", Regular.easeInOut, clipY, targetClipY, .3, true);
	
	var myTween2:Object = new Tween(targetMovieClip, "y", Regular.easeInOut, targetClipY, clipY, .3, true);
	
	invBtnUp.enabled = false;
	
	invBtnDown.enabled = false;
	
	myTween1.onMotionFinished = function()
	{
		ActivateButtons();
	}
	
}

function IsAllCorrect():Boolean
{
	var isCorrect:Boolean = true;
	
	for(var i:Number = 1; i <= numberOfSteps; i++)
	{
		var movieClip:MovieClip = mcSteps["mcStep_" + i];

		// find position in list
		
		for(var I:Number = 0; I < posArray.length; I++)
		{
			if(movieClip.y == posArray[I])
			{

				if(movieClip.textBox.text != this["step"+(I+1)])
				{
					isCorrect = false;
				}
				else
				{
					//show checks
					
					movieClip.chk._visible = true;
					
					myColor = new flash.geom.ColorTransform(movieClip.fill); 
			
					myColor.setRGB(correctColor);
					
					movieClip.enabled = false;
				}
			}
		}
	}
	
	return isCorrect;
}

function NoHighlight():void
{
	for(var i in mcSteps)
	{
		if(i.indexOf("mcStep")==0)
		{
			var theNum:Number = mcSteps[i]._name.split("_")[1];
			
			if(!mcSteps[i].chk._visible)
			{
				myColor = new flash.geom.ColorTransform(mcSteps[i].fill); 
			
				myColor.setRGB(fillColor);
			}
		}
	}
}

invBtnUp.onRelease = MoveUp;

invBtnDown.onRelease = MoveDown;

btnCheck.onRelease = Check;

function getScore():Number
{
	var n:Number = 0;
	
	if(IsAllCorrect())
	{
		n=1;
	}
	
	return n;
}

Init();*/
