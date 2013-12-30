package classes{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import fl.controls.TextArea;
	import flash.text.TextField;

	public class DIC_Button extends MovieClip{
		public var action:Function;
		public var addit1;
		public var addit2;
		public function DIC_Button(_name:String, _x:int, _y:int, _text:String, _action:Function, isTiTS = false, _enabled:Boolean=true, _addit1:*=undefined, _addit2:*=undefined, _width = 140){
			this.x = _x;
			this.y = _y;
			this.gotoAndStop(int(isTiTS)+1);
			this.MC.width = _width;
			this.name = _name;
			this.action = _action;
			this.addit1 = _addit1;
			this.addit2 = _addit2;
			this.text.text = _text;
			if (!_enabled) this.MC.gotoAndStop(3);
			
			this.buttonMode = true;
			this.mouseChildren = false;
			this.enabled = _enabled;
		}
		public function lock():void{
			this.enabled = false;
			this.MC.gotoAndStop(3);
		}
		public function unLock():void{
			this.enabled = true;
			this.MC.gotoAndStop(1);
		}
	}
}