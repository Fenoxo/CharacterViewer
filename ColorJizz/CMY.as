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
	public class CMY extends AbstractColor
	{
		public var c:Number;
		public var m:Number;
		public var y:Number;
		public function CMY(c:Number, m:Number, y:Number)
		{
			this.toSelf = "toCMY";
			this.c = c;
			this.m = m;
			this.y = y;
		}
		override public function toHex():Hex
		{
			return this.toRGB().toHex();
		}
		override public function toRGB():RGB
		{
			var R:int = (int)(( 1 - this.c ) * 255);
			var G:int = (int)(( 1 - this.m ) * 255);
			var B:int = (int)(( 1 - this.y ) * 255);
			return new RGB(R,G,B);
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
			return this.toRGB().toHSV();
		}
		override public function toCMY():CMY
		{
			return this;
		}
		override public function toCMYK():CMYK
		{
			var var_K:Number = 1;
			var C:Number = this.c;
			var M:Number = this.m;
			var Y:Number = this.y;
			if ( C < var_K )   var_K = C;
			if ( M < var_K )   var_K = M;
			if ( Y < var_K )   var_K = Y;
			if ( var_K == 1 ) {
				C = 0;
				M = 0;
				Y = 0;
			}
			else {
				C = ( C - var_K ) / ( 1 - var_K );
				M = ( M - var_K ) / ( 1 - var_K );
				Y = ( Y - var_K ) / ( 1 - var_K );
			}

			var K:Number = var_K;

			return new CMYK(C,M,Y,K);
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
			return this.c+','+this.m+','+this.y;
		}
	}

}

