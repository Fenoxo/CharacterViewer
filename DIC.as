package  {
	///Default classes
	import com.demonsters.debugger.MonsterDebugger;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.utils.Dictionary;
	import flash.utils.ByteArray;
	import flash.display.StageDisplayState;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;	
	import flash.net.URLLoaderDataFormat;
	import flash.net.FileReference;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	import flash.text.Font;
	import fl.managers.StyleManager;
	import fl.controls.UIScrollBar;
	import fl.events.SliderEvent;
	import fl.controls.Slider;
	import flash.ui.Mouse;
	
	///Custom classes
	import classes.*;
	import flash.text.TextField;
	
	///Main class
	public class DIC extends MovieClip {
		///Technical variables
		public var mainParent:MovieClip = new MovieClip;		//Holds main character
		public var creatureParent:MovieClip = new MovieClip;	//Holds simple Creatures
		public var crewParent:MovieClip = new MovieClip;		//Holds loaded NPCS
		public var drawParent:MovieClip;						//Holds mainParent, crewParent,... for drawing
		public var crewData:Object;								//Holds crew
		public var classDict:Dictionary = new Dictionary;		//Convert indexes to className
		public var player:creature = new creature;				//Hold player data
		public var playerName:String;							//Player name, for file naming
		public var c:int;										//Increments, for index mainly
		public var i:int;
		public var j:int;
		public var k:int;
		public var l:int;
		///Loading variable
		public var saveFile:SharedObject;
		public var file:FileReference;
		public var loader:URLLoader;
		public var PNGencoder:PNGEncoder2;
		public var b:BitmapData;
		public var capScale:Number;								//Capchar res multiplicator
		///Drawing variables
		public var ct:ColorTransform = new ColorTransform;		//Every colour transform are stored here at one point 
		public var skinType:int;								//Hole player.skinType, to shorten stuff
		public var foundPart:MovieClip = undefined;				//Used to return the last drawn part
		public var partRefs:Array=[];							//Holds added parts, their colour groups, colored child names
		public var heightMod:Number;							//To scale parts and stuff
		public var hasBalls:Boolean;							//If balls > 0
		public var hairColor:String;							//Holds player.hairColor
		public var skinColor:String;							//Holds player.skinTone
		public var partIndex:int;								//To pass around important index in the drawChar function
		public var masculine:int;								//If feminity<50, 0 or 1
		public var n:int;										//Increments, for drawing
		public var u:int;
		///Menu Variables
		public var isTiTS:Boolean = false;						//Wether viewer set in TiTS mode
		public var stageLock:Boolean = false;
		public var menuBtns:MovieClip = new MovieClip;
		public var basicBtns:MovieClip = new MovieClip;
		public var playerBtns:MovieClip = new MovieClip;
		public var scrollBar:DIC_ScrollBar= new DIC_ScrollBar();//The notes scrollbar
		public var buttons:Object = {};							//Holds all btns outside of menus
		public var dragTarget:MovieClip;						//Holds the dragging target, so you can drop it behind stuff
		public var bigCockList:Object = {};						//Contain all scalable cocks and boobs
		public var bigBoobList:Object = {};
		public var cockSlideTarget:Array;						//The selected cock/boobs
		public var boobSlideTarget:Array;	
		public var cockSlider;									//The cock/boob slider
		public var boobSlider;
		public var equipment:Array = [];
		public var addInfo:Object = {cockNum:0, cockSpot:9, cockBtn:[], boobNum:0, boobSpot:4, boobBtn:[]};
		//Loaded CoC player menu
		public var CoCMenu:Object = {};
		public var CoCBackgroundMenu:Object = {};
		public var CoCCreatureMenu:Object = {};
		public var CoCItemMenu:Object = {};
		public var CoCDetailMenu:Object = {};
		public var CoCSliderMenu:Object = {};
		//Loaded CoC player menu
		public var TiTSMenu:Object = {};
		public var TiTSBackgroundMenu:Object = {};
		public var TiTSCreatureMenu:Object = {};
		public var TiTSCrewMenu:Object ={};
		public var TiTSItemMenu:Object = {};
		public var TiTSDetailMenu:Object = {};
		public var TiTSSliderMenu:Object = {};
		//Created character menu	
		public var creatorMenu:Object = {};
		public var headMenu:Object = {};
		public var torsoMenu:Object = {};
		public var naughtyMenu:Object = {};
		public var cockMenu:Object = {};
		public var legsMenu:Object = {};
		public var otherMenu:Object = {};
		///Toggle targets
		public var partBalls:MovieClip = new MovieClip;
		public var partGills:MovieClip = new MovieClip;
		public var partEyes:MovieClip = new MovieClip;
		public var partOvi:MovieClip = new MovieClip;
		///Color variables
		public var eyeColor:uint;								//Holds eye color, for consistency (not stored in player)
		public var skinColorAry:Array = [];						//Link game color name to color code
		public var skinShadeAry:Array =[];
		public var bitsColorAry:Array =[];
		public var bitsShadeAry:Array=[];
		public var hairColorAry:Array =[];
		public var hairShadeAry:Array =[];
		public var hairColorNames:Object = {};					//Objects for the annoying drop menu system
		public var skinColorNames:Object = {};
		public var skinTypesNames:Object = {Skin:0, Fur:1, Scales:2, Goo:3};
		/*/Type arrays
		Each of those holds 3 lists of strings, that can be arranged to create a class name
		Example:	"HumanCock"+"0"+""
					"Normal"+"Balls"+"1"
		
		Types likes cocks aren't defined for every size (duh!)
		So the mostly empty string array is created by a function
		cockTypeAry[1][27] will be defined, but not cockTypeAry[1][26]
		
		When the dictionary builder finds an undefined string (cockTypeAry[1][26])
		it will not link it to a class name, but to "skip2"
		
		dictFindPart will reduce the second indexe until it reaches a defined size
		*/
		public var typeArray:Array;//Holds all type arrays
		public var headTypeAry:Array=[
			["FemaleHead","MaleHead"],
			[""],
			[""]];
		public var hairTypeAry:Array=[
			new Array(100),
			["NormalHair","FeatheredHair","GhostHair","GooHair","AnemoneHair"],
			["","Back"]];
		public var ballTypeAry:Array=[
			["Normal","Furry","Scaley","Gooey"],
			["Balls"],
			["0","1","2","3","4","5","6","7"]];
		public var assTypeAry:Array =[
			new Array(100),
			[""],
			[""]];
		public var boobTypeAry:Array=[
			["","L"],
			new Array(100),
			[""]];
		public var nipTypeAry:Array =[
			["LeftNipple", "RightNipple"],
			["0", "1", "2", "3", "4", "5", "6", "7"],
			[""]];
		public var hipsTypeAry:Array=[
			["Female","Male"],
			new Array(100),
			[""]];
		public var cockTypeAry:Array=[
			["HumanCock",
			"HorseCock",
			"DogCock",
			"DemonCock",
			"TentacleCock",
			"CatCock",
			"LizardCock",
			"AnemoneCock",
			"KangarooCock",
			"DragonCock"],
			new Array(100),
			[""]];
		public var faceTypeAry:Array=[
			["Normal","Corrupted","Lusty"],
			["Female","Andro","Male"],
			["HumanFace",
			"HorseFace",
			"DogFace",
			"CowFace",
			"SharkFace",
			"NagaFace",
			"CatFace",
			"LizardFace",
			"BunnyFace",
			"KangarooFace",
			"SpiderFace",
			"FoxFace",
			"DragonFace"]];
		public var bodyTypeAry:Array=[
			["Human", "Furry", "Scaley", "Gooey"],
			["Female", "Male"],
			["NormalBody","FitBody","FatBody"]];
		public var earTypeAry:Array =[
			["HumanEars",
			"HorseEars",
			"DogEars",
			"CowEars",
			"ElfEars",
			"CatEars",
			"SnakeEars",
			"BunnyEars",
			"KangarooEars",
			"FoxEars",
			"DragonEars",
			"NoEars"],
			["", "Hair"],
			[""]];
		public var legTypeAry:Array =[
			["Female","Male"],
			["HumanLegs",
			"CowLegs",
			"WolfPaws",
			"NagaTail",
			"Centaur",
			"DemonicHeels",
			"DemonFootClaws",
			"BeeLegs",
			"GooMound",
			"CatPaws",
			"LizardClaws",
			"MLP",
			"BunnyFeet",
			"HarpyLegs",
			"KangarooFeet",
			"SpiderLegs",
			"DriderLeg",
			"FoxPaws",
			"DragonClaws",],
			[""]];
		public var tailTypeAry:Array=[
			["NoTail",
			"HorseTail",  
			"DogTail",
			"DemonTail",
			"CowTail",
			"SpiderTail",
			"BeeTail",
			"SharkTail",
			"CatTail",
			"LizardTail",
			"BunnyTail",
			"HarpyTail",
			"KangarooTail",
			"FoxTail",
			"DragonTail"],
			[""],
			[""]];
		public var wingTypeAry:Array=[
			["NoWings",
			"BeeWings",
			"LargeBeeWings",
			"FaerieWings",  //not in game
			"AvianWings",  //also not in game
			"DragoonWings",  //yup not in game either
			"DemonBatWings",
			"LargeDemonBatWings",
			"SharkFin",
			"HarpyWings",
			"SmallDragonWings",
			"LargeDragonWings"],
			[""],
			[""]];
		public var hornTypeAry:Array=[
			["NoHorns",
			"DemonicHorns",
			"MinotaurHorns",
			"DraconicLizardHorns",
			"DoubleDraconicHorns",
			"AntlerHorns",
			"antennae"],
			[""],
			[""]];
		public var armTypeAry:Array =[
			["NormalArm",
			"HarpyArm",
			"SpiderArm"],
			[""],
			[""]];
		public var vagTypeAry:Array =[
			["No", ""],
			["FemaleVag",
			"MaleVag"],
			[""]];
		public var clitTypeAry:Array=[
			["Clit"],
			["0","1","2","3","4","5","6","7","8"],
			[""]];
		public var eyeTypeAry:Array =[
			["NormalEyes",
			"SpiderEyes"],
			[""],
			[""]];
		public var gillTypeAry:Array=[
			["NoGills",
			"Gills"],
			[""],
			[""]];
		public var oviTypeAry:Array =[
			["NoOvipositor",
			"Ovipositor"],
			[""],
			[""]];
		public var handTypeAry:Array=[
			["Female", "Male"],
			["RightArm"],
			[""]];
		
		////Initialization
		public function DIC(){
			MonsterDebugger.initialize(this);
			//Initialiaze part type, color and dropdown arrays
			createArrays();
			//Populate dictionnary
			typeArrayAdder();
			//Initialize GUI
			initGUI();
		}
		
		////Dictionnary and Reference system
		public function typeArrayAdder():void{
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
		} 
		public function createArrays():void{
			//Fill color arrays
			createSkinColorAry();
			createHairColorAry();
			createBitsColorAry();
			createShadeAry();
			//createSkinShadeAry();
			//createHairShadeAry();
			//createBitsShadeAry();
			//Fill color name arrays
			createColorNameAry();
			//Fill quantitative arrays
			createHipsAry();
			createHairAry();
			createAssAry();
			createCockAry();
			createBreastAry();
			skinColorAry.concat(hairColorAry);
			skinShadeAry.concat(hairShadeAry);
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
				trace("Defaulted index "+toDefault+" to 0.");
				toNote("This type of "+type+" is not added yet.",true);
			}
			for (i=0;i<toDefault.length;i++){
				key[toDefault[i]] = 0;
			}
			var className = classDict[key.toString()];
			var classType:Class = getDefinitionByName(className) as Class;
			foundPart = new classType() as MovieClip;
			drawParent.addChild(foundPart);
		}
		//Add parts and their children in desperate need of color to partRefs
		public function addPartRef(id:String, part:*, partBG="", partS="", hairBG="", hairS="", bitsBG="", bitsS="", pupils=""):void{
			if(part == undefined || part == null) return;
			//part.name = id;
			partRefs[id] = {part:part}
			partRefs[id].partBG= getDeepChildByName(part, partBG);
			partRefs[id].partS = getDeepChildByName(part, partS);
			partRefs[id].hairBG= getDeepChildByName(part, hairBG);
			partRefs[id].hairS = getDeepChildByName(part, hairS);
			partRefs[id].bitsBG= getDeepChildByName(part, bitsBG);
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
			if(!mute) trace("Got part "+partRefs[id].part+" with id:"+id);
			return partRefs[id].part;
		};
		//Get the index of a part name
		public function getPartInd(id:String):Array{
			if (getPart(id)){
				return getIndexes(getQualifiedClassName(getPart(id)));
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
		/*public function createSkinShadeAry():void{
			skinShadeAry["light"] = 0xd9a5c6;
			skinShadeAry["olive"] = 0xb7766a;
			skinShadeAry["dark"] = 0x9a5c5b;
			skinShadeAry["ebony"] = 0x30140e;
			skinShadeAry["pale white"] = 0xd0adda;
			skinShadeAry["white"] = 0xd4b6ea;
			skinShadeAry["sable"] = 0x784d5a;
			skinShadeAry["dark green"] = 0x26412b;
			skinShadeAry["grayish-blue"] = 0x5f6c83;
			skinShadeAry["pale yellow"] = 0xc7a285;
			skinShadeAry["rough gray"] = 0x7b6d89;
			skinShadeAry["purple"] = 0x572a8d;
			skinShadeAry["silver"] = 0x9d8bb7;
			skinShadeAry["red"] = 0x96121a;
			skinShadeAry["green"] = 0x24682c;
			skinShadeAry["blue"] = 0x2551bc;
			skinShadeAry["indigo"] = 0x4128c0;
			skinShadeAry["shiney black"] = 0x141119;//!!!
			skinShadeAry["orange"] = 0x9c3b26;
			skinShadeAry["grey"] = 0x5f5570;
			skinShadeAry["milky"] = 0xd9adcd;
			skinShadeAry["ashen"] = 0x9c747f;
			skinShadeAry["tan"] = 0xb07065;
			skinShadeAry["aphotic blue-black"] = 0x2a264e;
			//orange and black striped - a22a00 / 2a2a2a //this skinColor will have to be handled seperately (af will have to make a stripe layer)
		}*/
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
		/*public function createBitsShadeAry():void{
			bitsShadeAry["light"] = 0xd290b6;
			bitsShadeAry["olive"] = 0xb56367;
			bitsShadeAry["dark"] = 0x854341;
			bitsShadeAry["ebony"] = 0x1c0a06;
			bitsShadeAry["pale white"] = 0xcb99bf;
			bitsShadeAry["white"] = 0xd1a4cd;
			bitsShadeAry["sable"] = 0x6f3a4a;
			bitsShadeAry["dark green"] = 0x19352f;
			bitsShadeAry["grayish-blue"] = 0x464e7d;
			bitsShadeAry["pale yellow"] = 0xb98168;
			bitsShadeAry["rough gray"] = 0x5b5676;
			bitsShadeAry["purple"] = 0x4b0a63;
			bitsShadeAry["silver"] = 0x7b739e;
			bitsShadeAry["red"] = 0x880c2e;
			bitsShadeAry["green"] = 0x2b4d42;
			bitsShadeAry["blue"] = 0x6233c1;
			bitsShadeAry["indigo"] = 0x4c2093;
			bitsShadeAry["shiney black"] = 0x231e2c; // (AF will have to make shines)
			bitsShadeAry["orange"] = 0x7e2423;
			bitsShadeAry["grey"] = 0x3f3a49;
			bitsShadeAry["milky"] = 0xd6a0c8;
			bitsShadeAry["ashen"] = 0x84535c;
			bitsShadeAry["tan"] = 0xa45d53;
			bitsShadeAry["aphotic blue-black"] = 0x4128c0;
		}*/
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
		/*public function createHairShadeAry():void{
			hairShadeAry["dark blue"] = 0x201b65;
			hairShadeAry["bright orange"] = 0xd05c32;
			hairShadeAry["neon pink"] = 0xd83d92;
			hairShadeAry["purple"] = 0x572a8d;
			hairShadeAry["auburn"] = 0x67140b;
			hairShadeAry["black"] = 0x24202a;
			hairShadeAry["blonde"] = 0xd28c44;
			hairShadeAry["brown"] = 0x703732;
			hairShadeAry["red"] = 0x96121a;
			hairShadeAry["white"] = 0xd4b6ea;
			hairShadeAry["gray"] = 0x5f5570;
			hairShadeAry["shiny black"] = 0x4E586C;
			hairShadeAry["silver"] = 0x9d8bb7;
			hairShadeAry["platinum blonde"] = 0xd8a898;
			hairShadeAry["midnight black"] = 0x141119;
			hairShadeAry["sandy blonde"] = 0xcf8d78;
			hairShadeAry["green"] = 0x24682c;
		}*/
		public function createColorNameAry():void{
			i = 0;
			for (var key in skinColorAry){
				skinColorNames[key] = key;
				i++;
			}
			i = 0;
			for (key in hairColorAry){
				hairColorNames[key] = key;
				i++;
			}
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
					ary = [part, "Cock "+(i+1)+": 80in.", player.cocks[i].cockLength, i+1];
					if (part) bigCockList["Cock "+(i+1)] = ary;
				}
			}
			for (i = 0; i < player.breastRows.length; i++){
				if (player.breastRows[i].breastRating > 80){
					part = getPart("boobs"+i);
					ary = [part, "Row "+(i+1)+" rating: 80.", player.breastRows[i].breastRating, i+1];
					if (part) bigBoobList["Row "+(i+1)] = ary;
				}
			}
		}
		
		////Utilities
		//Return the minimized and maximized input, with a margin if desired.
		public function born(toBorn:Number, min:Number, max:Number, margin:Number=0):Number{
			toBorn = Math.max(toBorn+margin,min)-margin;
			toBorn = Math.min(toBorn-margin,max)+margin;
			return toBorn;
		}
		//Place string in the note box. You can replace or append.
		public function toNote(note:String = "", toAdd:Boolean = false):void{
			if (toAdd){
				notes.text = notes.text + "\r\r" + note;
			}else{
				notes.text = note;
			}
			scrollBar.update();
			scrollBar.visible = scrollBar.enabled;
			scrollBar.scrollPosition = scrollBar.maxScrollPosition;
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
			var p;
			for (p in tar) delete tar[p];
			for (p in obj) tar[p] = obj[p];
		}
		
		////Game loading
		///Reset Game
		public function reset(btnName:String=""):void{
			if (dragTarget) dragTarget.stopDrag();
			clearMenu(mainParent);
			clearMenu(creatureParent);
			clearMenu(crewParent);
			clearMenu();
			remove(instructions);
			toNote("");
			Background.gotoAndStop(int(isTiTS)*6+1);
			skinType = 0;
			eyeColor = getRandomColor();
			buttons.charCap.lock();
			buttons.backCap.lock();
			buttons.charRes.lock();
			addPlayerBtns();
			addInfo = {cockNum:0, cockSpot:9, cockBtn:[], boobNum:0, boobSpot:4, boobBtn:[]};
		}
		///Load from default
		public function loadFromDefault(btnName:String){
			loadDefault();
			addMainChar(creatorMenu, true);
			mainParent.setChildIndex(getPart("cock0", true), getIn(getPart("boobs0", true)));
		}
		///Load from shared object
		public function loadFromSave(btnName:String){
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
				var req:* = new URLRequest(tempFileRef.name);
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
			player.hairColor = "red";
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
			hairColor =  "red";
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
			//Load Crew
			crewData = save.characters;
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
				toNote("Skin tone not found: "+skinColor, true);
				skinColor = "light";
			}
			if(hairColorAry[hairColor] ==  undefined){
				toNote("Hair color not found: "+hairColor, true);
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
			//Toggle targets
			partBalls = getPart("balls");
			partEyes = getPart("face").pupils;
			//Scaling
			var sca = player.tallness/82;
			scale(drawParent, sca, 650, 0, true);
			drawParent.y = 720-drawParent.height;
			//Menu
			loadMenu("", menu);
			buttons.charCap.unLock();
			buttons.backCap.unLock();
			buttons.charRes.unLock();
		}
		public function addCrewChar(btnName:String, crew:Object, num:int):void{
			if(crewParent.getChildByName(String(num))){
				remove(crewParent.getChildByName(String(num)));
				return;
			}
			var save:Object = {};
			save.characters = {};
			save.characters[num] = crew;
			if (!loadTiTS(save, num)) return;
			toNote("Added "+ crew.short);
			//Colors
			skinColor = player.skinTone;
			hairColor = player.hairColor;
			if(skinColorAry[skinColor] ==  undefined){
				toNote("Skin tone not found: "+skinColor, true);
				skinColor = "light";
			}
			if(hairColorAry[hairColor] ==  undefined){
				toNote("Hair color not found: "+hairColor, true);
				hairColor = "red";
			}
			//Characteristics
			heightMod = 82/ player.tallness;
			masculine = int(player.femininity < 50);
			hasBalls = player.balls > 0;
			//Technical
			var par:MovieClip = new MovieClip;
			crewParent.addChild(par);
			par.doubleClickEnabled = true;
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
			drawParent.y = mainParent.y + mainParent.height - drawParent.height;
			drawParent.x = (1224-drawParent.width) * Math.random() + 200;
			var comp:MovieClip;
			for(i=0; i<crewParent.numChildren; i++){
				comp = crewParent.getChildAt(i) as MovieClip;
				if (drawParent.height > comp.height){
					crewParent.setChildIndex(drawParent, i);
					return;
				}
			}
		}
		
		////Drawing
		///Adding
		public function drawCharacter():void{
			trace("/\/Commencing drawing")
			addTail();
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
		}
		public function addPart(partName:String, j:int=0, k:int=0, l:int=0){
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
			addPartRef("face", foundPart, "fillbg", "shading", "", "", "lips", "", "pupils");
		}
		public function addBody():void{
			n = Math.floor(player.tone/51);
			dictFindPart("body", skinType, masculine, n)
			addPartRef("body", foundPart, "fillbg", "shading");
			partIndex = getIn(foundPart);
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
			dictFindPart("ears", player.earType, u);
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
			}else{
				var balls = new NormalBallsSc();
				var scale = new NormalBallsScMC();
				drawParent.addChild(balls);
				balls.addChildAt(scale, balls.numChildren-1);
				scale.x = 161.55;
				scale.y = 390.85;
				addPartRef("balls", balls, "", "shading");
				addPartRef("ballsMC", scale, "fillbg", "shading");
			}
		}
		public function addCocks():void{
			var comp:MovieClip;
			var aryLength:int =  player.cocks.length;
			var baseIndex:int = drawParent.numChildren;
			
			if (player.breastRows[2])
			if (player.breastRows[2].breastRating >=27)
			baseIndex = getIn(getPart("boobs2"));
			
			if (player.breastRows[2])
			if (player.breastRows[3].breastRating >=9)
			baseIndex = getIn(getPart("boobs3"));
			
			//Approaches 1 when aryLength grows
			var ranRed:Number = 1-Math.pow(4, -0.3*aryLength)
			var minRot:Number = -19 * ranRed;
			var maxRot:Number = 25 * ranRed;
			var rotRange:Number = maxRot - minRot;
			var aru:Array = [];
			var ara:Array = [];
			for (n=0;n<aryLength;n++){
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
			}
		}
		public function addBoobs():void{
			var minBoob:int = Math.min(player.breastRows.length-1, 3);
			var nipLen:int = born(player.nippleLength*2, 0, 7);
			var boob:MovieClip;
			for (n=minBoob;n>=0;n--){
				trace("Adding boob row",n);
				addInfo.boobNum++;
				u = born(player.breastRows[n].breastRating * heightMod, 0, 80);
				u = born(u, 0, 81)
				if(n==0) dictFindPart("boobs",0,u);
				else	 dictFindPart("boobs",1,u);
				boob = foundPart;
				boob.y = [0, 19.9, 49.45, 85.55][n];
				boob.x = [0, 24.95, 29.7, 16.30][n];
				boob.rotation = [0, 6.5, 7.5, 5.5][n];
				addPartRef("boobs"+n, boob, "fillbg", "shading", "", "", "areola", "areolaShading");
				
				foundPart = getDeepChildByName(boob, "leftNipple");
				addPartRef("leftNipple"+n, foundPart, "", "", "", "", "fillbg", "shading");
				
				foundPart = getDeepChildByName(boob, "rightNipple");
				addPartRef("rightNipple"+n, foundPart, "", "", "", "", "fillbg", "shading");
				
				for (u=1; u<nipLen; u++) cycle("1; 8; leftNipple"+n+",0,1,0; rightNipple"+n+",0,1,0;");
			}
			addInfo.boobSpot -= addInfo.boobNum;
		}
		public function addTail():void{
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
		public function colorPart(target:Object){
			trace("Coloring part "+target.part.name);
			if (skinType == 1){
				shade(target.partBG,"hair");
				shade(target.partS, "hairshade");
			}else{
				shade(target.partBG,"skin");
				shade(target.partS, "skinshade");
			}
			shade(target.hairBG,"hair");
			shade(target.hairS, "hairshade");
			shade(target.bitsBG,"bits");
			shade(target.bitsS, "bitsshade");
			shade(target.pupils,"eyes");
		}
		//Shade subparts as a defined type
		public function shade(item:*, type:String, force:uint = undefined):void{
			if (item == undefined)return;
			ct = new ColorTransform();
			ct.color = 0000000;
			switch (type){
				case "skin"		: ct.color = skinColorAry[skinColor];   break;
				case "skinshade": ct.color = skinShadeAry[skinColor];  break;
				case "bits"		: ct.color = bitsColorAry[skinColor];  break;
				case "bitsshade": ct.color = bitsShadeAry[skinColor]; break;
				case "hair"		: ct.color = hairColorAry[hairColor]; break;
				case "hairshade": ct.color = hairShadeAry[hairColor]; break;
				case "eyes"		: ct.color = eyeColor; break;
				case "forced"	: ct.color = force; break;
			}
			trace("Colored",item.name,"as",type,"with",ct.color)
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
		public function changeEyeClr(btnName:String):void{
			ct = new ColorTransform();
			eyeColor = getRandomColor();
			ct.color = eyeColor;
			partEyes.transform.colorTransform = ct;
		}
		
		////Interactions
		///Initialization
		public function initGUI():void{
			//Innit menu arrays
			initCoCMenu();
			initTiTSMenu();
			initCreatorMenu();
			//Buttons
			addPlayerBtns();
			addBasicBtns();
			//Scrollbar
			scrollBar.scrollTarget = notes;
			scrollBar.height = notes.height+2;
			scrollBar.move(notes.x + notes.width, notes.y-1);
			scrollBar.visible = false;
			//Children
			remove(placeHolder);
			addChild(scrollBar);
			addChild(creatureParent);
			addChild(crewParent);
			addChild(mainParent);
			addChild(texture);
			addChild(menuBtns);
			addChild(basicBtns);
			addChild(playerBtns);
			//Masking
			creatureParent.mask = new MaskSquare();
			mainParent.mask = new MaskSquare();
			crewParent.mask = new MaskSquare();
			addChild(creatureParent.mask);
			addChild(crewParent.mask);
			addChild(mainParent.mask);
			//Properties
			menuBtns.y = 450;
			basicBtns.x = 1424;
			Background.gotoAndStop(1);
			panels.cacheAsBitmap = true;
			mainParent.cacheAsBitmap = true;
			mainParent.mouseChildren = false;
			mouseEnabled = false;
			panels.mouseEnabled = false;
			texture.mouseEnabled = false;
			menuBtns.mouseEnabled = false;
			basicBtns.mouseEnabled = false;
			playerBtns.mouseEnabled = false;
			creatureParent.mouseEnabled = false;
			crewParent.mouseEnabled = false;
			Background.mouseEnabled = false;
			//Events
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			addEventListener(MouseEvent.MOUSE_UP, onDrop);
			creatureParent.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			creatureParent.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			crewParent.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			crewParent.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			mainParent.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			addEventListener(Event.ENTER_FRAME, resoSlide);
			//Event.ADDED
			//Event.Resize //Does not work for some reason//!!!
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
				9:["function", "clearCreatures", "Clear all", function clearN(e){clearMenu(creatureParent);}],
				10:["back", CoCMenu],
				11:["note", "Here you can load creatures you encountered during your adventures. \r\rCreatures are placed at player height. You can drag and drop them, drop them outside to delete them, and clear them all."]});
			setObject(CoCItemMenu, {
				0:["item", "TestDagger", "Dagger", speDagger],
				9:["function", "clearObject", "Clear all", clearEquipment],
				10:["back", CoCMenu],
				11:["note", "Here you can equip some of the equipment you've gathered during your journey. You can add right and left hand weapons, and a few clothes."]});
			setObject(CoCDetailMenu, {
				0:["toggle", "partBalls", "Toggle Balls", true],
				1:["toggle", "partGills", "Toggle Gills", true],
				2:["toggle", "partOvi", "Toggle Ovip", true],
				3:["function", "eye", "Shuffle Eyes", changeEyeClr],
				10:["back", CoCMenu],
				11:["note", "Here you can shuffle your eye color, and save it for this character. You can also toggle various parts."]});
		}
		public function initTiTSMenu():void{
			setObject(TiTSMenu, {
				0:["menu", "bgMenu", "Background", TiTSBackgroundMenu],
				1:["menu", "creatureMenu", "Creatures", TiTSCreatureMenu],
				2:["menu", "crewMenu", "Crew", TiTSCrewMenu],
				3:["menu", "itemMenu", "Items", TiTSItemMenu],
				4:["menu", "detailMenu", "Details", TiTSDetailMenu],
				5:["menu", "sliderMenu", "Sliders", TiTSSliderMenu],
				11:["note", "Save loaded.\rYou can modify various bits of your character, take pictures, add creatures, etc."]});
			setObject(TiTSCreatureMenu, {
				9:["function", "clearCreature", "Clear all", function clearN(e){clearMenu(creatureParent);}],
				10:["back", TiTSMenu],
				11:["note", "Here you can load Creatures you encountered during your adventures. \r\rCreatures are placed at player height. You can drag and drop them, drop them outside to delete them, and clear them all."]});
			setObject(TiTSItemMenu, {
				0:["item", "TestDagger", "Dagger", speDagger],
				9:["function", "clearObject", "Clear all", clearEquipment],
				10:["back", TiTSMenu],
				11:["note", "Here you can equip some of the equipment you've gathered during your journey. You can add right and left hand weapons, and a few clothes."]});
			setObject(TiTSDetailMenu, {
				0:["toggle", "partBalls", "Toggle Balls", true],
				1:["toggle", "partGills", "Toggle Gills", true],
				2:["toggle", "partOvi", "Toggle Ovip", true],
				3:["function", "eye", "Shuffle Eyes", changeEyeClr],
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
				0:["cycle", "9; face,1,1,0",				"9; face,0,0,1",					"Face"],
				1:["cycle", "",								"2; head,1,0,0", 					"Head"],
				2:["cycle", "2; ears,0,1,0", 				"12; ears,1,0,0", 					"Ears"],
				3:["cycle", "4; hair,0,1,0; backHair,0,1,0","100; hair,1,0,0; backHair,1,0,0",	"Hair"],
				4:["cycle", "", 							"10; horns,1,0,0", 					"Horns"],
				10:["back", creatorMenu]});
			setObject(torsoMenu, {
				0:["cycle", "2; body,0,1,0; hips,1,0,0; legs,1,0,0; vag,0,1,0; hand,1,0,0",	"10; body,1,0,1", 	"Body"],
				1:["cycle", "", 															"10; arms,1,0,0",	"Arms"],
				2:["cycle", "", 															"10; wings,1,0,0",	"Wings"],
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
				0:["cycle", "", "10; legs,0,1,0", "Legs"],
				1:["cycle", "", "23; hips,0,1,0", "Hips"],
				2:["cycle", "", "10; butt,1,0,0", "Butt"],
				3:["cycle", "", "10; tail,1,0,0", "Tail"],
				10:["back", creatorMenu],
				11:["note", ""]});
			setObject(otherMenu, {
				0:["toggle", "partGills", "Toggle Gills", true],
				1:["toggle", "partOvi", "Toggle Ovip", true],
				2:["toggle", "partBalls", "Toggle Balls", true],
				3:["function", "eye", "Shuffle Eyes", changeEyeClr],
				4:["dropdown", "skinChanger", "Skin Type", skinTypesNames, changeSkinType],
				5:["dropdown", "skinChanger", "Skin Color", skinColorNames, changeSkinClr],
				6:["dropdown", "hairChanger", "Hair Color", hairColorNames, changeHairClr],
				10:["back", creatorMenu],
				11:["note", "Here you can change skin type and color, hair color, eye color, and toggle various parts."]});
		}
		public function updateCoCMenu():void{
			//Load explored locations
			setObject(CoCBackgroundMenu, {
			0:["background", "Normal", 1],
			1:["background", "Mountain", Boolean(player.exploredMountain)],
			2:["background", "Lake", Boolean(player.exploredLake)],
			3:["background", "Forest", Boolean(player.exploredForest)],
			4:["background", "Desert", Boolean(player.exploredDesert)],
			10:["back", CoCMenu],
			11:["note", "Here you can load various places you've explored through your adventures!"]});			
			
			setObject(CoCSliderMenu,{
			0:["slider", 96, player.tallness-24, tallSlide, true],
			1:["slider", player.ballSize * heightMod - 7, 0, ballSlide, hasBalls && (player.ballSize * heightMod > 7)],
			2:["slider", player.clitLength * heightMod - 8, 0, clitSlide, (getPartInd("clit")[1] == 8)],
			3:["dropdown", "cockChanger", "Choose cock", bigCockList, cockSlideChange],
			4:["special", addCockSlider],
			5:["dropdown", "boobChanger", "Choose row", bigBoobList, boobSlideChange],
			6:["special", addBoobSlider],
			10:["back", CoCMenu],
			11:["note", "To be sure everything looks fine, the viewer prevents extreme sizes, but here you can scale them up to your real size. If you have multiple breasts and dicks above the maximum size, you just have to select which one you desire to change."]});
		}
		public function updateTiTSMenu():void{
			//Load explored locations
			setObject(TiTSBackgroundMenu, {
			10:["back", TiTSMenu],
			11:["note", "Here you can load various places you've explored through your adventures!"]});	
			
			setObject(TiTSSliderMenu,{
			0:["slider", 96, player.tallness-24, tallSlide, true],
			1:["slider", player.ballSize * heightMod - 7, 0, ballSlide, hasBalls && (player.ballSize * heightMod > 7)],
			2:["slider", player.clitLength * heightMod - 8, 0, clitSlide, (getPartInd("clit")[1] == 8)],
			3:["dropdown", "cockChanger", "Choose cock", bigCockList, cockSlideChange],
			4:["special", addCockSlider],
			5:["dropdown", "boobChanger", "Choose row", bigBoobList, boobSlideChange],
			6:["special", addBoobSlider],
			10:["back", TiTSMenu],
			11:["note", "To be sure everything looks fine, the viewer prevents extreme sizes, but here you can scale them up to your real size. If you have multiple breasts and dicks above the maximum size, you just have to select which one you desire to change."]});
			
			setObject(TiTSCrewMenu, {
			10:["back", TiTSMenu],
			11:["note", "Here you can add your loyal crew members. To remove them, double click, or simply press their button again."]});
			for (i=0; i<10; i++){
				if (crewData[i+1]){
					TiTSCrewMenu[i] = ["crew", crewData[i+1], i+1];
				}
			}
		}
		///Modes
		public function switchMode(btnName:String):void{
			var form:TextFormat;
			var font:Font;
			var tempFram:int;
			isTiTS = (btnName == "TiTS");
			var mod:int = int(isTiTS);
			
			reset();
			clearMenu(playerBtns);
			clearMenu(basicBtns);
			addPlayerBtns();
			addBasicBtns();
			panels.gotoAndStop(mod+1);
			texture.visible = !Boolean(mod);
			scrollBar.switchMode(isTiTS);
			
			font = new [CoC_Font, TiTS_Font][mod];
			form = new TextFormat();
			form.font = font.fontName;
			form.color = [0x000000, 0xFFFFFF][mod];
			notes.defaultTextFormat = form;
			form.size = 15;
			StyleManager.setStyle('embedFonts',true);
			StyleManager.setStyle('textFormat',form);	
			
			buttons.switchM.name = ["TiTS", "CoC"][mod];
			buttons.switchM.text.text = ["TiTS", "CoC"][mod];
			buttons.switchM.MC.gotoAndStop(1);
		}
		
		///Menu
		//Populate static menus
		public function addBasicBtns():void{
			buttons.restart = new DIC_Button("reset", 125, 380, "Reset", reset, isTiTS);
			buttons.creates = new DIC_Button("createChar", 125, 420, "Create", loadFromDefault, isTiTS);
			buttons.loadLoc = new DIC_Button("loadLocal", 125, 460, "Load", loadFromFile, isTiTS);
			buttons.scrshot = new DIC_Button("screenShot", 125, 540, "Render:", charCap, isTiTS, false);
			buttons.backCap = new DIC_Button("backCap", 125, 580, "Composition", backCap, isTiTS, false);
			buttons.charCap = new DIC_Button("charCap", 125, 620, "Character", charCap, isTiTS, false);
			buttons.charRes = new DIC_Slider(660-12, 15, 1, resoSlide, isTiTS, "", 125, 140, false);
			buttons.fullScr = new DIC_Button("fullScreen", 125, 720, "Full Screen", toggleFullScreen, isTiTS);
			buttons.switchM = new DIC_Button("TiTS", 125, 800, "TiTS", switchMode, isTiTS);
			for each(var btn in buttons) basicBtns.addChild(btn);
			basicBtns.addChild(buttons.charRes);
		}
		public function addPlayerBtns(btnName:String = ""):void{
			var nam:String;
			var btn:MovieClip;
			var test:SharedObject;
			var saveFound:Boolean = false;
			var mod = int(isTiTS);
			clearMenu(playerBtns);
			for (i = 1; i < 10; i++){
				nam = ["CoC_", "TiTS_"][mod] + i;
				test = SharedObject.getLocal(nam,"/");
				if (test.data.exists){
					btn = new DIC_Button(nam, 100, (45* i)-10, i + ": " + test.data.short, loadFromSave, isTiTS);
					playerBtns.addChild(btn);
					saveFound = true;
				}
			}
			if (!saveFound) toNote("No save found, sorry. Please open this locally, or from the website you usually play the game on. You can still use the create function, or load a file from the parent folder.");
		}
		//Load btns from the menu array
		public function loadMenu(btnName:String, ary:Object):void{
			toNote();
			clearMenu();
			for (var key:String in ary){
				var val:Array = ary[key];
				i = int(key);
				j = 45*i + 35;
				switch (val[0]){
					//Will load another menu
					case "menu":
						menuBtns.addChild(new DIC_Button(val[1], 100, j, val[2], loadMenu, isTiTS, true, val[3]));
					break;
					//Will toggle a part from it's name
					case "toggle":
						menuBtns.addChild(new DIC_Button(val[1], 100, j, val[2], toggleItem, isTiTS, val[3]));
					break;
					//Will run a function on click
					case "function":
						menuBtns.addChild(new DIC_Button(val[1], 100, j, val[2], val[3], isTiTS));
					break;
					//Will add an item, then run its specialization function
					case "item":
						menuBtns.addChild(new DIC_Button(val[1], 100, j, val[2], addObject, isTiTS, true, val[3]));
					break;
					//Will switch to a background, if it is unlocked
					case "background":
					menuBtns.addChild(new DIC_Button(val[1], 100, j, val[1], changeBackground, isTiTS, val[2], i+1));
					break;
					//Will change something's color
					case "dropdown":
						menuBtns.addChild(new DIC_Dropdown(val[1], val[2], 30, j-10, val[3], val[4], isTiTS));
					break;
					//Will create a slider
					case "slider":
						if(val[4]) menuBtns.addChild(new DIC_Slider(j, val[1], val[2], val[3], isTiTS, val[5]));
					break;
					//Will cycle a part, by adding given ints to its key
					case "cycle":
						menuBtns.addChild(new DIC_Button("1; " +val[1], 100, j, val[3], cycle, isTiTS, val[1] != "", undefined, undefined, 120));
						menuBtns.addChild(new DIC_Arrow("-1; " +val[2], 100-80, j, 0, cycle, isTiTS));
						menuBtns.addChild(new DIC_Arrow("+1; " +val[2], 100+80, j, 2, cycle, isTiTS));
					break;
					case "list":
						var num:int = addInfo[val[1]+"Num"];
						var b:String = val[1]+"Btn";
						for (k=0; k<num; k++){
							addInfo[b][k] = [];
							addInfo[b][k][0] = new DIC_Button("1; "+val[3].replace(/X/g, k), 100, j+k*45, val[2]+(k+1), cycle, isTiTS, val[3] != "", undefined, undefined, 120);
							addInfo[b][k][1] = new DIC_Arrow("-1; "+val[4].replace(/X/g, k), 100-80, j+k*45, 0, cycle, isTiTS);
							addInfo[b][k][2] = new DIC_Arrow("+1; "+val[4].replace(/X/g, k), 100+80, j+k*45, 2, cycle, isTiTS);
						}
						addInfo[b][k] = [];
						addInfo[b][k][1] = new DIC_Arrow("tak", 100-80, j+k*45, 1, val[5], isTiTS);
						addInfo[b][k][2] = new DIC_Arrow("add", 100+80, j+k*45, 3, val[6], isTiTS);
						for each(var bar:Array in addInfo[b])
						for each(var btn in bar)
						menuBtns.addChild(btn);
					break;
					//Will load a wre member on click
					case "crew":
						menuBtns.addChild(new DIC_Button("crew"+i, 100, j, val[1].short, addCrewChar, isTiTS, true, val[1], val[2]));
					break;
					//Will run a function on load
					case "special":
						val[1](j);
					break;
					//Will load menu on click, but with fixed height and width
					case "back":
						menuBtns.addChild(new DIC_Button("back", 100, 10*45+35, "Back", loadMenu, isTiTS, true, val[1], undefined, 120));
					break;
					case "note":
						toNote(val[1]);
					break;
				}
			}
		}
		//Clear all children from a given parent
		public function clearMenu(clearParent:MovieClip = null):void{
			if (!clearParent) clearParent = menuBtns;
			while(clearParent.numChildren > 0){
				clearParent.removeChildAt(0);
			}
		}
		
		///Mouse
		public function onDrag(event:MouseEvent):void{
			dragTarget = event.target as MovieClip;
			dragTarget.startDrag();
		}
		public function onDrop(event:MouseEvent):void{
			if (dragTarget){
				dragTarget.stopDrag();
				var _x = dragTarget.x;
				var _y = dragTarget.y;
				if(_x<200 || _x>1424 || _y<0 || _y>980){
					if (dragTarget != mainParent && dragTarget.parent != crewParent){
						remove(dragTarget);
					}
				}
			}
		}
		public function onDoubleClick(event:MouseEvent):void{
			remove(event.target as MovieClip);
		}
		public function onClick(event:MouseEvent):void{
			var tar = event.target;
			if (!stageLock){
				if (tar is DIC_Button){
					if (tar.enabled){
						tar.MC.gotoAndStop(2);
						if (tar.addit1 && tar.addit2){
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
		}
		public function onOver(event:MouseEvent):void{
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
		
		///General
		//Change the background.
		public function changeBackground(btnName:String, frame:int):void{
			Background.gotoAndStop(frame);
		}
		//Toggle fullscreen mode
		public function toggleFullScreen(btnName:String):void{
			if (stage.displayState == StageDisplayState.FULL_SCREEN){
				stage.displayState = StageDisplayState.NORMAL;
			}else{
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
		}
		
		///Screenshot
		//Will take a high-res screenCap of mainParent
        public function charCap(btnName:String):void{
			buttons.charCap.lock();
			buttons.backCap.lock();
			buttons.charRes.lock();
			stageLock = true;
			var charMask = mainParent.mask;
			mainParent.mask = null;
			remove(charMask);
			var rect:Rectangle = mainParent.getBounds(mainParent);
			var matrix:Matrix = new Matrix(capScale,0,0,capScale,-rect.x*capScale,-rect.y*capScale);
			b = new BitmapData(rect.width*capScale, rect.height*capScale, true, 0x0);
			b.draw(mainParent, matrix);
			mainParent.mask = new MaskSquare();
			addChild(mainParent.mask);
			PNGencoder = PNGEncoder2.encodeAsync(b);
			PNGencoder.addEventListener(Event.COMPLETE, saveCap);
        }
		//Will take a normal-res screenCap of this (with btn bars cropped)
		public function backCap(btnName:String):void{
			buttons.charCap.lock();
			buttons.backCap.lock();
			buttons.charRes.lock();
			stageLock = true;
			var matrix = new Matrix(1,0,0,1,-200,0);
			b = new BitmapData(1224, 980);
			b.draw(this,matrix);
			PNGencoder = PNGEncoder2.encodeAsync(b);
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
			b.dispose();
			buttons.charCap.unLock();
			buttons.backCap.unLock();
			buttons.charRes.unLock();
			stageLock = false;;
		}
		
		///Character modifications
		//Cycles parts
		public function cycle(btnName:String):void{
			var cycles:Array = btnName.split('; ');					//indents(-1 or +1); max(2 to 100); indent of the first part; second part; etc...
			var ind = int(cycles[0]);								//Determine if cycling down or up
			var max = int(cycles[1])-1;								//Maximum amount of cycling before return to 0, can be a lot bigger than actual number.
			var classType:Class;									//The new class
			var partReplace:MovieClip;								//The replacement part
			var cycled:Boolean;										//Wether or not a character was cycled completely
			var nam:Array;											//The ref of the part to cycle, and the keys to add
			var part:MovieClip;										//The part to cycle
			var className:String;									//The class name of the previous part
			var key:Array;											//the key of the previous part
			
			for (j=2; j<cycles.length; j++){
				nam = cycles[j].split(',');							//The ref of the part to cycle, and the keys to add
				part = getPart(nam[0]);								//The part to cycle
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
				partReplace.x = part.x;
				partReplace.y = part.y;
				partReplace.scaleX = part.scaleX;
				partReplace.scaleY = part.scaleY;
				if (nam[4]) partReplace.MC.rotation = part.MC.rotation;
				else partReplace.rotation = part.rotation;
				//Give it the color transform of the previous
				var ref:Object = partRefs[nam[0]];
				if(ref.partBG)	ref.partBG= getDeepChildByName(partReplace, ref.partBG.name);
				if(ref.partS)	ref.partS = getDeepChildByName(partReplace, ref.partS.name);
				if(ref.hairBG)	ref.hairBG= getDeepChildByName(partReplace, ref.hairBG.name);
				if(ref.hairS)	ref.hairS = getDeepChildByName(partReplace, ref.hairS.name);
				if(ref.bitsBG)	ref.bitsBG= getDeepChildByName(partReplace, ref.bitsBG.name);
				if(ref.bitsS)	ref.bitsS = getDeepChildByName(partReplace, ref.bitsS.name);
				if(ref.pupils)	ref.pupils= getDeepChildByName(partReplace, ref.pupils.name);
				ref.part = partReplace;
				colorPart(ref);
				//Specific Nipple stuff
				if (nam[0].slice(0,-1) == "boobs"){
					var rNip:MovieClip = getDeepChildByName(partReplace, "rightNipple");
					var lNip:MovieClip = getDeepChildByName(partReplace, "leftNipple");
					k = nam[0].slice(-1);
					partRefs["rightNipple"+k] = {part:rNip, bitsBG:rNip.fillbg, bitsS:rNip.shading}
					partRefs["leftNipple"+k]  = {part:lNip, bitsBG:lNip.fillbg, bitsS:lNip.shading}
					colorPart(partRefs["rightNipple"+k]);
					colorPart(partRefs["leftNipple"+k]);
				}
				//Finish stuff
				part.parent.addChild(partReplace);
				part.parent.swapChildren(part,partReplace);
				remove(part);
			}
		}
		//Get an item from a ref name, and set it to either visible or invisible
		public function toggleItem(btnName:String):void{
			var tar = this[btnName];
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
			
		}//!!!
		public function speCreature(target:MovieClip):void{
			var comp:MovieClip;
			var sca = 0.5+Math.random()/2;
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
		//Clear all equipment
		public function clearEquipment(btnName:String):void{
			for each(var obj in equipment) remove(obj);
		}
		//Add another cock
		public function moreCocks(btnName:String):void{
			var baseIndex:int = mainParent.numChildren;
			j = addInfo.cockNum;
			addInfo.cockNum++;
			addInfo.cockSpot--;
			
			baseIndex = getIn(getPart("balls"))+addInfo.cockNum;
			
			/*if (getPart("boobs2"))
			if (getIndexes(getQualifiedClassName(getPart("boobs2")))[0] >= 27)
			baseIndex = getIn(getPart("boobs2"));
			
			if (getPart("boobs3"))
			if (getIndexes(getQualifiedClassName(getPart("boobs3")))[0] >=9)
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
			var pos = addInfo[b][j][1].y;
			addInfo[b][j][1].y += 45;
			addInfo[b][j][2].y += 45;
			addInfo[b][j][1].lock();
			addInfo[b][j][2].lock(addInfo.cockSpot);
			addInfo[b].push(addInfo[b][j]);
			addInfo[b][j] = [];
			addInfo[b][j][0] = new DIC_Button("1; 10; cock"+j+",1,0,0,1", 100, pos, "Cock "+(j+1), cycle, isTiTS, true, undefined, undefined, 120);
			addInfo[b][j][1] = new DIC_Arrow("-1; 200; cock"+j+",0,1,0,1", 100-80, pos, 0, cycle, isTiTS);
			addInfo[b][j][2] = new DIC_Arrow("+1; 200; cock"+j+",0,1,0,1", 100+80, pos, 2, cycle, isTiTS);
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
			var pos = addInfo[b][j][1].y;
			addInfo[b][j][1].y += 45;
			addInfo[b][j][2].y += 45;
			addInfo[b][j][1].lock();
			addInfo[b][j][2].lock(addInfo.boobSpot);
			addInfo[b].push(addInfo[b][j]);
			addInfo[b][j] = [];
			addInfo[b][j][0] = new DIC_Button("1; 8; leftNipple"+j+",0,1,0; rightNipple"+j+",0,1,0;", 100, pos, "Row "+(j+1), cycle, isTiTS, true, undefined, undefined, 120);
			addInfo[b][j][1] = new DIC_Arrow("-1; 200; boobs"+j+",0,1,0", 100-80, pos, 0, cycle, isTiTS);
			addInfo[b][j][2] = new DIC_Arrow("+1; 200; boobs"+j+",0,1,0", 100+80, pos, 2, cycle, isTiTS);
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
				cockSlider = new DIC_Slider(j, 0, 0, cockSlide, isTiTS, "Select Row");
				menuBtns.addChild(cockSlider);
				if (i == 2){
					cockSlideChange(bigCockList[1].data);
				}
			}
		}
		public function addBoobSlider(j:int):void{
			i = 0;
			for (var key in bigBoobList)i++;
			if (i > 1){
				boobSlider = new DIC_Slider(j, 0, 0, boobSlide, isTiTS, "Select Row");
				menuBtns.addChild(boobSlider);
				if (i == 2){
					boobSlideChange(bigBoobList[1].data);
				}
			}
		}
		//Used to change the target of cockSlider and boobSlider, called by the DIC_Dropdown class
		public function cockSlideChange(ary:Array):void{
			if (cockSlideTarget[0]){
				cockSlideTarget[0].transform.colorTransform = new ColorTransform;
			}
			if (ary[0]){
				cockSlideTarget = [ary[0], ary[3]];
				ct = new ColorTransform();
				ct.redOffset = 255;
				cockSlideTarget[0].transform.colorTransform = ct;
				cockSlider.sliderText.text = ary[1];
				cockSlider.sliderBar.maximum = ary[2]-27;
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
		public function boobSlideChange(ary:Array):void{
			if (boobSlideTarget[0]){
				boobSlideTarget[0].transform.colorTransform = new ColorTransform;
			}
			if (ary[0]){
				boobSlideTarget = [ary[0], ary[3]];
				ct = new ColorTransform();
				ct.redOffset = 255;
				boobSlideTarget[0].transform.colorTransform = ct;
				boobSlider.sliderText.text = ary[1];
				boobSlider.sliderBar.maximum = ary[2]-80;
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
		public function tallSlide(event:Event):void{
			var par = event.currentTarget;
			var sizeDif = mainParent.height;
			var widthDif = mainParent.width;
			var newScale = (par.value+24);
			var feets = Math.floor(newScale/12);
			var inchees = newScale%12;
			par.parent.sliderText.text = "Height: "+feets+"ft."+inchees+"in.";
			scale(mainParent, newScale/82) ;
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
					par.parent.sliderText.text = "Row "+boobSlideTarget[1]+" rating: "+(par.value+80)+".";
					scale(boobSlideTarget[0].MC, (par.value +40) /40);
					if (isTiTS) par.parent.MC.progressBar.scaleX = par.parent.sliderBar.value/par.parent.sliderBar.maximum;
				}
			}
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
