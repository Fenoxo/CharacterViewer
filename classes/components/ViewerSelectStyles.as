package classes.components 
{
	import flash.display.Sprite;
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpcbeta.selectbox.SelectBox;
	
	/**
	 * ...
	 * @author ...
	 */
	internal class ViewerSelectStyles 
	{
		public static const CoC_selectStyle:Array = [
			"buttonWidth", 0,
			
			"skin", CoC_List_skin,
			"listSkin", CoC_List_skin,
			"focusRectSkin", Sprite,
			"cellRenderer", CoC_CellRenderer,
			
			"upSkin", CoC_ComboBox_upSkin,
			"downSkin", CoC_ComboBox_downSkin,
			"overSkin", CoC_ComboBox_overSkin,
			"disabledSkin", CoC_ComboBox_downSkin,
			
			"trackUpSkin", Sprite,
			"trackDownSkin", Sprite,
			"trackOverSkin", Sprite,
			"trackDisabledSkin", Sprite,
			
			"thumbIcon", Sprite,
			"thumbArrowUpSkin", CoC_CB_ScrollThumb_upSkin,
			
			"thumbUpSkin", CoC_CB_ScrollThumb_upSkin,
			"thumbDownSkin", CoC_CB_ScrollThumb_downSkin,
			"thumbOverSkin", CoC_CB_ScrollThumb_overSkin,
			"thumbDisabledSkin", Sprite,
			
			"upArrowUpSkin", CoC_CB_ScrollArrowUp_upSkin,
			"upArrowDownSkin", CoC_CB_ScrollArrowUp_downSkin,
			"upArrowOverSkin", CoC_CB_ScrollArrowUp_overSkin,
			"upArrowDisabledSkin", Sprite,
			
			"downArrowUpSkin", CoC_CB_ScrollArrowDown_upSkin,
			"downArrowDownSkin", CoC_CB_ScrollArrowDown_overSkin,
			"downArrowOverSkin", CoC_CB_ScrollArrowDown_downSkin,
			"downArrowDisabledSkin", Sprite
		];
		
		public static const TiTS_selectStyle:Array = [
			"buttonWidth", 6,
			
			"skin", TiTS_List_skin,
			"listSkin", TiTS_List_skin,
			"focusRectSkin", Sprite,
			"cellRenderer", TiTS_CellRenderer,
			
			"upSkin", TiTS_ComboBox_upSkin,
			"downSkin", TiTS_ComboBox_downSkin,
			"overSkin", TiTS_ComboBox_overSkin,
			"disabledSkin", TiTS_ComboBox_downSkin,
			
			"thumbIcon", Sprite,
			"thumbArrowUpSkin", TiTS_CB_ScrollThumb,
			
			"thumbUpSkin", TiTS_CB_ScrollThumb,
			"thumbDownSkin", TiTS_CB_ScrollThumb,
			"thumbOverSkin", TiTS_CB_ScrollThumb,
			"thumbDisabledSkin", Sprite,
			
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