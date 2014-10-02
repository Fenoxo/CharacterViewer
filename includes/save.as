/**
 * Loads a character given its id.
 * @param	id
 */
public function loadGame(id:int):void
{
	if (isTiTS) loadFromTiTSSave(id);
	else		loadFromCoCSave(id);
}

/**
 * Loads a randomized player data.
 */
public function loadRandom():void
{
	if (isTiTS) loadFromTiTSRandom();
	else		loadFromCoCRandom();
}
 
 /**
 * Loads the default character.
 * @param	btnName
 */
public function loadFromDefault():void
{
	loadDefault();
	addMainChar();
	updateCreatorMenu();
	switchMenu("creatorMenu");
	unlockScreenshot();
}

/**
 * Loads a CoC character given its id.
 * @param	id
 */
public function loadFromCoCSave(id:int):void
{
	var saveData:Object = CoCSaves[id];
	
	if (!loadCoCSave(saveData))
	{
		notes.toNote("Could not load. Try opening the save with a more recent version of CoC, then saving it. If the bug still persist, contact me at \"sbaf@post.com\".");
		return;
	}
	addMainChar();
	updateCoCMenu();
	switchMenu("CoCMenu");
	unlockScreenshot();
}

/**
 * Loads a TiTS character given its id.
 * @param	id
 */
public function loadFromTiTSSave(id:int):void
{
	var saveData:Object = TiTSSaves[id];
	
	if (!loadTiTSSave(saveData.characters.PC))
	{
		notes.toNote("Could not load. Try opening the save with a more recent version of TiTS, then saving it. If the bug still persist, contact me at \"sbaf@post.com\".");
		return;
	}
	
	loadTiTSSecondaries(saveData);
	
	addMainChar();
	updateTiTSMenu();
	switchMenu("TiTSMenu");
	unlockScreenshot();
}

/**
 * Loads NPC and Foes from a save object.
 * @param	save
 */
public function loadTiTSSecondaries(save:Object):void
{
	for each (var item:Object in save.characters)
	{
		if (isCharacterSaveValid(item))
		{
			NPCData[item.short] = item;
		}
	}
	for each (item in save.foes)
	{
		if (isCharacterSaveValid(item))
		{
			foeData[item.short] = item;
		}
	}
}

public function isCharacterSaveValid(save:Object):Boolean
{
	if (ite.legFlags && (ite.legFlags.indexOf(17) != -1 || ite.legFlags.indexOf(16) != -1))
	{
		return (true);
	}
	return (false);
}

/**
 * Loads a random CoC character
 */
public function loadFromCoCRandom():void
{
	loadCoCRandom();
	addMainChar();
	updateCreatorMenu();
	switchMenu("creatorMenu");
	unlockScreenshot();
}

/**
 * Loads a random TiTS character
 */
public function loadFromTiTSRandom():void
{
	loadTiTSRandom();
	addMainChar();
	updateCreatorMenu();
	switchMenu("creatorMenu");
	unlockScreenshot();
}

/**
 * Resets cocks, breasts and vaginas from a Creature object.
 */
public function clearPlayerObject():void
{
	player.removeCock(0,player.cocks.length);
	player.removeBreastRow(0,player.breastRows.length);
	player.removeVagina(0,player.vaginas.length);
}

/**
 * Loads a default player data.
 */
public function loadDefault():void
{
	//player = new Creature();
	clearPlayerObject();
	
	player.short = "Created";
	
	//Appearance
	player.gender = 0;
	player.femininity = 0;
	player.tallness = 80;
	player.hairColor = "silver";
	player.hairLength = 1;
	player.skinType = 0;
	player.skinTone = "light";
	player.faceType = 0;
	player.armType = 0;
	player.gills = false;
	player.earType = 0;
	player.earValue = 0;
	player.antennae = 0;
	player.horns = 0;
	player.hornType = 0;
	player.wingType = 0;
	player.lowerBody = 0;
	player.tailType = 0;
	player.tailVenom = 0;
	player.hipRating = 0;
	player.buttRating = 0;
	//Piercings
	player.nipplesPierced = 0;
	player.lipPierced = 0;
	player.tonguePierced = 0;
	player.eyebrowPierced = 0;
	player.earsPierced = 0;
	player.nosePierced = 0;
	//Sexual Stuff
	player.balls = 2;
	player.ballSize = 0;
	player.clitLength = 0;
	//Preggo stuff
	player.pregnancyIncubation = 0;
	//Set Cock array
	player.createCock();
	//Populate Cock Array
	player.cocks[0].cockThickness = 0;
	player.cocks[0].cockLength = 2;
	player.cocks[0].cockType = 0;
	player.cocks[0].pierced = 0;
	//Set Vaginal Array
	player.createVagina();
	//Populate Vaginal Array
	player.vaginas[0].labiaPierced = 0;
	player.vaginas[0].clitPierced = 0;
	//Nipples
	player.nippleLength = .25;
	//Set Breast Array
	player.createBreastRow();
	player.breastRows[0].breasts = 2;
	player.breastRows[0].nipplesPerBreast = 1;
	player.breastRows[0].breastRating = 1;
	//Applied
	player.eyeColor = "silver";
}

