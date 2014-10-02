import classes.components.ViewerButton;
import flash.utils.Dictionary;
/**
 * Removes any placeholder elements.
 * Creates menu objects.
 * Add and set every GUI elements (notes, background, ...).
 */
public function initViewer():void
{
	this.removeChildren();
	stage.frameRate = 24;
	
	//Init viewer data
	viewerData = new ViewerData();
	viewerData.init();
	//Init menu objects
	//initMouse();
	loadSaves();
	initMenuData();
	initMenus();
	//Add and set elements and global listeners
	initBackground();
	initNotes();
	initParents();
	initButtons();
	initListeners();
	//Stage
	stage.stageFocusRect = false;
}

/**
 * Creates every background BitmapData as well as Bitmap.
 * Quite heavy on memory, but allows instant switching,
 * and is much less heavy on dragging lotsa characters and stuff.
 */
public function initBackground():void
{
	var mask:BitmapData = new BitmapData(1674, 980, true, 0x11000000);
	var noise:BitmapData = new NoiseBitmap();
	var point:Point = new Point();
	
	CoCBackgrounds = new Vector.<BitmapData>(5, true);
	CoCBackgrounds[0] = getBackgroundData(1224, CoC_BackgroundDefault, backgroundScrollRect);
	CoCBackgrounds[1] = getBackgroundData(1224, CoC_BackgroundMountain, backgroundScrollRect);
	CoCBackgrounds[2] = getBackgroundData(1224, CoC_BackgroundLake, backgroundScrollRect);
	CoCBackgrounds[3] = getBackgroundData(1224, CoC_BackgroundForest, backgroundScrollRect);
	CoCBackgrounds[4] = getBackgroundData(1224, CoC_BackgroundDesert, backgroundScrollRect);
	
	TiTSBackgrounds = new Vector.<BitmapData>(4, true);
	TiTSBackgrounds[0] = getBackgroundData(1224, TiTS_BackgroundDefault);
	TiTSBackgrounds[1] = getBackgroundData(1224, TiTS_BackgroundTavros, backgroundScrollRect);
	TiTSBackgrounds[2] = getBackgroundData(1224, TiTS_BackgroundMhenga, backgroundScrollRect);
	TiTSBackgrounds[3] = getBackgroundData(1224, TiTS_BackgroundTarkus, backgroundScrollRect);
	
	CoCPanels = new Vector.<BitmapData>(2, true);
	CoCPanels[0] = getBackgroundData(200, CoC_PanelLeft, leftPanelScrollRect);
	CoCPanels[1] = getBackgroundData(250, CoC_PanelRight, rightPanelScrollRect);
	
	TiTSPanels = new Vector.<BitmapData>(2, true);
	TiTSPanels[0] = getBackgroundData(200, TiTS_PanelLeft);
	TiTSPanels[1] = getBackgroundData(250, TiTS_PanelRight);
	
	leftPanelBitmap = new Bitmap(CoCPanels[0]);
	rightPanelBitmap = new Bitmap(CoCPanels[1]);
	backgroundBitmap = new Bitmap(CoCBackgrounds[0]);
	backgroundBitmap.x = 200;
	rightPanelBitmap.x = 1424;
	
	addChild(leftPanelBitmap);
	addChild(rightPanelBitmap);
	addChild(backgroundBitmap);
	addChild(instructions);
	
	changePanels();
	changeBackground(0);
	
	function getBackgroundData(width:Number, backgroundClass:Class, noiseRectangle:Rectangle = null):BitmapData
	{
		var data:BitmapData = new BitmapData(width, 980, false);
		//data.draw(new backgroundClass(), null, null, null, null, true);
		data.draw(new backgroundClass());
		
		if (noiseRectangle)
		{
			data.copyPixels(noise, noiseRectangle, point, mask, point);
		}
		return (data);
	}
	
	mask.dispose();
	noise.dispose();
}

/**
 * Changes the background and the global ligthing.
 * @param	The background ID.
 */
public function changeBackground(backgroundID:int):void
{
	var backgrounds:Vector.<BitmapData> = (isTiTS) ? TiTSBackgrounds : CoCBackgrounds;
	
	backgroundBitmap.bitmapData = backgrounds[backgroundID];
	
	var ct:ColorTransform = BitmapUtils.getBitmapAverageDeviation(backgrounds[backgroundID], backgroundID);
	charactersParent.transform.colorTransform = ct;
	creaturesParent.transform.colorTransform = ct;
}

