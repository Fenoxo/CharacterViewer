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
	public class CIELab extends AbstractColor
	{
		public var l:Number;
		public var a:Number;
		public var b:Number;
		public function CIELab(l:Number, a:Number, b:Number)
		{
			this.toSelf = "toCIELab";
			this.l = l;// this.roundDec(l, 3);
			this.a = a;//this.roundDec(a, 3);
			this.b = b;//this.roundDec(b, 3);
		}
		override public function toHex():Hex
		{
			return this.toRGB().toHex();
		}
		override public function toRGB():RGB
		{
			return this.toXYZ().toRGB();
		}
		override public function toXYZ():XYZ
		{
			var ref_X:Number =  95.047;
			var ref_Y:Number = 100.000;
			var ref_Z:Number = 108.883;

			var var_Y:Number = (this.l + 16 ) / 116;
			var var_X:Number = this.a / 500 + var_Y;
			var var_Z:Number = var_Y - this.b / 200;

			if (Math.pow(var_Y,3) > 0.008856){
				var_Y = Math.pow(var_Y,3);
			}else {
				var_Y = (var_Y - 16 / 116) / 7.787;
			}
			if(Math.pow(var_X,3) > 0.008856){
				var_X = Math.pow(var_X,3);
			}else {
				var_X = (var_X - 16 / 116) / 7.787;
			}
			if (Math.pow(var_Z,3) > 0.008856){
				var_Z = Math.pow(var_Z,3);
			}else {
				var_Z = (var_Z - 16 / 116) / 7.787;
			}
			var x:Number = ref_X * var_X;
			var y:Number = ref_Y * var_Y;
			var z:Number = ref_Z * var_Z;
			return new XYZ(x,y,z);
		}
		override public function toYxy():Yxy
		{
			return this.toXYZ().toYxy();
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
			return this;
		}
		override public function toCIELCh():CIELCh
		{
			var var_H:Number = Math.atan2( this.b, this.a );

			if ( var_H > 0 ) {
				var_H = ( var_H / Math.PI ) * 180;
			}else{
				var_H = 360 - ( Math.abs( var_H ) / Math.PI ) * 180
			}

			var l:Number = this.l;
			var c:Number = Math.sqrt(Math.pow(this.a,2) + Math.pow(this.b,2));
			var h:Number = var_H;

			return new CIELCh(l,c,h);
		}
		public function toString ():String
		{
			return this.l+','+this.a+','+this.b;
		}
	}

}
