package classes{
	import fl.controls.List;
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.data.DataProvider;
	import classes.DIC_Data;
	
	public class DIC_List extends List{
		public var action:Function;
		public var select:Array;
		public function DIC_List(_data:Object, _action:Function, _select:Array = undefined){
			var isTiTS:Boolean = DIC_Data.isTiTS;
			var data:Array = [];
			for (var key in _data){
				data.push({label:key, data:_data[key]});
			}
			data.sortOn("label");
			this.x = 30;
			this.y = 30;
			this.rowCount = 18;
			this.rowHeight = 30;
			this.action = _action;
			this.cacheAsBitmap = true;
			this.allowMultipleSelection = true;
			this.dataProvider = new DataProvider(data);
			this.width = [140, 155][int(data.length > this.rowCount)];
			
			this.select = _select;
			this.selectedIndices = _select;
			
			this.setStyle("focusRectSkin", "Inexistant");
			this.setStyle("contentPadding", 1);
			this.setStyle("skin", "TiTS_List_skin");
			this.setStyle("cellRenderer", TiTS_CellRenderer);
			this.setStyle("thumbIcon", "Inexistant");
			this.setStyle("thumbUpSkin", "TiTS_CB_ScrollThumb");
    		this.setStyle("thumbDownSkin", "TiTS_CB_ScrollThumb");
    		this.setStyle("thumbOverSkin", "TiTS_CB_ScrollThumb");
			this.setStyle("thumbDisabledSkin", "TiTS_CB_ScrollThumb");
			this.setStyle("trackUpSkin", "Inexistant");
			this.setStyle("trackDownSkin", "Inexistant");
			this.setStyle("trackOverSkin", "Inexistant");
    		this.setStyle("trackDisabledSkin", "Inexistant");
    		this.setStyle("upArrowUpSkin", "Inexistant");
			this.setStyle("upArrowDownSkin", "Inexistant");
			this.setStyle("upArrowOverSkin", "Inexistant");
    		this.setStyle("upArrowDisabledSkin", "Inexistant");			
			this.setStyle("downArrowUpSkin", "Inexistant");
			this.setStyle("downArrowDownSkin", "Inexistant");
			this.setStyle("downArrowOverSkin", "Inexistant");
			this.setStyle("downArrowDisabledSkin", "Inexistant");
			
			addEventListener(Event.CHANGE, onChange);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			function onChange(event:Event):void{
				var found:Boolean;
				var key;
				var ite;
				for each(key in select){
					found = false;
					for each(ite in selectedIndices){
						if (key == ite){
							found = true;
						}
					}
					if (!found){
						action(event.currentTarget.activeCellRenderers[key].data.data, data.length, selectedIndices);
					}
				}
				for (key in selectedIndices){
					found = false;
					for each(ite in select){
						if (selectedIndices[key] == ite){
							found = true;
						}
					}
					if (!found){
						action(event.currentTarget.selectedItems[key].data, data.length, selectedIndices);
					}
				}
				select = selectedIndices;
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