/**
 * Updates the panels bitmap data.
 */
public function changePanels():void
{
	var panels:Vector.<BitmapData> = (isTiTS) ? TiTSPanels : CoCPanels;
	
	leftPanelBitmap.bitmapData = panels[0];
	rightPanelBitmap.bitmapData = panels[1];
}

/**
 * Gets the color names array for dropdown boxes.
 */
public function initMenuData():void
{
	var array:Array = viewerData.colorDict.getColorNameDictionaries();
	skinColorNames = array[0];
	hairColorNames = array[1];
}

/**
 * Creates the upper right TextField.
 */
public function initNotes():void
{
	notes = new ViewerNotes();
	notes.x = 1439;
	notes.y = 39;
	notes.setMode(false);
	addChild(notes);
}

/**
 * Adds the characters and creatures parents and set position, properties and listeners.
 * This is called to reset those parents, which avoids clearChildren, which can quite slow.
 */
public function initParents():void
{
	clearChars();
	clearCreatures();
	if (charactersParent.parent)
	{
		this.removeChild(charactersParent);
		this.removeChild(creaturesParent);
	}
	creaturesParent.removeEventListener(MouseEvent.MOUSE_DOWN, onGrab);
	creaturesParent.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
	charactersParent.removeEventListener(MouseEvent.MOUSE_DOWN, onGrab);
	charactersParent.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
	charactersParent.removeEventListener(NoteEvent.NEW_NOTE, onNewNoteEvent);
	
	var ct:ColorTransform = charactersParent.transform.colorTransform;
	
	charactersParent = new Sprite();
	creaturesParent = new Sprite();
	charactersParent.x = 200;
	creaturesParent.x = 200;
	charactersParent.buttonMode = true;
	creaturesParent.buttonMode = true;
	creaturesParent.scrollRect = backgroundScrollRect;
	charactersParent.scrollRect = backgroundScrollRect;
	charactersParent.transform.colorTransform = ct;
	creaturesParent.transform.colorTransform = ct;
	addChild(creaturesParent);
	addChild(charactersParent);
	
	creaturesParent.addEventListener(MouseEvent.MOUSE_DOWN, onGrab);
	creaturesParent.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
	charactersParent.addEventListener(MouseEvent.MOUSE_DOWN, onGrab);
	charactersParent.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
	charactersParent.addEventListener(NoteEvent.NEW_NOTE, onNewNoteEvent);
}

/**
 * Adds the menu parents, sets their position, and load their children.
 */
public function initButtons():void
{
	menu.y = 450;
	basicBtns.x = 1424;
	addSaveBtns();
	addBasicBtns();
	addChild(menu);
	addChild(basicBtns);
	addChild(saveBtns);
}

/**
 * Resets drag, cockSlider and boobSlider targets.
 * Resets the characters and creatures parent.
 * Resets the menus.
 * Resets the background.
 * Locks the screenshot buttons.
 */
public function reset():void
{
	if (dragTarget)
	{
		dragTarget.stopDrag();
	}
	if (instructions)
	{
		MCUtils.remove(instructions);
		instructions = null;
	}
	if (cockSliderTarget)
	{
		cockSliderTarget.transform.colorTransform = new ColorTransform();
	}
	if (boobSliderTarget)
	{
		boobSliderTarget.transform.colorTransform = new ColorTransform();
	}
	initParents();
	
	switchMenu();
	changeBackground(0);
	
	lockScreenshot();
	//garbageCollector();
}


/**
 * Loads, clones and stores every save object it can find.
 * Can be called to reload said objects.
 */
public function loadSaves():void
{
	CoCSaves = new Vector.<Object>(9, true);
	TiTSSaves = new Vector.<Object>(9, true);
	
	for (var i:int = 0; i < 9; i++)
	{
		var cocSave:SharedObject = SharedObject.getLocal("CoC_" + (i + 1), "/");
		var titSave:SharedObject = SharedObject.getLocal("TiTs_" + (i + 1), "/");
		
		if (cocSave.data.exists)
		{
			CoCSaves[i] = ObjectUtils.cloneObject(cocSave.data);
		}
		if (titSave.data.version != undefined)
		{
			TiTSSaves[i] = ObjectUtils.cloneObject(titSave.data);
		}
	}
}

