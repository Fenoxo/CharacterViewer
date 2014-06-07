package classes{
	import flash.text.TextFormat;
	import fl.controls.listClasses.CellRenderer;
	
	public class TiTS_CellRenderer extends CellRenderer{
		public function TiTS_CellRenderer(){
			this.setStyle("embedFonts", true);
			this.setStyle("upSkin", "Inexistant");
			this.setStyle("overSkin", "TiTS_CellRenderer_downSkin");
			this.setStyle("downSkin", "TiTS_CellRenderer_downSkin");
			this.setStyle("disabledSkin", "Inexistant");
			this.setStyle("selectedUpSkin", "TiTS_CellRenderer_downSkin");
			this.setStyle("selectedOverSkin", "TiTS_CellRenderer_downSkin");
			this.setStyle("selectedDownSkin", "TiTS_CellRenderer_downSkin");
			this.setStyle("selectedDisabledSkin", "Inexistant");
		}
	}
}
