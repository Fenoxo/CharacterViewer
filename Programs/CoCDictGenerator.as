package  {
	
	import flash.utils.Dictionary;
	import flash.display.MovieClip;
	
	
	public class CoCDictGenerator extends MovieClip {
		
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
		public var shadTypeAry:Array=[
			new Array(100),
			["Over"],
			["F"]];
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
			["Human",
			"Horse",
			"Dog",
			"Cow",
			"Elf",
			"Cat",
			"Snake",
			"Bunny",
			"Kangaroo",
			"Fox",
			"Dragon",
			"No"],
			["Ears"],
			["", "Hair"]];
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
		
		public var classDict:Dictionary = new Dictionary();
		
		public function CoCDictGenerator() {
			createHipsAry();
			createHairAry();
			createAssAry();
			createCockAry();
			createBreastAry();
			createShadAry();
			
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
			var i:int, j:int, k:int, l:int;
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
							}else{
								classDict[key.toString()] = className;
							}
							trace('this["' + key + '"] = "' + classDict[key.toString()] + '";');
							if (className == "skip3") className = "";
						}
						if (className == "skip2") className = "";
					}
					if (className == "skip1") className = "";
				}
			}
		}
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
		
	}
	
}
