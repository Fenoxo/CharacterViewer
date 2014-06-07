package classes{
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	import fl.controls.UIScrollBar;
	import classes.DIC_Data;
	
	public class DIC_ScrollBar extends UIScrollBar{
		private var CoC_Styles:Object = {
			focusRectSkin: null,
			thumbIcon: null,
			thumbUpSkin: "CoC_ScrollThumb",
    		thumbOverSkin: "CoC_ScrollThumb",
    		thumbDownSkin: "CoC_ScrollThumb",
			thumbDisabledSkin: null,
			
    		trackDisabledSkin: null,
			trackUpSkin: "CoC_ScrollTrack",
			trackDownSkin: "CoC_ScrollTrack",
			trackOverSkin: "CoC_ScrollTrack",
			
    		upArrowUpSkin: "CoC_ScrollArrowUp",
			upArrowDownSkin: "CoC_ScrollArrowUp",
			upArrowOverSkin: "CoC_ScrollArrowUp",
    		upArrowDisabledSkin: null,
			
			downArrowUpSkin: "CoC_ScrollArrowDown",
			downArrowOverSkin: "CoC_ScrollArrowDown",
    		downArrowDownSkin: "CoC_ScrollArrowDown",
			downArrowDisabledSkin: null
    	}
		private var TiTS_Styles:Object = {
			focusRectSkin: null,
			thumbIcon: null,
			thumbUpSkin: "TiTS_ScrollThumb_upSkin",
    		thumbOverSkin: "TiTS_ScrollThumb_downSkin", 
    		thumbDownSkin: "TiTS_ScrollThumb_downSkin",
			thumbDisabledSkin: null,
			
    		trackUpSkin: "TiTS_ScrollTrack",
			trackDownSkin: "TiTS_ScrollTrack",
			trackOverSkin: "TiTS_ScrollTrack",
    		trackDisabledSkin: null,
			
			upArrowUpSkin: null,
			upArrowDownSkin: null,
			upArrowOverSkin: null,
    		upArrowDisabledSkin: null,
			
			downArrowUpSkin: null,
			downArrowDownSkin: null,
			downArrowOverSkin: null,
    		downArrowDisabledSkin: null
			
    	}
		public function DIC_ScrollBar(){
			switchMode(DIC_Data.isTiTS);
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
