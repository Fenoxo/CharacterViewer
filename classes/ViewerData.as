package classes 
{
	/**
	 * Passed as an argument to characters and layers to give them access
	 * to the dictionnaries, the pool, and the translator.
	 * @author Sbaf
	 */
	public class ViewerData 
	{
		[Embed(source = "./../data/CoC_Dictionary.json", mimeType='application/octet-stream')]
		private static var CoC_Class_JSON:Class;
		[Embed(source = "./../data/CoC_Defaulter.json", mimeType='application/octet-stream')]
		private static var CoC_Default_JSON:Class;
		[Embed(source = "./../data/TiTS_Dictionary.json", mimeType='application/octet-stream')]
		private static var TiTS_Class_JSON:Class;
		[Embed(source = "./../data/TiTS_Defaulter.json", mimeType='application/octet-stream')]
		private static var TiTS_Default_JSON:Class;
		[Embed(source = "./../data/DIC_Cycler.json", mimeType='application/octet-stream')]
		private static var DIC_Cycler_JSON:Class;
		
		private static var initialized:Boolean = false;
		
		private var CoCDict:ClassDictionary;
		private var TiTSDict:ClassDictionary;
		public var classDict:ClassDictionary;
		public var colorDict:ColorDictionary;
		public var translator:SaveTranslator;
		public var partPool:PartPool;
		
		public var isTiTS:Boolean = false;
		
		/**
		 * Initialize a new ViewerData instance. Since the JSON classes are set to null,
		 * it should not and cannot not be initialized twice.
		 */
		public function ViewerData()
		{
			if (initialized)
				throw new Error("Viewer Data cannot be instanciated twice.");
			initialized = true;
		}
		
		/**
		 * Will create, initialize and store every global elements,
		 * like the pool, the dictionaries and the translator.
		 * Will set the JSON classes to null for garbadge collecting.
		 */
		public function init()
		{
			partPool = new PartPool();
			colorDict = new ColorDictionary();
			colorDict.init();
			translator = new SaveTranslator();
			
			CoCDict = new ClassDictionary(CoC_Class_JSON, CoC_Default_JSON, DIC_Cycler_JSON, partPool);
			TiTSDict = new ClassDictionary(TiTS_Class_JSON, TiTS_Default_JSON, DIC_Cycler_JSON, partPool);
			
			setMode(false);
			
			CoC_Class_JSON = null;
			CoC_Default_JSON = null;
			TiTS_Class_JSON = null;
			TiTS_Default_JSON = null;
			DIC_Cycler_JSON = null;
		}
		
		/**
		 * Changes the active dictionary.
		 * @param	isTiTS
		 */
		public function setMode(isTiTS):void
		{
			if (isTiTS)
			{
				classDict = TiTSDict;
			}
			else
			{
				classDict = CoCDict;
			}
			this.isTiTS = isTiTS;
		}
	}
}