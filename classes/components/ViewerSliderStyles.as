package classes.components 
{
	import com.sibirjak.asdpcbeta.slider.skins.SliderThumbSkin;
	import com.sibirjak.asdpcbeta.slider.skins.SliderTrackSkin;
	import com.sibirjak.asdpcbeta.slider.Slider;
	/**
	 * ...
	 * @author ...
	 */
	internal class ViewerSliderStyles 
	{
		public static const CoC_sliderStyle:Array = [
			Slider.style.thumbPadding, 4,
			Slider.style.thumbHeight, 18,
			Slider.style.thumbWidth, 16,
			Slider.style.trackSize, 8
		];
		
		public static const TiTS_sliderStyle:Array = [
			Slider.style.thumbPadding, 4,
			Slider.style.thumbHeight, 20,
			Slider.style.thumbWidth, 20,
			Slider.style.trackSize, 8
		];
		
		public static const CoC_trackStyle:Array = [
			"button_upSkin", CoC_SliderTrack_skin,
			"button_disabledSkin", CoC_SliderTrack_disabledSkin
		];
		
		public static const TiTS_trackStyle:Array = [
			"button_upSkin", null,
			"button_disabledSkin", null
		];
		
		public static const CoC_thumbStyle:Array = [
			"button_upSkin", CoC_SliderThumb_upSkin,
			"button_overSkin", CoC_SliderThumb_overSkin,
			"button_disabledSkin", null
		];
		
		public static const TiTS_thumbStyle:Array = [
			"button_upSkin", TiTS_SliderThumb_upSkin,
			"button_overSkin", TiTS_SliderThumb_overSkin,
			"button_disabledSkin", null
		];
	}
}