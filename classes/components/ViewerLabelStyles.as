package classes.components 
{
	import flash.text.AntiAliasType;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ViewerLabelStyles 
	{
		public static var base_labelStyle:Array = [
			"label_horizontalAlign", "center",
			"label_verticalAlign", "middle",
			"label_fittingMode", "scale"
		];
		
		public static var TiTS_labelStyle:Array = [
			"textFieldBase_antiAliasType", AntiAliasType.ADVANCED,
			"textFieldBase_embedFont", false,
			"textFieldBase_color", 0xFFFFFF,
			"textFieldBase_font", new TiTS_Font().fontName,
			"textFieldBase_size", 20
		];
		
		public static var CoC_labelStyle:Array = [
			"textFieldBase_antiAliasType", AntiAliasType.ADVANCED,
			"textFieldBase_embedFont", false,
			"textFieldBase_color", 0x000000,
			"textFieldBase_font", new CoC_Font().fontName,
			"textFieldBase_size", 20
		];
	}
}