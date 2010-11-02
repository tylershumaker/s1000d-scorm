package
{
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.events.*;
	
public class ldm_loader
{
	var _xml:XML;
	var ay_quest:Array;
	var i:int = 0;
	
	public function get_quest_array(xml:XML):Array
	{
		_xml = xml
		//ay_quest is a jagged dynamic array for all interaction data.
			// positions 9
			// 0: question type
			// 1: stem
			// 2: answer options (distractors)
			// 3: correct answer
			// 4: correct feedback ---- inner ranking denotes atempt match [5,"Correct!"]
			// 5: incorrect feedback ---- inner ranking denotes atempt match [6,"Incorrect"] 0r [6,"Incorrect - Try again!","Incorrect. The correct answer is ..."]
			// 6: graphics
			// 7: attempts
			// 8: weight
			ay_quest = new Array();
			
			for each(var interaction:XML in _xml.descendants("lcInteraction")) 
			{	
				//instantiate the question array
				// the var iType identifies the interaction type
				var iType:String = interaction.children()[0].name();
				ay_quest[i] = ["iType",iType];
				
				//trace("array_check : " + ay_quest[i+1]);
				 
				//trace("interaction type = " + iType);
				recursive(interaction);
				i++;
			}
		trace(ay_quest);
		return ay_quest;
	}
	
	
		
		public function recursive(xml:XML)
		{
			// loop through the interaction element to get stem etc.
			
			//trace("NAME: "+xml.name());
			//trace("the loop = " + i);
			var elementName:String = xml.name();
			//trace("the element name: " + elementName);
			
			switch (elementName)
			{
				case "lcQuestion" :
				
					//trace("question");
					recurseQuestion(xml);
					break;
				
				case "lcAnswerOptionGroup":
				
					recurseAnswerOpts(xml);
					break;
				
				case "lcFeedbackCorrect" :
					//trace("feedback");
					recurseFeedbackCorrect(xml);
					break;
				
				case "lcFeedbackIncorrect" :
				
					//trace("feedback");
					recurseFeedbackIncorrect(xml);
					break;
				
			}
			
			//if (xml.children()==xml) 
			//{
				//trace("VALUE: "+xml.children());
				//trace("-----------------");
			//} 
			//else 
			//{
				//trace("This node has children:");
			for each (var item:XML in xml.children()) 
			{
				// get the interaction type
				recursive(item);
				
			}
			//}
		}
		
		private function recurseQuestion(xml:XML)
		{
			//trace("recursing the question");
			var xDescription:XMLList = xml.child("description");
			var question:String = recurseDescription(xDescription);
			ay_quest[i+1] = question;
			//trace("question :" + ay_quest[i+1] );
		}
		
		private function recurseAnswerOpts(xml:XML)
		{
			//trace("recursing the answer opts");
			var count:int = xml.lcAnswerOption.length();
			trace("options: " + count);
			var ay_answers:Array = new Array();
			var j:int = 0;
			for each(var ans_opt:XML in xml.lcAnswerOption.lcAnswerOptionContent)
			{
				
				var answer = recurseAnswerOption(ans_opt);
				ay_answers[j] = answer;
				j++;
			}
			
			ay_quest[i+1] = ay_answers
			trace("array_check ao: " + ay_quest[i+3]);
																	
		}
		
		private function recurseAnswerOption(answer_opt:XML):String
		{
			var xDescription:XMLList = answer_opt.child("description");
			
			var answer:String = recurseDescription(xDescription);
			//ay_quest[i+2] = answer;
			trace("the answer: " + answer);
			return answer;
		}
		
		private function recurseDescription(xml:XMLList):String
		{
			trace("recursing the description element");
			var ret_string:String = "";
			for each(var descript:XML in xml)
			{
				for each(var element:XML in descript.descendants())
				{
					
						//trace(" _ " + element.name());
						var el_name:String = element.name();
						switch(el_name)
						{
							case "para":
							{
								//trace("para: " + element.children());
								ret_string += element.children() + "\n";
								break;
							}
							case "emphasis" :
							{
								//trace("em: " + element.children());
								ret_string += "with_emphasis " + element.children() + "\n";
								break;
							}
							case ("graphic") :
							{
								recurseGraphic(element);
								break;
							}
						}
				}
			}
			return ret_string;
				
		}
		
		private function recurseFeedbackCorrect(xml:XML)
		{
			//trace("recursing the feedback");
			var xDescription:XMLList = xml.child("description");
			var feedback:String = recurseDescription(xDescription);
			ay_quest[i+3] = feedback;
		}
		private function recurseFeedbackIncorrect(xml:XML)
		{
			//trace("recursing the feedback");
			var xDescription:XMLList = xml.child("description");
			var feedback:String = recurseDescription(xDescription);
			ay_quest[i+4] = feedback;
		}
		
		private function recurseGraphic(xml:XML)
		{
		}
	}
}