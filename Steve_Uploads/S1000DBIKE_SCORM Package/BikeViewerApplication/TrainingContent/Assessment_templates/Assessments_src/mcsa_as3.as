package
{
	import flash.events.*;
	import flash.display.MovieClip;
	
	
public class mcsa_as3 extends MovieClip
{
	
	//initialize correct state
	var allCorrect = false;

	public pop_question()
	{
		
		
	}
	private function get_correct()
	{
		var isCorrect:Boolean = false;
	
		//for(var i=1; i<=numAnswerItems;i++)
	//	{
	//		var theClip = this["check"+i.toString()];
	//		
	//		if(theClip.idCode == correctCode && theClip.checked)
	//		{
	//			isCorrect = true;
	//		}
	
		//return isCorrect;
	}

	private function get_score():Number
	{
		var n:Number = 0;
	
		if(getCorrect())
		{
			n=1;
		}
		
		return n;
	}
}