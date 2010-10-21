package {
    
    import flash.display.MovieClip;
    import flash.events.*;
    
    public class ComMedEvents extends MovieClip
	{
        
        public function ComMedEvents():void
		{

        }
        
        public function LoadCompleteDispatch():void {
            dispatchEvent(new Event("LoadComplete", true));
        }
    }
}