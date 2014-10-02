package classes.components 
{
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author 
	 */
	public class ViewerSliderBar extends Shape 
	{
		
		public function ViewerSliderBar(color:uint, width:Number, padding:Number) 
		{
			with (this.graphics)
			{
				beginFill(color, 1);
				drawRect(0, 0, width - 2 * padding, 8);
				endFill();
			}
			
			this.x = padding;
			this.y = 2;
		}
	}
}