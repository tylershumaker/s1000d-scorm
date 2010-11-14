package
{
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import fl.controls.TextArea;
	
	public class score_assessment extends MovieClip
	{
	
		public function score_assessment(score:int, num_questions:int)
		{
			var text1:TextArea = new TextArea();
			text1.width = 650;
			text1.height = 200;
			
			var tf:TextFormat = new TextFormat();
			tf.size = 18;

				
			text1.setStyle("textFormat",tf);
			this.addChild(text1);
			text1.text = "This completes the assessment. Your score is " + score + " questions correct out of " + num_questions + ".";
		}
		
	}
	
	
}