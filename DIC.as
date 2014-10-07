package
{
	//Debug
	import flash.system.System;
	import com.demonsters.debugger.MonsterDebugger;
	import com.sociodox.theminer.TheMiner;
	//Libraries
	import com.sibirjak.asdpcbeta.slider.SliderEvent;
	import flash.utils.Dictionary;
	import PNGEncoder2;
	//Native
	import flash.display.StageDisplayState;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.KeyboardEvent;
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
		private var viewerData:ViewerData;						//Contains the current dictionary and the pool, and sent as an argument to new characters.
		private var player:Creature = new Creature();			//Holds loaded char data.
		private var isTiTS:Boolean = false;
		
		//Backgrounds
		private var leftPanelBitmap:Bitmap;
		private var rightPanelBitmap:Bitmap;
		private var backgroundBitmap:Bitmap;
		private var CoCBackgrounds:Vector.<BitmapData>;
		private var TiTSBackgrounds:Vector.<BitmapData>;
		private var CoCPanels:Vector.<BitmapData>;
		private var TiTSPanels:Vector.<BitmapData>;
		
		//Parent
		private var creaturesParent:Sprite = new Sprite();		//Holds simple Creatures, like goblins
		private var charactersParent:Sprite = new Sprite();		//Holds loaded NPCS, including mainChar
		
		//Characters
		private var mainChar:Character;							//The main character
		
		//Saves
		private var CoCSaves:Vector.<Object>;
		private var TiTSSaves:Vector.<Object>;
		private var NPCData:Array = [];							//Holds TiTS NPC data (player.characters)
		private var foeData:Array = [];							//Holds TiTS foe data (player.foe)
		
		//Loading
		//private var saveFile:SharedObject;						//This part is a mess, since I couldn't manage to get file-loading right
		//private var file:FileReference;
		//private var loader:URLLoader;
		
		//Screenshots
		private var PNGEncoder:PNGEncoder2;						//Encode PNGs, used to export caps.
		private var capBitmap:BitmapData;						//Holds any screencap, required for disposal
		private var capScale:Number;								//The scaling of the screencap. If capScale == 2, then the screencap will be two times bigger.
		
		//Geom
		private var backgroundScrollRect:Rectangle = new Rectangle(200, 0, 1224, 980);
		private var rightPanelScrollRect:Rectangle = new Rectangle(1424, 0, 250, 980);
		private var leftPanelScrollRect:Rectangle = new Rectangle(0, 0, 200, 980);
		
		//Targets
		private var dragTarget:Sprite;							//Holds the dragging target, only way to make sure the game doesn't drop it if the target goes beneath something else.
		private var cockSliderTarget:MovieClip;					//The selected cock (the one the slider will scale)
		private var boobSliderTarget:MovieClip;					//The selected boob row
		
		//Menus
		private var menu:Sprite = new Sprite();
		private var menus:Object;
		private var notesList:Dictionary
		private var basicBtns:Sprite = new Sprite();				//Middle right menu: Create, ScreenCap, etc...
		private var saveBtns:Sprite = new Sprite();				//Upper left menu:   Player 1, player 2, etc.
		
		//Elements
		private var notes:ViewerNotes;							//The notebox on the right
		private var buttons:Object = { };						//Holds all basic buttons, for easy locking/editing
		private var cockSlider:ViewerSlider;
		private var boobSlider:ViewerSlider;
		
		//Elements data
		//public var selectedLists:Object = {0:[], 1:[]};		//Holds crew and foes selected items lists, for the TiTS weird lists.
		private var hairColorNames:Object;						//Objects for the annoying drop menu system
		private var skinColorNames:Object;						//Basically I need to link data and name, but they are the same here.
		private var skinTypesNames:Object = {					//Holds different skin types and their codes, for the skin type dropbox
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