﻿package classes
{
	public class vaginaClass
	{
		//constructor
		public function vaginaClass()
		{
		}
		//data
		//Vag wetness
		public var vaginalWetness:Number = 1;
		/*Vag looseness
		0 - virgin
		1 - normal
		2 - loose
		3 - very loose
		4 - gaping
		5 - monstrous*/
		public var vaginalLooseness:Number = 0;
		//Type
		//0 - Normal
		//5 - Black bugvag
		public var type:int = 0;
		public var virgin:Boolean = true;
		//Used to determine thickness of knot relative to normal thickness
		//Used during sex to determine how full it currently is.  For multi-dick sex.
		public var fullness:Number = 0;
		public var labiaPierced:Number = 0;
		public var labiaPShort:String = "";
		public var labiaPLong:String = "";		
		public var clitPierced:Number = 0;
		public var clitPShort:String = "";
		public var clitPLong:String = "";
		
		
		public function wetnessFactor():Number {
			if(vaginalWetness == 0) return 1.25;
			if(vaginalWetness == 1) return 1;
			if(vaginalWetness == 2) return 0.8;
			if(vaginalWetness == 3) return 0.7;
			if(vaginalWetness == 4) return 0.6;
			if(vaginalWetness == 5) return 0.5;
			return .5;
		}
		public function capacity():Number {
			if(vaginalLooseness == 0) return 8;
			if(vaginalLooseness == 1) return 16;
			if(vaginalLooseness == 2) return 24;
			if(vaginalLooseness == 3) return 36;
			if(vaginalLooseness == 4) return 56;
			if(vaginalLooseness == 5) return 100;
			return 10000;
		}
	}
}