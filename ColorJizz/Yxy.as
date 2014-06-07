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
	public class Yxy extends AbstractColor
	{
		public var Y:Number;
		public var x:Number;
		public var y:Number;
		public function Yxy(Y:Number, x:Number, y:Number)
		{
			this.toSelf = "toYxy";
			this.Y = this.roundDec(Y, 3);
			this.x = this.roundDec(x, 3);
			this.y = this.roundDec(y, 3);
		}
		override public function toHex():Hex
		{
			return this.toXYZ().toHex();
		}
		override public function toRGB():RGB
		{
			return this.toXYZ().toRGB();
		}
		override public function toXYZ():XYZ
		{
			var X:Number = this.x * ( this.Y / this.y );
			var Y:Number = this.Y;
			var Z:Number = ( 1 - this.x - this.y ) * ( this.Y / this.y );
			return new XYZ(X, Y, Z);
		}
		override public function toYxy():Yxy
		{
			return this;
		}
		override public function toHSV():HSV
		{
			return this.toXYZ().toHSV();
		}
		override public function toCMY():CMY
		{
			return this.toXYZ().toCMY();
		}
		override public function toCMYK():CMYK
		{
			return this.toXYZ().toCMYK();
		}
		override public function toCIELab():CIELab
		{
			return this.toXYZ().toCIELab();
		}
		override public function toCIELCh():CIELCh
		{
			return this.toXYZ().toCIELCh();
		}
		public function toString():String
		{
			return this.Y+','+this.x+','+this.y;
		}
	}

}