/**
 * Creates and place 9 invisible buttons inside saveBtns with loadGame as action.
 * @param	btnName
 */
public function addSaveBtns():void
{
	var button:ViewerButton;
	
	for (var i:int = 0; i < 10; i++)
	{
		button = new ViewerButton("", loadGame, i);
		button.x = 30;
		button.y = 45 * i + 17;
		button.visible = false;
		saveBtns.addChild(button);
	}
	updateSaveBtns();
}

/**
 * Will loop through the save objects and sets the corresponding save button
 * as visible if it exists. If it cannot find any save, will display a message
 * on the note box.
 */
public function updateSaveBtns():void
{
	var foundSave:Boolean = false;
	var saves:Vector.<Object> = (isTiTS) ? TiTSSaves : CoCSaves;
	
	for (var i:int = 0; i < 9; i++)
	{
		var button:ViewerButton = saveBtns.getChildAt(i) as ViewerButton;
		
		if (saves[i])
		{
			var name:String = (isTiTS) ? saves[i].saveName : saves[i].short;
			
			button.label = new String().concat(i + 1, ":", name);
			button.visible = true;
			button.setMode(isTiTS);
			foundSave = true;
		}
		else
		{
			button.visible = false
		}
	}
	if (!foundSave)
	{
		notes.toNote("No save found, sorry. Please open this locally, or from the website you usually play the game on. You can still use the Create and Random features.");
	}
}

/**
 * Reloads every savefiles.
 * Maybe should cause a game reset.
 */
public function reloadSaves():void
{
	loadSaves();
	updateSaveBtns();
}

/**
 * Create every basic buttons (reset, create, ...). Adds special fullScreen listener.
 */
public function addBasicBtns():void
{
	addComponent(55, 340 + 26, "reloadS", new ViewerButton("Reload", reloadSaves));
	addComponent(55, 380 + 26, "restart", new ViewerButton("Reset", reset));
	addComponent(55, 420 + 26, "creates", new ViewerButton("Create", loadFromDefault));
	addComponent(55, 460 + 26, "randoms", new ViewerButton("Random", loadRandom));
	addComponent(55, 482 + 66, "scrShot", new ViewerButton("Render:"));
	addComponent(55, 522 + 66, "bgdShot", new ViewerButton("Screen", backgroundCap));
	addComponent(55, 562 + 66, "chrShot", new ViewerButton("Character", characterCap));
	addComponent(51, 590 + 66, "charRes", new ViewerSlider(onResoSlide, 1.0, 15.0, "Resolution: Xx", true, 0, false));
	addComponent(55, 652 + 66, "switchM", new ViewerButton("TiTS", switchGUI, true));
	addComponent(55, 692 + 66, "fullScr", new ViewerButton("Full Screen"));
	addComponent(51, 720 + 66, "slidFPS", new ViewerSlider(onFpsSlide, 24.0, 60.0, "FPS: X", true, 0, false));
	
	buttons.fullScr.addEventListener(MouseEvent.CLICK, toggleFullScreen);
	buttons.scrShot.enabled = false;
	lockScreenshot();
	
	function addComponent(x:Number, y:Number, name:String, component:IViewerComponent):void
	{
		component.x = x;
		component.y = y;
		component.setMode(isTiTS);
		basicBtns.addChild(DisplayObject(component));
		buttons[name] = component;
	}
}

/**
 * Updates the mode of every basic buttons.
 */
public function updateBasicBtns():void
{
	for each (var component:IViewerComponent in buttons)
	{
		component.setMode(isTiTS);
	}
	buttons.switchM.label = (isTiTS)? "CoC" : "TiTS";
	buttons.switchM.args[0] = (isTiTS)? false : true;
}

/**
 * Locks every screenshot button.
 * Avoids people spam-clicking them, causing massive lag and bugs.
 */
public function lockScreenshot():void
{
	buttons.chrShot.enabled = false;
	buttons.bgdShot.enabled = false;
	buttons.charRes.enabled = false;
}

/**
 * If no screenshot is being encoded, unlocks save buttons.
 * If a screenshot is being encoded, silently fails, as the
 * PNGEncoder listener will unlock them on completion.
 */
public function unlockScreenshot():void
{
	if (PNGEncoder == null)
	{
		buttons.chrShot.enabled = true;
		buttons.bgdShot.enabled = true;
		buttons.charRes.enabled = true;
	}
}

