package classes.components 
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class ViewerSelect extends ComboBox implements IViewerComponent
	{
		public var action:Function;
		public var argument:String;
		
		public function ViewerSelect(action:Function = null, prompt:String = null, data:Object = null, argument:String = null) 
		{
			super();
			this.setSize(140, 36);
			this.buttonMode = true;
			
			if (data != null) this.data = data;
			if (prompt != null) this.prompt = prompt;
			if (action != null) this.action = action;
			if (argument != null) this.argument = argument;
			
			this.addEventListener(Event.CHANGE, onChange);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		private function onChange(event:Event):void
		{
			if (action!= null)
			{
				if (this.argument)
				{
					this.action(argument, this.selectedItem.data);
				}
				else
				{
					this.action(this.selectedItem.data);
				}
			}
		}
		
		private function onRemove(event:Event):void
		{
			this.removeEventListener(Event.CHANGE, onChange);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		public function setMode(isTiTS:Boolean):void
		{
			if (isTiTS)
			{//disabled
				this.setStyleArray(ViewerSelectStyles.TiTS_selectStyle);
				this.setStyle("embedFont", true);
				this.setStyle("textFormat", ViewerTextFormat.TiTSFormat);
				this.setStyle("disabledTextFormat", ViewerTextFormat.TiTSDisabledFormat);
				
				this.textField.setStyle("embedFont", true);
				this.textField.setStyle("textPadding", 3);
				this.textField.setStyle("textFormat", ViewerTextFormat.TiTSFormat);
				this.textField.setStyle("disabledTextFormat", ViewerTextFormat.TiTSDisabledFormat);
				
				this.dropdown.setStyle("contentPadding", 0);
				this.dropdown.setStyle("cellRenderer", TiTS_CellRenderer);
			}
			else
			{
				this.setStyleArray(ViewerSelectStyles.CoC_selectStyle);
				this.setStyle("embedFont", true);
				this.setStyle("textFormat", ViewerTextFormat.CoCFormat);
				this.setStyle("disabledTextFormat", ViewerTextFormat.CoCDisabledFormat);
				
				
				this.textField.setStyle("embedFont", true);
				this.textField.setStyle("textPadding", 3);
				this.textField.setStyle("textFormat", ViewerTextFormat.CoCFormat);
				this.textField.setStyle("disabledTextFormat", ViewerTextFormat.CoCDisabledFormat);
				
				this.dropdown.setStyle("contentPadding", 5);
				this.dropdown.setStyle("cellRenderer", CoC_CellRenderer);
			}
		}
		
		public function setCompSize(width:Number, height:Number):void
		{
			this.setSize(width, height);
		}
		
		public function setStyleArray(styles:Array)
		{
			for (var i:int = 0; i < styles.length; i += 2)
			{
				this.setStyle(styles[i], styles[i + 1]);
			}
		}
		
		public function set data(value:Object):void
		{
			var array:Array = [];
			var element:Object;
			
			for (var key:String in value)
			{
				element = {label:key, data:value[key]};
				array.push(element);
			}
			array.sortOn("label");
			this.dataProvider = new DataProvider(array);
			this.selectedIndex = 0;
		}
		
		override public function set enabled(value:Boolean):void
		{
			if (!value)
			{
				this.dataProvider.removeAll();
				this.buttonMode = false;
			}
			else
			{
				this.buttonMode = true;
			}
			super.enabled = value;
		}
	}
}