/**
 * Interpret (and load into player) data from a CoC save.
 * @param	The save object (a SharedObject)
 * @return	Existence of the save object. Could implement more complexe save corruption detection.
 */
public function loadCoCSave(save:Object):Boolean
{
	//Initiamize loading sequence
	if (save == null) return false;
	
	//Reset vital settings
	//player = new Creature();
	clearPlayerObject();
	
	//Player name (only used for NPCs)
	player.short = save.short;
	//Load file
	player.a = save.a
	player.long = save.long;
	player.capitalA = save.capitalA;
	player.temperment = save.temperment;
	player.special1 = save.special1;
	player.special2 = save.special2;
	player.special3 = save.special3;
	player.pronoun1 = save.pronoun1;
	player.pronoun2 = save.pronoun2;
	player.pronoun3 = save.pronoun3;
	//Load equipment
	player.armorName = save.armorName;
	player.weaponName = save.weaponName;
	player.weaponVerb = save.weaponVerb;
	player.armorDef = save.armorDef;
	player.armorPerk = save.armorPerk;
	player.weaponAttack = save.weaponAttack;
	player.weaponPerk = save.weaponPerk;
	player.weaponValue = save.weaponValue;
	player.armorValue = save.armorValue;
	//Load statistics
	player.str = save.str;
	player.tou = save.tou;
	player.spe = save.spe;
	player.inte = save.inte;
	player.lib = save.lib;
	player.sens = save.sens;
	player.cor = save.cor;
	player.fatigue = save.fatigue;
	//Load health state
	player.HP = save.HP;
	player.lust = save.lust;
	//Load experience
	player.XP = save.XP;
	player.level = save.level;
	player.gems = save.gems;
	//Load explored places
	player.exploredMountain = save.exploredMountain;
	player.exploredLake = save.exploredLake;
	player.exploredForest = save.exploredForest;
	player.exploredDesert = save.exploredDesert;
	//Load appearance
	player.gender = save.gender;
	player.femininity = save.femininity;
	player.tallness = save.tallness;
	player.hairColor = save.hairColor;
	player.hairLength = save.hairLength;
	player.skinType = save.skinType;
	player.skinTone = save.skinTone;
	player.skinDesc = save.skinDesc;
	player.faceType = save.faceType;
	player.armType = save.armType;
	player.gills = save.gills;
	if (save.earType == undefined) player.earType = 0;
	else player.earType = save.earType;
	if (save.earValue == undefined) player.earValue = 0;
	else player.earValue = save.earValue;
	if (save.antennae == undefined) player.antennae = 0;
	else player.antennae = save.antennae;
	player.horns = save.horns;
	if (save.hornType == undefined) player.hornType = 0;
	else player.hornType = save.hornType;
	player.wingDesc = save.wingDesc;
	player.wingType = save.wingType;
	player.lowerBody = save.lowerBody;
	player.tailType = save.tailType;
	player.tailVenom = save.tailVenum;
	player.tailRecharge = save.tailRecharge;
	player.hipRating = save.hipRating;
	player.buttRating = save.buttRating;
	//Piercings
	player.nipplesPierced = save.nipplesPierced;
	player.lipPierced = save.lipPierced;
	player.tonguePierced = save.tonguePierced;
	player.eyebrowPierced = save.eyebrowPierced;
	player.earsPierced = save.earsPierced;
	player.nosePierced = save.nosePierced;
	
	//Genitals
	player.balls = save.balls;
	player.cumMultiplier = save.cumMultiplier;
	player.ballSize = save.ballSize;
	player.hoursSinceCum = save.hoursSinceCum;
	player.fertility = save.fertility;
	player.clitLength = save.clitLength;
	
	//Pregnancy
	player.pregnancyIncubation = save.pregnancyIncubation;
	player.pregnancyType = save.pregnancyType;
	player.buttPregnancyIncubation = save.buttPregnancyIncubation;
	player.buttPregnancyType = save.buttPregnancyType;
	
	//Initialize arrays
	var i:int;
	//Set Cock array
	for (i = 0; i < save.cocks.length; i++)
	{
		player.createCock();
	}
	//Populate Cock Array
	for (i = 0; i < save.cocks.length; i++)
	{
		player.cocks[i].cockThickness = save.cocks[i].cockThickness;
		player.cocks[i].cockLength = save.cocks[i].cockLength;
		player.cocks[i].cockType = save.cocks[i].cockType;
		player.cocks[i].knotMultiplier = save.cocks[i].knotMultiplier;
		player.cocks[i].pierced = save.cocks[i].pierced;
	}
	//Set Vaginal Array
	for (i = 0; i < save.vaginas.length; i++)
	{
		player.createVagina();
	}
	//Populate Vaginal Array
	for (i = 0; i < save.vaginas.length; i++)
	{
		player.vaginas[i].vaginalWetness = save.vaginas[i].vaginalWetness;
		player.vaginas[i].vaginalLooseness = save.vaginas[i].vaginalLooseness;
		player.vaginas[i].fullness = save.vaginas[i].fullness;
		player.vaginas[i].virgin = save.vaginas[i].virgin;
		player.vaginas[i].labiaPierced = save.vaginas[i].labiaPierced;
		player.vaginas[i].clitPierced = save.vaginas[i].clitPierced;
	}
	//Nipples
	if (save.nippleLength == undefined) player.nippleLength = .25;
	else player.nippleLength = save.nippleLength;
	//Set Breast Array
	for (i = 0; i < save.breastRows.length; i++)
	{
		player.createBreastRow();
	}
	//Populate Breast Array
	for (i = 0; i < save.breastRows.length; i++)
	{
		player.breastRows[i].breasts = save.breastRows[i].breasts;
		player.breastRows[i].nipplesPerBreast = save.breastRows[i].nipplesPerBreast;
		player.breastRows[i].breastRating = save.breastRows[i].breastRating;
		player.breastRows[i].lactationMultiplier = save.breastRows[i].lactationMultiplier;
		player.breastRows[i].milkFullness = save.breastRows[i].milkFullness;
		player.breastRows[i].fuckable = save.breastRows[i].fuckable;
		player.breastRows[i].fullness = save.breastRows[i].fullness;
	}
	player.ass.analLooseness = save.ass.analLooseness;
	player.ass.analWetness = save.ass.analWetness;
	player.ass.fullness = save.ass.fullness;
	//Random eye color
	player.eyeColor = "random";
	return true;
}

