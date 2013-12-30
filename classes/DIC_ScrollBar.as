package classes{
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	import fl.controls.UIScrollBar;
	
	public class DIC_ScrollBar extends UIScrollBar{
		private var CoC_Styles:Object = {
			thumbUpSkin: "CoC_ScrollThumb_upSkin",
    		thumbOverSkin: "CoC_ScrollThumb_overSkin", 
    		thumbDownSkin: "CoC_ScrollThumb_downSkin",
    		trackUpSkin: "CoC_ScrollTrack_skin",
			trackDownSkin: "CoC_ScrollTrack_skin",
			trackOverSkin: "CoC_ScrollTrack_skin",
    		upArrowUpSkin: "CoC_ScrollArrowUp_upSkin",
			upArrowDownSkin: "CoC_ScrollArrowUp_downSkin",
			upArrowOverSkin: "CoC_ScrollArrowUp_overSkin",
    		downArrowUpSkin: "CoC_ScrollArrowDown_upSkin",
			downArrowOverSkin: "CoC_ScrollArrowDown_downSkin",
    		downArrowDownSkin: "CoC_ScrollArrowDown_overSkin",
			thumbIcon: null,
			trackDisabledSkin: null,
			upArrowDisabledSkin: null,
			downArrowDisabledSkin: null
    	}
		private var TiTS_Styles:Object = {
    		thumbUpSkin: "TiTS_ScrollThumb",
    		thumbOverSkin: "TiTS_ScrollThumb", 
    		thumbDownSkin: "TiTS_ScrollThumb",
    		trackUpSkin: "TiTS_ScrollTrack_skin",
			trackDownSkin: "TiTS_ScrollTrack_skin",
			trackOverSkin: "TiTS_ScrollTrack_skin",
    		trackDisabledSkin: null,
			thumbIcon: null,
			upArrowUpSkin: null,
			upArrowDownSkin: null,
			upArrowOverSkin: null,
    		upArrowDisabledSkin: null,
			downArrowUpSkin: null,
			downArrowDownSkin: null,
			downArrowOverSkin: null,
    		downArrowDisabledSkin: null
			
    	}
		public function DIC_ScrollBar(isTiTS:Boolean = false){
			switchMode(isTiTS);
		}
		public function switchMode(isTiTS:Boolean){
			var styl;
			if (isTiTS){
				styl = TiTS_Styles
				this.height += 28;
				this.y -= 14;
			}else{
				styl = CoC_Styles;
				this.height -= 28;
				this.y += 14;
			}
			var nam:String;
			for (var key:String in styl){
				nam = styl[key];
				if (!nam) nam = "Inexistant";
				this.setStyle(key, nam);
			}
		}
	}
}
