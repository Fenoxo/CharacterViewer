package classes{
	import flash.display.MovieClip;
	import fl.events.SliderEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import fl.controls.BaseButton;
	
	public class DIC_Slider extends MovieClip {
		public var max:int;
		public var styl:Object;
		public var isTiTS:Boolean;
		public var action:Function;
		public var thumb:BaseButton;
		public var track:BaseButton;
		private var CoC_Styles:Object = {
    		thumbUpSkin: "CoC_SliderThumb_upSkin",
    		thumbOverSkin: "CoC_SliderThumb_overSkin", 
    		thumbDownSkin: "CoC_SliderThumb_downSkin",
    		sliderTrackSkin: "CoC_SliderTrack_skin",
    		sliderTrackDisabledSkin: "CoC_SliderTrack_disabledSkin",
    		tickSkin: null,
    		focusRectSkin: null,
    		focusRectPadding: null,
    		thumbDisabledSkin: null
    	}
		private var TiTS_Styles:Object = {
    		thumbUpSkin: "TiTS_SliderThumb",
    		thumbOverSkin: "TiTS_SliderThumb", 
    		thumbDownSkin: "TiTS_SliderThumb",
    		tickSkin: null,
    		focusRectSkin:null,
    		focusRectPadding:null,
    		thumbDisabledSkin: null,
    		sliderTrackSkin: null,
    		sliderTrackDisabledSkin: null
    	}
		public function DIC_Slider(_y:int, _max:int, val:int, _action:Function, _isTiTS:Boolean, _text:String = "", _x:int = 100, _w:int = void, ena:Boolean = true){;
			if(_isTiTS){
				this.isTiTS = true;
				if(!_w) _w = 180;
				this.gotoAndStop(2);
			}else{
				this.isTiTS = false;
				if(!_w) _w = 140;
			}
			
			this.thumb = this.sliderBar.getChildAt(1);
			this.thumb.useHandCursor = true; 
			this.thumb.buttonMode = true;
			
			this.track = this.sliderBar.getChildAt(0);
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
				this.thumb.y += 2;
				this.thumb.height = 16;
				this.thumb.width = 16;
				this.track.visible = ena;
			}
			
			this.sliderBar.width = _w;
			this.sliderBar.x = -_w/2;
			this.x = _x;
			this.y = _y;
			this.max = _max;
			this.action = _action;
			this.sliderBar.maximum = this.max;
			this.sliderText.mouseEnabled = false;
			this.sliderBar.value = Math.min(Math.max(val, 0), max);
			this.sliderBar.addEventListener(SliderEvent.THUMB_DRAG, this.action);
			this.sliderBar.addEventListener(SliderEvent.CHANGE, this.action);
			
			if (_text){
				this.sliderText.text = _text;
			}else{
				this.sliderBar.addEventListener(Event.ADDED_TO_STAGE, this.action, false, 0, true);
			}
			var nam:String;
			for (var key:String in styl){
				nam = styl[key];
				if (!nam) nam = "Inexistant";
				this.sliderBar.setStyle(key, nam);
			}
			if (!ena) lock();
		}
		public function lock():void{
			this.enabled = false;
			this.sliderBar.maximum = 0;
			this.thumb.buttonMode = false;
			this.track.buttonMode = false;
			this.sliderText.visible = false;
			if (this.isTiTS) this.MC.visible = false;
		}
		public function unLock():void{
			this.enabled = true;
			this.thumb.buttonMode = true;
			this.track.buttonMode = true;
			this.sliderText.visible = true;
			this.sliderBar.maximum = this.max;
			this.sliderBar.value = 2;
			if (this.isTiTS) this.MC.visible = true;
		}
	}
	
}
