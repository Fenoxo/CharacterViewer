package classes.components 
{
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author 
	 */
	public class ViewerNotes extends Sprite 
	{
		private var notes:TextField;
		private var scrollBar:ViewerScrollbar;
		
		public function ViewerNotes() 
		{
			notes = new TextField();
			notes.wordWrap = true;
			notes.antiAliasType = AntiAliasType.ADVANCED;
			notes.sharpness = 100;
			notes.thickness = 100;
			this.addChild(notes);
			
			scrollBar = new ViewerScrollbar(notes);
			this.addChild(scrollBar);
			this.setCompSize(210, 310);
		}
		
		public function toNote(note:String = "", isToAdd:Boolean = false):void
		{
			if (!notes)
			{
				throw new Error("Note cannot be null. Check the menu note declaration.");
			}
			if (isToAdd && notes.text != "")
			{
				scrollBar.scrollPosition = scrollBar.maxScrollPosition;
				notes.text.concat("\r\r", note);
			}
			else
			{
				scrollBar.scrollPosition = scrollBar.minScrollPosition;
				notes.text = note;
			}
			scrollBar.update();
		}
		
		public function setMode(isTiTS:Boolean):void
		{
			notes.defaultTextFormat = (isTiTS) ? ViewerTextFormat.TiTSNotesFormat : ViewerTextFormat.CoCNotesFormat;
			
			scrollBar.setMode(isTiTS);
		}
		
		public function setCompSize(_width:Number, _height:Number):void
		{
			notes.width = _width;
			notes.height = _height;
			
			scrollBar.width = 13;
			scrollBar.height = _height + 20;
			scrollBar.x = _width;
			scrollBar.y = -13;
		}
	}
}