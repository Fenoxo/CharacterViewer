package classes.components
{
	import fl.data.DataProvider;
	import fl.controls.List;
	import flash.events.Event;
	
	public class ViewerScroll extends List implements IViewerComponent
	{
		public var onAdded:Function;
		public var onRemoved:Function;
		public var select:Array = [];
		
		public function ViewerScroll(selectAction:Function = null, deselectAction:Function = null, data:Object = null)
		{
			this.data = data;
			this.onAdded = selectAction;
			this.onRemoved = deselectAction;
			
			this.rowCount = 18;
			this.rowHeight = 30;
			this.allowMultipleSelection = true;
			this.width = (this.dataProvider.length > this.rowCount) ? 155 : 140;
			this.setStyleArray(ViewerScrollStyles.TiTS_scrollStyles);
			
			this.addEventListener(Event.CHANGE, onChange);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		public function setStyleArray(styles:Array)
		{
			for (var i:int = 0; i < styles.length; i += 2)
			{
				this.setStyle(styles[i], styles[i + 1]);
			}
		}
		
		private function onChange(event:Event = null):void
		{
			if (onAdded != null) updateAdded();
			if (onRemoved != null) updateRemoved();
			select = selectedIndices;
		}
		
		private function updateAdded():void
		{
			outer: for each (var key:uint in selectedIndices)
			{
				inner: for each (var compare:uint in select)
				{
					if (key == compare)
					{
						continue outer;
					}
				}
				onAdded(this.dataProvider.getItemAt(key).data);
			}
		}
		
		private function updateRemoved():void
		{
			outer: for each (var key:uint in select)
			{
				inner: for each (var compare:uint in selectedIndices)
				{
					if (key == compare)
					{
						continue outer;
					}
				}
				onRemoved(this.dataProvider.getItemAt(key).data);
			}
		}
		
		private function onRemove(event:Event):void
		{
			removeEventListener(Event.CHANGE, onChange);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		public function set data(value:Object):void
		{
			if (value == null) return;
			
			var array:Array = [];
			var element:Object;
			
			for (var key:String in value)
			{
				element = {label:key, data:value[key]};
				array.push(element);
			}
			array.sortOn("label");
			this.dataProvider = new DataProvider(array);
		}
		
		override public function set selectedIndices(array:Array):void 
		{
			super.selectedIndices = array;
			
			onChange();
		}
		
		public function setCompSize(width:Number, height:Number):void
		{
			this.setSize(width, height);
		}
		
		public function setMode(isTiTS:Boolean):void { }
	}
}
