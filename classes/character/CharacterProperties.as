package classes.character 
{
	import classes.save.Creature;
	/**
	 * Contains the characters properties, used for various purpose, like deciding
	 * if the clit slider should be enabled, or getting the femininity index for part creating.
	 * @author 
	 */
	public class CharacterProperties 
	{
		public var playerName:String;//The name of the player
		
		public var finishedDrawing:Boolean = false;//If the character is finished drawing
		//If true, any modification should induce recoloring and/or shader invalidating.
		
		public var heightMod:Number;//The ratio by which to multiply any value in inch.
		public var tallness:Number;//The tallness of the character in inch.
		public var realBallSize:Number;//The unlimited, scaled ball size.
		public var realClitSize:Number;//The unlimited, scale clit size.
		
		public var masculine:int;//1 if femininity < 50, 0 elsewise.
		public var hasBalls:Boolean;//If the character has balls.
		public var hasVag:Boolean;//If the character has a vagina
		public var hasClit:Boolean;//If the character has a clit
		public var hasBigBalls:Boolean;//If the character has scalable balls.
		public var hasBigClit:Boolean;//If the character has a scalable clit.
		
		public var skinColor:String;//The character's skin color name.
		public var hairColor:String;//The character's hair color name.
		public var eyeColor:String;//The character's eye color name.
		//"Random" if to be randomized next time the character is colored.
		//"Defined" if not to be modified but by the eyeTint setter.
		public var skinType:int; //The character's skin type ID.
		
		public function CharacterProperties(player:Creature) 
		{
			playerName = player.short;
			
			tallness = player.tallness;
			heightMod = 82 / tallness;
			realBallSize = player.ballSize * heightMod;
			realClitSize = player.clitLength * heightMod;
			
			masculine = (player.femininity < 50) ?  1 : 0;
			hasBalls = player.balls > 0;
			hasBigBalls = (realBallSize >= 8) && hasBalls;
			hasVag = player.vaginas.length > 0;
			
			skinType = player.skinType;
			eyeColor = player.eyeColor;
			skinColor = player.skinTone;
			hairColor = player.hairColor;
		}
	}
}