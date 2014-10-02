package classes.utils 
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author 
	 */
	public class BitmapUtils 
	{
		/**
		 * Analyse a background BitmapData instance, and mathematically deduce the lighting ColorTransform.
		 * @param	The background BitmapData.
		 * @param	The ID, to decide special behaviour.
		 * @return
		 */
		public static function getBitmapAverageDeviation(bitmap:BitmapData, backgroundID:int):ColorTransform
		{
			if (backgroundID == 0) return (new ColorTransform());
			
			var R:Number = 0;
			var G:Number = 0;
			var B:Number = 0;
			
			for (var i:int = 0; i < 100; i++)
			{
				var x:int = 200.5 + 12.240 * i;
				var y:int = 0.5 + 98.0 * (i % 10 + 0.5);
				
				var color:uint = bitmap.getPixel(x, y);
				
				R += color >> 16;
				G += (color & 0x00FF00) >> 8;
				B += (color & 0x0000FF);
			}
			
			
			R = (R / 100 / 126) / 2 + 0.5;
			G = (G / 100 / 126) / 2 + 0.5;
			B = (B / 100 / 126) / 2 + 0.5;
			
			return (new ColorTransform(R, G, B));
		}
	}

}