/**
 * Interpret (and load into player) data from a CoC save.
 * @param	The save object (a SharedObject)
 * @return	Existence of the save object. Could implement more complexe save corruption detection.
 */
public function loadTiTSSave(save:Object):Boolean
{
	if (save == null) return false;
	
	//Reset vital settings
	//player = new Creature();
	clearPlayerObject();
	
	//Player name (only used for NPCs)
	player.short = save.short;
	//Load stats
	player.str = 50;//!!!
	player.cor = 50;//!!!
	player.fatigue = 50;//!!!
	player.HP = save.HPRaw;
	player.lust = save.lustRaw +  save.lustMod;
	//Load appearance
	player.femininity = save.femininity;
	player.tallness = save.tallness;
	player.hairColor = save.hairColor;
	player.hairLength = save.hairLength;
	player.skinType = save.skinType;
	player.skinTone = save.skinTone;
	player.faceType = save.faceType;
	player.armType = save.armType;
	player.lowerBody = save.lowerBody;
	player.gills = save.gills;
	if (save.earType == undefined) player.earType = 0;
	else player.earType = save.earType;
	if (save.antennae == undefined) player.antennae = 0;
	else player.antennae = save.antennae;
	player.horns = save.horns;
	if (save.hornType == undefined) player.hornType = 0;
	else player.hornType = save.hornType;
	player.wingType = save.wingType;
	player.tailType = save.tailType;
	player.tailVenom = save.tailVenum;
	player.hipRating = save.hipRatingRaw +  save.hipRatingMod;
	player.buttRating = save.buttRatingRaw +  save.buttRatingMod;
	
	//Piercings
	player.nipplesPierced = save.nipplesPierced;
	player.lipPierced = save.lipPierced;
	player.tonguePierced = save.tonguePierced;
	player.eyebrowPierced = save.eyebrowPierced;
	player.earsPierced = save.earsPierced;
	player.nosePierced = save.nosePierced;
	
	//Genitals
	player.balls = save.balls;
	player.ballSize = save.ballSizeMod +  save.ballSizeRaw;
	player.clitLength = save.clitLength;
	
	var i:int;
	//Cock array
	for (i = 0; i < save.cocks.length; i++)
	{
		player.createCock();
	}
	//Populate Cock Array
	for (i = 0; i < save.cocks.length; i++)
	{
		player.cocks[i].cockLength = save.cocks[i].cLengthRaw +  save.cocks[i].cLengthMod;
		player.cocks[i].cockType = save.cocks[i].cType;
	}
	//Vaginal Array
	for (i = 0; i < save.vaginas.length; i++)
	{
		player.createVagina();
	}
	for (i = 0; i < save.vaginas.length; i++)
	{
		player.vaginas[i].clitPierced = save.vaginas[i].clitPierced;
	}
	//Nipples
	if (save.nippleLength == undefined) player.nippleLength = .25;
	else player.nippleLength = save.nippleLength;
	//Set Breast Array
	for (i = 0; i < save.breastRows.length; i++)
	{
		player.createBreastRow();
	}
	//Populate Breast Array
	for (i = 0; i < save.breastRows.length; i++)
	{
		player.breastRows[i].breasts = save.breastRows[i].breasts;
		player.breastRows[i].breastRating = save.breastRows[i].breastRatingRaw +  save.breastRows[i].breastRatingMod;
	}
	//Load eye color name.
	player.eyeColor = save.eyeColor;
	
	return true;
}

