package classes.utils 
{
	/**
	 * ...
	 * @author 
	 */
	public class ArrayUtils 
	{
		/**
		 * Randomize an array's elements.
		 * @param	The array to randomize.
		 * @return	The input array, randomized.
		 */
		public static function randomize(array:Array):void
		{
			var temp:Object;
			var tempOffset:int;
			var len = array.length - 1;
			for (var i:int = len; i >= 0; i--)
			{
				tempOffset = Math.random() * i;
				temp = array[i];
				array[i] = array[tempOffset];
				array[tempOffset] = temp;
			}
		}
	}
}