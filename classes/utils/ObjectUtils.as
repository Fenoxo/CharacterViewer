package classes.utils 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class ObjectUtils 
	{
		/**
		 * Clone the properties of every objects in sources to target.
		 * @param	The object to clear and set.
		 * @param	obj
		 */
		public static function setObject(target:Object, ...sources):void
		{
			var len:int = sources.length;
			
			for (var i:int = 0; i < len; i++)
			{
				var source:Object = sources[i];
				
				for (var key:String in source)
				{
					target[key] = source[key];
				}
			}
		}

		/**
		 * Return a copy of any given object.
		 * Every properties is cloned as well, but is casted as an Object.
		 * @param	Source object.
		 * @return	Cloned object.
		 */
		public static function cloneObject(target:Object):Object
		{
			var byte:ByteArray = new ByteArray();
			var clone:Object = new Object();
			
			byte.writeObject(target);
			byte.position = 0;
			clone = byte.readObject();
			return (clone);
		}
	}
}