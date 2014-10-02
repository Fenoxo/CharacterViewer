package
{
	//Libraries
	import com.sibirjak.asdpcbeta.slider.SliderEvent;
	import flash.utils.Dictionary;
	import PNGEncoder2;
	//Debug
	import flash.system.System;
	import com.demonsters.debugger.MonsterDebugger;
	import com.sociodox.theminer.TheMiner;
	//Native
	import flash.display.StageDisplayState;
	import flash.display.InteractiveObject;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.filters.GlowFilter;
	import flash.events.KeyboardEvent;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.net.SharedObject;
	import flash.ui.Mouse;
	//Custom
	import classes.character.*;
	import classes.components.*;
	import classes.elements.*;
	import classes.events.*;
	import classes.utils.*;
	import classes.*
	//Fen's classes
	import classes.save.*;
	
	public class DIC extends MovieClip
	{
		public static var instance:DIC;							//Holds the viewer instance, to allow GUI classes to access gamedata.
		
		//General variables
		public var viewerData:ViewerData;						//Contains the current dictionary and the pool, and sent as an argument to new characters.
		public var player:Creature = new Creature();			//Holds loaded char data.
		public var isTiTS:Boolean = false;
		
		//Backgrounds
		public var leftPanelBitmap:Bitmap;
		public var rightPanelBitmap:Bitmap;
		public var backgroundBitmap:Bitmap;
		public var CoCBackgrounds:Vector.<BitmapData>;
		public var TiTSBackgrounds:Vector.<BitmapData>;
		public var CoCPanels:Vector.<BitmapData>;
		public var TiTSPanels:Vector.<BitmapData>;
		
		//Parent
		public var creaturesParent:Sprite = new Sprite();		//Holds simple Creatures, like goblins
		public var charactersParent:Sprite = new Sprite();		//Holds loaded NPCS, including mainChar
		
		//Characters
		public var mainChar:Character;							//The main character
		
		//Saves
		public var CoCSaves:Vector.<Object>;
		public var TiTSSaves:Vector.<Object>;
		public var NPCData:Array = [];							//Holds TiTS NPC data (player.characters)
		public var foeData:Array = [];							//Holds TiTS foe data (player.foe)
		
		//Loading
		//public var saveFile:SharedObject;						//This part is a mess, since I couldn't manage to get file-loading right
		//public var file:FileReference;
		//public var loader:URLLoader;
		
		//Screenshots
		public var PNGEncoder:PNGEncoder2;						//Encode PNGs, used to export caps.
		public var capBitmap:BitmapData;						//Holds any screencap, required for disposal
		public var capScale:Number;								//The scaling of the screencap. If capScale == 2, then the screencap will be two times bigger.
		
		//Geom
		public var backgroundScrollRect:Rectangle = new Rectangle(200, 0, 1224, 980);
		public var rightPanelScrollRect:Rectangle = new Rectangle(1424, 0, 250, 980);
		public var leftPanelScrollRect:Rectangle = new Rectangle(0, 0, 200, 980);
		
		//Targets
		public var dragTarget:Sprite;							//Holds the dragging target, only way to make sure the game doesn't drop it if the target goes beneath something else.
		public var cockSliderTarget:MovieClip;					//The selected cock (the one the slider will scale)
		public var boobSliderTarget:MovieClip;					//The selected boob row
		
		//Menus
		public var menu:Sprite = new Sprite();
		public var menus:Object;
		public var notesList:Dictionary
		public var basicBtns:Sprite = new Sprite();				//Middle right menu: Create, ScreenCap, etc...
		public var saveBtns:Sprite = new Sprite();				//Upper left menu:   Player 1, player 2, etc.
		
		//Font
		public var CoCFontName:String = new CoC_Font().fontName;
		public var TiTSFontName:String = new TiTS_Font().fontName;
		
		//Elements
		public var notes:ViewerNotes;							//The notebox on the right
		public var buttons:Object = { };						//Holds all basic buttons, for easy locking/editing
		public var cockSlider:ViewerSlider;
		public var boobSlider:ViewerSlider;
		
		//Elements data
		//public var selectedLists:Object = {0:[], 1:[]};		//Holds crew and foes selected items lists, for the TiTS weird lists.
		public var hairColorNames:Object;						//Objects for the annoying drop menu system
		public var skinColorNames:Object;						//Basically I need to link data and name, but they are the same here.
		public var skinTypesNames:Object = {					//Holds different skin types and their codes, for the skin type dropbox
			Skin:0, Fur:1, Scales:2, Goo:3 };
		
		public function DIC()
		{
			DIC.instance = this;
		}
		
		static public function init():void 
		{
			//instance.addChild(new TheMiner());
			instance.initViewer();
			//MonsterDebugger.initialize(instance);
		}
		
		include "includes/events.as";
		include "includes/menus.as";
		include "includes/screenshots.as";
		include "includes/communication.as";
		
		include "includes/save.as";
		include "includes/elements.as";
	}
}