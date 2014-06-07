package classes{
	import flash.display.MovieClip;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import fl.controls.BaseButton;
	import classes.DIC_Data;
	
	public class DIC_Slider extends MovieClip {
		public var max:int;
		public var styl:Object;
		public var action:Function;
		public var thumb:BaseButton;
		public var track:BaseButton;
		private var CoC_Styles:Object = {
    		focusRectSkin: null,
			thumbUpSkin: CoC_SliderThumb,
    		thumbOverSkin: CoC_SliderThumb, 
    		thumbDownSkin: CoC_SliderThumb,
    		sliderTrackSkin: null,
    		sliderTrackDisabledSkin: null,
    		tickSkin: null,
    		thumbDisabledSkin: null
    	}
		private var TiTS_Styles:Object = {
    		focusRectSkin: null,
			thumbUpSkin: TiTS_SliderThumb,
    		thumbOverSkin: TiTS_SliderThumb,
    		thumbDownSkin: TiTS_SliderThumb,
    		tickSkin: null,
    		thumbDisabledSkin: null,
    		sliderTrackSkin: null,
    		sliderTrackDisabledSkin: null
    	}
		public function DIC_Slider(_y:int, _max:int, val:int, _action:Function, _text:String = "", _x:int = 100, _w:int = void, _enabled:Boolean = true){
			var isTiTS:Boolean = DIC_Data.isTiTS;
			if(isTiTS){
				if(!_w) _w = 180;
				this.gotoAndStop(2);
			}else{
				if(!_w) _w = 132;
			}
			
			this.thumb = this.sliderBar.getChildAt(1) as BaseButton;
			this.thumb.useHandCursor = true; 
			this.thumb.buttonMode = true;
			
			this.track = this.sliderBar.getChildAt(0) as BaseButton;
			this.track.useHandCursor = true; 
			this.track.buttonMode = true;
			this.track.height = 8;
			this.track.width = _w;
			this.track.y -= 4;
			
			if (isTiTS){
				this.styl = TiTS_Styles;
				this.MC.width = _w;
				this.MC.x = -_w/2;
			}else{
				this.styl = CoC_Styles;
				this.thumb.setSize(16, 16);
				this.thumb.y += 2;
				this.MC.width = _w + 8;
				this.MC.visible = _enabled;
			}
			for (var key in styl){
				if (styl[key] == null) styl[key] = "Inexistant";
				this.sliderBar.setStyle(key, styl[key]);
			}
			this.sliderBar.width = _w;
			this.sliderBar.x = -_w/2;
			this.x = _x;
			this.y = _y;
			this.max = _max;
			this.action = _action;
			this.cacheAsBitmap = true;
			this.sliderBar.maximum = this.max;
			this.sliderText.mouseEnabled = false;
			this.sliderBar.snapInterval = 0.01;
			this.sliderBar.value = Math.min(Math.max(val, 0), max);
			this.sliderBar.addEventListener(SliderEvent.CHANGE, action);
			this.sliderBar.addEventListener(SliderEvent.THUMB_DRAG, action);
			this.sliderBar.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
			if (_text){
				this.sliderText.text = _text;
			}else{
				this.sliderBar.addEventListener(Event.ADDED_TO_STAGE, this.action, false, 0, true);
			}
			
			if (!_enabled) lock();
		}
		public function onRemove(e:Event):void{
			this.sliderBar.removeEventListener(SliderEvent.CHANGE, action);
			this.sliderBar.removeEventListener(SliderEvent.THUMB_DRAG, action);
			this.sliderBar.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			this.sliderBar.removeEventListener(Event.ADDED_TO_STAGE, this.action);
		}
		public function lock():void{
			this.enabled = false;
			this.sliderBar.maximum = 0;
			this.thumb.buttonMode = false;
			this.track.buttonMode = false;
			this.sliderText.visible = false;
			if (DIC_Data.isTiTS) this.MC.visible = false;
		}
		public function unLock():void{
			this.enabled = true;
			this.thumb.buttonMode = true;
			this.track.buttonMode = true;
			this.sliderText.visible = true;
			this.sliderBar.maximum = this.max;
			this.sliderBar.value = 2;
			if (DIC_Data.isTiTS) this.MC.visible = true;
		}
	}
	
}
