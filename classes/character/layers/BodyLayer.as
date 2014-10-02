package classes.character.layers {
	import classes.character.CharacterData;
	import classes.character.CharacterProperties;
	import classes.character.PartPainter;
	import classes.PartPool;
	import classes.save.Creature;
	import classes.SaveTranslator;
	import classes.utils.ArrayUtils;
	import classes.utils.MCUtils;
	import classes.ClassDictionary;
	import classes.ViewerData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * The main layer. It is the only shaded layer and contains most parts.
	 * @author 
	 */
	public class BodyLayer extends AbstractLayer
	{
		public static const cockNames:Array = ["cock_0", "cock_1", "cock_2", "cock_3", "cock_4", "cock_5", "cock_6", "cock_7", "cock_8", "cock_9"];
		public static const boobNames:Array = ["boobs_0", "boobs_1", "boobs_2", "boobs_3"];
		public static const leftNippleNames:Array = ["leftNipple_0", "leftNipple_1", "leftNipple_2", "leftNipple_3"];
		public static const rightNippleNames:Array = ["rightNipple_0", "rightNipple_1", "rightNipple_2", "rightNipple_3"];
		public static const cockOrigin:Point = new Point(151.0, 367.0);
		
		public function BodyLayer(viewerData:ViewerData, characterData:CharacterData) 
		{
			super(viewerData, characterData);
		}
		
		/**
		 * Call one by one every drawing function, in order.
		 */
		override public function drawLayer():void
		{
			//addPart("wings", player.wingType)
			addPart("arms", player.armType);
			addAss();
			addPart("legs", prop.masculine, player.lowerBody);
			addBody();
			addPart("head", prop.masculine);
			addFace();
			addHips();
			addPart("hand", prop.masculine, prop.skinType);
			addVag();
			addClit();
			addBalls();
			addBoobs();
			addCocks();
			//addPart("gills", 0);
			//addPart("ovi", int(player.canOviposit()));	
			
			setBoobShadows();
			super.drawLayer();
		}
		
		private function addFace():void
		{
			var u:int = 2 - Math.floor(player.femininity / 34);
			
			var foundPart:MovieClip = classDict.findPart("face", 0, u, 0);
			painter.addPart("face", foundPart);
			addChild(foundPart);
		}
		
		private function addBody():void
		{
			var n:int = (player.tone >= 50) ? 1 : 0;
			
			var foundPart:MovieClip = classDict.findPart("body", prop.skinType, prop.masculine, n);
			painter.addPart("body", foundPart);
			addChild(foundPart);
		}
		
		private function addHips():void
		{
			var u:int = translator.getRealHipsIndex(player.hipRating);
			
			var foundPart:MovieClip = classDict.findPart("hips", prop.masculine, u);
			painter.addPart("hips", foundPart);
			addChild(foundPart);
		}
		
		private function addAss():void
		{
			var u:int = translator.getRealAssIndex(player.buttRating);
			
			var foundPart:MovieClip = classDict.findPart("butt", u);
			painter.addPart("butt", foundPart);
			addChild(foundPart);
		}
		
		private function addVag():void
		{
			var u:int = int(prop.hasVag);
			var n:int = prop.masculine;
			
			var foundPart:MovieClip = classDict.findPart("vag", u, n);
			painter.addPart("vag", foundPart);
			addChild(foundPart);
		}
		
		/**
		 * Adds and color the clit part, if the player has a clit and a vag.
		 * Sets the clit-related properties. This could be moved to CharProperties.
		 */
		private function addClit():void
		{
			var n:int = lim(prop.realClitSize, 0, 8) * int(prop.hasVag);
			
			var foundPart:MovieClip = classDict.findPart("clit", 0, n);
			addChild(foundPart);
			painter.addPart("clit", foundPart);
			
			prop.hasClit = (n > 0);
			prop.hasBigClit = (n == 8);
		}
		
		/**
		 * Adds the ball parts. If the balls are big enough, generate a scalable part.
		 * This could be replaced by a part with a MC inside, like for cocks, boobs, clit etc.
		 * However, given that there are non-scalable parts that need to be colored, it could be hard.
		 */
		private function addBalls():void
		{
			var u:int = lim(prop.realBallSize, 0, 8) * int(prop.hasBalls)
			
			if (u < 8)
			{
				var foundPart:MovieClip = classDict.findPart("balls", prop.skinType, 0, u);
				painter.addPart("balls", foundPart);
				addChild(foundPart);
			}
			else
			{
				var balls = pool.getNew(NormalBallsSc);
				var scale = pool.getNew(NormalBallsScMC);
				
				addChild(balls);
				balls.addChild(scale);
				
				scale.x = 159,65;
				scale.y = 373, 15;
				
				painter.addPart("balls", balls, false, "balls");
				painter.addPart("ballsMC", scale, false, "balls");
				scale.name = "MC";
				balls["MC"] = scale;
			}
		}
		
		/**
		 * Adds and color every player cocks up to 10, and adds placeholder ones up to 10.
		 * Could be simplified, but to little gain.
		 */
		private function addCocks():void
		{
			var cockNum:int = player.cocks.length;
			var cockParent:MovieClip = new MovieClip();
			
			ArrayUtils.randomize(player.cocks);
			
			var rotationRatio:Number = 1 - Math.pow(4, -0.3 * cockNum);//Approaches 1 when cockNum grows
			var minRotation:Number = -19 * rotationRatio;
			var maxRotation:Number = 25 * rotationRatio;
			var rotationRange:Number = maxRotation - minRotation;
			
			for (var i:int = 0; i < cockNum; i++)
			{
				var u:int = translator.getRealCockIndex(player.cocks[i].cockLength * prop.heightMod);
				var n:int = player.cocks[i].cockType;
				
				var foundPart:MovieClip = classDict.findPart("cock", n, u);
				
				painter.addPart(cockNames[i], foundPart);
				cockParent.addChild(foundPart);
				
				foundPart.MC.rotation = (Math.random() * rotationRange + minRotation);
				foundPart.x = -foundPart.MC.rotation / 10;
				
				if (u != 9)
				{
					foundPart.MC.scaleX = 1.0 - Math.abs(i - (cockNum / 2)) / 20;
					foundPart.MC.scaleY = 1.0 + (foundPart.MC.rotation - minRotation) / (10 * rotationRange);
				}
				else
				{
					foundPart.MC.scaleX = 1.0;
					foundPart.MC.scaleY = 1.0;
				}
			}
			
			for (i; i < 10; i++)
			{
				foundPart = classDict.findPart("cock", 0, 0);
				painter.addPart(cockNames[i], foundPart);
				
				foundPart.MC.rotation = -19 + Math.random() * 34;
				
				cockParent.addChild(foundPart);
			}
			
			addChild(cockParent);
			painter.addPart("cockParent", cockParent, false, "parent");
		}
		
		/**
		 * Adds and color 4 breasts rows. If the player doesn't have that many rows, placeholders are put in place.
		 * To respect indexes, the rows are added in reverse order.
		 */
		private function addBoobs():void
		{
			var nipLen:int = lim(player.nippleLength * 4, 0, 7);
			var definedLength:int = player.breastRows.length;
			var boob:MovieClip;
			var boobMask:MovieClip;
			var foundPart:MovieClip;
			var u:int;
			for (var n:int = 3; n >= 0; n--)
			{
				if (player.breastRows[n])
				{
					u = translator.getRealBoobIndex(player.breastRows[n].breastRating * prop.heightMod);
				}
				else
				{
					u = 0;
				}
				
				foundPart = classDict.findPart("boobs", (n == 0) ? 0 : 1 , u, nipLen);
				
				painter.addPart(boobNames[n], foundPart);
				addChild(foundPart);
				setBoobPos(n, foundPart);
				
				boob = foundPart;
				
				if (u == 10)
				{
					boob = boob.MC;
					MCUtils.scale(boob, 1.0);
				}
				foundPart = boob.leftNipple;
				painter.addPart(leftNippleNames[n], foundPart);
				
				foundPart = boob.rightNipple;
				painter.addPart(rightNippleNames[n], foundPart);
			}
		}
		
		/**
		 * Sets the shadows for every rows.
		 */
		private function setBoobShadows():void
		{
			setPartShadow(0, "boobs_1", "boobs_0");//Under boobs_0, above boobs_1
			setPartShadow(1, "boobs_2", "boobs_1", "boobs_0");//Under boobs_1, above boobs_2
			setPartShadow(2, "boobs_3", "boobs_2", "boobs_1", "boobs_0");//Under boobs_2, above boobs_3
			setPartShadow(3, "body", "boobs_3", "boobs_2", "boobs_1", "boobs_0");//Under boobs_3, above body
			setPartShadow(4, "legs", "boobs_3", "boobs_2", "boobs_1", "boobs_0");//Under boobs_3, above legs
			setPartShadow(5, "hips", "boobs_3", "boobs_2", "boobs_1", "boobs_0");//Under boobs_3, above hips
		}
		
		/**
		 * Using a layer number, a part name, and the list of all parts that cast a shadow on it,
		 * this function will add a fully shaded version of the part on top of it, then
		 * mask it with a sprite representing the shadows of the rows above.
		 * 
		 * Any system could be better, but there are no other systems.
		 * 
		 * Problems include:
		 * Ugly white pixel above shaded parts.
		 * This is caused by the upper limit of both the shaded part and the un-shaded part being
		 * on the same pixels. Since both are cached as bitmap, the alpha value mixes and you get
		 * clearer pixels. No current solution.
		 * 
		 * Weird mask XOR stuff.
		 * Masks interact with each other (damn adobe you scary), and negate other parts' mask for
		 * some reason. Needs more testing. Solution is to cache evrything as bitmap.
		 * 
		 * @param	Under which row the mask with be placed.
		 * @param	The part that will be shaded.
		 * @param	Every parts that could cast a shadow on the shaded part.
		 * @return
		 */
		private function setPartShadow(height:int, targetName:String, ...names):Sprite
		{
			var len:int = names.length;
			var parent:Sprite = new Sprite();
			var target:MovieClip = setDarkPart(targetName);
			
			for (var i:int = 0; i < len; i++)
			{
				var name:String = names[i];
				var part:MovieClip = painter.getPart(name);
				var index:int = classDict.getPartIndex(part, 2);
				
				var foundPart:MovieClip = classDict.findPart("shade", index);
				painter.addPart("shade_" + height + "_" + (len - i - 1), foundPart);//!!!
				parent.addChild(foundPart);
				
				MCUtils.transferMatrix(part, foundPart);
				foundPart.cacheAsBitmap = true;
			}
			//parent.cacheAsBitmap = true;
			target.mask = parent;
			addChild(parent);
			return (parent);
		}
		
		/**
		 * Retrieve the shaded clone of any part given its name.
		 * Colors it and adds it at the right index and coordinates too.
		 * @param	The name of the part to clone.
		 * @return
		 */
		private function setDarkPart(name:String):MovieClip
		{
			var darkName:String = "dark_" + name;
			var clearPart:MovieClip = painter.getPart(name);
			var darkPart:MovieClip = classDict.clonePart(clearPart);
			var index:int = getChildIndex(clearPart) + 1;
			
			painter.addPart(darkName, darkPart, true);
			addChildAt(darkPart, index);
			
			MCUtils.transferMatrix(clearPart, darkPart);
			
			if (classDict.getPartType(darkPart) == "boobs")
			{
				if (classDict.getPartIndex(darkPart, 2) == 10)
				{
					MCUtils.scale(darkPart.MC, 1.0);
				}
				
				painter.addPart(null, darkPart.leftNipple, true);
				painter.addPart(null, darkPart.rightNipple, true);
				//darkPart.y = clearPart.y - 0.5;
				//darkPart.x = clearPart.x - 0.01;
			}
			else
			{
				//darkPart.y = -0.5;
				//darkPart.x = -0.01;
			}
			
			//darkPart.scaleX = 1.0000001
			
			darkPart.cacheAsBitmap = true;
			clearPart.cacheAsBitmap = true;
			return (darkPart);
		}
		
		/**
		 * Sets the position of a boob row depending on its number.
		 * A major function once, only used for addBoobs now.
		 * @param	val
		 * @param	target
		 */
		private function setBoobPos(val:int, target:MovieClip):void
		{
			target.y = [0, 19.9, 49.45, 85.55][val];
			target.x = [0, 24.95, 29.7, 16.30][val];
			target.rotation = [0, 6.5, 7.5, 5.5][val];
		}
		
		/**
		 * Transfer nipple shading from one boob to another.
		 * Trigger updateCockIndex.
		 * @param	part
		 * @param	prevPart
		 */
		public function updateBoob(part:MovieClip, prevPart:MovieClip):void
		{
			painter.replaceAnonymousPart(prevPart.leftNipple, part.leftNipple);
			painter.replaceAnonymousPart(prevPart.rightNipple, part.rightNipple);
			
			painter.colorPart(part.leftNipple);
			painter.colorPart(part.rightNipple);
		}
		
		/**
		 * Updates the placement of the cock parent, so that boobs do not pass under the base.
		 * @param	event
		 */
		public function updateCockIndex():void
		{
			var index:int = numChildren -  1;
				
			var point:Point = localToGlobal(cockOrigin);
			
			for (var i:int = 0; i < 4; i++)
			{
				var boob:MovieClip = painter.getPart(boobNames[i]);
				
				if (boob.hitTestPoint(point.x, point.y, true))
				{
					index = getChildIndex(boob);
					trace("index gotten");
				}
			}
			var cockParent:MovieClip = painter.getPart("cockParent");
			
			trace(numChildren, numChildren);
			setChildIndex(cockParent, index);
		}
		
		/*private function addHorns():void
		{
			var foundPart:MovieClip = classDict.findPart("horns",player.hornType);
			addChild(foundPart);
			
			painter.addPart("horns", foundPart);
			if (player.antennae > 0)
			{
				foundPart = classDict.findPart("horns", 6);
				painter.addPart("antennae", foundPart);
				addChild(foundPart);
			}
		}*/
	}
}