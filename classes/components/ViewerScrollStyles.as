package classes.components 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class ViewerScrollStyles 
	{
		public static const TiTS_scrollStyles:Array =
		[
			"skin", TiTS_List_skin,
			"contentPadding", 1,
			"focusRectSkin", Sprite,
			"cellRenderer", TiTS_CellRenderer,
			
			"thumbIcon", Sprite,
			"thumbUpSkin", TiTS_CB_ScrollThumb,
    		"thumbDownSkin", TiTS_CB_ScrollThumb,
    		"thumbOverSkin", TiTS_CB_ScrollThumb,
			"thumbDisabledSkin", TiTS_CB_ScrollThumb,
			
			"trackUpSkin", Sprite,
			"trackDownSkin", Sprite,
			"trackOverSkin", Sprite,
    		"trackDisabledSkin", Sprite,
			
    		"upArrowUpSkin", Sprite,
			"upArrowDownSkin", Sprite,
			"upArrowOverSkin", Sprite,
    		"upArrowDisabledSkin", Sprite,
			
			"downArrowUpSkin", Sprite,
			"downArrowDownSkin", Sprite,
			"downArrowOverSkin", Sprite,
			"downArrowDisabledSkin", Sprite
		];
	}
}