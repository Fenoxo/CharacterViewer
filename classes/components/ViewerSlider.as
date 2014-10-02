package classes.components 
{
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpc.core.constants.Direction;
	import com.sibirjak.asdpcbeta.slider.core.SliderThumb;
	import com.sibirjak.asdpcbeta.slider.Slider;
	import com.sibirjak.asdpcbeta.slider.SliderEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ViewerSlider extends Slider implements IViewerComponent
	{
		public var action:Function;
		public var precision:uint = 1;
		public var isTrackVisible:Boolean;
		
		protected var _mode:int = -1;
		
		protected var _label:Label;
		protected var _labelText:String;
		protected var _dynamicText:Boolean;
		
		public var progressBarColor:uint = 0x8D31B0;
		public var disabledBarColor:uint = 0x3A4B6A;
		public var backgroundBarColor:uint = 0x343F52;
		
		protected var _progressBar:ViewerSliderBar;
		protected var _disabledBar:ViewerSliderBar;
		protected var _backgroundBar:ViewerSliderBar;
		
		public function ViewerSlider(action:Function = null, min:Number = 0.0, max:Number = 1.0, label:String = null, dynamicText:Boolean = false, precision:uint = 1, isTrackVisible:Boolean = true) 
		{
			super();
			this.direction = Direction.HORIZONTAL;
			this.setSize(148, _height);
			this.useHandCursor = true;
			this.liveDragging = true;
			this.minValue = min;
			this.maxValue = max;
			this.value = min;
			
			//I had to edit the original slider class.
			//Any line added was marked by the //sbaf tag.
			//All edits regard snapping and thumb position.
			
			this.action = action;
			this.precision = precision;
			this._dynamicText = dynamicText;
			this.isTrackVisible = isTrackVisible;
			
			if (label)
			{
				this.label = label;
			}
			if (dynamicText)
			{
				this.addEventListener(SliderEvent.CHANGE, updateLabelText);
			}
			if (action != null)
			{
				this.addEventListener(SliderEvent.CHANGE, action, false, 0, true);
				this.addEventListener(SliderEvent.CHANGE, onChange, false, 0, true);
				this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
			}
		}
		
		public function onRemoved(event:Event):void
		{
			this.removeEventListener(SliderEvent.CHANGE, action);
			this.removeEventListener(SliderEvent.CHANGE, onChange);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this.removeEventListener(SliderEvent.CHANGE, updateLabelText);
		}
		
		private function updateLabelText(event:SliderEvent = null):void
		{
			if (_dynamicText)
			{
				_label.text = _labelText.split("X").join(this.value.toFixed(precision));
			}
			else
			{
				_label.text = _labelText;
			}
			_label.validateNow();
		}
		
		public function setSlider(min:Number, max:Number, value:Number = NaN):void
		{
			this.minValue = min;
			this.maxValue = max;
			if (isNaN(value))
			{
				this.value = Math.min(min, max);
			}
			else
			{
				this.value = Math.max(Math.min(value, max), min);
			}
			updateLabelText();
		}
		
		public function setMode(isTiTS:Boolean):void
		{
			_mode = (isTiTS) ? 1 : 0;
			
			if (isTiTS)
			{
				this.setStyles(ViewerSliderStyles.TiTS_sliderStyle);
				if (this._label)
				{
					_label.setStyles(ViewerLabelStyles.TiTS_labelStyle);
				}
			}
			else
			{
				this.setStyles(ViewerSliderStyles.CoC_sliderStyle);
				if (this._label)
				{
					_label.setStyles(ViewerLabelStyles.CoC_labelStyle);
				}
			}
			
			
			if (this._initialised)
			{
				_setMode();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, _setMode, false, -1, true);
			}
		}
		
		private function _setMode(event:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, _setMode);
			
			var _thumb:Button = this.getChildByName(Slider.THUMB_NAME) as Button;
			var _track:Button = this.getChildByName(Slider.TRACK_NAME) as Button;
			
			if (_mode == 1)
			{
				_thumb.setStyles(ViewerSliderStyles.TiTS_thumbStyle);
				_track.setStyles(ViewerSliderStyles.TiTS_trackStyle);
				
				if (!_progressBar)
				{
					initProgressBar();
				}
			}
			else
			{
				_thumb.setStyles(ViewerSliderStyles.CoC_thumbStyle);
				_track.setStyles(ViewerSliderStyles.CoC_trackStyle);
			}
			
			_track.visible = isTrackVisible;
			
			updateBars();
		}
		
		public function setCompSize(width:Number, height:Number):void
		{
			this.setSize(Math.round(width), Math.round(height));
		}
		
		public function onChange(event:SliderEvent)
		{
			if (this._progressBar && _mode == 1)
			{
				this._progressBar.visible = (this.minValue < this.maxValue) && enabled;
				
				updateProgressBar();
			}
		}
		
		private function initProgressBar():void
		{
			_backgroundBar = new ViewerSliderBar(backgroundBarColor, this.width, 4);
			_progressBar = new ViewerSliderBar(progressBarColor, this.width, 4);
			_disabledBar = new ViewerSliderBar(disabledBarColor, this.width, 4);
			
			addChildAt(_disabledBar, 0);
			addChildAt(_backgroundBar, 1);
			addChildAt(_progressBar, 2);
			
			updateProgressBar();
		}
		
		private function updateBars():void
		{	
			if (_progressBar)
			{
				if (_mode == 1)
				{
					_progressBar.visible = (this.minValue < this.maxValue) && enabled;
					_backgroundBar.visible = _progressBar.visible;
					_disabledBar.visible = !_progressBar.visible;
				}
				else
				{
					_progressBar.visible = false;
					_backgroundBar.visible = false;
					_disabledBar.visible = false;
				}
				updateProgressBar();
			}
		}
		
		private function updateProgressBar():void
		{
			_progressBar.scaleX = (this.value - this.minValue) / (this.maxValue - this.minValue);
		}
		
		public function set label(value:String):void
		{
			_labelText = value;
			if (!_label)
			{
				_label = new Label();
				_label.setSize(_width, _height * 2);
				_label.setStyles(ViewerLabelStyles.base_labelStyle);
				_label.setStyles(ViewerLabelStyles.CoC_labelStyle);
				_label.y = 20;
				this.addChildAt(_label, 0);
			}
			updateLabelText();
		}
		
		public function get label():String
		{
			return (_label.text);
		}
		
		public function set dynamicText(value:Boolean)
		{
			_dynamicText = value;
			if (value)
			{
				this.addEventListener(SliderEvent.CHANGE, updateLabelText);
			}
			else
			{
				this.removeEventListener(SliderEvent.CHANGE, updateLabelText);
			}
			this.updateLabelText();
		}
		
		public function get dynamicText():Boolean
		{
			return (_dynamicText);
		}
		
		override public function set enabled(enabled:Boolean):void
		{
			super.enabled = enabled;
			if (_label)
			{
				this._label.visible = enabled;
			}
			updateBars();
		}
		
		override public function set value(value:Number):void
		{
			super.value = value;
			if (_label)
			{
				updateLabelText();
			}
			updateBars();
		}
	}
}