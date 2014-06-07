package classes{
	import flash.text.TextFormat;
	import fl.controls.listClasses.CellRenderer;
	
	public class CoC_CellRenderer extends CellRenderer{
		public function CoC_CellRenderer(){
			this.setStyle("embedFonts", true);
			this.setStyle("upSkin", "CoC_CellRenderer_upSkin");
			this.setStyle("overSkin", "CoC_CellRenderer_downSkin");
			this.setStyle("downSkin", "CoC_CellRenderer_downSkin");
			this.setStyle("disabledSkin", "Inexistant");
			this.setStyle("selectedUpSkin", "CoC_CellRenderer_downSkin");
			this.setStyle("selectedOverSkin", "CoC_CellRenderer_downSkin");
			this.setStyle("selectedDownSkin", "CoC_CellRenderer_downSkin");
			this.setStyle("selectedDisabledSkin", "Inexistant");
		}
	}
}
