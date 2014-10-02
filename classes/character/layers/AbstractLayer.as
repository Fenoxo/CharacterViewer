package classes.character.layers 
{
	import classes.character.*;
	import classes.save.*;
	import classes.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * Abstract layer class.
	 * Contains the constructor logic and the shared variables of BackLayer, BodyLayer and FrontLayer.
	 * Contains the function declaration for drawLayer.
	 * Contains utilitaries, like the lim and addPart function.
	 * @author 
	 */
	public class AbstractLayer extends Sprite 
	{
		protected var translator:SaveTranslator//Used to translate save data into dictionary indexes.
		protected var classDict:ClassDictionary//Used to get class from dictionary indexes.
		protected var pool:PartPool//Used to retrieve class instances
		
		protected var prop:CharacterProperties;//Used to share basic data between layers and the character instance.
		protected var painter:PartPainter;//Used to save and color added parts
		protected var player:Creature;//Used to carry player data for drawing
		
		protected var isTiTS:Boolean;
		
		/**
		 * Initialize the variables needed for the adding process.
		 * @param	The ViewerData object containing dictionaries, the pool and the translator.
		 * @param	The CharacterData object containing properties, and the PartPainter and Creature instances.
		 */
		public function AbstractLayer(viewerData:ViewerData, characterData:CharacterData) 
		{
			this.translator = viewerData.translator;
			this.classDict = viewerData.classDict;
			this.pool = viewerData.partPool;
			
			this.painter = characterData.painter;
			this.player = characterData.player;
			this.prop = characterData.prop;
			
			this.isTiTS = viewerData.isTiTS;
		}
		
		/**
		 * Runs every adding functions of the layer.
		 */
		public function drawLayer():void
		{
			this.player = null;
		}
		
		
		/**
		 * Adds and color any part given the basic indexes.
		 * @param	The type of the part
		 * @param	The first index.
		 * @param	The second index.
		 * @param	The third index.
		 */
		protected function addPart(partType:String, j:int = 0, k:int = 0, l:int = 0):void
		{
			var foundPart:MovieClip = classDict.findPart(partType, j, k, l);
			painter.addPart(partType, foundPart);
			
			addChild(foundPart);
		}
		
		/**
		* Returns the closest number to input that is inside the [min; max] interval.
		* Returns min if min > max.
		* @param	The value to limit.
		* @param	The lower limit.
		* @param	THe lower limit.
		* @return
		*/
		protected function lim(value:Number, min:Number, max:Number):Number
		{
			value = Math.max(value,min);
			value = Math.min(value,max);
			return (value);
		}
	}
}