package classes.elements {
	
	import com.gskinner.geom.ColorMatrix;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	
	
	public class GoblinNPC extends MovieClip {
		
		private var cm:ColorMatrix = new ColorMatrix();
		private var cmf:ColorMatrixFilter = new ColorMatrixFilter();
		
		public function GoblinNPC() {
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
		}
		
		public function onAdded(event:Event):void
		{
			cm.adjustHue(Math.random() * 360);
			cmf.matrix = cm.toArray();
			hair.filters = [cmf];
			
			cm.adjustHue(Math.random() * 360);
			cmf.matrix = cm.toArray();
			flask.filters = [cmf];
		}
	}
}
