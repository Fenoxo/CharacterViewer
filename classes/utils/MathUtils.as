package classes.utils 
{
	/**
	 * ...
	 * @author 
	 */
	public class MathUtils 
	{
		/**
		 * Returns a random value x, with 0 <= x and x < 1.
		 * The value is more likely to be close to 0.5 than to 0 or 1.
		 */
		public static function randomCentered():Number
		{
			return (Math.pow((Math.random() - ​0.5) * ​2, ​3) / ​2 + ​0.5);
		}
	}
}