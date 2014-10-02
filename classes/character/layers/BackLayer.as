package classes.character.layers 
{
	import classes.character.CharacterData;
	import classes.utils.MCUtils
	import classes.ViewerData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * The layer containing the "hairBack" and "tail" parts.
	 * This layer is not shaded.
	 * @author 
	 */
	public class BackLayer extends AbstractLayer
	{
		public static const tailNames:Array = ["tail_0", "tail_1", "tail_2", "tail_3", "tail_4", "tail_5", "tail_6", "tail_7", "tail_8"];
		
		public function BackLayer(viewerData:ViewerData, characterData:CharacterData) 
		{
			super(viewerData, characterData);
		}
		
		override public function drawLayer():void
		{
			addTails();
			addBackHair();
			super.drawLayer();
		}
		
		/**
		 * Add a tail or, if the player is a kitsune, adds the necessary number of tails and rotate them.
		 * Utimately to be replaced with 10 fox tail types for each possible number tails.
		 */
		private function addTails():void
		{
			if (player.tailType == 13 && !isTiTS)
			{
				var len:int = Math.min(player.tailVenom, 9);
				
				for ( var u:int = 0; u < len; u++)
				{
					var foundPart:MovieClip = classDict.findPart("tail", player.tailType);
					
					if (u % 4 == 0) MCUtils.scale(foundPart.MC);
					if (u % 4 == 1) MCUtils.scale(foundPart.MC, 1.0, -1.0);
					if (u % 4 == 2) MCUtils.scale(foundPart.MC, -1.0, 1.0);
					if (u % 4 == 3) MCUtils.scale(foundPart.MC, -1.0);
					
					var rot:Number = ((Math.random() * 10) -5) * len;
					
					foundPart.MC.rotation = rot;
					painter.addPart(tailNames[u], foundPart);
					addChild(foundPart);
				}
			}
			else
			{
				foundPart = classDict.findPart("tail", player.tailType);
				painter.addPart("tail", foundPart);
				addChild(foundPart);
			}
		}
		
		/**
		 * Adds the character back hair piece.
		 */
		private function addBackHair():void
		{
			var n:int = translator.getRealHairIndex(player.hairLength);
			
			var foundPart:MovieClip = classDict.findPart("hair", n, 0, 1);
			addChild(foundPart);
			painter.addPart("hairBack", foundPart);
		}
	}
}