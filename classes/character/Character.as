package classes.character
{
	import classes.character.layers.*;
	import classes.events.*
	import classes.utils.*
	import classes.save.*;
	import classes.*
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	/**
	 * MovieClip that receives a Creature object and a ViewerData object
	 * to construct, color and display a CoC or TiTS character.
	 * @author sb-af
	 */
	public final class Character extends Sprite
	{
		private var viewerData:ViewerData;
		private var characterData:CharacterData;
		
		private var classDict:ClassDictionary;
		private var colorDict:ColorDictionary;
		private var pool:PartPool;
		
		private var painter:PartPainter;
		private var player:Creature;
		private var prop:CharacterProperties;
		
		private var backLayer:BackLayer;
		private var backWeaponParent:Sprite;
		private var bodyLayer:BodyLayer;
		private var shaderLayer:ShaderLayer;
		private var frontLayer:FrontLayer;
		private var frontWeaponParent:Sprite;
		
		private var weapon:MovieClip = null;
		private var ct:ColorTransform = new ColorTransform();
		private var timeOutID:uint;
		
		public var standingPoint:Point = new Point(150, 792);
		public var middlePoint:Point = new Point(150, 350);
		
		public function Character() { }
		
		/**
		 * Initializes the character instance, given a creature instance and a viewer data instance.
		 * @param	The player data saved in a Creature object.
		 * @param	The viewerData object, containing every global viewer object.
		 */
		public function init(player:Creature, viewerData:ViewerData):void
		{
			this.classDict = viewerData.classDict;
			this.colorDict = viewerData.colorDict;
			this.pool = viewerData.partPool;
			this.name = player.short;
			
			this.painter = PartPainter.getNewPainter(colorDict, classDict);
			this.player = player;
			
			this.viewerData = viewerData;
			this.characterData = new CharacterData(painter, player);
			
			this.prop = characterData.prop;
			
			initLayers();
			initGraphics();
			
			player = null;
			characterData.prop = null;
			
			addEventListener(Event.REMOVED_FROM_STAGE, dispose);
		}
		
		/**
		 * Inits the containers, targets and mouse interactions.
		 */
		private function initLayers():void
		{
			backLayer = new BackLayer(viewerData, characterData);
			backWeaponParent = new Sprite();
			bodyLayer = new BodyLayer(viewerData, characterData);
			shaderLayer = new ShaderLayer(bodyLayer, characterData);
			frontLayer = new FrontLayer(viewerData, characterData);
			frontWeaponParent = new Sprite();
			
			addChild(backLayer);
			addChild(backWeaponParent);
			
			var bodyParent:Sprite = new Sprite();
			addChild(bodyParent);
			bodyParent.addChild(bodyLayer);
			bodyParent.addChild(shaderLayer);
			
			addChild(frontLayer);
			addChild(frontWeaponParent);
			
			mouseChildren = false;
			doubleClickEnabled = true;
			buttonMode = true;
		}
		
		/**
		 * Inits the drawing and coloring sequence.
		 */
		private function initGraphics():void
		{
			MCUtils.scale(this, 1 / prop.heightMod);
			
			backLayer.drawLayer();
			bodyLayer.drawLayer();
			frontLayer.drawLayer();
			
			updateEars();
			
			prop.finishedDrawing = true;
			colorCharacter();
			
			//Since updateCockIndex doesn't work with items not rendered
			//this seams to be necessary.
			timeOutID = setTimeout(bodyLayer.updateCockIndex, 50);
		}
		
		/**
		 * Disposes of the ShaderLayer object, the PartPainter object, and removes listeners.
		 * @param	event
		 */
		public function dispose(event:Event):void
		{
			clearTimeout(timeOutID);
			removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
			shaderLayer.dispose();
			painter.dispose();
		}
		
		/**
		 * Get the color codes from the color dictionary then feed them to the part painter for coloring.
		 * If necessary, reshade the character.
		 */
		public function colorCharacter():void
		{
			if (!prop.finishedDrawing) return;
			var colors:Vector.<uint> = colorDict.getColorCodes(	prop.skinColor,
																prop.hairColor,
																prop.skinType);
			painter.colorAllParts(colors);
			painter.colorPupils(prop.eyeColor);
			prop.eyeColor = "defined";
			
			shaderLayer.invalidate();
		}
		
		/**
		 * Cycles a part given it's name, a cycling ID, and an increment value.
		 * @param	direction
		 * @param	partName
		 * @param	updateBoobs
		 * @param	updateCocks
		 */
		public function cycle(partNames:Array, ID:int, increment:int = 1):void
		{
			if (increment != 1 && increment != -1)
				throw new Error("Increment must be 1 or -1.");
			
			for each (var name:String in partNames)
			{
				var prevPart:MovieClip = painter.getPart(name);
				
				if (prevPart == null)
				{
					dispatchEvent(new NoteEvent("Sorry, looks likes the part is not yet implemented.", false, true));
					continue;
				}
				var nextClass:Class = classDict.getNextClass(prevPart, ID, increment);
				
				if (Object(prevPart).constructor != nextClass)
				{
					setPartClass(name, nextClass);
				}
			}
		}
		
		/**
		 * Given a part name and indexes, sets the part's class.
		 * @param	Name of the part to change.
		 * @param	First index.
		 * @param	Second index.
		 * @param	Third index.
		 */
		public function setPartIndexes(name:String, j:int = -1, k:int = -1, l:int = -1):void
		{
			var part:MovieClip = painter.getPart(name);
			var indexes:Vector.<*> = classDict.getPartIndexes(part);
			
			var type:String = indexes[0];
			
			if (j == -1) j = indexes[1];
			if (k == -1) k = indexes[2];
			if (l == -1) l = indexes[3];
			
			if (j != indexes[1] || k != indexes[2] || l != indexes[3])
			{
				var partClass:Class = classDict.getClassUnsecured(type, j, k, l);
				
				if (!partClass)
					throw new Error("Indexes do not match any class of this type.");
				
				setPartClass(name, partClass);
			}
		}
		
		/**
		 * Sets the part class (should be of same type).
		 * @param	The part to change.
		 * @param	The class to set.
		 */
		public function setPartClass(name:String, nextClass:Class):void
		{
			var prevPart:MovieClip = painter.getPart(name);
			var nextPart:MovieClip = pool.getNew(nextClass);
			
			if (classDict.getPartType(prevPart) != classDict.getPartType(nextPart))
				throw new Error("NextClass must be of the same type as the part to replace.");
			
			painter.replacePart(name, nextPart);
			
			MCUtils.transferMask(prevPart, nextPart);
			MCUtils.transferMatrix(prevPart, nextPart);
			MCUtils.replaceChildren(prevPart, nextPart);
			
			if (prevPart.MC && nextPart.MC)
			{
				nextPart.MC.rotation = prevPart.MC.rotation;
			}
			
			updatePart(nextPart, prevPart);
		}
		
		/**
		 * Updates a part after setting its class.
		 * Will update ears indexes, nipple coloration, cock indexes, 
		 * @param	part
		 * @param	prevPart
		 */
		public function updatePart(part:MovieClip, prevPart:MovieClip):void
		{
			var type:String = classDict.getPartType(part);
			
			if (type == "hair") updateEars();
			
			if (type == "vag") updateClit(part);
			
			if (type == "clit") updateVag(part);
			
			if (type == "boobs")
			{
				bodyLayer.updateBoob(part, prevPart);
				bodyLayer.updateCockIndex();
			}
			
			if (prop.finishedDrawing)
			{
				painter.colorPart(part);
				shaderLayer.invalidate();
			}
		}
		
		/**
		 * Update the ear index when hair becomes too short ot too long,
		 * so that it uses the half-hidden or fully-shown part.
		 */
		private function updateEars():void
		{
			var hair:MovieClip = painter.getPart("hairFront");
			var length:int = classDict.getPartIndex(hair, 1);
			
			setPartIndexes("ears", -1, -1, (length > 2) ? 1 : 0);
		}
		
		/**
		 * If there is no vagina, set the clit length to 0.
		 * @param	part
		 */
		public function updateClit(part:MovieClip):void
		{
			if (classDict.getPartIndex(part, 1) == 0)
			{
				setPartIndexes("clit", -1, 0, -1);
			}
		}
		
		/**
		 * If there is a clit, set the vagina first index to 1.
		 * @param	part
		 */
		public function updateVag(part:MovieClip):void
		{
			if (classDict.getPartIndex(part, 2) > 0)
			{
				setPartIndexes("vag", 1);
			}
		}
		
		//Functions called outside the Character class.
		
		/**
		 * Set a new weapon. Currently works but may need rewrite to work with more weapons in more positions.
		 * @param	weaponName
		 * @param	weaponClass
		 * @param	armPos
		 */
		public function setWeapon(weaponClass:Class, armPos:int)
		{
			if (this.weapon != null)
				weapon.parent.removeChild(this.weapon);
			
			this.weapon = pool.getNew(weaponClass);
			
			if (armPos == 1)
				backWeaponParent.addChild(weapon);
			else
				frontWeaponParent.addChild(weapon);
		
			var arms:MovieClip = painter.getPart("arms");
			var indexes:Vector.<*> = classDict.getPartIndexes(arms);
			
			setPartIndexes("arms", -1, armPos, -1);
		}
		
		/**
		 * Clear every equipment the character may wear.
		 * @param	btnName
		 */
		public function clearEquipment():void
		{
			if (weapon)
			{
				weapon.parent.removeChild(weapon);
				weapon = null;
				setPartIndexes("arms", -1, 0, -1);
			}
		}
		
		/**
		 * Add a new temporary goo shader.
		 * Logic should be moved inside ShaderLayer.
		 * @param	Scale of new shader.
		 */
		public function addTemporaryGooShader(scale:Number)
		{
			shaderLayer.hideActiveShader();
			shaderLayer.addGooShader(scale / scaleX, true);
		}
		
		/**
		 * Remove any temporary shader.
		 * Logic should be moved inside ShaderLayer.
		 */
		public function removeTemporaryShader()
		{
			shaderLayer.removeShader(true);
			shaderLayer.showActiveShader();
		}
		
		/**
		 * Toggle an item's visibility given its name.
		 * @param	btnName
		 */
		public function toggleItem(itemName:String):void
		{
			var target:MovieClip = painter.getPart(itemName);
			if (target)
			{
				target.visible = !target.visible;
				shaderLayer.invalidate();
			}
		}
		
		/**
		 * Invalidate current shader.
		 */
		public function updateShader():void
		{
			shaderLayer.invalidate();
		}
		
		/**
		 * Returns a part given it's name.
		 * @param	Name of the part to get.
		 * @return
		 */
		public function getPart(name:String):MovieClip
		{
			return (painter.getPart(name));
		}
		
		/**
		 * Set the character's skinType ID and recolor.
		 * @param	The new skinType.
		 */
		public function set skinType(type:int):void
		{
			trace("Changed skin type to " + type);
			prop.skinType = type;
			colorCharacter();
		}
		
		/**
		 * Get the character's skinType ID.
		 */
		public function get skinType():int
		{
			return (prop.skinType);
		}
		
		/**
		 * Set the character's hairColor name and recolor.
		 * @param	The new hair color.
		 */
		public function set hairColor(color:String):void
		{
			trace("Changed hair color to " + color);
			prop.hairColor = color;
			colorCharacter();
		}
		
		/**
		 * Get the character's hairColor name.
		 */
		public function get hairColor():String
		{
			return (prop.hairColor);
		}
		
		/**
		 * Set the character's skin tone name and recolor.
		 * @param	The new skin tone.
		 */
		public function set skinColor(color:String):void
		{
			trace("Changed skin color to " + color);
			prop.skinColor = color;
			colorCharacter();
		}
		
		/**
		 * Get the character's skin tone name.
		 */
		public function get skinColor():String
		{
			return (prop.skinColor);
		}
		
		/**
		 * Set the character's eyes tint value and recolor.
		 * @param	The new eye color code.
		 */
		public function set eyeTint(color:uint):void
		{
			ct.color = color;
			var tar:MovieClip = painter.getPart("face").pupils;
			tar.transform.colorTransform = ct;
			prop.eyeColor = "defined";
		}
		
		/**
		 * Return the eye tint color code.
		 */
		public function get eyeTint():uint
		{
			return (painter
					.getPart("face")
					.pupils
					.transform
					.colorTransform
					.color);
		}
		
		/**
		 * Returns a list of every scalable cocks, to be fed inside a ViewerSelect object.
		 */
		public function get bigCockArray():Object
		{
			var data:Object = { };
			
			for (var i:int = 0; i < player.cocks.length; i++)
			{
				var length:Number = player.cocks[i].cockLength * prop.heightMod;
				if (length >= 27)
				{
					data["Cock " + (i + 1)] = [i, length];
					data["Choose Cock"] = [ -1];
				}
			}
			
			return data;
		}
		
		/**
		 * Returns a list of every scalable boobs, to be fed inside a ViewerSelect object.
		 */
		public function get bigBoobArray():Object
		{
			var data:Object = [];
			
			for (var i:int = 0; i < player.breastRows.length; i++)
			{
				var rating:Number = player.breastRows[i].breastRating * prop.heightMod;
				if (rating >= 80)
				{
					data["Row " + (i + 1)] = [i, rating];
					data["Choose Row"] = [ -1];
				}
			}
			return data;
		}
		
		/**
		 * Returns the CharacterProperties object used.
		 */
		public function get properties():CharacterProperties
		{
			return (prop);
		}
		
		/**
		 * Sets the X value of the standing point inside charactersParent object.
		 */
		public function set standingX(value:Number):void
		{
			this.x = value - this.standingPoint.x * this.scaleX;
		}
		
		/**
		 * Returns the X value of the standing point inside charactersParent object.
		 */
		public function get standingX():Number
		{
			return (this.x + this.standingPoint.x * this.scaleX);
		}
		
		/**
		 * Sets the Y value of the standing point inside charactersParent object.
		 */
		public function set standingY(value:Number):void
		{
			this.y = value - this.standingPoint.y * this.scaleY;
		}
		
		/**
		 * Returns the Y value of the standing point inside charactersParent object.
		 */
		public function get standingY():Number
		{
			return (this.y + this.standingPoint.y * this.scaleY);
		}
		
		/**
		 * Sets the X value of the middle point inside charactersParent object.
		 */
		public function set middleX(value:Number):void
		{
			this.x = value - this.middlePoint.x * this.scaleX;
		}
		
		/**
		 * Returns the X value of the middle point inside charactersParent object.
		 */
		public function get middleX():Number
		{
			return (this.x + this.middlePoint.x * this.scaleX);
		}
		
		/**
		 * Sets the Y value of the middle point inside charactersParent object.
		 */
		public function set middleY(value:Number):void
		{
			this.y = value - this.middlePoint.y * this.scaleY;
		}
		
		/**
		 * Returns the Y value of the middle point inside charactersParent object.
		 */
		public function get middleY():Number
		{
			return (this.y + this.middlePoint.y * this.scaleY);
		}
		
		/**
		 * Returns the array containing every cock names.
		 */
		public function get cockNames():Array
		{
			return(BodyLayer.cockNames);
		}
		
		/**
		 * Returns the array containing every boob names.
		 */
		public function get boobNames():Array
		{
			return(BodyLayer.boobNames);
		}
	}
}