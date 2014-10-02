package classes.components
{
	import fl.controls.listClasses.CellRenderer;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	
	public class TiTS_CellRenderer extends CellRenderer
	{
		public function TiTS_CellRenderer()
		{
			this.setStyle("embedFonts", true);
			this.setStyle("textFormat", ViewerTextFormat.TiTSFormat);
			this.setStyle("disabledTextFormat", ViewerTextFormat.TiTSFormat);
			
			this.setStyle("upSkin", Sprite);
			this.setStyle("overSkin", TiTS_CellRenderer_downSkin);
			this.setStyle("downSkin", TiTS_CellRenderer_downSkin);
			this.setStyle("disabledSkin", Sprite);
			this.setStyle("selectedUpSkin", TiTS_CellRenderer_downSkin);
			this.setStyle("selectedOverSkin", TiTS_CellRenderer_downSkin);
			this.setStyle("selectedDownSkin", TiTS_CellRenderer_downSkin);
			this.setStyle("selectedDisabledSkin", Sprite);
		}
	}
}
/*public function TiTS_CellRenderer()
{
	this.setStyleArray(CellRendererStyles.TiTS_rendererStyle);
	super();
}

public function setStyleArray(styles:Array)
{
	for (var i:int = 0; i < styles.length; i += 2)
	{
		this.setStyle(styles[i], styles[i + 1]);
	}
}*/