/**
 * Get a random int inside the given interval.
 * @param	Lower limit.
 * @param	Upper limit.
 * @return
 */
public function getRandInt(lower:int, upper:int):int
{
	return (Math.round((lower - 0.5) + (upper  - lower + 0.5) * Math.random()));
}

/**
 * Loads randomized CoC player data.
 */
public function loadCoCRandom():void
{
	var color:ColorDictionary = viewerData.colorDict;
	
	//player = new Creature();
	clearPlayerObject();
	
	//Name
	player.short = "Created";
	//Appearance
	player.gender = getRandInt(0, 3);
	player.femininity = getRandInt(0, 100);
	player.tallness = getRandInt(40, 100);
	player.hairColor = color.getRandomHairColor();
	player.hairLength = getRandInt(0, 20);
	player.skinType = getRandInt(0, 5);
	player.skinTone = color.getRandomSkinColor();
	player.faceType = getRandInt(0, 13);
	player.armType = getRandInt(0, 5);
	player.gills = Boolean(getRandInt(0, 1));
	player.earType = getRandInt(0, 13);
	player.earValue = 0;
	player.antennae = getRandInt(0, 13);
	player.horns = getRandInt(0, 13);
	player.hornType = getRandInt(0, 13);
	player.wingType = getRandInt(0, 13);
	player.lowerBody = getRandInt(0, 13);
	player.tailType = getRandInt(0, 13);
	player.tailVenom = getRandInt(0, 13);
	player.hipRating = getRandInt(0, 30);
	player.buttRating = getRandInt(0, 20);
	//Piercings
	player.nipplesPierced = getRandInt(0, 13);
	player.lipPierced = getRandInt(0, 13);
	player.tonguePierced = getRandInt(0, 13);
	player.eyebrowPierced = getRandInt(0, 13);
	player.earsPierced = getRandInt(0, 13);
	player.nosePierced = getRandInt(0, 13);
	//Sexual Stuff
	player.balls = getRandInt(0, 4);
	player.ballSize = getRandInt(0, 9);
	player.clitLength = getRandInt(0, 10);
	//Preggo stuff
	player.pregnancyIncubation = 0;
	//Set Cock array
	var length:int = getRandInt(0, 3);
	for (var i:int = 0; i < length; i++)
	{
		player.createCock();
		//Populate Cock Array
		player.cocks[i].cockThickness = getRandInt(0, 3);
		player.cocks[i].cockLength = getRandInt(0, 30);
		player.cocks[i].cockType = getRandInt(0, 10);
		player.cocks[i].pierced = 0;
	}
	//Set Vaginal Array
	if (Boolean(getRandInt(0, 1)))
	{
		player.createVagina();
		//Populate Vaginal Array
		player.vaginas[0].labiaPierced = 0;
		player.vaginas[0].clitPierced = 0;
	}
	//Nipples
	player.nippleLength = getRandInt(0, 10) / 4;
	//Set Breast Array
	length = getRandInt(0, 4)
	for (i = 0; i < length; i++)
	{
		player.createBreastRow();
		player.breastRows[i].breasts = 2;
		player.breastRows[i].nipplesPerBreast = 1;
		player.breastRows[i].breastRating = getRandInt(0, 100);
	}
}

