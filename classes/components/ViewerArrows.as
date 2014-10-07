package classes.components 
{
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author 
	 */
	public class ViewerArrows extends Sprite implements IViewerComponent
	{
		private var main:Button;
		private var left:Button;
		private var right:Button;
		
		public var args:Array
		public var action:Function;
		
		public function ViewerArrows(label:String, action:Function, args:Array = null, disableCenter:Boolean = true, disableArrows:Boolean = true) 
		{
			initGraphics();
			
			centerDisabled = disableCenter;
			arrowDisabled = disableArrows;
			
			
			this.args = args;
			this.label = label;
			this.action = action;
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
		}
		
		public function setCompSize(width:Number, height:Number):void
		{
			if (left.visible)
			{
				if (width < height * 2)
					throw new Error("Cannot set a width smaller than twice the height");
				
				this.main.setSize(width - height * 2, height);
				this.left.setSize(height, height);
				this.right.setSize(height, height);
				
				this.left.x = 0;
				this.main.x = height;
				this.right.x = width - height;
			}
			else
			{
				this.main.setSize(width, height);
				this.main.x = 0;
			}
		}
		
		public function setMode(isTiTS:Boolean):void
		{
			if (isTiTS)
			{
				left.setStyles(ViewerArrowsStyles.TiTS_arrowLeftStyle);
				right.setStyles(ViewerArrowsStyles.TiTS_arrowRightStyle);
				main.setStyles(ViewerButtonStyles.TiTS_buttonStyle);
				main.setStyle(Button.style.labelStyles, ViewerLabelStyles.TiTS_labelStyle);
				main.setStyle(Button.style.overLabelStyles, ViewerLabelStyles.TiTS_labelStyle);
				main.setStyle(Button.style.selectedLabelStyles, ViewerLabelStyles.TiTS_labelStyle);
				main.setStyle(Button.style.disabledLabelStyles, ViewerLabelStyles.TiTS_labelStyle);
			}
			else
			{
				left.setStyles(ViewerArrowsStyles.CoC_arrowLeftStyle);
				right.setStyles(ViewerArrowsStyles.CoC_arrowRightStyle);
				main.setStyles(ViewerButtonStyles.CoC_buttonStyle);
				main.setStyle(Button.style.labelStyles, ViewerLabelStyles.CoC_labelStyle);
				main.setStyle(Button.style.overLabelStyles, ViewerLabelStyles.CoC_labelStyle);
				main.setStyle(Button.style.selectedLabelStyles, ViewerLabelStyles.CoC_labelStyle);
				main.setStyle(Button.style.disabledLabelStyles, ViewerLabelStyles.CoC_labelStyle);
			}
		}
		
		public function set label(value:String):void
		{
			this.main.label = value;
		}
		
		public function set centerDisabled(value:Boolean):void
		{
			this.main.enabled = !value;
			
			if (value)
			{
				this.main.removeEventListener(ButtonEvent.CLICK, onClick);
			}
			else
			{
				this.main.addEventListener(ButtonEvent.CLICK, onClick, false, 0, true);
			}
		}
		
		public function get centerDisabled():Boolean
		{
			return (!this.main.enabled);
		}
		
		public function set arrowDisabled(value:Boolean):void
		{
			this.left.visible = !value;
			this.right.visible = !value;
			
			if (value)
			{
				this.left.removeEventListener(ButtonEvent.CLICK, onClick);
				this.right.removeEventListener(ButtonEvent.CLICK, onClick);
			}
			else
			{
				this.left.addEventListener(ButtonEvent.CLICK, onClick, false, 0, true);
				this.right.addEventListener(ButtonEvent.CLICK, onClick, false, 0, true);
			}
		}
		
		public function get arrowDisabled():Boolean
		{
			return (!this.left.visible);
		}
		
		private function initGraphics():void
		{
			this.main = new Button();
			this.main.autoRepeat = true;
			this.main.useHandCursor = true;
			this.addChild(main);
			
			this.left = new Button();
			this.left.autoRepeat = true;
			this.left.useHandCursor = true;
			this.addChild(left);
			
			this.right = new Button();
			this.right.autoRepeat = true;
			this.right.useHandCursor = true;
			this.addChild(right);
			
			this.setCompSize(172, 36);
		}
		
		private function onClick(event:ButtonEvent):void
		{
			if (event.currentTarget == left)	this.action(this.args, 1, -1);
			if (event.currentTarget == main)	this.action(this.args, 0, +1);
			if (event.currentTarget == right)	this.action(this.args, 1, +1);
		}
		
		private function onRemoved(event:Event):void
		{
			this.main.removeEventListener(ButtonEvent.CLICK, onClick);
			this.left.removeEventListener(ButtonEvent.CLICK, onClick);
			this.right.removeEventListener(ButtonEvent.CLICK, onClick);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
	}
}