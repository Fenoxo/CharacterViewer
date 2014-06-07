package classes{
	public final class DIC_Data extends Object{
		public static var isTiTS:Boolean = false;
		//The singleton instance
		private static var _instance:DIC_Data;
		//Global variables
		public var GUIMode:Boolean = false;
    	//The constructor function
		public function DIC_Data(){
			if(_instance){
				throw new Error("Singleton... use getInstance()");
			} 
			_instance = this;
		}
		//The get mode function
		//public static function isTiTS:Boolean{
		//	return _instance.GUIMode;
		//}
	}
}