/**
 * Changes the current menu, given a name.
 * 
 * Throws an error if it cannot find the menu.
 * If the menu was never added to stage, adds it and sets its position.
 * Turns the previous menu invisible.
 * "menu" property is set to the new menu.
 * Adds the menu note to the note box.
 * @param	menuName
 */
public function switchMenu(menuName:String = "none")
{
	var oldMenu:Sprite = menu;
	var newMenu:Sprite = menus[menuName];
	
	if (!newMenu)
	{
		throw new Error("Could not find menu.");
	}
	if (!newMenu.parent)
	{
		newMenu.x = oldMenu.x;
		newMenu.y = oldMenu.y;
		addChild(newMenu);
	}
	
	oldMenu.visible = false;
	newMenu.visible = true;
	this.menu = newMenu;
	notes.toNote(this.notesList[menu]);
}

/**
 * Toggles the viewer mode.
 * Changes include button types, menus loaded, save location, text format and class dictionary.
 * @param	btnName
 */
public function switchGUI(isTiTS:Boolean):void
{
	this.isTiTS = isTiTS;
	
	reset();
	
	changePanels();
	viewerData.setMode(isTiTS);
	notes.setMode(isTiTS);
	updateSaveBtns();
	updateBasicBtns();
}

/**
 * Inits all menu objects.
 * Will first retrieve the menu data from their builder functions.
 * Will then loop through each menu in each tree, and parse them as Sprites.
 * Will then add a "none" property to the menu and note lists, for default behaviour.
 */
public function initMenus():void
{
	var key:String;
	var CoCMenus:Object = initCoCMenu();
	var TiTSMenus:Object = initTiTSMenu();
	var creatorMenus:Object = initCreatorMenu();
	
	this.menus = { };
	this.notesList = new Dictionary(true);
	for (key in CoCMenus)
	{
		this.menus[key] = parseMenu(CoCMenus[key], false);
	}
	for (key in TiTSMenus)
	{
		this.menus[key] = parseMenu(TiTSMenus[key], true);
	}
	for (key in creatorMenus)
	{
		this.menus[key] = parseMenu(creatorMenus[key], false);
	}
	this.menus.none = this.menu;
	this.notesList[this.menu] = "";
}

/**
 * Loops through each element of a menu, and creates the appropriate viewer component
 * using the parsed data.
 * AddComponent helper function could be moved outside.
 * @param	menuObject
 * @param	isTiTS
 * @return
 */
public function parseMenu(menuObject:Object, isTiTS:Boolean):Sprite
{
	var menuParent:Sprite = new Sprite();
	
	var addedComponent:IViewerComponent;
	var info:Array;
	var y:int;
	
	for (var key:String in menuObject)
	{
		info = menuObject[key];
		y = 45 * int(key);
		y += (isTiTS) ? 20 : 35
		
		switch (info[0])
		{
			case "button"://Button element
				addComponent(30, y, new ViewerButton(info[2], info[1], info[3], info[4]));
			break;
			case "arrows"://Button with two added arrows on the sides
				addComponent(16, y, new ViewerArrows(info[2], info[1], info[3], info[4], info[5]));
			break;
			case "slider"://Slider element
				addComponent(26, y, new ViewerSlider(info[1], 0.0, 1.0, info[2], info[3]));
			break;
			case "select"://Dropdown box element
				addComponent(30, y, new ViewerSelect(info[1], info[2], info[3], info[4]));
			break;
			case "scroll"://Scrollable list element
				addComponent(30, y, new ViewerScroll(info[1], info[2]));
			break;
			case "picker"://Color picker element
				addComponent(30, y, new ViewerPicker(info[1], info[2]));
			break;
			case "back"://Preset slightly thinner button 
				addComponent(40, y, new ViewerButton("Back", switchMenu, info[1]));
				addedComponent.setCompSize(120, 36);
			break;
			case "note"://Adds a note to the notesList object, to be loaded on menu switch
				this.notesList[menuParent] = info[1];
			break;
		}
	}
	
	return (menuParent);
	
	function addComponent(x:Number, y:Number, component:IViewerComponent = null):void
	{
		component.x = x;
		component.y = y;
		component.name = key;
		component.setMode(isTiTS);
		menuParent.addChild(DisplayObject(component));
		addedComponent = component;
	}
}

