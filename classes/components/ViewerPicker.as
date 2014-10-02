package classes.components 
{
	import fl.controls.ColorPicker;
	import fl.events.ColorPickerEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class ViewerPicker extends ColorPicker implements IViewerComponent
	{
		public var action:Function;
		public var argument:String;
		
		public function ViewerPicker(action:Function = null, argument:String = null) 
		{
			super();
			this.setSize(140, 36);
			
			this.action = action;
			this.argument = argument;
			this.editable = false;
			this.showTextField = false;
			
			this.addEventListener(ColorPickerEvent.CHANGE, onChange);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		private function onChange(event:ColorPickerEvent = null):void
		{
			if ((action) != null)
			{
				if (argument)
				{
					action(argument, event.color);
				}
				else
				{
					action(event.color);
				}
			}
		}
		
		private function onRemoved(event:Event = null):void
		{
			this.removeEventListener(ColorPickerEvent.CHANGE, onChange);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		public function setMode(isTiTS:Boolean):void
		{
			if (isTiTS)
			{
				this.setStyleArray(ViewerPickerStyles.TiTS_pickerStyle);
			}
			else
			{
				this.setStyleArray(ViewerPickerStyles.CoC_pickerStyle);
			}
		}
		
		public function setCompSize(width:Number, height:Number):void
		{
			this.setSize(width, height);
		}
		
		public function setStyleArray(styles:Array):void
		{
			for (var i:int = 0; i < styles.length; i += 2)
			{
				this.setStyle(styles[i], styles[i + 1]);
			}
		}
	}
}