package classes.components 
{
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author 
	 */
	public class ViewerTextFormat 
	{
		public static var CoCFormat:TextFormat = new TextFormat(new CoC_Font().fontName, 18, 0x000000);
		public static var TiTSFormat:TextFormat = new TextFormat(new TiTS_Font().fontName, 18, 0xFFFFFF);
		
		public static var CoCDisabledFormat:TextFormat = new TextFormat(new CoC_Font().fontName, 18, 0x888888);
		public static var TiTSDisabledFormat:TextFormat = new TextFormat(new TiTS_Font().fontName, 18, 0x888888);
		
		public static var CoCNotesFormat:TextFormat = new TextFormat(new CoC_Font().fontName, 24, 0x000000);
		public static var TiTSNotesFormat:TextFormat = new TextFormat(new TiTS_Font().fontName, 24, 0xFFFFFF);
	}
}