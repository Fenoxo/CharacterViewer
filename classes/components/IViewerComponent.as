package classes.components 
{
	import com.sibirjak.asdpc.core.IDisplayObject;
	
	/**
	 * The interface contains the declaration of functions
	 * common to every single viewer components.
	 * It is necessary to have a variable able to contain
	 * every viewer components.
	 * @author 
	 */
	public interface IViewerComponent
	{
		function get x():Number;
		function get y():Number;
		function get name():String;
		function set x(value:Number):void;
		function set y(value:Number):void;
		function set name(value:String):void;
		function setMode(isTiTS:Boolean):void;
		function setCompSize(width:Number, height:Number):void;
	}
}