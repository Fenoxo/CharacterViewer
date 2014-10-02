/**
 * Remove the previous main character.
 * Add a new main character, add it to charactersParent and store it in mainChar,
 * Update and load the necessary menu.
 * @param	The menu to load.
 * @param	If the character is loaded of created.
 */
public function addMainChar():void
{
	reset();
	mainChar = new Character();
	
	mainChar.init(player, viewerData);
	mainChar.standingX = 850;
	mainChar.standingY = 820;
	mainChar.name = "MainCharacter";
	
	charactersParent.addChild(mainChar);
}

/**
 * Add a new NPC character, add it to charactersParent and store it in mainChar,
 * Update and load the necessary menu.
 * Should ultimately use an ID system, like the LoadGame function.
 * @param	The save object of the NPC.
 */
public function addNPCChar(NPC:Object):void
{
	loadTiTSSave(NPC);
	
	var newChar:Character = new Character();
	
	newChar.init(player, viewerData);
	newChar.standingX = 1224 * MathUtils.randomCentered() + 200;
	newChar.standingY = mainChar.standingY + 250 - 400 * player.tallness / 82;
	
	charactersParent.addChild(newChar);
	MCUtils.sortChildrenOn(charactersParent, "standingY");
	charactersParent.addChild(mainChar);
}

/**
 * Removes an NPC char given it's data.
 * @param	The save object of the NPC.
 */
public function removeNPCChar(NPC:Object)
{
	var name:String = NPC.short;
	var char:Character = charactersParent.getChildByName(name) as Character;
	
	charactersParent.removeChild(char);
}

/**
 * Sets the selected indexes of the foe and NPC selectbox to an empty array.
 * This triggers the update systems, and delete every characters.
 */
public function clearChars():void
{	
	var NPCList:ViewerScroll = menus.TiTSNPCMenu.getChildByName("0");
	var foeList:ViewerScroll = menus.TiTSFoeMenu.getChildByName("0");
	
	NPCList.selectedIndices = [];
	foeList.selectedIndices = [];
}

/**
 * Adds a new creature object, given its Class.
 * Sets a random scale factor, and position.
 * Orders every creatures by scale, to create
 * a perspective effect. Overkill and not very
 * efficient at all.
 * @param	creatureClass
 */
public function addCreature(creatureClass:Class)
{
	var creature:MovieClip = viewerData.partPool.getNew(creatureClass);
	creaturesParent.addChild(creature);
	
	var sca = 1 +  Math.random() / 4;
	
	MCUtils.scale(creature, sca);
	
	creature.mouseChildren = false;
	creature.doubleClickEnabled = true;
	
	creature.x = Math.round(260 + MathUtils.randomCentered() * 1200);
	creature.y = Math.round(mainChar.standingY - creature.height / sca);
	
	for (var i:int = 0; i < creaturesParent.numChildren; i++)
	{
		var comp:MovieClip = creaturesParent.getChildAt(i) as MovieClip;
		
		if (comp.scaleX > creature.scaleX)
		{
			creaturesParent.setChildIndex(creature, i);
			break;
		}
	}
}

/**
 * Clears everything in the creaturesParent object.
 */
public function clearCreatures():void
{
	creaturesParent.removeChildren();
}
