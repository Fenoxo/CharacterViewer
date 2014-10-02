package classes.character
{
	import classes.ClassDictionary;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	import classes.ColorDictionary;
	
	/**
	 * Contains every colorable segments of a character, and color them on demand.
	 * @author Sbaf
	 */
	public class PartPainter 
	{
		private static var pool:Vector.<PartPainter> = new Vector.<PartPainter>;
		
		/**
		 * Returns a new or reseted PartPainter instance.
		 * @param	The ColorDictionary instance.
		 * @param	The current ClassDictionary, to get part types.
		 * @return
		 */
		public static function getNewPainter(colorDictionary:ColorDictionary, classDictionary:ClassDictionary):PartPainter
		{
			var painter:PartPainter;
			
			if (pool.length > 0)
			{
				painter = pool.pop();
			}
			else
			{
				painter = new PartPainter();
			}
			
			painter.init(colorDictionary, classDictionary);
			return (painter);
		}
		
		private var segmentsSkinFill:Dictionary;//The dictionary linking parts to their skinFill child.
		private var segmentsSkinShad:Dictionary;//The dictionary linking parts to their skinShade child.
		private var segmentsSkinDark:Dictionary;//The dictionary linking parts to their skinFill child if they are fully shaded.
		private var segmentsHairFill:Dictionary;//The dictionary linking parts to their hairFill child.
		private var segmentsHairShad:Dictionary;//The dictionary linking parts to their hairShade child.
		private var segmentsBitsFill:Dictionary;//The dictionary linking parts to their bitsFill child.
		private var segmentsBitsShad:Dictionary;//The dictionary linking parts to their bitsShade child.
		private var segmentsBitsDark:Dictionary;//The dictionary linking parts to their sbitsFill child if they are fully shaded.
		private var partReference:Dictionary;//The dictionary linking part names to their parts.
		private var darkReference:Dictionary;//The dictionary linking fully shaded parts to the true value.
		
		private var segmentEyes:MovieClip;//The current face's pupils.

		private var colorTransform:ColorTransform = new ColorTransform(0.0, 0.0, 0.0);//The painter's colorTransform.
		private var currentColorCodes:Vector.<uint>;//The current color codes, gotten from the ColorDictionary instance.
		private var colorDict:ColorDictionary;//The current ColorDictionary instance.
		private var classDict:ClassDictionary;//The current ClassDictionary instance.
		
		/**
		 * Returns a newly set PartPainter instance.
		 */
		public function PartPainter()
		{
			setAllSegmentsDicts();
		}
		
		/**
		 * Initiates the reseted instance.
		 * @param	colorDictionary
		 * @param	classDictionary
		 */
		public function init(colorDictionary:ColorDictionary, classDictionary:ClassDictionary)
		{
			colorDict = colorDictionary;
			classDict = classDictionary;
		}
		
		/**
		 * Resets and add the instance to the pool.
		 */
		public function dispose():void
		{
			resetAllSegmentsDicts();
			pool.push(this);
		}
		
		/**
		 * Initiates every segment dictionaries.
		 */
		private function setAllSegmentsDicts():void
		{
			segmentsSkinFill = new Dictionary(true);
			segmentsSkinShad = new Dictionary(true);
			segmentsSkinDark = new Dictionary(true);
			segmentsHairFill = new Dictionary(true);
			segmentsHairShad = new Dictionary(true);
			segmentsBitsFill = new Dictionary(true);
			segmentsBitsShad = new Dictionary(true);
			segmentsBitsDark = new Dictionary(true);
			partReference = new Dictionary(true);
			darkReference = new Dictionary(true);
		}
		
		/**
		 * Resets every segment dictionaries.
		 */
		private function resetAllSegmentsDicts():void
		{
			resetDict(segmentsSkinFill);
			resetDict(segmentsSkinShad);
			resetDict(segmentsSkinDark);
			resetDict(segmentsHairFill);
			resetDict(segmentsHairShad);
			resetDict(segmentsBitsFill);
			resetDict(segmentsBitsShad);
			resetDict(segmentsBitsDark);
			resetDict(partReference);
			resetDict(darkReference);
			currentColorCodes = null;
			segmentEyes = null;
		}
		
		/**
		 * Resets any given Dictionary object.
		 * Twice slower than creating a new one, but amazing memory substainability.
		 * @param	dict
		 */
		private function resetDict(dict:Dictionary)
		{
			for (var key:Object in dict)
			{
				delete (dict[key]);
			}
		}
		
		/**
		 * Adds a new part to the painter.
		 * @param	The name of the part, so it can be fetched later with getPart(). If null, the part will saved as an anonymous part.
		 * @param	The part, so its segments can be saved.
		 * @param	If the fill segments should be colored like the shaded ones.
		 * @param	The name of type, used to find the PartNames object, only needed for non-dictionary types.
		 */
		public function addPart(name:String, part:MovieClip, isDark:Boolean = false, type:String = null)
		{
			if (name != null) partReference[name] = part;
			
			if (type == null) type = classDict.getPartType(part);
			
			var segments:PartNames = colorDict.getChildrenNames(type);
			
			if (!segments)
			{
				throw new Error("Could not find the PartNames instance. Either use a name defined in DIC_ChildrenNames.json, or give one in the partName argument.");
			}
			if (isDark)
			{
				darkReference[part] = true;
				if (segments.SF) segmentsSkinDark[part] = getSegment(part, segments.SF);
				if (segments.BF) segmentsBitsDark[part] = getSegment(part, segments.BF);
			}
			else
			{
				if (segments.SF) segmentsSkinFill[part] = getSegment(part, segments.SF);
				if (segments.BF) segmentsBitsFill[part] = getSegment(part, segments.BF);
			}
			if (segments.SS) segmentsSkinShad[part] = getSegment(part, segments.SS);
			if (segments.BS) segmentsBitsShad[part] = getSegment(part, segments.BS);
			if (segments.HF) segmentsHairFill[part] = getSegment(part, segments.HF);
			if (segments.HS) segmentsHairShad[part] = getSegment(part, segments.HS);
			if (segments.EF) segmentEyes = getSegment(part, segments.EF);
		}
		
		/**
		 * Deletes a part given it's name.
		 * If the part is non-dictionary, a type must be given too.
		 * @param	Name of the part to delete.
		 * @param	Type of the part to delete.
		 */
		public function deletePart(name:String, type:String = null):void
		{
			var part:MovieClip = partReference[name];
			delete (partReference[name]);
			delete (darkReference[part]);
			
			delete (segmentsSkinDark[part]);
			delete (segmentsBitsDark[part]);
			delete (segmentsSkinFill[part]);
			delete (segmentsBitsFill[part]);
			delete (segmentsSkinShad[part]);
			delete (segmentsBitsShad[part]);
			delete (segmentsHairFill[part]);
			delete (segmentsHairShad[part]);
			
			if (type == null) type = classDict.getPartType(part);
			if (type == null) throw new Error("Type not found.");
			
			var segments:PartNames = colorDict.getChildrenNames(type);
			
			if (segments.EF) segmentEyes = null;
		}
		
		/**
		 * Deletes an anonymous part. Only the part is needed.
		 * @param	The part to delete.
		 */
		public function deleteAnonymousPart(part:MovieClip):void
		{
			delete (darkReference[part]);
			
			delete (segmentsSkinDark[part]);
			delete (segmentsBitsDark[part]);
			delete (segmentsSkinFill[part]);
			delete (segmentsBitsFill[part]);
			delete (segmentsSkinShad[part]);
			delete (segmentsBitsShad[part]);
			delete (segmentsHairFill[part]);
			delete (segmentsHairShad[part]);
		}
		
		/**
		 * Replaces a part reference by a new one.
		 * Check if the part is fully-shaded, and transfers the property.
		 * @param	Name of the part to replace.
		 * @param	The new part.
		 */
		public function replacePart(name:String, newPart:MovieClip):void
		{
			var isDark:Boolean = darkReference[partReference[name]];
			
			deletePart(name);
			addPart(name, newPart, isDark);
		}
		
		/**
		 * Replaces an anonymous part reference by a new one.
		 * Check if the part is fully-shaded, and transfers the property.
		 * @param	The old part.
		 * @param	The new part.
		 */
		public function replaceAnonymousPart(oldPart:MovieClip, newPart:MovieClip):void
		{
			var isDark:Boolean = darkReference[oldPart];
			
			deleteAnonymousPart(oldPart);
			addPart(null, newPart, isDark);
		}
		
		/**
		 * Gets a segment given its parent and name.
		 * Assumes that PartPool added every sub children (MC) as the part's properties.
		 * @param	The parent.
		 * @param	The name.
		 * @return	The segment.
		 */
		private function getSegment(part:MovieClip, childName:String):MovieClip
		{
			var child:DisplayObject = part[childName];
			
			if (child)
			{
				return (child as MovieClip);
			}
			
			throw new Error("Child not found, please check DIC_ChildrenNames.json and the corresponding draw function.")
		}
		
		/**
		 * Return a part given its name.
		 * @param	name
		 */
		public function getPart(name:String):MovieClip
		{
			return (partReference[name]);
		}
		
		/**
		 * Recolors a previously added part.
		 * @param	The part to color.
		 */
		public function colorPart(part:MovieClip):void
		{
			var colors:Vector.<uint> = currentColorCodes;
			colorSegment(segmentsSkinFill[part], colors[0]);
			colorSegment(segmentsSkinShad[part], colors[1]);
			colorSegment(segmentsSkinDark[part], colors[1]);
			colorSegment(segmentsHairFill[part], colors[2]);
			colorSegment(segmentsHairShad[part], colors[3]);
			colorSegment(segmentsBitsFill[part], colors[4]);
			colorSegment(segmentsBitsShad[part], colors[5]);
			colorSegment(segmentsBitsDark[part], colors[5]);
		}
		
		/**
		 * Colors a single segment, using a given color.
		 * @param	The segment to color.
		 * @param	The color to use.
		 */
		private function colorSegment(segment:MovieClip, color:uint):void
		{
			if (!segment) return;
			
			var ct:ColorTransform = colorTransform;
			ct.redOffset = color >> 16;
			ct.greenOffset = (color & 0xFF00) >> 8;
			ct.blueOffset = (color & 0xFF);
			
			segment.transform.colorTransform = ct;
		}
		
		/**
		 * Color every saved parts, given a color vector.
		 * @param	The color vector containing in order SkinFill, SkinShade, HairFill, HairShade, BitsFill, BitsShade and EyeColor color codes.
		 */
		public function colorAllParts(colors:Vector.<uint>):void
		{
			currentColorCodes = colors;
			
			colorAllSegments(segmentsSkinFill, colors[0]);
			colorAllSegments(segmentsSkinShad, colors[1]);
			colorAllSegments(segmentsSkinDark, colors[1]);
			colorAllSegments(segmentsHairFill, colors[2]);
			colorAllSegments(segmentsHairShad, colors[3]);
			colorAllSegments(segmentsBitsFill, colors[4]);
			colorAllSegments(segmentsBitsShad, colors[5]);
			colorAllSegments(segmentsBitsDark, colors[5]);
		}
		
		/**
		 * Colors an entire dictionary of segments given a single color.
		 * @param	The dictionary of segments to color.
		 * @param	The color code to use.
		 */
		private function colorAllSegments(segments:Dictionary, color:uint):void
		{
			var ct:ColorTransform = colorTransform;
			ct.redOffset = color >> 16;
			ct.greenOffset = (color & 0xFF00) >> 8;
			ct.blueOffset = (color & 0xFF);
			
			for each (var segment:MovieClip in segments)
			{
				segment.transform.colorTransform = ct;
			}
		}
		
		/**
		 * Colors, if necessary, the current face's pupils.
		 * @param	eyeColor
		 */
		public function colorPupils(eyeColor:String):void
		{
			if (eyeColor == "defined") return;
			
			var color:uint;
			
			if (eyeColor == "random")
			{
				color = Math.random() * 0xFFFFFF;
			}
			else
			{
				color = colorDict.getEyeColor(eyeColor);
			}
			
			colorSegment(segmentEyes, color);
		}
	}
}