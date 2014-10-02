package classes.components
{
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.textfield.Label;
	import flash.display.Shape;
	
	public class ViewerButton extends Button implements IViewerComponent
	{
		public var args:Array;
		public var action:Function;
		
		protected var _mode:int = -1;
		
		public function ViewerButton(label:String = "", action:Function = null, ... args)
		{
			super();
			this.args = args;
			this.label = label;
			this.action = action;
			this.useHandCursor = true;
			
			//Edited the Button class to update label styles on function update().
			//Edited the Button class so that autoRepeat dispatches CLICK instead of MOUSE_DOWN
			this.autoRepeat = true;
			this.setStyle(Label.style.fittingMode, Label.FITTING_MODE_CHOP_LAST)
			
			this.setMode(false);
			this.setSize(140, 36);
			
			while (args.length && args[args.length - 1] == null)
			{
				args.pop();
			}
			if (args.length > 9)
				throw new Error("Too many arguments.");
		}
		
		override protected function onClick():void
		{
			if (action == null) return;
			
			switch (args.length)
			{
				case 0: action(); break;
				case 1: action(args[0]); break;
				case 2: action(args[0], args[1]); break;
				case 3: action(args[0], args[1], args[2]); break;
				case 4: action(args[0], args[1], args[2], args[3]); break;
				case 5: action(args[0], args[1], args[2], args[3], args[4]); break;
				case 6: action(args[0], args[1], args[2], args[3], args[4], args[5]); break;
				case 7: action(args[0], args[1], args[2], args[3], args[4], args[5], args[6]); break;
				case 8: action(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]); break;
				case 9: action(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]); break;
				default: throw new Error("Too many arguments.");
			}
		}
		
		public function setCompSize(width:Number, height:Number):void
		{
			this.setSize(Math.round(width), Math.round(height));
		}
		
		public function setMode(isTiTS:Boolean):void
		{
			if (isTiTS)
			{
				this.setStyles(ViewerButtonStyles.TiTS_buttonStyle);
				this.setStyle(Button.style.labelStyles, ViewerLabelStyles.TiTS_labelStyle);
				this.setStyle(Button.style.overLabelStyles, ViewerLabelStyles.TiTS_labelStyle);
				this.setStyle(Button.style.selectedLabelStyles, ViewerLabelStyles.TiTS_labelStyle);
				this.setStyle(Button.style.disabledLabelStyles, ViewerLabelStyles.TiTS_labelStyle);
				this._mode = 1;
			}
			else
			{
				this.setStyles(ViewerButtonStyles.CoC_buttonStyle);
				this.setStyle(Button.style.labelStyles, ViewerLabelStyles.CoC_labelStyle);
				this.setStyle(Button.style.overLabelStyles, ViewerLabelStyles.CoC_labelStyle);
				this.setStyle(Button.style.selectedLabelStyles, ViewerLabelStyles.CoC_labelStyle);
				this.setStyle(Button.style.disabledLabelStyles, ViewerLabelStyles.CoC_labelStyle);
				this._mode = 0;
			}
			this.update();
		}
		
		public function get isTiTS():Boolean
		{
			switch (this._mode)
			{
				case 1: return (true);
				case 0: return (false);
				default: throw new Error("Button mode not set yet. Use the setMode method");
			}
		}
	}
}