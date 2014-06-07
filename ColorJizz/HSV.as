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
	public class HSV extends AbstractColor
	{
		public var h:Number;
		public var s:Number;
		public var v:Number;
		public function HSV(h:Number, s:Number, v:Number)
		{
			this.toSelf = "toHSV";
			this.h = h;
			this.s = s;
			this.v = v;
		}
		override public function toHex():Hex
		{
			return this.toRGB().toHex();
		}
		override public function toRGB():RGB
		{
			var h:Number = this.h / 360;
			var s:Number = this.s / 100;
			var v:Number = this.v / 100;
			var r:Number;
			var g:Number;
			var b:Number;
			var var_h:Number, var_i:Number, var_1:Number, var_2:Number, var_3:Number, var_r:Number, var_g:Number, var_b:Number;
			if (s == 0) {
				r = v * 255;
				g = v * 255;
				b = v * 255;
			} else {
				var_h = h * 6;
				var_i = Math.floor(var_h);
				var_1 = v * (1 - s);
				var_2 = v * (1 - s * (var_h - var_i));
				var_3 = v * (1 - s * (1 - (var_h - var_i)));

				if (var_i == 0) {var_r = v; var_g = var_3; var_b = var_1}
				else if (var_i == 1) {var_r = var_2; var_g = v; var_b = var_1}
				else if (var_i == 2) {var_r = var_1; var_g = v; var_b = var_3}
				else if (var_i == 3) {var_r = var_1; var_g = var_2; var_b = v}
				else if (var_i == 4) {var_r = var_3; var_g = var_1; var_b = v}
				else {var_r = v; var_g = var_1; var_b = var_2};

				r = var_r * 255;
				g = var_g * 255;
				b = var_b * 255;
			}
			return new RGB(Math.round(r), Math.round(g), Math.round(b));
		}
		override public function toXYZ():XYZ
		{
			return this.toRGB().toXYZ();
		}
		override public function toYxy():Yxy
		{
			return this.toXYZ().toYxy();
		}
		override public function toHSV():HSV
		{
			return this;
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
			return this.toRGB().toCIELab();
		}
		override public function toCIELCh():CIELCh
		{
			return this.toCIELab().toCIELCh();
		}
		public function toString():String
		{
			return this.h+','+this.s+','+this.v;
		}
	}

}

