package classes.components 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author 
	 */
	public class ViewerCellRendererStyles 
	{
		public static const CoC_rendererStyle:Array = [
			"embedFonts", true,
			"upSkin", CoC_CellRenderer_upSkin,
			"overSkin", CoC_CellRenderer_downSkin,
			"downSkin", CoC_CellRenderer_downSkin,
			"disabledSkin", Sprite,
			"selectedUpSkin", CoC_CellRenderer_downSkin,
			"selectedOverSkin", CoC_CellRenderer_downSkin,
			"selectedDownSkin", CoC_CellRenderer_downSkin,
			"selectedDisabledSkin", Sprite
		];
		
		public static const TiTS_rendererStyle:Array = [
			"embedFonts", true,
			"upSkin", Sprite,
			"overSkin", TiTS_CellRenderer_downSkin,
			"downSkin", TiTS_CellRenderer_downSkin,
			"disabledSkin", Sprite,
			"selectedUpSkin", TiTS_CellRenderer_downSkin,
			"selectedOverSkin", TiTS_CellRenderer_downSkin,
			"selectedDownSkin", TiTS_CellRenderer_downSkin,
			"selectedDisabledSkin", Sprite
		];
	}
}