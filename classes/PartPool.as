package classes 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.geom.ColorTransform;

	/**
	 * The pool containing every character parts while waiting for re-use.
	 * It allows less memory usage and faster performances.
	 * @author Sbaf
	 */
	public class PartPool 
	{
		private var pool:Dictionary = new Dictionary();
		public var createdPartsCounter:int = 0;
		public var currentPartsCounter:int = 0;
		
		public function PartPool() { }
		
		/**
		 * Retrieve, if it exists, a new part of class "partClass".
		 * If it doesn't exist, create a new one.
		 * @param	partClass
		 * @return
		 */
		public function getNew(partClass:Class):MovieClip
		{
			var part:MovieClip;
			var available:Vector.<MovieClip> = pool[partClass];
			
			if (available && available.length)
			{
				part = available.pop();
				currentPartsCounter--;
			}
			else
			{
				part = new partClass();
				//part.cacheAsBitmap = true;//!!!
				createdPartsCounter++;
				
				if ("MC" in part)
				{
					initProperties(part);
				}
			}
			
			part.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			return (part);
		}
		
		/**
		 * Store a part inside the pool.
		 * No real need to use this function directly, as there is a REMOVED_FROM_STAGE listener that usually does the trick.
		 * @param	part
		 */
		public function storePart(part:MovieClip):void
		{
			part.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			var partClass:Class = Object(part).constructor;
			var available:Vector.<MovieClip> = pool[partClass];
			
			if (available == null)
			{
				available = pool[partClass] = new Vector.<MovieClip>();
			}
			
			part.mask = null;
			
			if (available.indexOf(part) == -1)
			{
				pool[partClass].push(part);
			}
			else
			{
				throw new Error("ERROR: Element appended twice to pool. Never remove from stage elements you got from the pool and that you are still using.");
			}
			
			currentPartsCounter++;
		}
		
		/**
		 * Flash MovieClips classes possess a dynamic property for each of their native children.
		 * This will loop through every items inside a child of part named "MC" if it exists,
		 * and create new properties for part containing MC's children.
		 * @param	part
		 */
		private function initProperties(part:MovieClip)
		{
			var MC:MovieClip = part.MC;
			
			for (var name:String in MC)
			{
				part[name] = MC[name];
			}
		}
		
		/**
		 * Stores the target inside the pool.
		 * Triggered on REMOVED_FROM_STAGE.
		 * @param	Event
		 */
		private function onRemoved(event:Event):void
		{
			storePart(event.target as MovieClip);
		}
	}
}