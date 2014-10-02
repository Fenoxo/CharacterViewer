package classes.character.layers 
{
	import classes.character.CharacterData;
	import classes.ViewerData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * The uppermost layer. Contains hairFront and ears, will contain eyes and horns when added.
	 * THis layer is not shaded.
	 * @author 
	 */
	public class FrontLayer extends AbstractLayer
	{
		
		public function FrontLayer(viewerData:ViewerData, characterData:CharacterData) 
		{
			super(viewerData, characterData);
		}
		
		override public function drawLayer():void
		{
			//addPart("eyes", player.eyeType);
			addFrontHair();
			//addHorns();
			addEars();
			super.drawLayer();
		}
		
		private function addFrontHair():void
		{
			var n:int = translator.getRealHairIndex(player.hairLength);
			
			var foundPart:MovieClip = classDict.findPart("hair", n, 0, 0);
			painter.addPart("hairFront", foundPart);
			addChild(foundPart);
		}

		private function addEars():void
		{
			var u:int = int(player.hairLength > 10);
			var foundPart:MovieClip = classDict.findPart("ears", player.earType, 0, u);
			painter.addPart("ears", foundPart);
			addChild(foundPart);
		}
	}
}