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
	public class XYZ extends AbstractColor
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public function XYZ(x:Number, y:Number, z:Number)
		{
			this.toSelf = "toXYZ";
			this.x = this.roundDec(x, 3);
			this.y = this.roundDec(y, 3);
			this.z = this.roundDec(z, 3);
		}
		override public function toHex():Hex
		{
			return this.toRGB().toHex();
		}
		override public function toRGB():RGB
		{
			var var_X:Number = this.x / 100;
			var var_Y:Number = this.y / 100;
			var var_Z:Number = this.z / 100;

			var var_R:Number = var_X *  3.2406 + var_Y * -1.5372 + var_Z * -0.4986;
			var var_G:Number = var_X * -0.9689 + var_Y *  1.8758 + var_Z *  0.0415;
			var var_B:Number = var_X *  0.0557 + var_Y * -0.2040 + var_Z *  1.0570;

			if (var_R > 0.0031308) {
				var_R = 1.055 * Math.pow(var_R,(1/2.4)) - 0.055;
			}else {
				var_R = 12.92 * var_R;
			}
			if (var_G > 0.0031308){
				var_G = 1.055 * Math.pow(var_G,(1/2.4)) - 0.055;
			}else {
				var_G = 12.92 * var_G;
			}
			if (var_B > 0.0031308){
				var_B = 1.055 * Math.pow(var_B,(1/2.4)) - 0.055;
			}else {
				var_B = 12.92 * var_B;
			}
			var r:Number = Math.round(var_R * 255);
			var g:Number = Math.round(var_G * 255);
			var b:Number = Math.round(var_B * 255);

			return new RGB(r,g,b);
		}
		override public function toXYZ():XYZ
		{
			return this;
		}
		override public function toYxy():Yxy
		{
			var Y:Number = this.y;
			var x:Number = this.x / ( this.x + this.y + this.z );
			var y:Number = this.y / ( this.x + Y + this.z );
			return new Yxy(Y, x, y);
		}
		override public function toHSV():HSV
		{
			return this.toRGB().toHSV();
		}
		override public function toCMY():CMY
		{
			return this.toRGB().toCMY();
		}
		override public function toCMYK():CMYK
		{
			return this.toCMY().toCMYK();
		}
		override public function toCIELab():CIELab
		{
			var Xn:Number =  95.047;
			var Yn:Number = 100.000;
			var Zn:Number = 108.883;

			var x:Number = this.x / Xn;
			var y:Number = this.y / Yn;
			var z:Number = this.z / Zn;

			if (x > 0.008856){
				x = Math.pow(x, 1/3);
			}else {
				x = (7.787 * x) + (16 / 116);
			}
			if (y > 0.008856){
				y = Math.pow(y, 1 / 3);
			}else {
				y = (7.787 * y) + (16 / 116);
			}
			if (z > 0.008856){
				z = Math.pow(z, 1 / 3);
			}else {
				z = (7.787 * z) + (16 / 116);
			}
			var l:Number;
			if (y>0.008856){
				l = (116 * y) - 16;
			}else {
				l = 903.3*y;
			}
			var a:Number = 500 * (x - y);
			var b:Number = 200 * (y - z);

			return new CIELab(l, a, b);
		}
		override public function toCIELCh():CIELCh
		{
			return this.toCIELab().toCIELCh();
		}
		public function toString():String
		{
			return this.x+','+this.y+','+this.z;
		}
	}

}

