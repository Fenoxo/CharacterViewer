package  {
	///Default classes
	import flash.display.InteractiveObject;
	import flash.display.StageDisplayState;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.filters.GlowFilter;
	import flash.system.ApplicationDomain;
	import flash.events.KeyboardEvent;
	import flash.events.IOErrorEvent;
	import flash.events.FocusEvent;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.utils.Dictionary;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.net.URLLoaderDataFormat;
	import flash.net.FileReference;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.ui.Mouse;
	import fl.managers.StyleManager;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	///Custom classes
	import classes.*;
	
	//Imports
	//import com.demonsters.debugger.MonsterDebugger;
	//import com.sociodox.theminer.TheMiner;
	import ColorJizz.RGB;
	import ColorJizz.Hex;
	
	///Main class
	public class DIC extends MovieClip {
		
		static var instance:DIC;								//Holds this, to allow GUI classes to access gamedata. Not pretty, but it works
		
		//General variables
		public var isTiTS:Boolean = false;						//True if the game is in TiTS mode, false if it is in CoC mode.
		
		///Technical variables
		public var backgroundBitmap:Bitmap;						//Backgrounds and panels are drawn on this bitmap.
		public var mainParent:MovieClip = new MovieClip();		//Holds main character, the one you load and stuff
		public var creatureParent:MovieClip = new MovieClip();	//Holds simple Creatures, like goblins
		public var charactersParent:MovieClip = new MovieClip();//Holds loaded NPCS, including mainParent.
		public var drawParent:MovieClip;						//Holds temporarely a character parent, most often mainParent
		public var NPCData:Array = [];							//Holds NPC data (player.characters)
		public var foeData:Array = [];							//Holds foe data (player.foe)
		public var classDict:Dictionary;						//Convert indexes to className, linking a part, and three ints, such as size, type, etc... ("cock, 10, 5") and the corresponding class
		public var CoCDict:CoC_Dictionary;						//Holds the CoC class dict
		public var TiTSDict:TiTS_Dictionary;					//Holds the TiTS class dict
		public var player:creature = new creature();			//Holds loaded char data.
		public var playerName:String;							//Player name, for convenience.
		
		///Loading variable
		public var saveFile:SharedObject;						//This part is a mess, since I couldn't manage to get file-loading right
		public var file:FileReference;
		public var loader:URLLoader;
		public var PNGencoder:PNGEncoder2;						//Encode PNGs, used to export caps.
		public var capBitmap:BitmapData;						//Holds any screencap, required for memeory management and disposal
		public var capScale:Number;								//When you screen a character, this is the scaling factor, for higher resolution results.
		
		///Drawing variables
		public var ct:ColorTransform = new ColorTransform;		//Every colour transform are stored here at one point, to avoid "new colortransform" for each part to shade.
		public var skinType:int;								//Holds player.skinType, for convenience
		public var foundPart:MovieClip = undefined;				//Used to return the last drawn part, for convenience
		public var partRefs:Array=[];							//Holds any added parts, and the name of their childs requiring coloring
		public var heightMod:Number;							//To scale parts. Basically when the size of part should be independant of the player size (clit, cock), this rectifies it.
		public var hasBalls:Boolean;							//If there are more than one ball, for convenience.
		public var hairColor:String;							//Holds player.hairColor, for convenience.
		public var skinColor:String;							//Holds player.skinTone, for convenience.
		public var partIndex:int;								//To pass around important index in the drawChar function. Usually the index of the body, so you add the back hair at the right place.
		public var masculine:int;								//If feminity < 50, 0 ,else, 1, for (wait for it) convenience.
		
		///GUI Variables
		public var focusTarget:InteractiveObject;				//Used to know what you are targeting using shift.
		public var stageLock:Boolean = false;					//If clicking should be processed, to avoid people using screencapping lag to fuck things up.
		public var clickTimer:Timer = new Timer(300, 1); 		//Started when you click, resetted when you stop, starts clickFastTimer when over.
		public var clickFastTimer:Timer = new Timer(50, 0);		//Send a new click event repeatedly
		public var clickTimerTarget:DisplayObject;				//Holds the GUI element you are holding the click on, to verify if you're still on it.
		public var menuBtns:MovieClip = new MovieClip;			//Bottom left menu:  (Head, Body, etc.) or (Background, NPC, etc.)
		public var basicBtns:MovieClip = new MovieClip;			//Middle right menu: Create, ScreenCap, etc...
		public var savesBtns:MovieClip = new MovieClip;			//Upper left menu:   Player 1, player 2, etc.
		public var scrollBar:DIC_ScrollBar;						//The notes scrollbar
		public var notes:TextField;								//The notebox on the right
		public var buttons:Object = {};							//Holds all basic buttons, for easy locking
		public var dragTarget:MovieClip;						//Holds the dragging target, only way to make sure the game doesn't drop it if the target goes beneath something else.
		public var selectedLists:Object = {0:[], 1:[]};			//Holds crew and foes selected items lists, for the TiTS weird lists.
		public var bigCockList:Object = {};						//Contain all scalable cocks (any cock so big they don't have art)
		public var bigBoobList:Object = {};						//Same with boobs.
		public var cockSlideTarget:Array;						//The selected cock (the one the slider will scale)
		public var boobSlideTarget:Array;						//Same.
		public var cockSlider;									//The cockslider, for convenience
		public var boobSlider;									//Same.
		public var equipment:Array = [];						//Array holding all added equipment, for easy removal.
		//Weird GUI related info, stating the numer of cocks and remaining GUI space, as well as their respective buttons, and same for boobs.
		public var addInfo:Object = {cockNum:0, cockSpot:9, cockBtn:[], boobNum:0, boobSpot:4, boobBtn:[]};
		
		//Loaded CoC player menu
		public var CoCMenu:Object = {};				//Holds all submenus for CoC loaded characters
		public var CoCBackgroundMenu:Object = {};	//Holds all CoC background buttons (actually filled on player load)
		public var CoCCreatureMenu:Object = {};		//Holds all creature buttons
		public var CoCItemMenu:Object = {};			//Holds all item buttons
		public var CoCDetailMenu:Object = {};		//Holds all toogle buttons, aswell as the eyecolor tablet.
		public var CoCSliderMenu:Object = {};		//Holds all sliders
		//Loaded TiTS player menu
		public var TiTSMenu:Object = {};			//Holds all submenus for TiTS loaded characters
		public var TiTSBackgroundMenu:Object = {};	//Holds all TiTS backgrounds (none, HAHA)
		public var TiTSCreatureMenu:Object = {};	//Blablabla
		public var TiTSNPCMenu:Object = {};			//Holds all NPCs (again, filled on loading)
		public var TiTSFoeMenu:Object = {};			//Holds all foes (")
		public var TiTSItemMenu:Object = {};		//Blablabla
		public var TiTSDetailMenu:Object = {};		//Blabla
		public var TiTSSliderMenu:Object = {};		//Bla
		//Created character menu	
		public var creatorMenu:Object = {};			//Holds all submenues for new characters everywhere
		public var headMenu:Object = {};			//Head menu
		public var torsoMenu:Object = {};			//Trunk menu
		public var naughtyMenu:Object = {};			//Genitals menu
		public var cockMenu:Object = {};			//Genitals submenu, just for cocks
		public var legsMenu:Object = {};			//Legs and tails submenu
		public var otherMenu:Object = {};			//Eyecolor and stuff
		///Color variables
		public var eyeColor:uint;					//Holds eye color, for consistency (not stored in player)
		public var skinColorAry:Array = [];			//Link game color name to color code (skinColorAry["light"] = 0xffdac8;)
		public var skinShadeAry:Array =[];			//Filled with the dark version of the skin color
		public var bitsColorAry:Array =[];			//Same, but instead of skin, is color of nipples, dickhead and lips
		public var bitsShadeAry:Array=[];			//Yeah...
		public var hairColorAry:Array =[];			//Same, but fur and hair colors
		public var hairShadeAry:Array =[];			//Again, shaded version of hair colors.
		public var hairColorNames:Object = {};		//Objects for the annoying drop menu system
		public var skinColorNames:Object = {};		//Basically I need to link data and name, but they are the same here.
		public var skinTypesNames:Object = {		//Holds different skin types and their codes, for the skin type dropbox
			Skin:0, Fur:1, Scales:2, Goo:3};
		
		////Initialization
		public function DIC(){
			DIC.instance = this;
			//MonsterDebugger.initialize(this);
		}
		static function init():void{
			//Initialiaze part type, color and dropdown boxes arrays
			instance.createArrays();
			//Initialize GUI
			instance.initGUI();
		}
		////Dictionnary and Reference system
		/*public function typeArrayAdder():void{
			//The function takes each array group, and "nest" them, making every possible combination.
			//If one element of the array is undefined, it will store "skip" instead, so dictfindpart knows to decrement instead of replacing by default
			typeArray = [
				[headTypeAry,	"head"],
				[cockTypeAry,	"cock"],
				[ballTypeAry,	"balls"],
				[clitTypeAry,	"clit"],
				[vagTypeAry,	"vag"],
				[hairTypeAry,	"hair"],
				[faceTypeAry,	"face"],
				[hornTypeAry,	"horns"],
				[earTypeAry, 	"ears"],
				[eyeTypeAry, 	"eyes"],
				[gillTypeAry,	"gills"],
				[bodyTypeAry,	"body"],
				[boobTypeAry,	"boobs"],
				[shadTypeAry,	"shade"],
				[nipTypeAry,	"nipple"],
				[armTypeAry,	"arms"],
				[legTypeAry,	"legs"],
				[hipsTypeAry,	"hips"],
				[assTypeAry,	"butt"],
				[oviTypeAry, 	"ovi"],
				[tailTypeAry,	"tail"],
				[wingTypeAry,	"wings"],
				[handTypeAry,	"hand"]];						//Holds type arrays and their key
			var className = "";
			var key = [];
			for(i = 0; i < typeArray.length; i++){
				for (j = 0; j < typeArray[i][0][0].length; j++){
					if (typeArray[i][0][0][j] == undefined){
						className = "skip1";
					}
					for (k = 0; k < typeArray[i][0][1].length; k++){
						if (typeArray[i][0][1][k] == undefined){
							className = "skip2";
						}
						for (l = 0; l < typeArray[i][0][2].length; l++){
							if (typeArray[i][0][2][l] == undefined){
								className = "skip3";
							}
							key = [typeArray[i][1],j,k,l];
							if (className == ""){
								classDict[key.toString()] = typeArray[i][0][0][j] + typeArray[i][0][1][k] + typeArray[i][0][2][l];
								trace(key+" linked to "+classDict[key.toString()]);
							}else{
								classDict[key.toString()] = className;
							}
							if (className == "skip3") className = "";
						}
						if (className == "skip2") className = "";
					}
					if (className == "skip1") className = "";
				}
			}
		} *///!!!
		public function createArrays():void{
			//Fill color arrays
			createSkinColorAry();
			createHairColorAry();
			createBitsColorAry();
			createShadeAry();
			//Fill color name arrays
			createColorNameAry();
			skinColorAry.concat(hairColorAry);
			skinShadeAry.concat(hairShadeAry);
			//Init class dictionary
			CoCDict = new CoC_Dictionary();
			TiTSDict = new TiTS_Dictionary();
			classDict = CoCDict as Dictionary;
		}
		
		///Part finders
		//Turns indexes into a class, then create it and add it to drawCharacter
		public function dictFindPart(type:String, j:int=0, k:int=0, l:int=0):void{
			var key = [type,j,k,l];
			var toDefault = [];
			for (i=1; i<4; i++){
				while (classDict[key.toString()] == "skip"+i){
					key[i]--;
					trace("Key reduced to "+key);
				}
			}
			j = key[1];
			k = key[2];
			l = key[3];
			if (!testClass(key.toString())){
				if (testClass([type,0,k,l].toString())) toDefault = [1];
				if (testClass([type,j,0,l].toString())) toDefault = [2];
				if (testClass([type,j,k,0].toString())) toDefault = [3];
				if (toDefault == []){
					if (testClass([type,j,0,0].toString())) toDefault = [2,3];
					if (testClass([type,0,k,0].toString())) toDefault = [3,1];
					if (testClass([type,0,0,l].toString())) toDefault = [1,2];
				}
				if (toDefault == []) toDefault = [1,2,3];
				if (!testClass([type,0,0,0].toString())) trace("Can't find type "+type);
				trace("Part "+ key + " index "+toDefault+" set 0 by default.");
				toNote("This type of "+type+" is not added yet.",true);
			}
			for (i=0;i<toDefault.length;i++){
				key[toDefault[i]] = 0;
			}
			var className = classDict[key.toString()];
			var classType:Class = getDefinitionByName(className) as Class;
			foundPart = new classType() as MovieClip;
			foundPart.cacheAsBitmap = true; //!!!
			drawParent.addChild(foundPart);
		}
		//Add parts and their children in desperate need of color to partRefs
		public function addPartRef(id:String, part:*, partB="", partS="", hairB="", hairS="", bitsB="", bitsS="", pupils="", ghost=false):void{
			if(part == undefined || part == null) return;
			try{part.name = id;}catch(e){}
			partRefs[id] = {part:part}
			partRefs[id].ghost = ghost;
			partRefs[id].partB= getDeepChildByName(part, partB);
			partRefs[id].partS = getDeepChildByName(part, partS);
			partRefs[id].hairB= getDeepChildByName(part, hairB);
			partRefs[id].hairS = getDeepChildByName(part, hairS);
			partRefs[id].bitsB= getDeepChildByName(part, bitsB);
			partRefs[id].bitsS = getDeepChildByName(part, bitsS);		
			partRefs[id].pupils= getDeepChildByName(part, pupils);
			trace ("Part added, ID is "+ id);
		}
		
		///Information getters
		//Reverse classDict search
		public function getIndexes(className:String):Array {
			for(var key:String in classDict) {
				if(classDict[key] == className) {
					return key.split(",");
				}
			}
			return null;
		}
		//Reverse partRefs search
		public function getPart(id:String, mute:Boolean=false):* {
			if(partRefs[id] == undefined){
				trace("Error: Could not get part: "+id);
				return;
			}
			if(!mute) trace("Got part "+partRefs[id].part+" with id:"+id+" and indexes "+getIndexes(getQualifiedClassName(partRefs[id].part)));
			return partRefs[id].part;
		};
		//Get the index of a part name
		public function getPartInd(id:String):Array{
			if (getPart(id)){
				return getIndexes(getQualifiedClassName(getPart(id, true)));
			}else{
				return ["",0,0,0];
			}
		}
		//Test if a class is defined
		public function testClass(className:String):Boolean{
			if(classDict[className] == undefined){
				trace("No dictionnary entry for "+className);
				return false;
			}
			if(!ApplicationDomain.currentDomain.hasDefinition(classDict[className])){
				trace("Artwork for "+classDict[className]+" for "+className+" is not added yet");
				return false;
			}
			trace(classDict[className]+" is defined by "+className+".");
			return true;
		}
		
		///Array creators
		//"Quantitative" arrays creators
		public function createHipsAry():void{
			hipsTypeAry[1][0] = "NoHips";
			hipsTypeAry[1][6] = "Hips1";
			hipsTypeAry[1][8] = "Hips2";
			hipsTypeAry[1][10] = "Hips3";
			hipsTypeAry[1][13] = "Hips4";
			hipsTypeAry[1][16] = "Hips5";
			hipsTypeAry[1][20] = "Hips6";
		}
		public function createHairAry():void{
			hairTypeAry[0][0] = "Bald";
			hairTypeAry[0][1] = "ReallyShort";
			hairTypeAry[0][6] = "Short";
			hairTypeAry[0][11] = "Medium";
			hairTypeAry[0][16] = "Long";
		}
		public function createAssAry():void{
			assTypeAry[0][0] = "ButtBase";
			assTypeAry[0][4] = "Butt1";
			assTypeAry[0][6] = "Butt2";
			assTypeAry[0][8] = "Butt3";
			assTypeAry[0][10] = "Butt4";
			assTypeAry[0][13] = "Butt5";
			assTypeAry[0][16] = "Butt6";
		}
		public function createCockAry():void{
			cockTypeAry[1][0] = "0";
			cockTypeAry[1][1] = "1";
			cockTypeAry[1][4] = "2";
			cockTypeAry[1][7] = "3";
			cockTypeAry[1][10] = "4";
			cockTypeAry[1][14] = "5";
			cockTypeAry[1][18] = "6";
			cockTypeAry[1][21] = "7";
			cockTypeAry[1][24] = "8";
			cockTypeAry[1][27] = "9";
		}
		public function createBreastAry():void{
			boobTypeAry[1][0] = "Flat";
			boobTypeAry[1][1] = "BreastsA";
			boobTypeAry[1][3] = "BreastsB";
			boobTypeAry[1][5] = "BreastsC";
			boobTypeAry[1][7] = "BreastsD";
			boobTypeAry[1][9] = "BreastsDD";
			boobTypeAry[1][15] = "BreastsG";
			boobTypeAry[1][27] = "BreastsJ";
			boobTypeAry[1][48] = "BreastsN";
			boobTypeAry[1][80] = "BreastsZ";
		}
		public function createShadAry():void{
			shadTypeAry[0][0] = shadTypeAry[2][0] = "F";
			shadTypeAry[0][1] = shadTypeAry[2][1] = "A";
			shadTypeAry[0][3] = shadTypeAry[2][3] = "B";
			shadTypeAry[0][5] = shadTypeAry[2][5] = "C";
			shadTypeAry[0][7] = shadTypeAry[2][7] = "D";
			shadTypeAry[0][9] = shadTypeAry[2][9] = "DD";
			shadTypeAry[0][15] = shadTypeAry[2][15] = "G";
			shadTypeAry[0][27] = shadTypeAry[2][27] = "J";
			shadTypeAry[0][48] = shadTypeAry[2][48] = "N";
			shadTypeAry[0][80] = shadTypeAry[2][80] = "Z";
			
			shadTypeAry[2] = ["F"];
		}
		//Color array creators
		public function createSkinColorAry():void{
			skinColorAry["light"] = 0xffdac8;
			skinColorAry["olive"] = 0xd89c6b;
			skinColorAry["dark"] = 0xb5795c;
			skinColorAry["ebony"] = 0x3d1d0e;
			skinColorAry["pale white"] = 0xf4e4dc;
			skinColorAry["white"] = 0xf9f0eb;
			skinColorAry["sable"] = 0x8d655a;
			skinColorAry["dark green"] = 0x2d562b;
			skinColorAry["grayish-blue"] = 0x708f84;
			skinColorAry["pale yellow"] = 0xead686;
			skinColorAry["rough gray"] = 0x908f8a;
			skinColorAry["purple"] = 0x64109f;
			skinColorAry["silver"] = 0xb8b8b8;
			skinColorAry["red"] = 0xbd1a1a;
			skinColorAry["green"] = 0x2a892c;
			skinColorAry["blue"] = 0x2f78bd;
			skinColorAry["indigo"] = 0x513bc1;
			skinColorAry["shiney black"] = 0x191919;//play around with color
			skinColorAry["orange"] = 0xb74d26;
			skinColorAry["grey"] = 0x707070;
			skinColorAry["milky"] = 0xffe3cf;
			skinColorAry["ashen"] = 0xb89880;
			skinColorAry["tan"] = 0xd09365;
			skinColorAry["aphotic blue-black"] = 0x32324f;
			//orange and black striped - a23900/2a2a2a - 892b00/24202a //this skinColor will have to be handled seperately (af will have to make a stripe layer)
		}
		public function createBitsColorAry():void{
			bitsColorAry["light"] = 0xfabdbd;
			bitsColorAry["olive"] = 0xd8826b;
			bitsColorAry["dark"] = 0xa25945;
			bitsColorAry["ebony"] = 0x251006;
			bitsColorAry["pale white"] = 0xf7cec9;
			bitsColorAry["white"] = 0xf9d8d4;
			bitsColorAry["sable"] = 0x874e4e;
			bitsColorAry["dark green"] = 0x1e4731;
			bitsColorAry["grayish-blue"] = 0x576a87;
			bitsColorAry["pale yellow"] = 0xe1ac6e;
			bitsColorAry["rough gray"] = 0x6d717a;
			bitsColorAry["purple"] = 0x5d256b;
			bitsColorAry["silver"] = 0x9397a4;
			bitsColorAry["red"] = 0x9d0f30;
			bitsColorAry["green"] = 0x336544;
			bitsColorAry["blue"] = 0x7744cb;
			bitsColorAry["indigo"] = 0x63309c;
			bitsColorAry["shiney black"] = 0x2f2f2f; // (AF will have to make shines)
			bitsColorAry["orange"] = 0x993025;
			bitsColorAry["grey"] = 0x4d4d4d;
			bitsColorAry["milky"] = 0xffd2cf;
			bitsColorAry["ashen"] = 0xa47163;
			bitsColorAry["tan"] = 0xc77c57;
			bitsColorAry["aphotic blue-black"] = 0x63309c;
		}
		public function createHairColorAry():void{
			hairColorAry["dark blue"] = 0x2a264e;
			hairColorAry["bright orange"] = 0xf87c32;
			hairColorAry["neon pink"] = 0xff5193;
			hairColorAry["purple"] = 0x64109f;
			hairColorAry["auburn"] = 0x821f0b;
			hairColorAry["black"] = 0x2a2a2a;
			hairColorAry["blonde"] = 0xfabc45;
			hairColorAry["brown"] = 0x844932;
			hairColorAry["red"] = 0xbd1a1a;
			hairColorAry["white"] = 0xf9f0eb;
			hairColorAry["gray"] = 0x707070;
			hairColorAry["shiny black"] = 0x23232F;
			hairColorAry["silver"] = 0xb8b8b8;
			hairColorAry["platinum blonde"] = 0xffdf99;
			hairColorAry["midnight black"] = 0x191919;
			hairColorAry["sandy blonde"] = 0x0f5bc79;
			hairColorAry["green"] = 0x2a892c;
		}
		public function createColorNameAry():void{
			i = 0;
			for (var key in skinColorAry){
				skinColorNames[key] = key;
				
				i++;
			}
			delete skinColorNames["aphotic blue-black"];
			skinColorNames["aphotic blue"] = "aphotic blue-black";
			i = 0;
			for (key in hairColorAry){
				hairColorNames[key] = key;
				i++;
			}
			delete hairColorNames["platinum blonde"];
			hairColorNames["platinum"] = "platinum blonde";
		}
		public function createShadeAry():void{
			var color:Array;
			function hex2rgb(hex:uint):Array{
				return [(hex & 0xFF0000) >> 16, (hex & 0x00FF00) >> 8, (hex & 0x0000FF)];
			}
			function rgb2hex(rgb:Array):uint{
				return (rgb[0]<<16)|(rgb[1] << 8)|rgb[2];
			}
			function shade(hex:uint):uint{
				color = hex2rgb(hex);
				
				for (i=0; i<3; i++) color[i] -= 5;
				for (i=0; i<3; i++) color[i] *= 0.7;
				
				color[0] *= 1.10;
				color[1] *= 0.90;
				color[2] *= 1.10;
				
				for(i=0; i<3; i++) color[i] = Math.max(color[i], 0);
				
				return rgb2hex(color);
			}
			var key:String;
			for (key in skinColorAry) skinShadeAry[key] = shade(skinColorAry[key]);
			for (key in hairColorAry) hairShadeAry[key] = shade(hairColorAry[key]);
			for (key in bitsColorAry) bitsShadeAry[key] = shade(bitsColorAry[key]);
		}
		//Technical arrays creators
		public function createBigAry():void{
			trace("Saving scalable parts");
			var part:MovieClip;
			var ary:Array;
			cockSlideTarget = [];
			boobSlideTarget = [];
			setObject(bigCockList, {});
			setObject(bigBoobList, {});
			bigCockList["No target"] = [];
			bigBoobList["No target"] = [];
			
			for (i = 0; i < player.cocks.length; i++){
				if (player.cocks[i].cockLength > 27){
					part = getPart("cock"+i);
					ary = [part, "Cock "+(i+1)+": 27in.", player.cocks[i].cockLength, i+1];
					if (part) bigCockList["Cock "+(i+1)] = ary;
				}
			}
			for (i = 0; i < player.breastRows.length; i++){
				if (player.breastRows[i].breastRating > 80){
					part = getPart("boobs"+i);
					ary = [part, "Row "+(i+1)+": 80/100", player.breastRows[i].breastRating, i+1];
					if (part) bigBoobList["Row "+(i+1)] = ary;
				}
			}
		}
		
		////Utilities
		//Return the minimized and maximized input.
		public function born(toBorn:Number, min:Number, max:Number):Number{
			toBorn = Math.max(toBorn,min);
			toBorn = Math.min(toBorn,max);
			return toBorn;
		}
		//Place string in the note box. You can replace or append.
		public function toNote(note:String = "", toAdd:Boolean = false):void{
			scrollBar.scrollPosition = scrollBar.maxScrollPosition;
			if (toAdd && notes.text != ""){
				notes.text = notes.text + "\r\r" + note;
			}else{
				notes.text = note;
			}
			scrollBar.update();
			scrollBar.visible = scrollBar.enabled;
		}
		//Get the child from its name, and will look into scalable content if not found.
		public function getDeepChildByName(part:*,childName:String):MovieClip{
			var norm = part.getChildByName(childName);
			if(norm){
				return norm;
			}else if(part.MC){
				var deep = part.MC.getChildByName(childName);
				if (deep){
					return deep;
				}
			}
			return undefined;
		}
		//Add child the deeper possible
		public function addDeepChild(paren:*, part:*):void{
			if (paren.MC){
				paren.MC.addChild(part);
			}else{
				paren.addChild(part);
			}
		}
		//Get the indexe. Because I HATE that bit of code, so the less I have to write it, the better.
		public function getIn(target:*):int{
			return target.parent.getChildIndex(target);
		}
		//Get the class of the object, for cloning purpose
		public function getClass(target:*):Class{
			return getDefinitionByName(getQualifiedClassName(target));
		}
		//Remove child from parent
		public function remove(target:*):void{
			if(target){
				if(target.stage){
					target.parent.removeChild(target);
					return;
				}
			}else{
				trace("Error: Could not delete target");
			}
		}
		//Scale item, and increment baseValues to x and y
		public function scale(target:*, val:Number, baseX:Number=0, baseY:Number=0, from0=false):*{
			target.scaleX = val;
			target.scaleY = val;
			if(from0){
				target.x = baseX;
				target.y = baseY;
			}else{
				target.x += baseX;
				target.y += baseY;
			}
		}
		//For debug, allow you to turn invisible any element you click
		public function toggleVisible(e:Event):void{
			e.target.visible = !e.target.visible;
		}
		//Set object but keep old instance. Only used here to allow internesting.
		public function setObject(tar:Object, obj:Object):void{
			var p:String;
			for (p in tar) delete tar[p];
			for (p in obj) tar[p] = obj[p];
		}
		//Randomize an array
		public function randomize(array:Array):Array{
			var temp:Object;
			var tempOffset:int;
			for (var i:int = array.length - 1; i >= 0; i--){
				tempOffset = Math.random() * i;
				temp = array[i];
				array[i] = array[tempOffset];
				array[tempOffset] = temp;
			}
			return array;
		}
		
		////Game loading
		///Reset Game
		public function reset(btnName:String=""):void{
			if (dragTarget) dragTarget.stopDrag();
			clearMenu(mainParent);
			clearMenu(creatureParent);
			clearMenu(charactersParent);
			clearMenu();
			remove(instructions);
			toNote("");
			back.gotoAndStop(int(isTiTS)*6+1);
			skinType = 0;
			eyeColor = getRandomColor();
			buttons.characterCap.lock();
			buttons.backgroundCap.lock();
			buttons.charRes.lock();
			addSavesBtns();
			addInfo = {cockNum:0, cockSpot:9, cockBtn:[], boobNum:0, boobSpot:4, boobBtn:[]};
		}
		///Load from default
		public function loadFromDefault(btnName:String):void{
			loadDefault();
			addMainChar(creatorMenu, true);
			mainParent.setChildIndex(getPart("cock0", true), getIn(getPart("boobs0", true)));
		}
		///Load from shared object
		public function loadFromSave(btnName:String):void{
			saveFile = SharedObject.getLocal(btnName,"/");
			if (loadGame(saveFile.data)){
				addMainChar([CoCMenu, TiTSMenu][int(isTiTS)]);
			}else{
				toNote("Could not load. Try opening save with a more recent version of CoC, then saving it.");
			}
		}
		///Load from file
		public function loadFromFile(btnName:String):void{
			file = new FileReference();
			file.browse();
			file.addEventListener(Event.SELECT, onFileSelect);
		}
		public function onFileSelect(evt:Event):void{
			file.load();
			file.addEventListener(Event.COMPLETE, onFileLoaded);
		}
		public function onFileLoaded(evt:Event):void{
			var tempFileRef:FileReference = FileReference(evt.target);
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onDataLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadFailed)
			try{
				var req:* = new URLRequest(inputPath);
				loader.load(req);
			}catch (error:Error){
				loadFailed();
			}
		}
		public function onDataLoaded(evt:Event):void{
			loader.data.position = 0;
			var sav = loader.data.readObject();
			if (sav){
				if(sav.data){
					if (loadGame(sav.data)){
						addMainChar([CoCMenu, TiTSMenu][int(isTiTS)]);
						return;
					}
				}
			}
			loadFailed();
		}
		public function loadFailed(e:Event = undefined){
			toNote("Save file not found or corrupted, check that it is in the same directory as the CoC.swf file.\r\rLoad from file is not available when playing directly from a website like furaffinity or fenoxo.com.", true);
		}
		///Load Data
		public function loadDefault():void{
			//Reset arrays
			player.removeCock(0,player.cocks.length);
			player.removeBreastRow(0,player.breastRows.length);
			player.removeVagina(0,player.vaginas.length);
			player.removeStatuses();
			player.removePerks();
			player.removeKeyItems();
			//Name
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
			player.hipRating =0;
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
			skinType = 0;
			skinColor = "light";
			hairColor =  "silver";
		}
		public function loadGame(save:Object):Boolean{
			if (isTiTS) return loadTiTS(save);
			else		return loadCoC(save);
		}
		public function loadCoC(save:Object):Boolean{
			//Initiamize loading sequence
			if(save == null) return false;
			var counter:Number = player.cocks.length;
			//Reset vital settings
			player.removeCock(0,player.cocks.length);
			player.removeBreastRow(0,player.breastRows.length);
			player.removeVagina(0,player.vaginas.length);
			player.removeStatuses();
			player.removePerks();
			player.removeKeyItems();
			player.short = save.short;
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
			if(save.earType == undefined) player.earType = 0;
			else player.earType = save.earType;
			if(save.earValue == undefined) player.earValue = 0;
			else player.earValue = save.earValue;
			if(save.antennae == undefined) player.antennae = 0;
			else player.antennae = save.antennae;
			player.horns = save.horns;
			if(save.hornType == undefined) player.hornType = 0;
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
			//Set Cock array
			for(i = 0; i < save.cocks.length; i++) {
				player.createCock();
			}
			//Populate Cock Array
			for(i = 0; i < save.cocks.length; i++) {
				player.cocks[i].cockThickness = save.cocks[i].cockThickness;
				player.cocks[i].cockLength = save.cocks[i].cockLength;
				player.cocks[i].cockType = save.cocks[i].cockType;
				player.cocks[i].knotMultiplier = save.cocks[i].knotMultiplier;
				player.cocks[i].pierced = save.cocks[i].pierced;
			}
			//Set Vaginal Array
			for(i = 0; i < save.vaginas.length; i++) {
				player.createVagina();
			}
			//Populate Vaginal Array
			for(i = 0; i < save.vaginas.length; i++) {
				player.vaginas[i].vaginalWetness = save.vaginas[i].vaginalWetness;
				player.vaginas[i].vaginalLooseness = save.vaginas[i].vaginalLooseness;
				player.vaginas[i].fullness = save.vaginas[i].fullness;
				player.vaginas[i].virgin = save.vaginas[i].virgin;
				player.vaginas[i].labiaPierced = save.vaginas[i].labiaPierced;
				player.vaginas[i].clitPierced = save.vaginas[i].clitPierced;
			}
			//Nipples
			if(save.nippleLength == undefined) player.nippleLength = .25;
			else player.nippleLength = save.nippleLength;
			//Set Breast Array
			for(i = 0; i < save.breastRows.length; i++) {
				player.createBreastRow();
			}
			//Populate Breast Array
			for(i = 0; i < save.breastRows.length; i++) {
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
			return true;
		}
		public function loadTiTS(save:Object, j:int = 0):Boolean{
			//Initiamize loading sequence
			if(save == null) return false;
			var char = save.characters[j];
			//Reset vital settings
			player.removeCock(0,player.cocks.length);
			player.removeBreastRow(0,player.breastRows.length);
			player.removeVagina(0,player.vaginas.length);
			player.removeStatuses();
			player.removePerks();
			player.removeKeyItems();
			player.short = char.short;
			//Load NPC
			i = 0;
			for each (var ite in save.characters){
				NPCData[i] = ite;
				i ++;
			}
			i = 0;
			for each (ite in save.foes){
				foeData[i] = ite;
				i++;
			}
			//Load stats
			player.str = 50;//!!!
			player.cor = 50;//!!!
			player.fatigue = 50;//!!!
			player.HP = char.HPRaw;
			player.lust = char.lustRaw;
			//Load appearance
			player.femininity = char.femininity;
			player.tallness = char.tallness;
			player.hairColor = char.hairColor;
			player.hairLength = char.hairLength;
			player.skinType = char.skinType;
			player.skinTone = char.skinTone;
			player.faceType = char.faceType;
			player.armType = char.armType;
			player.gills = char.gills;
			if(char.earType == undefined) player.earType = 0;
			else player.earType = char.earType;
			if(char.antennae == undefined) player.antennae = 0;
			else player.antennae = char.antennae;
			player.horns = char.horns;
			if(char.hornType == undefined) player.hornType = 0;
			else player.hornType = char.hornType;
			player.wingType = char.wingType;
			player.tailType = char.tailType;
			player.tailVenom = char.tailVenum;
			player.hipRating = char.hipRating;
			player.buttRating = char.buttRating;
			
			//Piercings
			player.nipplesPierced = char.nipplesPierced;
			player.lipPierced = char.lipPierced;
			player.tonguePierced = char.tonguePierced;
			player.eyebrowPierced = char.eyebrowPierced;
			player.earsPierced = char.earsPierced;
			player.nosePierced = char.nosePierced;
			
			//Genitals
			player.balls = char.balls;
			player.ballSize = char.ballSize;
			player.clitLength = char.clitLength;
			
			//Cock array
			for(i = 0; i < char.cocks.length; i++) {
				player.createCock();
			}
			//Populate Cock Array
			for(i = 0; i < char.cocks.length; i++) {
				player.cocks[i].cockLength = char.cocks[i].cLength;
				player.cocks[i].cockType = char.cocks[i].cockType;
				player.cocks[i].pierced = char.cocks[i].pierced;
			}
			//Vaginal Array
			for(i = 0; i < char.vaginas.length; i++) {
				player.createVagina();
			}
			for(i = 0; i < char.vaginas.length; i++) {
				player.vaginas[i].clitPierced = char.vaginas[i].clitPierced;
			}
			//Nipples
			if(char.nippleLength == undefined) player.nippleLength = .25;
			else player.nippleLength = char.nippleLength;
			//Set Breast Array
			for(i = 0; i < char.breastRows.length; i++) {
				player.createBreastRow();
			}
			//Populate Breast Array
			for(i = 0; i < char.breastRows.length; i++) {
				player.breastRows[i].breasts = char.breastRows[i].breasts;
				player.breastRows[i].breastRating = char.breastRows[i].breastRating;
			}
			return true;
		}
		
		///Initialize character
		public function addMainChar(menu:Object, crea:Boolean = false):void{
			reset();
			toNote("Loaded.", true);
			//Colors
			skinColor = player.skinTone;
			hairColor = player.hairColor;
			if(skinColorAry[skinColor] ==  undefined){
				toNote("Skin tone not found: "+skinColor+ ".", true);
				skinColor = "light";
			}
			if(hairColorAry[hairColor] ==  undefined){
				toNote("Hair color not found: "+hairColor+ ".", true);
				hairColor = "red";
			}
			//Characteristics
			playerName = player.short;
			heightMod = 82/ player.tallness;
			masculine = int(player.femininity < 50);
			hasBalls = player.balls > 0;
			//Technical
			drawParent = mainParent;
			//Drawing
			partRefs = [];
			drawCharacter();
			colorCharacter();
			//Menus
			createBigAry();
			if (!crea){
				if (!isTiTS) updateCoCMenu();
				if (isTiTS) updateTiTSMenu();
			}
			//Scaling
			var sca = player.tallness/82;
			scale(drawParent, sca, 650, 0, true);
			drawParent.y = 720-drawParent.height;
			//Menu
			loadMenu("", menu);
			buttons.characterCap.unLock();
			buttons.backgroundCap.unLock();
			buttons.charRes.unLock();
		}
		public function addNPChar(ary:Array, len:int, sel:Array):void{
			if (len+1 == NPCData.length) selectedLists[0] = sel;
			if (len == foeData.length) selectedLists[1] = sel;
			var NPC:Object = ary[0];
			var num:int = ary[1];
			if(charactersParent.getChildByName(String(num))){
				remove(charactersParent.getChildByName(String(num)));
				return;
			}
			var save:Object = {};
			save.characters = {};
			save.characters[num] = NPC;
			if (!loadTiTS(save, num)) return;
			toNote("Added "+ NPC.short+ ".", true);
			//Colors
			skinColor = player.skinTone;
			hairColor = player.hairColor;
			if(skinColorAry[skinColor] ==  undefined){
				toNote("Skin tone not found: "+skinColor+ ".", true);
				skinColor = "light";
			}
			if(hairColorAry[hairColor] ==  undefined){
				toNote("Hair color not found: "+hairColor+ ".", true);
				hairColor = "red";
			}
			//Characteristics
			heightMod = 82/ player.tallness;
			masculine = int(player.femininity < 50);
			hasBalls = player.balls > 0;
			//Technical
			var par:MovieClip = new MovieClip;
			charactersParent.addChild(par);
			par.doubleClickEnabled = true;
			par.buttonMode = true;
			par.mouseChildren = false;
			drawParent = par;
			drawParent.name = String(num);
			//Drawing
			partRefs = [];
			drawCharacter();
			colorCharacter();
			//Scaling
			var sca = player.tallness/82;
			scale(drawParent, sca, 650, 0, true);
			drawParent.y = mainParent.y + 1.2*mainParent.height - 1.2*drawParent.height;
			drawParent.x = (1224-drawParent.width) * Math.random() + 200;
			var comp:MovieClip;
			for(i=0; i<charactersParent.numChildren; i++){
				comp = charactersParent.getChildAt(i) as MovieClip;
				if (drawParent.height > comp.height){
					charactersParent.setChildIndex(drawParent, i);
					return;
				}
			}
		}
		
		////Drawing
		///Adding
		public function drawCharacter():void{
			trace("/\/Commencing drawing")
			addTails();
			addPart("wings", player.wingType)
			addArms();
			addAss();
			addLegs();
			addBody();
			addFace();
			addPart("eyes", player.eyeType);
			addHair();
			addHorns();
			addEars();
			addHips();
			addHand();
			addVag();
			addBalls();
			addBoobs();
			addCocks();
			addPart("gills", 0);
			addPart("ovi", int(player.canOviposit()));	
			updateBoobMasks();
		}
		public function addPart(partName:String, j:int=0, k:int=0, l:int=0):void{
			dictFindPart(partName, j, k, l);
			addPartRef(partName, foundPart)
		}
		public function addFace():void{
			var newHead:MovieClip;
			if (masculine) newHead = new MaleHead();
			else newHead = new FemaleHead();
			drawParent.addChild(newHead);
			addPartRef("head", newHead, "fillbg", "shading");
			u = 2-Math.floor(player.femininity/34);
			n = 0
			/*if (player.cor >= 75) n = 1;
			else if (player.lust > 80 || player.lib > 80) n = 2;*/
			dictFindPart("face", n, u, 0);
			foundPart.name = "face";
			addPartRef("face", foundPart, "fillbg", "shading", "", "", "lips", "lipsShading", "pupils");
		}
		public function addBody():void{
			n = Math.floor(player.tone/51);
			dictFindPart("body", skinType, masculine, n);
			addPartRef("body", foundPart, "fillbg", "shading");
			partIndex = getIn(foundPart);
			var test:MovieClip = foundPart;
			dictFindPart("body", skinType, masculine, n);
			addPartRef("ghostbody", foundPart, "fillbg", "shading", "", "", "", "", "", true);
			test.addChild(foundPart);
		}
		public function addHand():void{
			dictFindPart("hand", masculine);
			addPartRef("hand", foundPart, "fillbg", "shading");
		}
		public function addLegs():void{
			dictFindPart("legs", masculine, skinType);
			addPartRef("legs", foundPart, "fillbg", "shading");
		}
		public function addHips():void{
			u = born(player.hipRating,0,20)
			dictFindPart("hips",masculine,u);
			addPartRef("hips", foundPart, "fillbg", "shading");
		}
		public function addHair():void{
			n = born(player.hairLength,0,16);
			dictFindPart("hair", n, 0, 1);
			addPartRef("backHair", foundPart, "", "", "hairbg", "shading");
			drawParent.addChildAt(foundPart, partIndex);
			dictFindPart("hair", n, 0, 0);
			addPartRef("hair", foundPart, "", "", "hairbg", "shading");
			partIndex = getIn(foundPart);
		}
		public function addEars():void{
			u = int(player.hairLength > 10);
			dictFindPart("ears", player.earType, 0, u);
			addPartRef("ears", foundPart, "fillbg", "shading");
			
		}
		public function addAss():void{
			dictFindPart("butt", born(player.buttRating, 0, 16));
			addPartRef("butt", foundPart, "", "shading");
		}
		public function addVag():void{
			u = int(player.vaginas.length > 0);
			n = masculine;
			dictFindPart("vag", u, n);
			addPartRef("vag", foundPart, "fillbg", "shading");
			
			n = born(player.clitLength * heightMod, 0, 8);
			if (u == 0) n = 0;
			if (player.ballSize > 5 && hasBalls) n = 0;
			if (player.ballSize > 3 && player.clitLength < 7 && hasBalls) n = 0;
			dictFindPart("clit", 0, n);
			addPartRef("clit", foundPart, "", "skin", "", "", "fillbg", "shading");
		}
		public function addBalls():void{
			u = born(player.ballSize * heightMod, 0, 8) * int(hasBalls)
			if (u < 8){
				dictFindPart("balls", skinType, 0, u);
				addPartRef("balls", foundPart, "fillbg", "shading");
				foundPart.name = "balls";
			}else{
				var balls = new NormalBallsSc();
				var scale = new NormalBallsScMC();
				drawParent.addChild(balls);
				balls.addChildAt(scale, balls.numChildren-1);
				scale.x = 161.55;
				scale.y = 375;
				balls.name = "balls";
				addPartRef("balls", balls, "", "shading");
				addPartRef("ballsMC", scale, "fillbg", "shading");
			}
		}
		public function addCocks():void{
			var comp:MovieClip;
			var aryLength:int =  player.cocks.length;
			var baseIndex:int = drawParent.numChildren;
			
			if (player.breastRows[0])
				if (player.breastRows[0].breastRating >= 80)
					baseIndex = getIn(getPart("boobs0"));
			
			if (player.breastRows[1])
				if (player.breastRows[1].breastRating >= 80)
					baseIndex = getIn(getPart("boobs1"));
			
			if (player.breastRows[2])
				if (player.breastRows[2].breastRating >=27)
					baseIndex = getIn(getPart("boobs2"));
			
			if (player.breastRows[2])
				if (player.breastRows[3].breastRating >=9)
					baseIndex = getIn(getPart("boobs3"));
			
			player.cocks  = randomize(player.cocks);
			
			var ranRed:Number = 1-Math.pow(4, -0.3*aryLength)//Approaches 1 when aryLength grows
			var minRot:Number = -19 * ranRed;
			var maxRot:Number = 25 * ranRed;
			var rotRange:Number = maxRot - minRot;
			var bottom:Boolean = true;
			var aru:Array = [];
			var ara:Array = [];
			for (var n=0;n<aryLength;n++){
				trace("Adding cock "+n);
				addInfo.cockNum++;
				u = born(player.cocks[n].cockLength * heightMod, 1, 27);
				dictFindPart("cock", player.cocks[n].cockType, u);
				addPartRef("cock"+n,foundPart, "fillbg", "shading", "", "", "headFill", "headShade");
				drawParent.setChildIndex(foundPart, baseIndex);
				
				foundPart.MC.rotation = (Math.random()*rotRange + minRot);
				foundPart.x = -foundPart.MC.rotation/10;
				foundPart.MC.scaleX -= Math.abs(n-(aryLength/2))/20;
				foundPart.MC.scaleY += (foundPart.MC.rotation-minRot)/(10*rotRange);
				aru.push(foundPart.MC.scaleX);
				ara.push(foundPart.MC.scaleY);
				
				if (n == 0 && Math.random() > 0.5 && aryLength > 2){
					foundPart.MC.rotation = minRot + Math.random();
					bottom = false;
				}
				if (n == 1 && bottom && aryLength > 2){
					foundPart.MC.rotation = minRot + Math.random();
				}
			}
		}
		public function addBoobs():void{
			var minBoob:int = Math.min(player.breastRows.length-1, 3);
			var nipLen:int = born(player.nippleLength*2, 0, 7);
			var boob:MovieClip;
			var boobMask:MovieClip;
			for (n=minBoob;n>=0;n--){
				trace("Adding boob row",n);
				addInfo.boobNum++;
				u = born(player.breastRows[n].breastRating * heightMod, 0, 80);
				u = born(u, 0, 81)
				
				if(n==0) dictFindPart("boobs",0,u);
				else	 dictFindPart("boobs",1,u);
				addPartRef("boobs"+n, foundPart, "fillbg", "shading", "", "", "areola", "areolaShading");
				setBoobPos(n);
				boob = foundPart;
				
				if(n==0) dictFindPart("boobs",0,u);
				else	 dictFindPart("boobs",1,u);
				addPartRef("ghostboobs"+n, foundPart, "fillbg", "shading", "", "", "areola", "areolaShading", "", true);
				setBoobPos(n);
				boobMask = new MovieClip;
				boob.addChild(boobMask);
				foundPart.mask = boobMask;
				
				foundPart = getDeepChildByName(boob, "leftNipple");
				addPartRef("leftNipple"+n, foundPart, "", "", "", "", "fillbg", "shading");
				
				foundPart = getDeepChildByName(boob, "rightNipple");
				addPartRef("rightNipple"+n, foundPart, "", "", "", "", "fillbg", "shading");
				
				for (u=1; u<nipLen; u++) cycle("1; 8; leftNipple"+n+",0,1,0; rightNipple"+n+",0,1,0;");
			}
			addInfo.boobSpot -= addInfo.boobNum;
		}
		public function addTails():void{
			if (player.tailType == 13 ){
				for ( u = 0; u < player.tailVenom; u++){
					dictFindPart("tail", player.tailType);
					if (u % 4 == 1) foundPart.MC.scaleX = -1;
					if (u % 4 == 2) foundPart.MC.scaleY = -1;
					if (u % 4 == 3) scale(foundPart.MC, -1);
					var rot = ((Math.random() * 10) -5) * player.tailVenom;
					foundPart.MC.rotation = rot; 
					addPartRef("tail"+u, foundPart, "skinbg", "", "hairbg");
				}
			}else{
				dictFindPart("tail", player.tailType);
				addPartRef("tail", foundPart, "skinbg", "", "hairbg");
			}
		}
		public function addHorns():void{
			dictFindPart("horns",player.hornType);
			addPartRef("horns", foundPart);
			if (player.antennae >0){
				dictFindPart("horns",6);
				addPartRef("antennae", foundPart);
			}
		}
		public function addArms():void{
			dictFindPart("arms", player.armType);
			addPartRef("arms", foundPart, "fillbg", "shading");
		}
		public function updateBoobMasks():void{
			//Load
			//Contains parts to shade
			var obj:Object = {};
			//Contains those part's ghosts (darkshaded version that will be masked by additional shadow shapes)
			var ghost:Object = {};
			
			//Fill obj with parts to shade
			obj.body = getPart("body");
			obj.legs = getPart("legs");
			for (var i=0; i<4; i++){
				obj["boobs"+i] = getPart("boobs"+i);
			}
			
			//For each part to shade
			for (var key:String in obj){
				//Create the ghost name
				var id:String = "ghost"+key;
				//Load the part to shade
				var part:MovieClip = obj[key];
				//Load the ref of said part
				var oldRef:Object = partRefs[key];
				//If there's already a partref for the ghost, delete it, and remove old part
				if (partRefs[id]){
					remove(partRefs[id].part);
					remove(partRefs[id].part.mask);
					delete partRefs[id];
				}
				//If there's actually a part to shade
				if (part){
					//Clone the part to shade
					part = new (getClass(obj[key]))();
					//Name the clone
					part.name = id;
					//Create a new object, make it a part ref, and load it
					var newRef = partRefs[id] = {part:part};
					//Part ref for a ghost, so fully shade, so ghost = true
					newRef.ghost = true;
					//Transfer the names of the parts to shade
					newRef.partB = getDeepChildByName(part, "fillbg");
					newRef.partS = getDeepChildByName(part, "shading");
					if(oldRef.bitsB)	newRef.bitsB = getDeepChildByName(part, oldRef.bitsB.name);
					if(oldRef.bitsS)	newRef.bitsS = getDeepChildByName(part, oldRef.bitsS.name);
					//Color ghost
					colorPart(newRef);
					//Add it at the index of the part to shade+1 (over it)
					drawParent.addChildAt(part, getIn(getPart(key))+1);
					
					//If mask//!!!
					part.mask = new MovieClip;
					part.cacheAsBitmap = true;
					part.mask.cacheAsBitmap = true;
					
					//If said part is boobs
					if (key.slice(0, -1) == "boobs"){
						//Create the mask
						part.mask = new MovieClip;
						//Add the mask to drawparent for scaling purpose
						drawParent.addChild(part.mask);
						//The boob number
						i = key.slice(-1);
						//Set the boob pos
						setBoobPos(int(i), part);
						//Add nipples part refs !!!
						var leftNip:MovieClip = getDeepChildByName(part, "leftNipple");
						var rightNip:MovieClip = getDeepChildByName(part, "rightNipple");
						addPartRef("ghostleftNipple"+i, leftNip, "", "", "", "", "fillbg", "shading", "", true);
						addPartRef("ghostrightNipple"+i, rightNip, "", "", "", "", "fillbg", "shading", "", true);
						colorPart(partRefs["ghostleftNipple"+i]);
						colorPart(partRefs["ghostrightNipple"+i]);
						
						var u:int = getPartInd("leftNipple"+i)[2];
						if (u < 1){
							cycle("-1; 10; ghostrightNipple"+i+",0,1,0")
							cycle("-1; 10; ghostleftNipple"+i+",0,1,0")
						}else{
							for (var l=1; l<u; l++){
								cycle("1; 10; ghostrightNipple"+i+",0,1,0")
								cycle("1; 10; ghostleftNipple"+i+",0,1,0")
							}
						}
					}
					//Add ghost to ghost
					ghost[key] = part;
				}
			}
			//Create legs and body mask
			var bodyMask:MovieClip = new MovieClip;
			var legsMask:MovieClip = new MovieClip;
			//Add them fo scaling
			drawParent.addChild(bodyMask);
			drawParent.addChild(legsMask);
			//Set them as mask
			ghost["body"].mask = bodyMask;
			ghost["legs"].mask = legsMask;
			//Cache as bitmap
			bodyMask.cacheAsBitmap = true;
			legsMask.cacheAsBitmap = true;
			
			//From 1 to 3
			for (var n=1; n<4; n++){
				//Check if there's a ghost of boobs+n
				if (ghost["boobs"+(n-1)]){
					//Find the shadow mask to apply on ghost, the shadow of the boob+(n-1) on boobs+n
					dictFindPart("shade", getPartInd("boobs"+(n-1))[2], 0, 0);//getPartInd("boobs"+n)[2]);
					//Cache as bitmap for masking
					foundPart.cacheAsBitmap = true;
					//Add shadow mask to body mask MC
					bodyMask.addChild(foundPart);
					//Move shadow accurately to boobs
					setBoobPos(n-1);
					//Copy it
					foundPart = new (getClass(foundPart));
					//Cache as bitmap for masking
					foundPart.cacheAsBitmap = true;
					//Add it to legs MC
					legsMask.addChild(foundPart);
					//legsMask.graphics.copyFrom(foundPart.graphics);
					//Move again
					setBoobPos(n-1);
					//i from [1, 2, 3] to 3
					for (i=n; i<4; i++){
						//If there's a ghost of boob+i (boobs+n and lower)
						if (ghost["boobs"+i]){
							//Duplicate shadow mask
							foundPart = new (getClass(foundPart));
							//Cache as bitmap for masking
							foundPart.cacheAsBitmap = true;
							//Name it, because whatevs
							foundPart.name = n+"boobs"+i;
							//Add it to the mask MC
							ghost["boobs"+i].mask.addChild(foundPart);
							ghost["boobs"+i].mask.cacheAsBitmap = true;
							//Move it
							setBoobPos(n-1);
						}
					}
				}
			}
		}
		public function setBoobPos(val:int, target:MovieClip = undefined):void{
			if (target == undefined) target = foundPart;
			target.y = [0, 19.9, 49.45, 85.55][val];
			target.x = [0, 24.95, 29.7, 16.30][val];
			target.rotation = [0, 6.5, 7.5, 5.5][val];
		}
		
		///Coloring
		//Runs through partRefs to add colors
		public function colorCharacter():void{
			trace("/\/Commencing coloring");
			trace("Color:",skinColor,skinColorAry[skinColor],hairColor,hairColorAry[hairColor]);
			trace("Shade:",skinColor, skinShadeAry[skinColor],hairColor,hairShadeAry[hairColor]);
			trace("Skin type is "+ skinType);
			for each(var obj in partRefs){
				colorPart(obj);
			}
		}
		//Color a single part
		public function colorPart(target:Object):void{
			trace("Coloring part "+target.part.name);
			var code:Array = [0,1,2,3,4,5];
			if (skinType == 1) code = [2,3,2,3,4,5];
			if (target.ghost){
				for (var i=0; i<6; i+=2){
					code[i] = code[i+1];
				}
			}
			shade(target.partB, code[0]);
			shade(target.partS, code[1]);
			shade(target.hairB, code[2]);
			shade(target.hairS, code[3]);
			shade(target.bitsB, code[4]);
			shade(target.bitsS, code[5]);
			shade(target.pupils, 6);
		}
		//Shade subparts as a defined type
		public function shade(item:*, type:int):void{
			if (item == undefined)return;
			if (ct == undefined) ct = new ColorTransform();
			ct.color = 0000000;
			switch (type){
				case 0: ct.color = skinColorAry[skinColor]; break;
				case 1: ct.color = skinShadeAry[skinColor]; break;
				case 2: ct.color = hairColorAry[hairColor]; break;
				case 3: ct.color = hairShadeAry[hairColor]; break;
				case 4: ct.color = bitsColorAry[skinColor]; break;
				case 5: ct.color = bitsShadeAry[skinColor]; break;
				case 6: ct.color = eyeColor; break;
			}
			item.transform.colorTransform = ct;
		}
		//Get a random uint color code, for the pupils
		public function getRandomColor():uint{
			var letters = '0123456789ABCDEF'.split('');
			var color = '0x';
			for (var i = 0; i < 6; i++ ) {
				color += letters[Math.round(Math.random() * 15)];
			}
			return color;
		}
		//Change color related characteristic and recolor character
		public function changeSkinType(type:int):void{
			trace("Changed skin type to "+ type);
			skinType = type;
			colorCharacter();
		}
		public function changeHairClr(color:String):void{
			trace("Changed hair color to "+ color);
			hairColor = color;
			colorCharacter();
		}
		public function changeSkinClr(color:String):void{
			trace("Changed skin color to "+ color);
			skinColor = color;
			colorCharacter();
		}
		//Randomize eyeColor
		public function changeEyeClr(color:uint):void{
			var tar = MovieClip(mainParent.getChildByName("face")).pupils;
			eyeColor = color;
			ct.color = eyeColor;
			tar.transform.colorTransform = ct;
		}
		
		////Interactions
		///Initialization
		public function initGUI():void{
			remove(panels);
			remove(back);
			remove(texture);
			backgroundBitmap = new Bitmap(new BitmapData(1674, 980, false), "always");
			backgroundBitmap.bitmapData.draw(panels);
			backgroundBitmap.bitmapData.draw(back);
			backgroundBitmap.bitmapData.draw(texture, null, new ColorTransform(1, 1, 1, 0.1), BlendMode.MULTIPLY);
			this.addChildAt(backgroundBitmap, 0);
			//Notes
			notes = new TextField();
			notes.x = 1440;
			notes.y = 40;
			notes.width = 215;
			notes.height = 300;
			notes.wordWrap = true;
			notes.antiAliasType = AntiAliasType.ADVANCED;
			notes.sharpness = 100;
			notes.thickness = 100;
			notes.defaultTextFormat = new TextFormat(CoC_Font.name, 24);
			//Scrollbar
			scrollBar = new DIC_ScrollBar();
			scrollBar.scrollTarget = notes;
			scrollBar.height = notes.height+2;
			scrollBar.move(notes.x-1 + notes.width-0.25, notes.y-1);
			scrollBar.visible = false;
			//Children
			addChild(notes);
			addChild(scrollBar);
			addChild(creatureParent);
			addChild(charactersParent);
			addChild(menuBtns);
			addChild(basicBtns);
			addChild(savesBtns);
			charactersParent.addChild(mainParent);
			//Masking
			//Will need to implement http://gskinner.com/blog/archives/2006/11/understanding_d.html		
			//mainParent.cacheAsBitmap = true;
			//creatureParent.cacheAsBitmap = true;
			//charactersParent.cacheAsBitmap = true;
			charactersParent.x += 200;
			creatureParent.x += 200;
			var rect:Rectangle = new Rectangle(0, 0, 1224, 980);
			creatureParent.scrollRect = rect;
			charactersParent.scrollRect = rect;
			//Stage
			stage.stageFocusRect = false;
			//Properties
			menuBtns.y = 450;
			basicBtns.x = 1424;
			mainParent.mouseChildren = false;
			mainParent.buttonMode = true;//!!!
			creatureParent.buttonMode = true;
			//Innit menu arrays
			initCoCMenu();
			initTiTSMenu();
			initCreatorMenu();
			//Buttons
			addSavesBtns();
			addBasicBtns();
			//Events
			addEventListener(Event.ENTER_FRAME, resoSlide);
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			addEventListener(MouseEvent.MOUSE_UP, onDrop);
			addEventListener(MouseEvent.MOUSE_UP, onUp);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onFocus);
			creatureParent.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			creatureParent.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			charactersParent.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			charactersParent.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			clickTimer.addEventListener(TimerEvent.TIMER, onHoldClick);
			clickFastTimer.addEventListener(TimerEvent.TIMER, onHoldClick);
			
			initStyleManager();
			
			//this.addChild(new TheMiner());
			//!!!
		}
		public function initCoCMenu():void{
			setObject(CoCMenu, {
				0:["menu", "bgMenu", "Background", CoCBackgroundMenu],
				1:["menu", "creatureMenu", "Creatures", CoCCreatureMenu],
				2:["menu", "itemMenu", "Items", CoCItemMenu],
				3:["menu", "detailMenu", "Details", CoCDetailMenu],
				4:["menu", "sliderMenu", "Sliders", CoCSliderMenu],
				11:["note", "Save loaded.\rYou can modify various bits of your character, take pictures, add creatures, etc."]});
			setObject(CoCCreatureMenu, {
				0:["item", "GoblinNPC", "Goblin", speCreature],
				9:["function", "clearCreatures", "Clear all", clearCreatures],
				10:["back", CoCMenu],
				11:["note", "Here you can load creatures you encountered during your adventures. \r\rCreatures are placed at player height. You can drag and drop them, drop them outside to delete them, and clear them all."]});
			setObject(CoCItemMenu, {
				0:["item", "TestDagger", "Dagger", speDagger],
				9:["function", "clearObject", "Clear all", clearEquipment],
				10:["back", CoCMenu],
				11:["note", "Here you can equip some of the equipment you've gathered during your journey. You can add right and left hand weapons, and a few clothes."]});
			setObject(CoCDetailMenu, {
				0:["toggle", "balls", "Toggle Balls", true],
				1:["toggle", "gills", "Toggle Gills", true],
				2:["toggle", "ovi", "Toggle Ovip", true],
				3:["picker", changeEyeClr],
				10:["back", CoCMenu],
				11:["note", "Here you can shuffle your eye color, and save it for this character. You can also toggle various parts."]});
		}
		public function initTiTSMenu():void{
			setObject(TiTSMenu, {
				0:["menu", "bgMenu", "Background", TiTSBackgroundMenu],
				1:["menu", "creatureMenu", "Creatures", TiTSCreatureMenu],
				2:["menu", "NPCMenu", "NPCs", TiTSNPCMenu],
				3:["menu", "foeMenu", "Foes", TiTSFoeMenu],
				4:["menu", "itemMenu", "Items", TiTSItemMenu],
				5:["menu", "detailMenu", "Details", TiTSDetailMenu],
				6:["menu", "sliderMenu", "Sliders", TiTSSliderMenu],
				11:["note", "Save loaded.\rYou can modify various bits of your character, take pictures, add creatures, etc."]});
			setObject(TiTSBackgroundMenu, {
				0:["background", "Normal", true, 7],
				1:["background", "Tavros", true, 8],
				2:["background", "Mhen'ga", true, 9],
				3:["background", "Tarkus", true, 10],
				//4:["background", "None", true, 6],//!!!
				10:["back", TiTSMenu],
				11:["note", "Here you can load every places you can explore, as your background."]});
			setObject(TiTSCreatureMenu, {
				9:["function", "clearCreatures", "Clear all", clearCreatures],
				10:["back", TiTSMenu],
				11:["note", "Here you can load Creatures you encountered during your adventures. \r\rCreatures are placed at player height. You can drag and drop them, drop them outside to delete them, and clear them all."]});
			setObject(TiTSItemMenu, {
				0:["item", "TestDagger", "Dagger", speDagger],
				9:["function", "clearObject", "Clear all", clearEquipment],
				10:["back", TiTSMenu],
				11:["note", "Here you can equip some of the equipment you've gathered during your journey. You can add right and left hand weapons, and a few clothes."]});
			setObject(TiTSDetailMenu, {
				0:["toggle", "balls", "Toggle Balls", true],
				1:["toggle", "gills", "Toggle Gills", true],
				2:["toggle", "ovi", "Toggle Ovip", true],
				3:["picker", changeEyeClr],
				10:["back", TiTSMenu],
				11:["note", "Here you can shuffle your eye color, and save it for this character. You can also toggle various parts."]});
		}
		public function initCreatorMenu():void{
			setObject(creatorMenu, {
				0:["menu", "head", "Head", headMenu],
				1:["menu", "torso", "Torso", torsoMenu],
				2:["menu", "naughty", "Genitals", naughtyMenu],
				3:["menu", "legs", "Legs", legsMenu],
				4:["menu", "other", "Others", otherMenu],
				11:["note", "Here you can create your very own character, from scratch! Just cycle the parts you wish to change."]});
			setObject(headMenu, {
				0:["cycle", "3; face,1,1,0",				"26; face,0,0,1",					"Face"],
				1:["cycle", "",								"2; head,1,0,0", 					"Head"],
				2:["cycle", "", 							"12; ears,1,0,0", 					"Ears"],
				3:["cycle", "4; hair,0,1,0; backHair,0,1,0","100; hair,1,0,0; backHair,1,0,0",	"Hair"],
				4:["cycle", "", 							"15; horns,1,0,0", 					"Horns"],
				10:["back", creatorMenu]});
			setObject(torsoMenu, {
				0:["cycle", "2; body,0,1,0; ghostbody,0,1,0; hips,1,0,0; legs,1,0,0; vag,0,1,0; hand,1,0,0",	"10; body,1,0,1; ghostbody,1,0,1", 	"Body"],
				1:["cycle", "", "10; arms,1,0,0",	"Arms"],
				2:["cycle", "", "15; wings,1,0,0",	"Wings"],
				3:["list", 	"boob", "Row ", "8; leftNippleX,0,1,0; rightNippleX,0,1,0;", "100; boobsX,0,1,0", lessBoobs, moreBoobs],
				10:["back", creatorMenu],
				11:["note", "Here you can cycle boobs and add more, up to four rows."]});
			setObject(naughtyMenu, {
				0:["cycle", "", 				"2; vag,1,0,0", 	"Pussy"],
				1:["cycle", "", 				"10; clit,0,1,0", 	"Clit"],
				2:["cycle", "10; balls,1,0,0",	"10; balls,0,0,1",	"Ball"],
				3:["menu", "cocks", "Cocks", cockMenu],
				10:["back", creatorMenu],
				11:["note", "Here you can cycle genitals. To access the cock editing list, click \"Cocks\"."]});
			setObject(cockMenu, {
				0:["list", 	"cock", "Cock ", "10; cockX,1,0,0,1", "200; cockX,0,1,0,1", lessCocks, moreCocks],
				10:["back", creatorMenu],
				11:["note", "Here you can cycle cocks and add more if you whish."]});
			setObject(legsMenu, {
				0:["cycle", "", "25; legs,0,1,0", "Legs"],
				1:["cycle", "", "23; hips,0,1,0", "Hips"],
				2:["cycle", "", "10; butt,1,0,0", "Butt"],
				3:["cycle", "", "26; tail,1,0,0", "Tail"],
				10:["back", creatorMenu],
				11:["note", ""]});
			setObject(otherMenu, {
				0:["toggle", "gills", "Toggle Gills", true],
				1:["toggle", "ovi", "Toggle Ovip", true],
				2:["toggle", "balls", "Toggle Balls", true],
				3:["picker", changeEyeClr],
				4:["dropdown", "typeChanger", "Skin Type", skinTypesNames, changeSkinType],
				5:["dropdown", "skinChanger", "Skin Color", skinColorNames, changeSkinClr],
				6:["dropdown", "hairChanger", "Hair Color", hairColorNames, changeHairClr],
				10:["back", creatorMenu],
				11:["note", "Here you can change skin type and color, hair color, eye color, and toggle various parts."]});
		}
		public function initStyleManager(mod:int = 0):void{
			var form:TextFormat = new TextFormat();
			var font:Font = new [CoC_Font, TiTS_Font][mod];
			form.font = font.fontName;
			form.color = [0x000000, 0xFFFFFF][mod];
			notes.defaultTextFormat = form;
			form.size = 18;
			StyleManager.setStyle('embedFonts',true);
			StyleManager.setStyle('textFormat',form);	
		}
		public function updateCoCMenu():void{
			//Load explored locations
			setObject(CoCBackgroundMenu, {
			0:["background", "Normal", true, 1],
			1:["background", "Mountain", Boolean(player.exploredMountain), 2],
			2:["background", "Lake", Boolean(player.exploredLake), 3],
			3:["background", "Forest", Boolean(player.exploredForest), 4],
			4:["background", "Desert", Boolean(player.exploredDesert), 5],
			//5:["background", "None", true, 6],//!!!
			10:["back", CoCMenu],
			11:["note", "Here you can load various places you've explored through your adventures!"]});			
			
			setObject(CoCSliderMenu,{
			0:["slider", 96, player.tallness-24, tallSlide, true],
			1:["slider", born(player.ballSize * heightMod - 7, 0, 25), 0, ballSlide, hasBalls && (player.ballSize * heightMod > 7)],
			2:["slider", born(player.clitLength * heightMod - 8,0,25), 0, clitSlide, (getPartInd("clit")[1] == 8)],
			3:["dropdown", "cockChanger", "Choose cock", bigCockList, cockSlideChange],
			4:["special", addCockSlider],
			5:["dropdown", "boobChanger", "Choose row", bigBoobList, boobSlideChange],
			6:["special", addBoobSlider],
			10:["back", CoCMenu],
			11:["note", "To be sure everything looks fine, the viewer prevents extreme sizes, but here you can scale them up to your real size. If you have multiple breasts and dicks above the maximum size, you just have to select which one you desire to change."]});
		}
		public function updateTiTSMenu():void{		
			setObject(TiTSSliderMenu,{
			0:["slider", 96, player.tallness-24, tallSlide, true],
			1:["slider", born(player.ballSize * heightMod - 7, 0, 25), 0, ballSlide, hasBalls && (player.ballSize * heightMod > 7)],
			2:["slider", born(player.clitLength * heightMod - 8,0,25), 0, clitSlide, (getPartInd("clit")[1] == 8)],
			3:["dropdown", "cockChanger", "Choose cock", bigCockList, cockSlideChange],
			4:["special", addCockSlider],
			5:["dropdown", "boobChanger", "Choose row", bigBoobList, boobSlideChange],
			6:["special", addBoobSlider],
			10:["back", TiTSMenu],
			11:["note", "To be sure everything looks fine, the viewer prevents extreme sizes, but here you can scale them up to your real size. If you have multiple breasts and dicks above the maximum size, you just have to select which one you desire to change."]});
			
			setObject(TiTSNPCMenu, {
			0:["scroll", {}, addNPChar, 0],
			9:["function", "clearNPCs", "Clear all", clearChars],
			10:["back", TiTSMenu],
			11:["note", "Here you can add all the important characters you've encountered through your adventures. The menu supports shift and control clicking. You can also set the depth with the mouse wheel."]});
			var obj:Object = {}
			for (i=1; i<NPCData.length; i++){
				if (NPCData[i]){
					obj[NPCData[i].short] = [NPCData[i], i];
				}
			}
			TiTSNPCMenu[0][1] = obj;
			
			setObject(TiTSFoeMenu, {
			0:["scroll", {}, addNPChar, 1],
			9:["function", "clearFoes", "Clear all", clearChars],
			10:["back", TiTSMenu],
			11:["note", "Here you can add the murderers, arsonists and jailwalkers you've encountered through your travels. Why would you do that? Not my problem. The menu supports shift and control clicking. You can also set the depth with the mouse wheel."]});
			obj = {};
			for (i=0; i<foeData.length; i++){
				if (foeData[i]){
					obj[foeData[i].short] = [foeData[i], i];
				}
			}
			TiTSFoeMenu[0][1] = obj;
		}
		///Modes
		public function switchGUI(btnName:String):void{
			var form:TextFormat;
			var font:Font;
			var tempFram:int;
			DIC_Data.isTiTS = isTiTS = (btnName == "TiTS");
			var mod:int = int(isTiTS);
			
			reset();
			
			initStyleManager(mod);
			
			clearMenu(savesBtns);
			clearMenu(basicBtns);
			addSavesBtns();
			addBasicBtns();
			panels.gotoAndStop(mod+1);
			
			scrollBar.switchMode(isTiTS);
			
			backgroundBitmap.bitmapData.draw(panels);
			backgroundBitmap.bitmapData.draw(back);
			if (!isTiTS) backgroundBitmap.bitmapData.draw(texture, null, new ColorTransform(1, 1, 1, 0.1), BlendMode.MULTIPLY);
			
			buttons.switchM.name = ["TiTS", "CoC"][mod];
			buttons.switchM.text.text = ["TiTS", "CoC"][mod];
			buttons.switchM.MC.gotoAndStop(1);
			
			if (isTiTS){
				classDict = TiTSDict;
			}else{
				classDict = CoCDict;
			}
		}
		
		///Menu
		//Populate menus
		public function loadMenu(btnName:String, ary:Object):void{
			toNote();
			clearMenu();
			var dec:int = [78, 80][int(isTiTS)];
			for (var key:String in ary){
				var val:Array = ary[key];
				i = int(key);
				j = 45*i + 35;
				switch (val[0]){
					//Will load another menu
					case "menu":
						menuBtns.addChild(new DIC_Button(val[1], 100, j, val[2], loadMenu, true, val[3]));
					break;
					//Will toggle a part from it's name
					case "toggle":
						menuBtns.addChild(new DIC_Button(val[1], 100, j, val[2], toggleItem, val[3]));
					break;
					//Will run a function on click
					case "function":
						menuBtns.addChild(new DIC_Button(val[1], 100, j, val[2], val[3]));
					break;
					//Will add an item, then run its specialization function
					case "item":
						menuBtns.addChild(new DIC_Button(val[1], 100, j, val[2], addObject, true, val[3]));
					break;
					//Will switch to a background, if it is unlocked
					case "background":
						menuBtns.addChild(new DIC_Button(val[1], 100, j, val[1], changeBackground, val[2], val[3]));
					break;
					//Will change something's color
					case "dropdown":
						menuBtns.addChild(new DIC_Dropdown(val[1], val[2], j, val[3], val[4]));
					break;
					case "picker":
						menuBtns.addChild(new DIC_Color(j, val[1], eyeColor));
					break;
					//Will create a slider
					case "slider":
						if(val[4]) menuBtns.addChild(new DIC_Slider(j, val[1], val[2], val[3], val[5]));
					break;
					//Will create a scrollable list
					case "scroll":
						menuBtns.addChild(new DIC_List(val[1], val[2], selectedLists[val[3]]));
					break;
					//Will cycle a part, by adding given ints to its key
					case "cycle":
						menuBtns.addChild(new DIC_Button("1; " +val[1], 100, j, val[3], cycle, val[1] != "", undefined, undefined, 120));
						menuBtns.addChild(new DIC_Arrow("-1; " +val[2], 100-dec, j, 0, cycle));
						menuBtns.addChild(new DIC_Arrow("+1; " +val[2], 100+dec, j, 2, cycle));
					break;
					case "list":
						var num:int = addInfo[val[1]+"Num"];
						var b:String = val[1]+"Btn";
						for (k=0; k<num; k++){
							addInfo[b][k] = [];
							addInfo[b][k][0] = new DIC_Button("1; "+val[3].replace(/X/g, k), 100, j+k*45, val[2]+(k+1), cycle, val[3] != "", undefined, undefined, 120);
							addInfo[b][k][1] = new DIC_Arrow("-1; "+val[4].replace(/X/g, k), 100-dec, j+k*45, 0, cycle);
							addInfo[b][k][2] = new DIC_Arrow("+1; "+val[4].replace(/X/g, k), 100+dec, j+k*45, 2, cycle);
						}
						addInfo[b][k] = [];
						addInfo[b][k][1] = new DIC_Arrow("tak", 100-dec, j+k*45, 1, val[5]);
						addInfo[b][k][2] = new DIC_Arrow("add", 100+dec, j+k*45, 3, val[6]);
						for each(var bar:Array in addInfo[b])
						for each(var btn in bar)
						menuBtns.addChild(btn);
					break;
					//Will run a function on load
					case "special":
						val[1](j);
					break;
					//Will load menu on click, but with fixed height and width
					case "back":
						menuBtns.addChild(new DIC_Button("back", 100, 10*45+35, "Back", loadMenu, true, val[1], undefined, 120));
					break;
					case "note":
						toNote(val[1]);
					break;
				}
			}
		}
		public function addBasicBtns():void{
			buttons.restart = new DIC_Button("reset", 125, 380, "Reset", reset);
			buttons.creates = new DIC_Button("createChar", 125, 420, "Create", loadFromDefault);
			//buttons.loadLoc = new DIC_Button("loadLocal", 125, 460, "Load", loadFromFile);
			buttons.scrshot = new DIC_Button("screenShot", 125, 540, "Render:", characterCap, false);
			buttons.backgroundCap = new DIC_Button("backgroundCap", 125, 580, "Composition", backgroundCap, false);
			buttons.characterCap = new DIC_Button("characterCap", 125, 620, "Character", characterCap, false);
			buttons.charRes = new DIC_Slider(660-12, 15, 1, resoSlide, "", 125, 140, false);
			buttons.fullScr = new DIC_Button("fullScreen", 125, 720, "Full Screen", toggleFullScreen, true, undefined, undefined, 140, true);
			buttons.switchM = new DIC_Button("TiTS", 125, 800, "TiTS", switchGUI);
			var ary:Array = [];
			var i:int = 0;
			for each(var btn in buttons){
				ary[i] = btn;
				i++;
			}
			ary.sortOn("y");
			for(i=0; i<ary.length; i++) basicBtns.addChild(ary[i]);
		}
		public function addSavesBtns(btnName:String = ""):void{
			var nam:String;
			var btn:MovieClip;
			var test:SharedObject;
			var saveFound:Boolean = false;
			var mod = int(isTiTS);
			clearMenu(savesBtns);
			for (i = 1; i < 10; i++){
				nam = ["CoC_", "TiTS_"][mod] + i;
				test = SharedObject.getLocal(nam,"/");
				if (test.data.exists){
					btn = new DIC_Button(nam, 100, (45* i)-10, i + ": " + test.data.short, loadFromSave);
					savesBtns.addChild(btn);
					saveFound = true;
				}
			}
			if (!saveFound) toNote("No save found, sorry. Please open this locally, or from the website you usually play the game on. You can still use the create feature, or load a file from the parent folder.");
		}
		//Clear all children from a given parent
		public function clearMenu(clearParent:MovieClip = null):void{
			if (!clearParent) clearParent = menuBtns;
			for (var i = clearParent.numChildren-1; i >= 0; i--){
				if (clearParent.getChildAt(i) !== mainParent){ 
					clearParent.removeChildAt(i);
				}
			}
		}
		//Clear specific functions
		public function clearEquipment(btnName:String):void{
			for each(var obj in equipment) remove(obj);
		}
		public function clearChars(btnName:String):void{
			selectedLists = {};
			if (btnName == "clearNPCs") loadMenu("", TiTSNPCMenu);
			if (btnName == "clearFoes") loadMenu("", TiTSFoeMenu);
			clearMenu(charactersParent);
		}
		public function clearCreatures(btnName:String):void{
			clearMenu(creatureParent);
		}
		
		///Mouse
		public function onClick(event:MouseEvent):void{
			var tar = event.target;
			if (clickFastTimer.running && event.cancelable) return;
			if (!stageLock){
				if (tar is DIC_Button){
					if (tar.enabled){
						tar.MC.gotoAndStop(2);
						if (tar.direct){
							return;
						}else if (tar.addit1 && tar.addit2){
							tar.action(tar.name, tar.addit1, tar.addit2);
						}else if (tar.addit1){
							tar.action(tar.name, tar.addit1);
						}else{
							tar.action(tar.name);
						}
					}
				}
				if (tar is DIC_Arrow){
					if (tar.enabled){
						tar.gotoAndStop(tar.fram+1);
						tar.action(tar.name);
					}
				}
			}
		}
		public function onDoubleClick(event:MouseEvent):void{
			remove(event.target as MovieClip);
		}
		public function onUp(event:MouseEvent):void{
			clickTimer.stop();
			clickFastTimer.stop();
		}
		public function onDown(event:MouseEvent):void{
			var tar = event.target;
			if (tar is DIC_Button){
				if (tar.enabled){
					tar.MC.gotoAndStop(3);
				}
			}
			if (tar is DIC_Arrow){
				if (tar.enabled){
					tar.gotoAndStop(tar.fram+2);
				}
			}
			clickTimerTarget = tar;
			clickTimer.reset();
			clickTimer.start();
		}
		public function onHoldClick(event:TimerEvent):void{
			if (clickTimerTarget.hitTestPoint(mouseX, mouseY, true)){
				clickTimerTarget.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false));
			}
			if (!clickFastTimer.running){
				clickFastTimer.start();
			}
		}
		public function onOver(event:MouseEvent):void{
			if (!event.buttonDown)
			event.target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
			var tar = event.target;
			if (tar is DIC_Button){
				if (tar.enabled){
					tar.MC.gotoAndStop(2);
				}
			}
			if (tar is DIC_Arrow){
				if (tar.enabled){
					tar.gotoAndStop(tar.fram+1);
				}
			}
		}
		public function onOut(event:MouseEvent):void{
			var tar = event.target;
			if (tar is DIC_Button){
				if (tar.enabled){
					tar.MC.gotoAndStop(1);
				}
			}
			if (tar is DIC_Arrow){
				if (tar.enabled){
					tar.gotoAndStop(tar.fram);
				}
			}
		}
		public function onDrag(event:MouseEvent):void{
			dragTarget = event.target as MovieClip;
			dragTarget.startDrag();
			Mouse.hide();
		}
		public function onDrop(event:MouseEvent):void{
			if (dragTarget){
				dragTarget.stopDrag();
				var rect:Rectangle = dragTarget.getBounds(dragTarget.parent);
				var _x:int = rect.x + rect.width/2;
				var _y:int = rect.y + rect.height/2;
				if(dragTarget.parent != charactersParent){
					if (_x<200 || _x>1424 || _y<0 || _y>980){
						remove(dragTarget);
					}
				}
			}
			Mouse.show();
		}
		public function onWheel(event:MouseEvent):void{
			var tar:MovieClip = MovieClip(event.target);
			var par:MovieClip = MovieClip(tar.parent);
			var ind:int = getIn(tar);
			var inc:int = -born(event.delta, -1, 1);
			if (inc == 0) return;
			
			for (var i = ind + inc; i >= 0 && i < par.numChildren; i+= inc){
				if (tar.hitTestObject(par.getChildAt(i))){
					par.setChildIndex(tar, i);
					return;
				}
				if (i == 0 || i == par.numChildren-1){
					par.setChildIndex(tar, i);
				}
			}
		}
		///Focus
		public function onFocus(event:FocusEvent):void{
			if (focusTarget){
				focusTarget.filters = [];
			}
			if (stage.focus){
				focusTarget = stage.focus;
				trace("Showing focus on: "+focusTarget.name);
				focusTarget.filters = [new GlowFilter([0x856032,0xFFFFFF][int(isTiTS)], 1, 7, 7, 2, 3, isTiTS)];
			}
		}
		public function onKeyPressed(event:KeyboardEvent):void{
			if (focusTarget && event.keyCode == 13){
				focusTarget.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			if (focusTarget && event.keyCode == 27){
				focusTarget.filters = [];
				focusTarget = null;
			}
		}
		///General
		//Change the background.
		public function changeBackground(btnName:String, frame:int):void{
			back.gotoAndStop(frame);
			backgroundBitmap.bitmapData.draw(panels);
			backgroundBitmap.bitmapData.draw(back);
			if (!isTiTS) backgroundBitmap.bitmapData.draw(texture, null, new ColorTransform(1, 1, 1, 0.1), BlendMode.MULTIPLY);
			
			//Ambient lighting
			
			var R:int = 0;
			var G:int = 0;
			var B:int = 0;
			
			for (var i:int = 0; i < 100; i++){
				var rgb:RGB = new Hex(backgroundBitmap.bitmapData.getPixel(Math.random() * 1274 + 200, 980 - Math.random() * Math.random() * 980)).toRGB();
				R += rgb.r;
				G += rgb.g;
				B += rgb.b;
			}
			R *= 0.01;
			G *= 0.01;
			B *= 0.01;
			R -= 126;
			G -= 126;
			B -= 126;
			R *= 0.8;
			G *= 0.8;
			B *= 0.8;
			
			if (btnName != "Normal"){
				var e:ColorTransform = new ColorTransform(1, 1, 1, 1, R, G, B);
			}else{
				var e:ColorTransform = new ColorTransform();
			}
			mainParent.transform.colorTransform = e;
		}
		//Toggle fullscreen mode
		public function toggleFullScreen(event:MouseEvent):void{
			try{
				if(stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE || stage.displayState==StageDisplayState.FULL_SCREEN){
					stage.displayState=StageDisplayState.NORMAL;
				}else{
					stage.displayState=StageDisplayState.FULL_SCREEN;
				}
			}catch(e:Error){
				toNote("Looks like fullscreen is not allowed on this website. You can contact the moderator if you need it though, or download the flash and use the projector.");
			}
		}
		
		///Screenshot
		//Will take a high-res screenCap of mainParent
        public function characterCap(btnName:String):void{
			buttons.characterCap.lock();
			buttons.backgroundCap.lock();
			buttons.charRes.lock();
			stageLock = true;
			
			var rect:Rectangle = mainParent.getBounds(mainParent);
			var matrix:Matrix = new Matrix(capScale,0,0,capScale,-rect.x*capScale,-rect.y*capScale);
			capBitmap = new BitmapData(rect.width*capScale, rect.height*capScale, true, 0x0);
			capBitmap.draw(mainParent, matrix);
			
			PNGencoder = PNGEncoder2.encodeAsync(capBitmap);
			PNGencoder.addEventListener(Event.COMPLETE, saveCap);
        }
		//Will take a normal-res screenCap of this (with btn bars cropped)
		public function backgroundCap(btnName:String):void{
			buttons.characterCap.lock();
			buttons.backgroundCap.lock();
			buttons.charRes.lock();
			stageLock = true;
			var matrix = new Matrix(1,0,0,1,-200,0);
			capBitmap = new BitmapData(1224, 980);
			capBitmap.draw(this,matrix);
			PNGencoder = PNGEncoder2.encodeAsync(capBitmap);
			PNGencoder.addEventListener(Event.COMPLETE, saveCap);
		}
		//Will save the screenCap, and unlock the btns
		public function saveCap(e:Event):void{
			try{
				var fileRef = new FileReference();
				fileRef.save(PNGencoder.png,playerName+".png");
            }catch (e:Error){
				trace("Error:"+e);
            }
			PNGencoder = null;
			capBitmap.dispose();
			buttons.characterCap.unLock();
			buttons.backgroundCap.unLock();
			buttons.charRes.unLock();
			stageLock = false;;
		}
		
		///Character modifications
		//Cycles parts
		public function cycle(btnName:String):void{
			var cycles:Array = btnName.split('; ');					//indents(-1 or +1); max(2 to 100); indent of the first part; second part; etc...
			var ind:int = int(cycles[0]);							//Determine if cycling down or up
			var max:int = int(cycles[1])-1;							//Maximum amount of cycling before return to 0, can be a lot bigger than actual number.
			var classType:Class;									//The new class
			var partReplace:MovieClip;								//The replacement part
			var cycled:Boolean;										//Wether or not a character was cycled completely
			var nam:Array;											//The ref of the part to cycle, and the keys to add
			var part:MovieClip;										//The part to cycle
			var className:String;									//The class name of the previous part
			var key:Array;											//the key of the previous part
			var i:int; 
			var j:int;
			for (j=2; j<cycles.length; j++){
				nam = cycles[j].split(',');							//The ref of the part to cycle, and the keys to add
				part = getPart(nam[0]);								//The part to cycle
				if (!part) continue;
				if (nam[1]+nam[2]+nam[3] == 0) continue;
				className = getQualifiedClassName(part);			//The class name of the previous part
				key = getIndexes(className);						//the key of the previous part
				for(i=1;i<key.length;i++) key[i] = int(key[i]);		//Convert key elements to integers
				for(i=1;i<nam.length;i++) nam[i] = int(nam[i]);
				do{													//While the class is not defined, keep cycling characters
					cycled = false;
					for(i=1;i<4;i++){								//When key[0] does return to 0, key[1] +=1, etc...
						if(nam[i] && !cycled){
							key[i] += nam[i]*ind;
							if(key[i] > max){
								key[i] = 0;
							}else if(key[i] < 0){
								key[i] = max;
							}else{
								cycled = true;
							}
						}
					}
				}while (!testClass(key.toString()));
				if(className == classDict[key.toString()]){
					toNote("No other type of this part, sorry. "+[":c",":(",":'(",":C","°_°"][Math.floor(Math.random()*5)]);
					return;
				}
				//Create the new part
				classType = getDefinitionByName(classDict[key.toString()]) as Class;
				partReplace = new classType();
				//Position transfering (For boobs, dicks and such);
				try{partReplace.name = part.name;}catch(e){}
				partReplace.x = part.x;
				partReplace.y = part.y;
				partReplace.scaleX = part.scaleX;
				partReplace.scaleY = part.scaleY;
				if (nam[4]) partReplace.MC.rotation = part.MC.rotation;
				else partReplace.rotation = part.rotation;
				//Give it the color transform of the previous
				var ref:Object = partRefs[nam[0]];
				if(ref.partB)	ref.partB= getDeepChildByName(partReplace, ref.partB.name);
				if(ref.partS)	ref.partS = getDeepChildByName(partReplace, ref.partS.name);
				if(ref.hairB)	ref.hairB= getDeepChildByName(partReplace, ref.hairB.name);
				if(ref.hairS)	ref.hairS = getDeepChildByName(partReplace, ref.hairS.name);
				if(ref.bitsB)	ref.bitsB= getDeepChildByName(partReplace, ref.bitsB.name);
				if(ref.bitsS)	ref.bitsS = getDeepChildByName(partReplace, ref.bitsS.name);
				if(ref.pupils)	ref.pupils= getDeepChildByName(partReplace, ref.pupils.name);
				ref.part = partReplace;
				colorPart(ref);
				part.cacheAsBitmap = partReplace.cacheAsBitmap;
				//Specific Nipple stuff
				if (nam[0].slice(0,-1) == "boobs" && nam[2]){
					var k = nam[0].slice(-1);
					cycle(nam[2]+"; 100; bodyshade"+k+",1,0,0; bodyshade"+(k-1)+",0,0,1");
					var rNip:MovieClip = getDeepChildByName(partReplace, "rightNipple");
					var lNip:MovieClip = getDeepChildByName(partReplace, "leftNipple");
					key = getPartInd("leftNipple"+k);
					partRefs["rightNipple"+k] = {part:rNip, bitsB:rNip.fillbg, bitsS:rNip.shading}
					partRefs["leftNipple"+k]  = {part:lNip, bitsB:lNip.fillbg, bitsS:lNip.shading}
					colorPart(partRefs["rightNipple"+k]);
					colorPart(partRefs["leftNipple"+k]);
					
					if (key[2] < 1){
						cycle("-1; 10; rightNipple"+k+",0,1,0")
						cycle("-1; 10; leftNipple"+k+",0,1,0")
					}else{
						var u = (ind == 1)? 2:1;
						for (var l=u; l<key[2]; l++){
							cycle("1; 10; rightNipple"+k+",0,1,0")
							cycle("1; 10; leftNipple"+k+",0,1,0")
						}
					}
				}
				if (nam[0] == "hair" && nam[1]){
					var a:int = key[1];
					if (((a == 0 || a == 11)&& ind == 1) || ((a == 6 || a == 16)&& ind == -1)){
						cycle("1; 2; ears,0,0,1")
					}
				}
				//Finish stuff
				part.parent.addChild(partReplace);
				part.parent.swapChildren(part,partReplace);
				part.parent.removeChild(part);
				if (nam[0].slice(0,-1) == "boobs" && nam[2]){
					updateBoobMasks();
				}
				if (nam[0] == "ghostbody"){
					partReplace.mask = part.mask;
					part.mask = null;
				}
			}
		}
		//Get an item from a ref name, and set it to either visible or invisible
		public function toggleItem(btnName:String):void{
			var tar = mainParent.getChildByName(btnName);
			if (tar) tar.visible = !tar.visible;
		}
		//Add an item to a parent, and run a specializing function
		public function addObject(btnName:String, special:Function = null):void{
			var classType:Class = getDefinitionByName(btnName) as Class;
			var item = new classType();
			item.name = btnName;
			trace("Added item: "+btnName);
			if(special!=null) special(item);
		}
		//If addItem isn't enough, here are the specializing functions
		public function speDagger(target:MovieClip):void{
			function erase(e:Event):void{
				remove(e.currentTarget);
			}
			mainParent.addChild(target);
			target.addEventListener(MouseEvent.CLICK, erase, false, 0, true);
			equipment.push(target);
		}
		public function speCreature(target:MovieClip):void{
			var comp:MovieClip;
			var sca = 1+Math.random()/2;
			scale(target, sca);
			creatureParent.addChild(target);
			target.mouseChildren = false;
			target.doubleClickEnabled = true;
			target.x = 260+Math.random()*1200;
			target.y = mainParent.y+2/3*mainParent.height;
			toNote("Creatures are placed at player height. You can drag and drop them, drop them outside or double click to delete them, and clear them all.");
			for(i=0;i<creatureParent.numChildren;i++){
				comp = creatureParent.getChildAt(i) as MovieClip;
				if (comp.scaleX > target.scaleX){
					creatureParent.setChildIndex(target, i);
					return;
				}
			}		
		}
		//Add another cock
		public function moreCocks(btnName:String):void{
			var baseIndex:int = mainParent.numChildren;
			j = addInfo.cockNum;
			addInfo.cockNum++;
			addInfo.cockSpot--;
			
			baseIndex = getIn(getPart("balls"))+addInfo.cockNum;
			
			/*if (getPart("boobs2"))
			if (getPartInd("boobs2")[2] >= 27)
			baseIndex = getIn(getPart("boobs2"));
			
			if (getPart("boobs3"))
			if (getPartInd("boobs3")[2] >=9)
			baseIndex = getIn(getPart("boobs3"));*/
			
			dictFindPart("cock", 0, 1);
			addPartRef("cock"+j,foundPart, "fillbg", "shading", "", "", "headFill", "headShade");
			colorPart(partRefs["cock"+j]);
			drawParent.setChildIndex(foundPart, baseIndex);
			
			var ranRed:Number = 1-Math.pow(2, -0.3*addInfo.cockNum)
			var minRot:Number = -19 * ranRed;
			var maxRot:Number = 25 * ranRed;
			var rotRange:Number = maxRot - minRot;
			foundPart.MC.rotation = (Math.random()*rotRange + minRot);
			foundPart.x = -foundPart.MC.rotation/10;
			
			var b:String = "cockBtn";
			var pos:int = addInfo[b][j][1].y;
			var dec:int = [77, 80][int(isTiTS)];
			addInfo[b][j][1].y += 45;
			addInfo[b][j][2].y += 45;
			addInfo[b][j][1].lock();
			addInfo[b][j][2].lock(addInfo.cockSpot);
			addInfo[b].push(addInfo[b][j]);
			addInfo[b][j] = [];
			addInfo[b][j][0] = new DIC_Button("1; 10; cock"+j+",1,0,0,1", 100, pos, "Cock "+(j+1), cycle, true, undefined, undefined, 120);
			addInfo[b][j][1] = new DIC_Arrow("-1; 200; cock"+j+",0,1,0,1", 100-dec, pos, 0, cycle);
			addInfo[b][j][2] = new DIC_Arrow("+1; 200; cock"+j+",0,1,0,1", 100+dec, pos, 2, cycle);
			for each(var btn in addInfo[b][j])
			menuBtns.addChild(btn);
		}
		public function lessCocks(btnName:String):void{
			addInfo.cockNum--;
			addInfo.cockSpot++;
			j = addInfo.cockNum;
			
			remove(getPart("cock"+j));
			delete partRefs["cock"+j];
			
			var b:String = "cockBtn";
			for each(var btn in addInfo[b][j]) remove(btn);
			addInfo[b].splice(-2, 1);
			addInfo[b][j][1].y -= 45;
			addInfo[b][j][2].y -= 45;
			addInfo[b][j][1].lock(addInfo.cockNum);
			addInfo[b][j][2].lock();
		}
		public function moreBoobs(btnName:String):void{
			j = addInfo.boobNum;
			addInfo.boobNum++;
			addInfo.boobSpot--;
			
			var baseIndex:int;
			if (j == 0){
				baseIndex = drawParent.numChildren;
				dictFindPart("boobs", 0, 1);
			}else{
				baseIndex = getIn(getPart("boobs"+(j-1)))
				dictFindPart("boobs", 1, 0);
			}
			
			var boob:MovieClip = foundPart;
			addPartRef("boobs"+j, boob, "fillbg", "shading", "", "", "areola", "areolaShading");
			colorPart(partRefs["boobs"+j]);
			drawParent.setChildIndex(boob, baseIndex);
			
			foundPart = getDeepChildByName(boob, "leftNipple");
			addPartRef("leftNipple"+j, foundPart, "", "", "", "", "fillbg", "shading");
			colorPart(partRefs["leftNipple"+j]);
				
			foundPart = getDeepChildByName(boob, "rightNipple");
			addPartRef("rightNipple"+j, foundPart, "", "", "", "", "fillbg", "shading");
			colorPart(partRefs["rightNipple"+j]);
			
			boob.y = [0, 19.9, 49.45, 85.55][j];
			boob.x = [0, 24.95, 29.7, 16.30][j];
			boob.rotation = [0, 6.5, 7.5, 5.5][j];
			
			var b:String = "boobBtn";
			var pos:int = addInfo[b][j][1].y;
			var dec:int = [77, 80][int(isTiTS)];
			addInfo[b][j][1].y += 45;
			addInfo[b][j][2].y += 45;
			addInfo[b][j][1].lock();
			addInfo[b][j][2].lock(addInfo.boobSpot);
			addInfo[b].push(addInfo[b][j]);
			addInfo[b][j] = [];
			addInfo[b][j][0] = new DIC_Button("1; 8; leftNipple"+j+",0,1,0; rightNipple"+j+",0,1,0;", 100, pos, "Row "+(j+1), cycle, true, undefined, undefined, 120);
			addInfo[b][j][1] = new DIC_Arrow("-1; 200; boobs"+j+",0,1,0", 100-dec, pos, 0, cycle);
			addInfo[b][j][2] = new DIC_Arrow("+1; 200; boobs"+j+",0,1,0", 100+dec, pos, 2, cycle);
			for each(var btn in addInfo[b][j])
			menuBtns.addChild(btn);
		}
		public function lessBoobs(btnName:String):void{
			addInfo.boobNum--;
			addInfo.boobSpot++;
			j = addInfo.boobNum;
			
			remove(getPart("boobs"+j));
			delete partRefs["boobs"+j];
			delete partRefs["leftNipple"+j];
			delete partRefs["rightNipple"+j];
			
			var b:String = "boobBtn";
			for each(var btn in addInfo[b][j]) remove(btn);
			addInfo[b].splice(-2, 1);
			addInfo[b][j][1].y -= 45;
			addInfo[b][j][2].y -= 45;
			addInfo[b][j][1].lock(addInfo.boobNum);
			addInfo[b][j][2].lock();
		}
		public function addCockSlider(j:int):void{
			i = 0;
			for (var key in bigCockList) i++;
			if (i > 1){
				cockSlider = new DIC_Slider(j, 0, 0, cockSlide, "Select Row");
				menuBtns.addChild(cockSlider);
				if (i == 2){
					cockSlideChange(bigCockList["Cock 1"], false);
				}
			}
		}
		public function addBoobSlider(j:int):void{
			i = 0;
			for (var key in bigBoobList)i++;
			if (i > 1){
				boobSlider = new DIC_Slider(j, 0, 0, boobSlide, "Select Row");
				menuBtns.addChild(boobSlider);
				if (i == 2){
					boobSlideChange(bigBoobList["Row 1"], false);
				}
			}
		}
		//Used to change the target of cockSlider and boobSlider, called by the DIC_Dropdown class
		public function cockSlideChange(ary:Array, mult:Boolean = true):void{
			if (cockSlideTarget[0]){
				cockSlideTarget[0].transform.colorTransform = new ColorTransform;
			}
			if (ary[0]){
				if (mult){
					ct = new ColorTransform();
					ct.redOffset = 255;
					ary[0].transform.colorTransform = ct;
				}
				cockSlideTarget = [ary[0], ary[3]];
				cockSlider.sliderText.text = ary[1];
				cockSlider.sliderBar.maximum = ary[2]-27;
				cockSlider.sliderBar.snapInterval = 0.01;
				cockSlider.sliderBar.value = 0;
				cockSlider.enabled = true;
			}else{
				cockSlideTarget = [];
				cockSlider.sliderText.text = "Select Cock";
				cockSlider.sliderBar.maximum = 0;
				cockSlider.sliderBar.value = 0;
				cockSlider.enabled = true;
			}
		}
		public function boobSlideChange(ary:Array, mult:Boolean = true):void{
			if (boobSlideTarget[0]){
				boobSlideTarget[0].transform.colorTransform = new ColorTransform;
			}
			if (ary[0]){
				if (mult) {
					ct = new ColorTransform();
					ct.redOffset = 255;
					ary[0].transform.colorTransform = ct;
				}
				boobSlideTarget = [ary[0], ary[3]];
				boobSlider.sliderText.text = ary[1];
				boobSlider.sliderBar.maximum = ary[2]-80;
				cockSlider.sliderBar.snapInterval = 0.01;
				boobSlider.sliderBar.value = 0;
				boobSlider.enabled = true;
			}else{
				boobSlideTarget = [];
				boobSlider.sliderText.text = "Select Row";
				boobSlider.sliderBar.maximum = 0;
				boobSlider.sliderBar.value = 0;
				boobSlider.enabled = true;
			}
		}
		//Do the actual resizing
		public function cockSlide(event:Event):void{
			if (cockSlideTarget[0]){
				var par = event.currentTarget;
				par.parent.sliderText.text =  "Cock "+cockSlideTarget[1]+": "+(par.value +27)+"in.";
				scale(cockSlideTarget[0].MC, (par.value+27)/27);
				if (isTiTS) par.parent.MC.progressBar.scaleX = par.parent.sliderBar.value/par.parent.sliderBar.maximum;
			}
		}
		public function boobSlide(event:Event):void{
			if (boobSlideTarget[0]){
				if(boobSlideTarget[0].MC){
					var par = event.currentTarget;
					par.parent.sliderText.text = "Row "+boobSlideTarget[1]+": "+(par.value+80)+"/100";
					scale(boobSlideTarget[0].MC, (par.value +40) /40);
					if (isTiTS) par.parent.MC.progressBar.scaleX = par.parent.sliderBar.value/par.parent.sliderBar.maximum;
				}
			}
		}
		public function tallSlide(event:Event):void{
			var par = event.currentTarget;
			var sizeDif:Number = mainParent.height;
			var widthDif:Number = mainParent.width;
			var newScale:Number = (par.value+24);
			par.parent.sliderText.text = "Height: "+int(newScale/12)+"ft."+int(newScale%12)+"in.";
			scale(mainParent, newScale/82);
			mainParent.y += sizeDif-mainParent.height;
			mainParent.x += (widthDif-mainParent.width)/2
			heightMod = 82/newScale;
			if (isTiTS) par.parent.MC.progressBar.scaleX = par.parent.sliderBar.value/par.parent.sliderBar.maximum;
		}
		public function ballSlide(event:Event):void{
			var par = event.currentTarget;
			var balls = getPart("ballsMC", true);
			scale(balls, (par.value+7)/7);
			par.parent.sliderText.text = "Ball size: "+(par.value +7)+"in.";
			if (isTiTS) par.parent.MC.progressBar.scaleX = par.parent.sliderBar.value/par.parent.sliderBar.maximum;
		}
		public function clitSlide(event:Event):void{
			var par = event.currentTarget;
			var clit = getPart("clit", true);
			scale(clit.MC, (par.value +8)/8);
			par.parent.sliderText.text = "Clit size: "+(par.value +8)+"in.";
			if (isTiTS) par.parent.MC.progressBar.scaleX = par.parent.sliderBar.value/par.parent.sliderBar.maximum;
		}
		public function resoSlide(event:Event):void{
			var par = buttons.charRes;
			if (par){
				capScale = par.sliderBar.value + 1;
				par.sliderText.text = Math.ceil(capScale * mainParent.width)+" x "+Math.ceil(capScale * mainParent.height);
				if (isTiTS) par.MC.progressBar.scaleX = par.sliderBar.value/par.sliderBar.maximum;
			}
		}
	}
}
