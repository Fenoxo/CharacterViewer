package classes{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import classes.DIC_Data;
	import flash.display.Stage;

	public class DIC_Arrow extends MovieClip{
		public var action:Function;
		public var fram:int;
		public var lockFram:int;
		public function DIC_Arrow(_name:String, _x:int, _y:int, dir:int, _action:Function){
			var isTiTS:Boolean = DIC_Data.isTiTS;
			var cock:Class = DIC_Data;
			this.x = _x;
			this.y = _y;
			this.name = _name;
			this.action = _action;
			this.buttonMode = true;
			this.mouseChildren = false;
			this.cacheAsBitmap = true;
			if(isTiTS){
				this.fram = 14;
				this.lockFram = 17;
				this.gotoAndStop(fram);
				this.rotation = dir*90;
			}else{
				this.fram = dir*3+1; 
				this.lockFram = 13;
				this.gotoAndStop(fram);
			}
			
		}
		public function lock(locked:Boolean = true):void{
			if (!locked){
				this.gotoAndStop(lockFram);
				this.enabled = false;
			}else{
				this.gotoAndStop(fram);
				this.enabled = true;			
			}
		}
	}
}