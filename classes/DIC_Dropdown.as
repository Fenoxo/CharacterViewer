package classes{
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.text.TextFormat;
	
	public class DIC_Dropdown extends ComboBox{
		public var action:Function;
		public var data:Array = [];
		private var CoC_Styles:Object = {
			listSkin: "CoC_List_skin",
			upSkin: "CoC_ComboBox_upSkin",
			downSkin: "CoC_ComboBox_downSkin",
			overSkin: "CoC_ComboBox_overSkin",
			thumbUpSkin: "CoC_ScrollThumb_upSkin",
    		thumbDownSkin: "CoC_ScrollThumb_downSkin",
    		thumbOverSkin: "CoC_ScrollThumb_overSkin", 
    		trackUpSkin: "CoC_ScrollTrack_skin",
			trackDownSkin: "CoC_ScrollTrack_skin",
			trackOverSkin: "CoC_ScrollTrack_skin",
    		upArrowUpSkin: "CoC_ScrollArrowUp_upSkin",
			upArrowDownSkin: "CoC_ScrollArrowUp_downSkin",
			upArrowOverSkin: "CoC_ScrollArrowUp_overSkin",
    		downArrowUpSkin: "CoC_ScrollArrowDown_upSkin",
			downArrowDownSkin: "CoC_ScrollArrowDown_overSkin",
			downArrowOverSkin: "CoC_ScrollArrowDown_downSkin",
			disabledSkin: null,
			thumbIcon: null,
			trackDisabledSkin: null,
			upArrowDisabledSkin: null,
			downArrowDisabledSkin: null
    	}
		private var TiTS_Styles:Object = {
			listSkin: "TiTS_List_skin",
			upSkin: "TiTS_ComboBox_upSkin",
			downSkin: "TiTS_ComboBox_downSkin",
			overSkin: "TiTS_ComboBox_overSkin",
			thumbUpSkin: "TiTS_ComboBox_ScrollThumb",
    		thumbDownSkin: "TiTS_ComboBox_ScrollThumb",
    		thumbOverSkin: "TiTS_ComboBox_ScrollThumb",
			disabledSkin: null,
			thumbIcon: null,
			trackUpSkin: null,
			trackDownSkin: null,
			trackOverSkin: null,
    		upArrowUpSkin: null,
			upArrowDownSkin: null,
			upArrowOverSkin: null,
    		downArrowUpSkin: null,
			downArrowDownSkin: null,
			downArrowOverSkin: null,
    		trackDisabledSkin: null,
			upArrowDisabledSkin: null,
			downArrowDisabledSkin: null
    	}
		public function DIC_Dropdown(_name:String,_prompt:String,_x:Number,_y:Number, _data:Object,_action:Function, isTiTS:Boolean){
			for (var key in _data){
				data.push({label:toCap(key), data:_data[key]});
			}
			if(data.length < 2){
				this.visible = false;
				return;
			}
			data.sortOn("label");
			this.name = _name;
			this.action = _action;
			this.prompt = _prompt;
			this.x = _x;
			this.y = _y;
			this.height = 36;
			this.width = 140;
			this._rowCount = 8;
			this.textField.width = 140;
			this.getChildAt(0).buttonMode = true;
			this.dropdownWidth = 160;
			this.dataProvider = new DataProvider(data);
			this.addEventListener(Event.CHANGE, effect);
			trace("New CoC_Dropdown with data length of "+data.length+".");
			
			if (isTiTS){
				this.dropdown.setRendererStyle("upSkin", "TiTS_CellRenderer_upSkin")
				this.dropdown.setRendererStyle("overSkin", "TiTS_CellRenderer_downSkin")
				this.dropdown.setRendererStyle("downSkin", "TiTS_CellRenderer_downSkin")
				this.dropdown.setRendererStyle("disabledSkin", "Inexistant")
				this.dropdown.setRendererStyle("selectedUpSkin", "TiTS_CellRenderer_downSkin")
				this.dropdown.setRendererStyle("selectedOverSkin", "TiTS_CellRenderer_downSkin")
				this.dropdown.setRendererStyle("selectedDownSkin", "TiTS_CellRenderer_downSkin")
				this.dropdown.setRendererStyle("selectedDisabledSkin", "Inexistant")
			}
			
			var nam:String;
			for (key in CoC_Styles){
				nam = [CoC_Styles, TiTS_Styles][int(isTiTS)][key];
				if (!nam) nam = "Inexistant";
				this.setStyle(key, nam);
			}
			function effect(event:Event){
				action(ComboBox(event.target).selectedItem.data)
			}
			function toCap(str:String):String{
				return str.substr(0,1).toUpperCase() + str.substr(1); 
			}
		}
	}
}
