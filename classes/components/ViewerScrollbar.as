package classes.components 
{
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.scrollbar.ScrollBar;
	import fl.controls.UIScrollBar;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class ViewerScrollbar extends UIScrollBar
	{
		private var _mode:int = -1;
		
		public function ViewerScrollbar(owner:DisplayObject) 
		{
			super();
			this.scrollTarget = owner;
		}
		
		public function setMode(isTiTS:Boolean):void
		{
			if (isTiTS && _mode == 0)
			{
				this.setStyleArray(ViewerScrollbarStyles.TiTS_scrollbarStyle);
				this.height += 32;
				this.y -= 15;
				this.x += 2;
				_mode = 1;
			}
			else if (!isTiTS && _mode != 0)
			{
				this.setStyleArray(ViewerScrollbarStyles.CoC_scrollbarStyle);
				this.height -= 32;
				this.y += 15;
				this.x -= 2;
				_mode = 0;
			}
		}
		
		public function setCompSize(width:Number, height:Number):void
		{
			this.setSize(width, height);
		}
		
		public function setStyleArray(styles:Array)
		{
			for (var i:int = 0; i < styles.length; i += 2)
			{
				this.setStyle(styles[i], styles[i + 1]);
			}
		}
	}
}