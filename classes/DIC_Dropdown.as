package classes{
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import fl.controls.ComboBox;
	import fl.controls.List;
	import fl.controls.listClasses.CellRenderer;
	import fl.data.DataProvider;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import classes.DIC_Data;
	
	public class DIC_Dropdown extends ComboBox{
		public var styl:Object;
		public var data:Array = [];
		private var action:Function;
		private var CoC_Styles:Object = {
			buttonWidth: 0,
			focusRectSkin: null,
			listSkin: CoC_List_skin,
			skin: CoC_List_skin,
			cellRenderer: CoC_CellRenderer,
			
			upSkin: CoC_ComboBox_upSkin,
			downSkin: CoC_ComboBox_downSkin,
			overSkin: CoC_ComboBox_overSkin,
			disabledSkin: null,
			
			trackUpSkin: null,
			trackOverSkin: null,
    		trackDownSkin: null,
			trackDisabledSkin: null,
			
			thumbIcon: null,
			thumbArrowUpSkin: CoC_CB_ScrollThumb_upSkin,
    		thumbUpSkin: CoC_CB_ScrollThumb_upSkin,
    		thumbOverSkin: CoC_CB_ScrollThumb_overSkin, 
			thumbDownSkin: CoC_CB_ScrollThumb_downSkin,
    		thumbDisabledSkin: null,
			
    		upArrowUpSkin: CoC_CB_ScrollArrowUp_upSkin,
			upArrowOverSkin: CoC_CB_ScrollArrowUp_overSkin,
    		upArrowDownSkin: CoC_CB_ScrollArrowUp_downSkin,
			upArrowDisabledSkin: null,
			
			downArrowUpSkin: CoC_CB_ScrollArrowDown_upSkin,
			downArrowDownSkin: CoC_CB_ScrollArrowDown_overSkin,
			downArrowOverSkin: CoC_CB_ScrollArrowDown_downSkin,
			downArrowDisabledSkin: null
    	}
		private var TiTS_Styles:Object = {
			buttonWidth: 6,
			focusRectSkin: null,
			listSkin: TiTS_List_skin,
			skin: TiTS_List_skin,
			cellRenderer: TiTS_CellRenderer,
			
			upSkin: TiTS_ComboBox_upSkin,
			downSkin: TiTS_ComboBox_downSkin,
			overSkin: TiTS_ComboBox_overSkin,
			disabledSkin: null,
			
			thumbIcon: null,
			thumbArrowUpSkin: TiTS_CB_ScrollThumb,
			
    		thumbUpSkin: TiTS_CB_ScrollThumb,
    		thumbDownSkin: TiTS_CB_ScrollThumb,
    		thumbOverSkin: TiTS_CB_ScrollThumb,
			thumbDisabledSkin: null,
			
			trackUpSkin: null,
			trackDownSkin: null,
			trackOverSkin: null,
			trackDisabledSkin: null,
			
    		upArrowUpSkin: null,
			upArrowDownSkin: null,
			upArrowOverSkin: null,
			upArrowDisabledSkin: null,
			
    		downArrowUpSkin: null,
			downArrowDownSkin: null,
			downArrowOverSkin: null,
			downArrowDisabledSkin: null//null
		}
		public function DIC_Dropdown(_name:String,_prompt:String,_y:Number, _data:Object,_action:Function){
			var isTiTS:Boolean = DIC_Data.isTiTS;
			for (var key in _data){
				data.push({label:key.substr(0,1).toUpperCase() + key.substr(1), data:_data[key]});
			}
			if(data.length < 3){
				this.visible = false;
				return;
			}
			var mod = int(isTiTS);
			this.styl = [CoC_Styles, TiTS_Styles][mod];
			for (key in styl){
				if (styl[key] == null) styl[key] = Inexistant;
				this.setStyle(key, styl[key]);
			}
			data.sortOn("label");
			this.x = 30;
			this.y = _y-18;
			this.height = 36;
			this.width = 140;
			this.name = _name;
			this._rowCount = 6;
			this.dropdown.rowHeight = 30;
			this.action = _action;
			this.prompt = _prompt;
			this.cacheAsBitmap = true;
			this.dataProvider = new DataProvider(data);
			this.textField.setStyle("textPadding", [3, 1][mod]);
			this.dropdown.setStyle("contentPadding", [5, 0][mod]);
			this.dropdown.setStyle("cellRenderer", [CoC_CellRenderer, TiTS_CellRenderer][mod]);
			
			
			if(data.length > this._rowCount){
				this.dropdownWidth = [160, 155][mod];
			}else{
				this.dropdownWidth = 140;
			}
			
			
			/*var obj:Object = ComboBox.getStyleDefinition();
			for (key in obj){
				trace(key+": "+obj[key]+",");
				trace(this.getStyle(key));
			}*/
			
			addEventListener(Event.CHANGE, onChange);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			function onChange(event:Event):void{
				action(ComboBox(event.target).selectedItem.data)
			}
			function onRemove(event:Event):void{
				removeEventListener(Event.CHANGE, onChange);
				removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
				removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			}
			function onOver(event:MouseEvent):void{
				Mouse.cursor="button";
			}
			function onOut(event:MouseEvent):void{
				Mouse.cursor="auto";
			}
		}
	}
}
