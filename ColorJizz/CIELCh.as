package ColorJizz
{
	import ColorJizz.CIELab;
	import ColorJizz.CIELCh;
	import ColorJizz.CMY;
	import ColorJizz.CMYK;
	import ColorJizz.Hex;
	import ColorJizz.HSV;
	import ColorJizz.RGB;
	import ColorJizz.XYZ;
	import ColorJizz.Yxy;
	/**
	 * ...
	 * @author Mikee
	 */
	public class CIELCh extends AbstractColor
	{
		public var l:Number;
		public var c:Number;
		public var h:Number;
		public function CIELCh(l:Number, c:Number, h:Number )
		{
			this.toSelf = "toCIELCh";
			this.l = l;
			this.c = c;
			this.h = h<360?h:(h-360);
		}
		override public function toHex():Hex
		{
			return this.toCIELab().toHex();
		}
		override public function toRGB():RGB
		{
			return this.toCIELab().toRGB();
		}
		override public function toXYZ():XYZ
		{
			return this.toCIELab().toXYZ();
		}
		override public function toYxy():Yxy
		{
			return this.toXYZ().toYxy();
		}
		override public function toHSV():HSV
		{
			return this.toCIELab().toHSV();
		}
		override public function toCMY():CMY
		{
			return this.toCIELab().toCMY();
		}
		override public function toCMYK():CMYK
		{
			return this.toCIELab().toCMYK();
		}
		override public function toCIELab():CIELab
		{
			var l:Number = this.l;
			var hradi:Number = this.h * (Math.PI/180);
			var a:Number = Math.cos(hradi) * this.c;
			var b:Number = Math.sin(hradi) * this.c;
			return new CIELab(l,a,b);
		}
		override public function toCIELCh():CIELCh
		{
			return this;
		}
		public function toString ():String
		{
			return this.l + ','+this.c +','+this.h;
		}
	}

}

