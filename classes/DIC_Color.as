package classes{
	import fl.events.ColorPickerEvent;
	import fl.controls.ColorPicker;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.text.TextFormat;
	import flash.geom.ColorTransform;
	import classes.DIC_Data;
	
	public class DIC_Color extends ColorPicker{
		public var action:Function;
		public var select:Array;
		private var CoC_Styles:Object = {
			downSkin: CoC_ColorPicker_downSkin,
			overSkin: CoC_ColorPicker_overSkin,
			upSkin: CoC_ColorPicker_upSkin,
			colorWell: CoC_ColorPicker_colorWell,
			disabledSkin: null,
			
			swatchSelectedSkin: CoC_ColorPicker_swatchSelectedSkin,
			background: CoC_ColorPicker_backgroundSkin,
			swatchSkin: CoC_ColorPicker_swatchSkin,
			
			textFieldSkin: null,
			focusRectSkin: null,
			
			backgroundPadding: 10,
			swatchPadding: 0,
			swatchHeight: 20,
			swatchWidth: 20,
			columnCount: 36
    	}
		private var TiTS_Styles:Object = {
			downSkin: TiTS_ColorPicker_downSkin,
			overSkin: TiTS_ColorPicker_overSkin,
			upSkin: TiTS_ColorPicker_upSkin,
			colorWell: TiTS_ColorPicker_colorWell,
			disabledSkin: null,
			
			swatchSelectedSkin: TiTS_ColorPicker_swatchSelectedSkin,
			background: TiTS_ColorPicker_backgroundSkin,
			swatchSkin: TiTS_ColorPicker_swatchSkin,
			
			textFieldSkin: null,
			focusRectSkin: null,
			
			backgroundPadding: 10,
			swatchPadding: 0,
			swatchHeight: 20,
			swatchWidth: 20,
			columnCount: 36
    	}
		public function DIC_Color(_y:int, _action:Function, color:uint){
			var isTiTS:Boolean = DIC_Data.isTiTS;
			this.x = 30;
			this.y = _y-18;
			this.action = _action;
			this.editable = false;
			this.showTextField = false;
			
			var nam:*;
			var styl:Object = [CoC_Styles, TiTS_Styles][int(isTiTS)];
			for (var key:String in styl){
				nam = styl[key];
				if (nam == null) nam = "Inexistant";
				this.setStyle(key, nam);
			}
			
			this.height = 36;
			this.width = 140;
			this.selectedColor = color;
			
			addEventListener(Event.CHANGE, onChange);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			function onChange(event:ColorPickerEvent):void{
				action(event.color);
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
