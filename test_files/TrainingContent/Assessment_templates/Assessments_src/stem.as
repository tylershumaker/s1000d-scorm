package
{
	import flash.events.*;
	import flash.display.MovieClip;
	//import fl.containers.UILoader;
	//import flash.display.Loader;
	import fl.containers.UILoader;
	import flash.net.URLRequest;
	
	public class stem extends MovieClip
	{
		//var loader:Loader;
		var loader:UILoader; 
		
		public function stem()
		{
			//trace("INIT: " + this.name);
			
		}
		
		function loadedCompleteHandler(e:Event):void
		{
		}
		
		public function hide_ui()
		{
			if(this.loader != null)
			{
				/*this.loader.visible = false;
				loader.height=5;*/
			}
		}
	
		public function setStem(question:String, icn:String)
		{
			
			if(icn == null)
			{
				if(loader != null)
				{
					
					removeChild(loader);
					loader = null;
				}
			}
			this.quest_txt.text = question;
			
			//trace(quest_txt);
			trace(quest_txt.text);
			var txt:String = this.quest_txt.text;
			//txt.split("\n",
			
			if(icn != null)
			{
				//trace(the_icn);
				if(loader == null)
				{
				
					var url = "media/" + icn + ".jpg";
					
					loader = uil_quest_graphic;
					loader.load(new URLRequest(url));
					loader.width = 350;
					loader.height = 300;
					//loader.height=350;
					//loader.width = 400;
					//loader.load(new URLRequest(url));
					//loader.width = 250;
					//loader.height = 400;
					loader.x = quest_txt.x + 125;
					loader.y = quest_txt.y + 70;
					//loader.scaleContent = false;
					this.addChild(loader);
					loader.visible = true;
				}
				else
				{
					/*loader.visible = true;
					loader.height = 250;*/
				}
				
				//myUILoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				//myUILoader.addEventListener(Event.COMPLETE, completeHandler);
				//myUILoader.move(10, 35);
				

			}
			
			
			
		}
		
		
	}
}