package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Oofuchiwaki
	 */
	public class Main extends MovieClip 
	{
		private var drop:Drop;
		public function Main() 
		{
			if (stage)
			{
				onStage();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE , onStage);
			}
		}
		
		private function onStage(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			drop = new Drop();
			addChild(drop);
		}
		
	}

}