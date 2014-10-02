package classes 
{
	import com.ColorJizz.Hex;
	import com.ColorJizz.CIELab;
	import com.ColorJizz.HSV;
	import com.ColorJizz.RGB;
	import flash.utils.Dictionary;
	import classes.character.PartNames;

	/**
	 * ...
	 * @author Sbaf
	 */
	public class ColorDictionary 
	{
		[Embed(source = "./../data/DIC_HairColor.json", mimeType='application/octet-stream')]
		private static const HairColor:Class;
		[Embed(source = "./../data/DIC_SkinColor.json", mimeType='application/octet-stream')]
		private static const SkinColor:Class;
		[Embed(source = "./../data/DIC_BitsColor.json", mimeType='application/octet-stream')]
		private static const BitsColor:Class;
		[Embed(source = "./../data/DIC_EyesColor.json", mimeType='application/octet-stream')]
		private static const EyesColor:Class;
		[Embed(source = "./../data/DIC_ChildrenNames.json", mimeType='application/octet-stream')]
		private static const ChildrenNames:Class;
		
		private var skinColorDict:Object;
		private var hairColorDict:Object;
		private var bitsColorDict:Object;
		private var eyesColorDict:Object;
		private var skinShadeDict:Object;
		private var hairShadeDict:Object;
		private var bitsShadeDict:Object;
		
		private var elementsNames:Object;
		private var dictLengthDict:Object;
		
		public function ColorDictionary()
		{
			
		}
		
		/**
		 * Parse the dictionaries using the revivers.
		 * Mathematically deduces shades and missing bits colors.
		 */
		public function init()
		{
			dictLengthDict = new Dictionary(true);
			skinColorDict = JSON.parse(new SkinColor(), uintReviver);
			hairColorDict = JSON.parse(new HairColor(), uintReviver);
			bitsColorDict = JSON.parse(new BitsColor(), uintReviver);
			eyesColorDict = JSON.parse(new EyesColor(), uintReviver);
			
			completeBitsDictionary();
			createShadeDictionaries();
			
			elementsNames = JSON.parse(new ChildrenNames(), namesReviver);
		}
		
		/**
		 * Get the color codes given skinColor, hairColor and skinType.
		 * @param	The name of the skin tone.
		 * @param	The name of the hair color.
		 * @param	The skin type code.
		 */
		public function getColorCodes(skinColor:String, hairColor:String, skinType:int)
		{
			var colors:Vector.<uint> = new Vector.<uint>(6, true);
			
			if (!skinColorDict[skinColor])
			{
				trace("WARNING: skin color not found:", skinColor);
				skinColor = "white";
			}
			if (!hairColorDict[hairColor])
			{
				trace("WARNING: hair color not found:", hairColor);
				hairColor = "red";
			}
			
			colors[2] = hairColorDict[hairColor];
			colors[3] = hairShadeDict[hairColor];
			
			if (skinType == 1)
			{
				colors[0] = attenuate(colors[2], 0.82);
				colors[1] = attenuate(colors[3], 0.82);
				colors[4] = interpolate(bitsColorDict[skinColor], colors[0], 0.5);
				colors[5] = interpolate(bitsShadeDict[skinColor], colors[1], 0.5);
			}
			else
			{
				colors[0] = skinColorDict[skinColor];
				colors[1] = skinShadeDict[skinColor];
				colors[4] = bitsColorDict[skinColor];
				colors[5] = bitsShadeDict[skinColor];
			}
			return (colors);
		}
		
		/**
		 * Returns the name of the segments for a particuliar type.
		 * @param	The name of the part.
		 * @return
		 */
		public function getChildrenNames(partName:String):PartNames
		{
			return (elementsNames[partName]);
		}
		
		/**
		 * Will loops through the skin color dictionary and find every color
		 * that doesn't have a bits dictionary equivalent, replacing them
		 * with a temporary mathematically deduced color code.
		 */
		private function completeBitsDictionary():void
		{
			bitsColorDict = {};
			
			for (var key:String in skinColorDict)
			{
				if (!bitsColorDict[key])
				{
					bitsColorDict[key] = shade(skinColorDict[key]);
				}
			}
			
			function shade(hex:uint):uint
			{
				var color:HSV = new Hex(hex).toHSV();
				
				color.s = color.s * 1.1;
				color.v = color.v * 0.7;
				
				return (color.toHex().hex);
			}
		}
		
		/**
		 * Creates three objects, linking ingame color names to their shaded hexadecimal color code.
		 * It uses basic color math to obtain a colder, darker and slightly more saturated color than
		 * the original.
		 */
		private function createShadeDictionaries():void
		{
			skinShadeDict = {};
			hairShadeDict = {};
			bitsShadeDict = {};
			var key:String;
			for (key in skinColorDict) skinShadeDict[key] = shade(skinColorDict[key]);
			for (key in hairColorDict) hairShadeDict[key] = shade(hairColorDict[key]);
			for (key in bitsColorDict) bitsShadeDict[key] = shade(bitsColorDict[key]);
			
			function shade(hex:uint):uint
			{
				var color:RGB = new Hex(hex).toRGB();
				
				color.r = Math.max((color.r - 5) * 0.7 * 1.1, 0);
				color.g = Math.max((color.g - 5) * 0.7 * 0.9, 0);
				color.b = Math.max((color.b - 5) * 0.7 * 1.1, 0);
				
				return (color.toHex().hex);
			}
		}
		
		/**
		 * Creates two objects to be fed to the ComboBox constructor,
		 * linking the displayed color name to the ingame color name.
		 */
		public function getColorNameDictionaries():Array
		{
			var skinColorNames:Object = { };
			var hairColorNames:Object = { };
			
			for (var key in skinColorDict)
			{
				skinColorNames[key] = key;
			}
			
			delete skinColorNames["aphotic blue-black"];
			skinColorNames["aphotic blue"] = "aphotic blue-black";
			
			for (key in hairColorDict)
			{
				hairColorNames[key] = key;
			}
			
			delete hairColorNames["platinum blonde"];
			hairColorNames["platinum"] = "platinum blonde";
			
			return ([skinColorNames, hairColorNames]);
		}
		
		/**
		 * A reviver is a function that receives a key and a JSON parsed elements, in this case strings,
		 * and returns the actual elements that will be saved, in this case, hexadecimal color values.
		 * This one also saves the length of the final object in a dictionary.
		 * @param	The key of the JSON element.
		 * @param	The parsed element.
		 * @return	The element casted as hexadecimal.
		 */
		private function uintReviver(k:String, src:*):*
		{
			if (k)
			{
				return (uint(src));
			}
			
			var i:int = 0;
			for each (var color:uint in src)
			{
				i++;
			}
			dictLengthDict[src] = i;
			return (src);
		}
		
		/**
		 * The reviver for the ChildrenName JSON file.
		 * Converts parsed objects to PartNames.
		 * @param	k
		 * @param	src
		 * @return
		 */
		private function namesReviver(k:String, src:*):*
		{
			if (k && !(src is String))
			{
				return (new PartNames(src));
			}
			return (src);
		}
		
		/**
		 * Returns an interpolation of two colors, weighted by a progress factor.
		 * Uses CIELab for perfect accuracy, a bit overkill.
		 * @param	The first color.
		 * @param	The second color.
		 * @param	The weigth of the second color in the result.
		 */
		private function interpolate(colorFrom:uint, colorTo:uint, progress:Number)
		{
			var coFrom:CIELab = new Hex(colorFrom).toCIELab();
			var coTo:CIELab = new Hex(colorTo).toCIELab();
			
			coFrom.a += progress * (coTo.a - coFrom.a);
			coFrom.b += progress * (coTo.b - coFrom.b);
			coFrom.l += progress * (coTo.l - coFrom.l);
			
			return (coFrom.toHex().hex);
		}
		
		/**
		 * Reduces value and saturation of any given color, by a given amount.
		 * Amount should be smaller than 1, or inverse effect will happen.
		 * Amount should be positive, or 0x000000 will be returned.
		 * @param	color
		 * @param	amount
		 * @return
		 */
		private function attenuate(color:uint, amount:Number):uint
		{
			var hsv:HSV = new Hex(color).toHSV();
			hsv.s *= amount;
			hsv.v *= Math.sqrt(amount);
			return (hsv.toHex().hex);
		}
		
		
		/**
		 * Gets the pupils color code given the eye color name.
		 * Only used for TiTS.
		 * @param	colorName
		 * @return
		 */
		public function getEyeColor(colorName:String):uint
		{
			if (eyesColorDict.hasOwnProperty(colorName))
			{
				return (eyesColorDict[colorName]);
			}
			return (eyesColorDict["blue"]);
		}
		
		/**
		 * Returns a random color name, given a color dictionary.
		 * Pretty slow, but only fastest way would be to have color arrays.
		 * @param	dict
		 * @return
		 */
		private function getRandomDictKey(dict:Object):String
		{
			var length:int = dictLengthDict[dict];
			if (length == 0)
				throw new Error("Could not find dictionary length.");
			var index:int = length * Math.random();
			
			for (var key:String in dict)
			{
				if (index == 0)
				{
					return (key);
				}
				index --;
			}
			throw new Error("Saved length doesn't match real length. Do not modify the dictionary under any circumstances.");
		}
		
		/**
		 * Returns a random hair color name.
		 * @return
		 */
		public function getRandomHairColor():String
		{
			return (getRandomDictKey(hairColorDict));
		}
		
		/**
		 * Returns a random skin color name.
		 * @return
		 */
		public function getRandomSkinColor():String
		{
			return (getRandomDictKey(skinColorDict));
		}
		
		/**
		 * Returns a random eye color name.
		 * @return
		 */
		public function getRandomEyeColor():String
		{
			return (getRandomDictKey(eyesColorDict));
		}
	}
}