/**
 * Loads randomized TiTS player data.
 */
public function loadTiTSRandom():void
{
	var color:ColorDictionary = viewerData.colorDict;
	
	//player = new Creature();
	clearPlayerObject();
	
	//Name
	player.short = "Created";
	//Appearance
	player.gender = getRandInt(0, 3);
	player.femininity = getRandInt(0, 100);
	player.tallness = getRandInt(40, 100);
	player.hairColor = color.getRandomHairColor();
	player.hairLength = getRandInt(0, 20);
	player.skinType = getRandInt(0, 5);
	player.skinTone = color.getRandomSkinColor();
	player.faceType = getRandInt(0, 26);
	player.armType = getRandInt(0, 26);
	player.gills = Boolean(getRandInt(0, 1));
	player.earType = getRandInt(0, 26);
	player.earValue = 0;
	player.antennae = getRandInt(0, 26);
	player.horns = getRandInt(0, 26);
	player.hornType = getRandInt(0, 26);
	player.wingType = getRandInt(0, 26);
	player.lowerBody = getRandInt(0, 27);
	player.tailType = getRandInt(0, 27);
	player.tailVenom = getRandInt(0, 27);
	player.hipRating = getRandInt(0, 30);
	player.buttRating = getRandInt(0, 20);
	//Piercings
	player.nipplesPierced = getRandInt(0, 27);
	player.lipPierced = getRandInt(0, 27);
	player.tonguePierced = getRandInt(0, 27);
	player.eyebrowPierced = getRandInt(0, 27);
	player.earsPierced = getRandInt(0, 27);
	player.nosePierced = getRandInt(0, 27);
	//Sexual Stuff
	player.balls = getRandInt(0, 4);
	player.ballSize = getRandInt(0, 9);
	player.clitLength = getRandInt(0, 10);
	//Preggo stuff
	player.pregnancyIncubation = 0;
	//Set Cock array
	var length:int = getRandInt(0, 3);
	for (var i:int = 0; i < length; i++)
	{
		player.createCock();
		//Populate Cock Array
		player.cocks[i].cockThickness = getRandInt(0, 3);
		player.cocks[i].cockLength = getRandInt(0, 30);
		player.cocks[i].cockType = getRandInt(0, 10);
		player.cocks[i].pierced = 0;
	}
	//Set Vaginal Array
	if (Boolean(getRandInt(0, 1)))
	{
		player.createVagina();
		//Populate Vaginal Array
		player.vaginas[0].labiaPierced = 0;
		player.vaginas[0].clitPierced = 0;
	}
	//Nipples
	player.nippleLength = getRandInt(0, 10) / 4;
	//Set Breast Array
	length = getRandInt(0, 4)
	for (i = 0; i < length; i++)
	{
		player.createBreastRow();
		player.breastRows[i].breasts = 2;
		player.breastRows[i].nipplesPerBreast = 1;
		player.breastRows[i].breastRating = getRandInt(0, 100);
	}
}

/**
 * Loads a character from a .sol file. Currently not working.
 * @param	btnName
 */
/*public function loadFromFile(btnName:String):void
 * {
	file = new FileReference();
	file.browse();
	file.addEventListener(Event.SELECT, onFileSelect);
}
public function onFileSelect(evt:Event):void
{
	file.load();
	file.addEventListener(Event.COMPLETE, onFileLoaded);
}
public function onFileLoaded(evt:Event):void
{
	var tempFileRef:FileReference = FileReference(evt.target);
	loader = new URLLoader();
	loader.dataFormat = URLLoaderDataFormat.BINARY;
	loader.addEventListener(Event.COMPLETE, onDataLoaded);
	loader.addEventListener(IOErrorEvent.IO_ERROR, loadFailed)
	try
	{
		var req:* = new URLRequest(inputPath);
		loader.load(req);
	}catch (error:Error)
	{
		loadFailed();
	}
}
public function onDataLoaded(evt:Event):void
{
	loader.data.position = 0;
	var sav = loader.data.readObject();
	if (sav)
	{
		if (sav.data)
		{
			if (loadGame(sav.data))
			{
				addMainChar([CoCMenu, TiTSMenu][int(isTiTS)]);
				return;
			}
		}
	}
	loadFailed();
}
public function loadFailed(e:Event = undefined)
{
	toNote("Save file not found or corrupted, check that it is in the same directory as the CoC.swf file.\r\rLoad from file is not available when playing directly from a website like furaffinity or fenoxo.com.", true);
}*/
/**
 * Loads the default data into player.
 */