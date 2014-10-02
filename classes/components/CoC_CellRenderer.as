package classes.components
{
	import fl.controls.listClasses.CellRenderer;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	
	
	public class CoC_CellRenderer extends CellRenderer
	{
		public function CoC_CellRenderer()
		{
			this.setStyle("embedFonts", true);
			this.setStyle("upSkin", CoC_CellRenderer_upSkin);
			this.setStyle("overSkin", CoC_CellRenderer_downSkin);
			this.setStyle("downSkin", CoC_CellRenderer_downSkin);
			this.setStyle("disabledSkin", Sprite);
			this.setStyle("selectedUpSkin", CoC_CellRenderer_downSkin);
			this.setStyle("selectedOverSkin", CoC_CellRenderer_downSkin);
			this.setStyle("selectedDownSkin", CoC_CellRenderer_downSkin);
			this.setStyle("selectedDisabledSkin", Sprite);
		}
	}
}
/*public function CoC_CellRenderer()
{
	this.setStyle("upSkin", CoC_CellRenderer_upSkin);
	this.setStyleArray(CellRendererStyles.CoC_rendererStyle);
	super();
}

public function setStyleArray(styles:Array)
{
	for (var i:int = 0; i < styles.length; i += 2)
	{
		this.setStyle(styles[i], styles[i + 1]);
	}
}*/