/**
 * Inits the CoC menu tree data.
 */
public function initCoCMenu():Object
{
	var menus:Object = { };
	menus.CoCMenu = {
		0:["button", switchMenu, "Background", "CoCBackgroundMenu"],
		1:["button", switchMenu, "Creatures", "CoCCreatureMenu"],
		2:["button", switchMenu, "Items", "CoCItemMenu"],
		3:["button", switchMenu, "Details", "CoCDetailMenu"],
		4:["button", switchMenu, "Sliders", "CoCSliderMenu"],
		11:["note", "Save loaded.\rYou can modify various bits of your character, take pictures, add Creatures, etc."]
		};
	menus.CoCCreatureMenu = {
		0:["button", addCreature, "Goblin", GoblinNPC],
		9:["button", clearCreatures, "Clear all"],
		10:["back", "CoCMenu"],
		11:["note", "Here you can load Creatures you encountered during your adventures. \r\rCreatures are placed at player height. You can drag and drop them, drop them outside or double-click to delete them, and clear them all."]
	};
	menus.CoCBackgroundMenu = {
		0:["button", changeBackground, "Normal", 0],
		1:["button", changeBackground, "Mountain", 1],
		2:["button", changeBackground, "Lake", 2],
		3:["button", changeBackground, "Forest", 3],
		4:["button", changeBackground, "Desert", 4],
		10:["back", "CoCMenu"],
		11:["note", "Here you can load various places you've explored through your adventures."]
	};
	menus.CoCSliderMenu = {
		0:["slider", onTallSlide, "Height: Xft.", true],
		1:["slider", onBallSlide, "Ball size: Xin.", true],
		2:["slider", onClitSlide, "Clit length: Xin.", true],
		3:["select", cockChanger, "Choose Cock"],
		4:["slider", onCockSlide, "", true],
		5:["select", boobChanger, "Choose Row"],
		6:["slider", onBoobSlide, "", true],
		10:["back", "CoCMenu"],
		11:["note", "To be sure everything looks fine, the viewer prevents extreme sizes, but here you can scale them up to your real size. If you have multiple breasts and dicks above the maximum size, you just have to select which one you desire to change."]
	};
	menus.CoCDetailMenu = {
		0:["button", toggleItem, "Toggle Balls", "balls"],
		1:["button", toggleItem, "Toggle Gills", "gills"],
		2:["button", toggleItem, "Toggle Ovip", "ovi"],
		3:["picker", setProperty, "eyeTint"],
		10:["back", "CoCMenu"],
		11:["note", "Here you can shuffle your eye color, and save it for this character. You can also toggle various parts."]
	};
	menus.CoCItemMenu = {
		0:["button", setWeapon, "Dagger", Dagger, 0],
		1:["button", setWeapon, "Hammer", Hammer, 1],
		9:["button", clearEquipment, "Clear all"],
		10:["back", "CoCMenu"],
		11:["note", "Here you can equip some of the equipment you've gathered during your journey. You can add right and left hand weapons, and a few clothes."]
	};
	return (menus);
}

/**
 * Update the CoC menu tree data to match the current char.
 */
public function updateCoCMenu():void
{
	getElement("CoCBackgroundMenu", 1).enabled = Boolean(player.exploredMountain);
	getElement("CoCBackgroundMenu", 2).enabled = Boolean(player.exploredLake);
	getElement("CoCBackgroundMenu", 3).enabled = Boolean(player.exploredForest);
	getElement("CoCBackgroundMenu", 4).enabled = Boolean(player.exploredDesert);
	
	updateSliders(menus.CoCSliderMenu);
	
	getElement("CoCDetailMenu", 3).selectedColor = mainChar.eyeTint;
}

/**
 * Inits the TiTS menu tree data.
 */
