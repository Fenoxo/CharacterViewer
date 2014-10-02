package classes.character {
	
	import classes.save.Creature;
	
	/**
	 * Contains object used only by a particular Character object and its children.
	 * All those objects are set with the Character object and disposed with it,
	 * the exception being the player object, which may be used by other characters
	 * after being reseted. It should not be used in any way after drawing and coloring.
	 * @author 
	 */
	public class CharacterData 
	{
		public var painter:PartPainter;//The character's PartPainter instance
		public var player:Creature;//The global player instance, set to null after drawing
		public var prop:CharacterProperties;//The character's properties object.
		
		/**
		 * Returns a new CharacterData instance, creates a new CharacterProperties instance.
		 * @param	The character's PartPainter instance.
		 * @param	The global player instance.
		 */
		public function CharacterData(partPainter:PartPainter, player:Creature) 
		{
			this.painter = partPainter;
			this.player = player;
			this.prop = new CharacterProperties(player);
		}
	}
}