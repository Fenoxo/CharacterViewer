package classes 
{
	import classes.PartPool;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Sbaf
	 */
	public class ClassDictionary
	{
		private var dictionary:Object;					//Link types and indexes to classes
		private var reversedDictionary:Object;			//Link classes to types and indexes
		private var defaulterDictionary:Object;			//Link types to the order of indexes to default
		private var cyclerDictionary:Object;			//Link types to the indexes to increment/decrement
		private var pool:PartPool;						//Hols unused part objects
		
		/**
		 * ClassDictionary constructor.
		 * @param	A class representing an embedded JSON string linking indexes to class names.
		 * @param	A class representing an embedded JSON string linking part types to the order in which the indexes should be defaulted.
		 * @param	A pool containing parts while they are not in use.
		 */
		public function ClassDictionary(source:Class, defaulter:Class, cycler:Class, partPool:PartPool) 
		{
			pool = partPool;
			
			dictionary = JSON.parse(new source(), classDictionaryReviver);
			
			//Parse the JSON defaulter file with its reviver
			defaulterDictionary = JSON.parse(new defaulter(), defaulterReviver);
			
			//Parse the JSON cycler file with its reviver
			cyclerDictionary = JSON.parse(new cycler(), cyclerReviver);
			
			//Create an object linking a class name with its indexes.
			reversedDictionary = getReversedDictionary();
		}
		
		/**
		 * Attempt to return a class instance from a type and indexes.
		 * @param	Type of searched class.
		 * @param	First index of searched class.
		 * @param	Second index of searched class.
		 * @param	Third index of searched class.
		 * @return
		 */
		public function findPart(type:String, j:int = 0, k:int = 0, l:int = 0):MovieClip
		{
			//Test if the class exists
			var testResult:int = testClass(type, j, k, l);
			//If the type isn't defined, throw an Error
			if (testResult == 2)
				throw new Error("Part type not found: " + type);
			//If the class still isn't defined, set the right indexes to 0 until it is.
			if (testResult == 1)
			{
				var indexes:Vector.<int> = getDefaultIndexes(type, j, k, l);
				j = indexes[0];
				k = indexes[1];
				l = indexes[2];
			}
			
			var partClass:Class = dictionary[type][j][k][l];
			
			//Return a new instance of said class.
			return (pool.getNew(partClass));
		}
		
		/**
		 * Returns an int Vector containing the new indexes after defaulting.
		 * @param	Type of the part to get.
		 * @param	First index.
		 * @param	Second index.
		 * @param	Third index.
		 * @return
		 */
		private function getDefaultIndexes(type:String, j:int, k:int, l:int):Vector.<int>
		{
			//Get the defaulter. The defaulter is a fixed width int vector containing
			//the order in which indexes should be set to default, in case they 
			//were not matched to any part class.
			var defaulter:Vector.<int> = defaulterDictionary[type];
			
			//Depending on the number of indexes we are allowed to set to default,
			//the class test order changes. We must set to defaul the minimum
			//number of indexes possible, but try to set to default the least
			//important first.
			switch (defaulter.length)
			{
				case 3:
					if (testDef(1))		return (getVec(1));
					if (testDef(2))		return (getVec(2));
					if (testDef(3))		return (getVec(3));
					if (testDef(1, 2))	return (getVec(1, 2));
					if (testDef(1, 3))	return (getVec(1, 3));
					if (testDef(2, 3))	return (getVec(2, 3));
										return (getVec(1, 2, 3));
				break;
				
				case 2:
					if (testDef(1))		return (getVec(1));
					if (testDef(2))		return (getVec(2));
										return (getVec(1, 2));
				break;
				
				case 1:
										return (getVec(1));
				break;
			}
			throw new Error("No class found, but no correctly-sized defaulter set for class type " + type + ".");
			
			//This helper function will, given two ints, check if our indexes match any
			//class after defaulting the first, second and/or third indexes.
			
			//If the argument a is set to one, it will get the first index to default
			//from the defaulter vector, then set the corresponding temporary variable
			//to 0, then test the class and return true (defined) or false (undefined).
			function testDef(a:int = 0, b:int = 0):Boolean
			{
				if (a) a = defaulter[a - 1];
				if (b) b = defaulter[b - 1];
				
				var _j:int = (a == 1 || b == 1) ? 0 : j;
				var _k:int = (a == 2 || b == 2) ? 0 : k;
				var _l:int = (a == 3 || b == 3) ? 0 : l;
				
				return(testClass(type, _j, _k, _l) == 0);
			}
			
			//This helper function will do a similar job, but instead
			//returns a vector containing the indexes (j, k, l), or
			//0 in their place if any of those were defaulted.
			function getVec(a:int = 0, b:int = 0, c:int = 0):Vector.<int>
			{
				if (a) a = defaulter[a - 1];
				if (b) b = defaulter[b - 1];
				if (c) c = defaulter[c - 1];
				
				var vect:Vector.<int> = new Vector.<int>(3, true);
				
				vect[0] = (a == 1 || b == 1 || c == 1) ? 0 : j;
				vect[1] = (a == 2 || b == 2 || c == 2) ? 0 : k;
				vect[2] = (a == 3 || b == 3 || c == 3) ? 0 : l;
				
				return (vect);
			}
		}
		
		/**
		 * Returns new instance of the given part's class.
		 * @param	The part to clone.
		 * @return
		 */
		public function clonePart(part:MovieClip):MovieClip
		{
			return (pool.getNew(Object(part).constructor));
		}
		
		/**
		 * Tests if a class is defined.
		 * Returns 2 for undefined type, 1 for any undefined indexes, 0 for defined class.
		 * @param	Type of searched class.
		 * @param	First index of searched class.
		 * @param	Second index of searched class.
		 * @param	Third index of searched class.
		 */
		public function testClass(type:String, j:int, k:int, l:int):int
		{
			var current:Vector.<*> = dictionary[type];
			if (current == null)
				return (2);
			if (j >= current.length)
				return (1);
			current = current[j];
			if (current == null || k >= current.length)
				return (1);
			current = current[k];
			if (current == null || l >= current.length)
				return (1);
			if (current[l] == undefined)
				return (1);
			return (0);
		}
		
		/**
		 * Returns an untyped vector containing the type and indexes, if they exist,
		 * of a dictionary-defined class instance.
		 * Do not modify the vector, or modify this function to clone it each time.
		 * @param	The part to retrieve the indexes of.
		 * @return
		 */
		public function getPartIndexes(part:MovieClip):Vector.<*>
		{
			return (reversedDictionary[Object(part).constructor]);
		}
		
		/**
		 * Returns a particular index of a dictionary-defined class instance.
		 * @param	The part to retrieve the index of.
		 * @param	Which index to select, 1, 2 or 3.
		 * @return
		 */
		public function getPartIndex(part:MovieClip, index:int):int
		{
			if (index < 1 || index > 3)
				throw new Error("Index different than 1, 2 or 3.");
			return (reversedDictionary[Object(part).constructor][index]);
		}
		
		/**
		 * Returns the type of a dictionary-defined class instance.
		 * @param	The part to retrieve the type of.
		 * @return
		 */
		public function getPartType(part:MovieClip):String
		{
			return (reversedDictionary[Object(part).constructor][0]);
		}
		
		/**
		 * Returns the next class given the part, cycling ID and increment.
		 * @param	The part to cycle.
		 * @param	The cycling ID.
		 * @param	increment
		 * @return
		 */
		public function getNextClass(prevPart:MovieClip, ID:int, increment:int = 1):Class
		{
			if (prevPart == null)
				throw new Error("prevPart cannot be null.");
			
			var indexes:Vector.<*> = getPartIndexes(prevPart);
			var type:String = indexes[0];
			
			if (!cyclerDictionary[type] || !cyclerDictionary[type][ID])
				return (Object(prevPart).constructor);
			
			var cycler:Vector.<int> = cyclerDictionary[type][ID];
			
			//The current index
			var index:int;
			//If the next index should be looped
			var doCycle:Boolean = true;
			//The current vector.
			var vector:Vector.<*> = dictionary[type];
			
			//Loop through each index.
			for (var i:int = 0; i < 3; i++)
			{
				//Increment or decrement the current index until it is
				//associated with a defined result. If it crosses the
				//limits of the vector before it can, then send it to 
				//the other side, and allow the next cyclable index to
				//be cycled.
				index = indexes[i + 1];
				if (cycler[i] && doCycle)
				{
					doCycle = false;
					do
					{
						index += increment;
						if (index < 0 || index >= vector.length)
						{
							index = (index < 0) ? vector.length - 1 : 0;
							doCycle = true;
						}
					}
					while (vector[index] == undefined)
				}
				//Whatever the result, get the next vector.
				//If (i == 2), vector[index] is the result.
				if (i < 2)
				{
					vector = vector[index];
				}
			}
			//Return the class.
			return (vector[index]);
		}
		
		/**
		 * Gets a dictionary class given a type and indexes.
		 * Doesn't try to default undefined results, just fails and crash horribly.
		 * @param	Type of searched class.
		 * @param	First index of searched class.
		 * @param	Second index of searched class.
		 * @param	Third index of searched class.
		 */
		public function getClassUnsecured(type:String, j:int, k:int, l:int)
		{
			return (dictionary[type][j][k][l]);
		}
		
		/**
		 * The reviver for the class dictionary JSON parser.
		 * Tests if class exists, and remove undefined classes and empty objects.
		 * @param	key
		 * @param	src
		 * @return
		 */
		private function classDictionaryReviver(key:String, src:*):*
		{
			if (src is String)
			{
				if (ApplicationDomain.currentDomain.hasDefinition(String(src)))
				{
					//If it's a string and is defined as a class name, return source.
					return (getDefinitionByName(String(src)));
				}
				//If it's a string but not defined, return undefined.
				return (undefined);
			}
			if (src["0"])
			{
				//If the object uses ints as keys, return a vector instead.
				var array:Array = [];
				
				for (var prop:String in src)
				{
					array[int(prop)] = src[prop];
				}
				
				if (array[0] is Class)
					return (Vector.<Class>(array));
				if (array[0][0] is Class)
					return (Vector.<Vector.<Class>>(array));
				
				return (Vector.<Vector.<Vector.<Class>>>(array));
			}
			//If it's an object with one or more properties, return source.
			for (var key:String in src)
			{
				return (src);
			}
			//If it's an empty object, return undefined;
			return (undefined);
		}
		
		
		/**
		 * Create an object allowing to find the indexes of any class in the dictionary.
		 */
		private function getReversedDictionary():Object
		{
			var reversed:Object = { };
			var dictionary:Object = this.dictionary;
			
			for (var type:String in dictionary)
			{
				var vect1:Vector.<Vector.<Vector.<Class>>> = dictionary[type];
				
				for (var j:int = 0; j < vect1.length; j++)
				{
					var vect2:Vector.<Vector.<Class>> = vect1[j];
					
					if (vect2 == null) continue;
					
					for (var k:int = 0; k < vect2.length; k++)
					{
						var vect3:Vector.<Class> = vect2[k];
						
						if (vect3 == null) continue;
						
						for (var l:int = 0; l < vect3.length; l++)
						{
							var partClass:Class = vect3[l];
							
							if (partClass == null) continue;
							
							var vector:Vector.<*> = new Vector.<*>(4, true);
							
							vector[0] = type;
							vector[1] = j;
							vector[2] = k;
							vector[3] = l;
							
							reversed[partClass] = vector;
						}
					}
				}
			}
			return (reversed);
		}
		
		/**
		 * The reviver for the defaulter JSON file.
		 * Convert strings such as "123" to an int vector.
		 * @param	key
		 * @param	src
		 * @return
		 */
		private function defaulterReviver(key:String, src:*):*
		{
			if (key)
			{
				var len:int = src.length;
				
				if (len > 3)
					throw new Error("Warning: defaulter is too long.");
				
				if (len == 0)
					return (undefined);
				
				var vector:Vector.<int> = new Vector.<int>(len, true);
				
				while (len--)
				{
					vector[len] = src.charCodeAt(len) - 48;
				}
				
				return (vector);
			}
			return (src);
		}
		
		/**
		 * The reviver for the cycler JSON file.
		 * Converts strings such as "1,0,0" to int vectors.
		 * Doesn't currently detect types that do not contain at least "0" or "1" as keys.
		 * @param	key
		 * @param	src
		 * @return
		 */
		private function cyclerReviver(key:String, src:*):*
		{
			if (src is String)
			{
				var cycler:Vector.<int> = new Vector.<int>(3, true);
				
				var srcString:String = src as String;
				
				cycler[0] = srcString.charCodeAt(0) - 48;
				cycler[1] = srcString.charCodeAt(2) - 48;
				cycler[2] = srcString.charCodeAt(4) - 48;
				
				return (cycler);
			}
			if (src["0"] || src["1"])
			{
				var len:int = (src["1"]) ? 2 : 1;
				var vector:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(len, true);
				
				vector[0] = src[0];
				if (len > 1)
					vector[1] = src[1];
				
				return (vector);
			}
			return (src);
		}
	}
}