public function initTiTSMenu():Object
{
	var menus:Object = { };
	menus.TiTSMenu = {
		0:["button", switchMenu, "Background", "TiTSBackgroundMenu"],
		1:["button", switchMenu, "Creatures", "TiTSCreatureMenu"],
		2:["button", switchMenu, "NPCs", "TiTSNPCMenu"],
		3:["button", switchMenu, "Foes", "TiTSFoeMenu"],
		4:["button", switchMenu, "Items", "TiTSItemMenu"],
		5:["button", switchMenu, "Details", "TiTSDetailMenu"],
		6:["button", switchMenu, "Sliders", "TiTSSliderMenu"],
		11:["note", "Save loaded.\rYou can modify various bits of your character, take pictures, add Creatures, etc."]
	};
	menus.TiTSBackgroundMenu = {
		0:["button", changeBackground, "Normal", 0],
		1:["button", changeBackground, "Tavros", 1],
		2:["button", changeBackground, "Mhen'ga", 2],
		3:["button", changeBackground, "Tarkus", 3],
		10:["back", "TiTSMenu"],
		11:["note", "Here you can load every places you can explore, as your background."]
	};
	menus.TiTSCreatureMenu = {
		9:["button", clearCreatures, "Clear all"],
		10:["back", "TiTSMenu"],
		11:["note", "Here you can load Creatures you encountered during your adventures. \r\rCreatures are placed at player height. You can drag and drop them, drop them outside to delete them, and clear them all."]
	};
	menus.TiTSDetailMenu = {
		0:["button", toggleItem, "Toggle Balls", "balls"],
		1:["button", toggleItem, "Toggle Gills", "gills"],
		2:["button", toggleItem, "Toggle Ovip", "ovi"],
		10:["back", "TiTSMenu"],
		11:["note", "Here you can shuffle your eye color, and save it for this character. You can also toggle various parts."]
	};
	menus.TiTSSliderMenu = {
		0:["slider", onTallSlide, "Height: Xft.", true],
		1:["slider", onBallSlide, "Ball size: Xin.", true],
		2:["slider", onClitSlide, "Clit length: Xin.", true],
		3:["select", cockChanger, "Choose Cock"],
		4:["slider", onCockSlide, "Cock Y: Xin.", true],
		5:["select", boobChanger, "Choose Row"],
		6:["slider", onBoobSlide, "Row Y rating: X", true],
		10:["back", "TiTSMenu"],
		11:["note", "To be sure everything looks fine, the viewer prevents extreme sizes, but here you can scale them up to your real size. If you have multiple breasts and dicks above the maximum size, you just have to select which one you desire to change."]
	};
	menus.TiTSNPCMenu = {
		0:["scroll", addNPCChar, removeNPCChar],
		9:["button", clearChars, "Clear all"],
		10:["back", "TiTSMenu"],
		11:["note", "Here you can add all the important characters you've encountered through your adventures. The menu supports shift and control clicking. You can also set the depth with the mouse wheel."]
	};
	menus.TiTSFoeMenu = {
		0:["scroll", addNPCChar, removeNPCChar],
		9:["button", clearChars, "Clear all"],
		10:["back", "TiTSMenu"],
		11:["note", "Here you can add the murderers, arsonists and jailwalkers you've encountered through your travels. Why would you do that? Not my problem. The menu supports shift and control clicking. You can also set the depth with the mouse wheel."]
	};
	menus.TiTSItemMenu = {
		0:["button", setWeapon, "Dagger", Dagger, 0],
		1:["button", setWeapon, "Hammer", Hammer, 1],
		9:["button", clearEquipment, "Clear all"],
		10:["back", "TiTSMenu"],
		11:["note", "Here you can equip some of the equipment you've gathered during your journey. You can add right and left hand weapons, and a few clothes."]
	};
	return (menus);
}

/**
 * Updates the TiTS menu tree data to match the current character.
 */
public function updateTiTSMenu():void
{
	updateSliders(menus.TiTSSliderMenu);
	
	getElement("TiTSNPCMenu", 0).data = NPCData;
	getElement("TiTSFoeMenu", 0).data = foeData;
}

/**
 * Inits the creator menu tree data.
 */
