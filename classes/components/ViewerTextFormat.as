package classes.components 
{
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author 
	 */
	public class ViewerTextFormat 
	{
		public static const CoCFormat:TextFormat = new TextFormat(new CoC_Font().fontName, 18, 0x000000);
		public static const TiTSFormat:TextFormat = new TextFormat(new TiTS_Font().fontName, 18, 0xFFFFFF);
		
		public static const CoCDisabledFormat:TextFormat = new TextFormat(new CoC_Font().fontName, 18, 0x888888);
		public static const TiTSDisabledFormat:TextFormat = new TextFormat(new TiTS_Font().fontName, 18, 0x888888);
		
		public static const CoCNotesFormat:TextFormat = new TextFormat(new CoC_Font().fontName, 24, 0x000000);
		public static const TiTSNotesFormat:TextFormat = new TextFormat(new TiTS_Font().fontName, 24, 0xFFFFFF);
	}
}