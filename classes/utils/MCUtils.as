package classes.utils 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class MCUtils 
	{
		/**
		 * Removes a child from its parent, and add another at the same index.
		 * @param	prevChild
		 * @param	nextChild
		 */
		public static function replaceChildren(prevChild:MovieClip, nextChild:MovieClip):void
		{
			var parent:DisplayObjectContainer = prevChild.parent;
			
			if (parent == null)
				throw new Error("PrevChild does not have a parent");
			
			parent.addChild(nextChild);
			parent.swapChildren(prevChild, nextChild);
			parent.removeChild(prevChild);
		}
		
		/**
		 * Transfer the scale, rotation and position from one MovieClip to another.
		 * @param	prevObject
		 * @param	nextObject
		 */
		public static function transferMatrix(prevObject:MovieClip, nextObject:MovieClip):void
		{
			nextObject.x = prevObject.x;
			nextObject.y = prevObject.y;
			nextObject.scaleX = prevObject.scaleX;
			nextObject.scaleY = prevObject.scaleY;
			nextObject.rotation = prevObject.rotation;
		}
		
		/**
		 * Transfers the mask of one object to another, then sets the mask of the first object to null.
		 * @param	prevObject
		 * @param	nextObject
		 */
		public static function transferMask(prevObject:MovieClip, nextObject:MovieClip):void
		{
			nextObject.mask = prevObject.mask;
			prevObject.mask = null;
		}
		
		/**
		 * Get the index (depth) of any child that has a parent.
		 * @param	The object to get the index of.
		 * @return	The index of the target.
		 */
		public static function getDepth(target:DisplayObject):int
		{
			if (!target.parent)
				throw new Error("Target does not have a parent, cannot get index.");
			return (target.parent.getChildIndex(target));
		}
		
		/**
		 * Removes the target from its parent.
		 * @throws	Error If target doesn't have a parent.
		 * @param	The target to remove.
		 */
		public static function remove(target:DisplayObject):void
		{
			if (!target.parent)
				throw new Error("Target doesn't have a parent.");
			
			target.parent.removeChild(target);
		}

		/**
		 * Sets the scaling of target to scaling
		 * @param	The DisplayObject to set.
		 * @param	The new scaling factor.
		 */
		public static function scale(target:DisplayObject, scalingX:Number = 1.0, scalingY:Number = NaN):void
		{
			if (isNaN(scalingX)) scalingX = 1.0;
			if (isNaN(scalingY)) scalingY = scalingX;
			
			target.scaleX = scalingX;
			target.scaleY = scalingY;
		}
		
		/**
		 * Sets the scaleX and scaleY properties of an object, then moves the object so that the given point remains in place.
		 * @param	The object to move and scale.
		 * @param	The value of the scaling.
		 * @param	The scaling reference point.
		 */
		public static function scaleTargetFrom(target:DisplayObject, scaling:Number, origin:Point)
		{
			var destination:Point = target.localToGlobal(origin);
	
			target.scaleX = scaling;
			target.scaleY = scaling;
			
			destination = target.globalToLocal(destination);
			
			target.x += (destination.x - origin.x) * scaling;
			target.y += (destination.y - origin.y) * scaling;
		}

		/**
		 * Sort the target's children, like the array sortOn method.
		 * @param	The parent of the children to sort.
		 * @param	The propertie on which to sort them.
		 * @param	Options, such as descending or ascending order.
		 */
		public static function sortChildrenOn(parent:Sprite, propertie:String, options:int = 0)
		{
			var children:Array = [];
			var length:int = parent.numChildren;
			children.length = length;
			
			for (var i:int = length; i > 0;)
			{
				children[--i] = parent.getChildAt(i);
			}
			
			children.sortOn(propertie, options);
			
			for (i = 0; i < length; i++)
			{
				parent.addChild(children[i]);
			}
		}
	}
}