public function initCreatorMenu():Object
{
	var menus:Object = { };
	menus.creatorMenu = {
		0:["button", switchMenu, "Head", "headMenu"],
		1:["button", switchMenu, "Torso", "torsoMenu"],
		2:["button", switchMenu, "Genitals", "naughtyMenu"],
		3:["button", switchMenu, "Legs", "legsMenu"],
		4:["button", switchMenu, "Colors", "colorMenu"],
		5:["button", switchMenu, "Others", "otherMenu"],
		11:["note", "Here you can create your very own character, from scratch! Just cycle the parts you wish to change."]
	};
	menus.headMenu = {
		0:["arrows", cycle, "Face", ["face"]],
		1:["arrows", cycle, "Head", ["head"], true],
		2:["arrows", cycle, "Ears", ["ears"], true],
		3:["arrows", cycle, "Hair", ["hairFront", "hairBack"]],
		4:["arrows", cycle, "Horns", ["horns"], true],
		10:["back", "creatorMenu"],
		11:["note", "Here you can cycles heads, ears, hair and horns."]
	};
	menus.torsoMenu = {
		0:["arrows", cycle, "Body", ["body", "dark_body", "hips", "dark_hips", "legs", "dark_legs", "vag", "hand"], false, true],
		1:["arrows", cycle, "Arms", ["arms"], true],
		2:["arrows", cycle, "Wings", ["wings"], true],
		3:["arrows", cycle, "Row 1", ["boobs_0", "shade_0_0", "shade_1_0", "shade_2_0", "shade_3_0", "shade_4_0", "shade_5_0"]],
		4:["arrows", cycle, "Row 2", ["boobs_1", "dark_boobs_1", "shade_1_1", "shade_2_1", "shade_3_1", "shade_4_1", "shade_5_1"]],
		5:["arrows", cycle, "Row 3", ["boobs_2", "dark_boobs_2", "shade_2_2", "shade_3_2", "shade_4_2", "shade_5_2"]],
		6:["arrows", cycle, "Row 4", ["boobs_3", "dark_boobs_3", "shade_3_3", "shade_4_3", "shade_5_3"]],
		10:["back", "creatorMenu"],
		11:["note", "Here you can cycle breasts and nipples."]
	};
	menus.naughtyMenu = {
		0:["arrows", cycle, "Pussy", ["vag"], true],
		1:["arrows", cycle, "Clit", ["clit"], true],
		2:["arrows", cycle, "Balls", ["balls"]],
		3:["button", switchMenu, "Cocks", "cockMenu"],
		10:["back", "creatorMenu"],
		11:["note", "Here you can cycle genitals. To access the cock editing list, click \"Cocks\"."]
	};
	menus.cockMenu = {
		0:["arrows", cycle, "Cock 1", ["cock_0"]],
		1:["arrows", cycle, "Cock 2", ["cock_1"]],
		2:["arrows", cycle, "Cock 3", ["cock_2"]],
		3:["arrows", cycle, "Cock 4", ["cock_3"]],
		4:["arrows", cycle, "Cock 5", ["cock_4"]],
		5:["arrows", cycle, "Cock 6", ["cock_5"]],
		6:["arrows", cycle, "Cock 7", ["cock_6"]],
		7:["arrows", cycle, "Cock 8", ["cock_7"]],
		8:["arrows", cycle, "Cock 9", ["cock_8"]],
		9:["arrows", cycle, "Cock 10", ["cock_9"]],
		10:["back", "naughtyMenu"],
		11:["note", "Here you can cycle cock length and types."]
	};
	menus.legsMenu = {
		0:["arrows", cycle, "Legs", ["legs", "dark_legs"], true],
		1:["arrows", cycle, "Hips", ["hips", "dark_hips"], true],
		2:["arrows", cycle, "Butt", ["butt"], true],
		3:["arrows", cycle, "Tail", ["tail"], true],
		10:["back", "creatorMenu"],
		11:["note", ""]
	};
	menus.colorMenu = {
		0:["picker", setProperty, "eyeTint"],
		1:["select", setProperty, "Skin Type", skinTypesNames, "skinType"],
		2:["select", setProperty, "Skin Color", skinColorNames, "skinColor"],
		3:["select", setProperty, "Hair Color", hairColorNames, "hairColor"],
		10:["back", "creatorMenu"],
		11:["note", "Here set you skin, hair and eye color as well as your skin type."]
	}
	menus.otherMenu = {
		0:["button", toggleItem, "Toggle Gills", "gills"],
		1:["button", toggleItem, "Toggle Ovip", "ovi"],
		2:["button", toggleItem, "Toggle Balls", "balls"],
		3:["slider", onTallSlide, "Height: Xft.", true],
		10:["back", "creatorMenu"],
		11:["note", "Here you can toggle various parts."]
	};
	return (menus);
}

/**
 * Updates the creator menu mode and data, to find the current char.
 */
public function updateCreatorMenu():void
{
	if (getElement("creatorMenu", 0).isTiTS != isTiTS)
	{
		updateMenu(menus.creatorMenu);
		updateMenu(menus.headMenu);
		updateMenu(menus.torsoMenu);
		updateMenu(menus.naughtyMenu);
		updateMenu(menus.cockMenu);
		updateMenu(menus.legsMenu);
		updateMenu(menus.colorMenu);
		updateMenu(menus.otherMenu);
	}
	
	var prop:CharacterProperties = mainChar.properties;
	
	ViewerSlider(menus.otherMenu.getChildByName("3")).setSlider(40, 150, prop.tallness);
	
	getElement("colorMenu", 0).selectedColor = mainChar.eyeTint;
	getElement("colorMenu", 1).selectedIndex = -1;
	getElement("colorMenu", 2).selectedIndex = -1;
	getElement("colorMenu", 3).selectedIndex = -1;
	getElement("colorMenu", 1).prompt = "Skin";
	getElement("colorMenu", 2).prompt = prop.skinColor;
	getElement("colorMenu", 3).prompt = prop.hairColor;
}

/**
 * Sets the mode of every children of a Sprite.
 * @param	menu
 */
public function updateMenu(menu:Sprite):void
{
	var component:IViewerComponent;
	
	for (var i:int = menu.numChildren - 1; i >= 0; i--)
	{
		component = menu.getChildAt(i) as IViewerComponent;
		component.setMode(isTiTS);
		component.y += (isTiTS) ? -15 : 15;
	}
}

/**
 * Updates every sliders of one of the slider menu sprites.
 * @param	menu
 */
public function updateSliders(menu:Sprite):void
{
	var prop:CharacterProperties = mainChar.properties;
	
	getMenuElement(menu, 0).setSlider(40, 150, prop.tallness);
	getMenuElement(menu, 1).setSlider(7.0, Math.min(prop.realBallSize, 13.0) * int(prop.hasBalls));
	getMenuElement(menu, 2).setSlider(8.0, Math.min(prop.realClitSize, 33.0) * int(prop.hasBalls));
	
	var cockSelectData:Object = mainChar.bigCockArray;
	var boobSelectData:Object = mainChar.bigBoobArray;
	var cockSelect:ViewerSelect = getMenuElement(menu, 3);
	var boobSelect:ViewerSelect = getMenuElement(menu, 5);
	
	cockSlider = getMenuElement(menu, 4);
	boobSlider = getMenuElement(menu, 6);
	
	if (cockSelectData["Choose cock"])
	{
		cockSelect.enabled = true;
		cockSelect.data = cockSelectData;
		cockChanger([ -1]);
	}
	else
	{
		cockSelect.enabled = false;
		cockSlider.enabled = false;
	}
	if (boobSelectData["Choose row"])
	{
		boobSelect.enabled = true;
		boobSelect.data = boobSelectData;
		boobChanger([ -1]);
	}
	else
	{
		boobSelect.enabled = false;
		boobSlider.enabled = false;
		boobSlider.label = "";
	}
}

/**
 * Returns an element from a menu by name.
 * @param	menu
 * @param	number
 * @return
 */
public function getElement(menu:String, number:int):*
{
	return (menus[menu].getChildByName(number.toString()));
}

/**
 * Returns an element from a given menu.
 * @param	menu
 * @param	number
 * @return
 */
public function getMenuElement(menu:Sprite, number:int):*
{
	return (menu.getChildByName(number.toString()));
}

/**
 * Runs the garbadge collector in debug mode.
 * Only used with Monster Debugger to force garbadge collection.
 */
public function garbageCollector():void
{
	System.gc();
}

/**
 * Sets a home-made loading cursor.
 * Very very buggy thanks to Adobe, will need to check up tutorial.
 */
/*public function initMouse():void
{
	//http://www.techques.com/question/1-4610528/Optionally-use-Flash-10.2-cursors,-while-still-being-compatible-with-Flash-10.0
	var data:MouseCursorData = new MouseCursorData();
	data.frameRate = 24;
	data.hotSpot = new Point(9, 9);
	data.data = new Vector.<flash.display.BitmapData>([
		MouseBmp1,
		MouseBmp2,
		MouseBmp3,
		MouseBmp4,
		MouseBmp5,
		MouseBmp6,
		MouseBmp7,
		MouseBmp8,
		MouseBmp9,
		MouseBmp10
	]);
	Mouse.registerCursor("loading", data);
	Mouse.cursor = "loading";
}*/