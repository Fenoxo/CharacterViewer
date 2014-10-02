package classes.character
{
	/**
	 * Used to store a part's children names.
	 * @author Sbaf
	 */
	public class PartNames 
	{
		public var SF:String;//Skin fill
		public var SS:String;//Skin shad
		public var HF:String;//Hair fill
		public var HS:String;//Hair shad
		public var BF:String;//Bits fill
		public var BS:String;//Bits shad
		public var EF:String;//Eyes fill
		
		public function PartNames(names:Object) 
		{
			this.SF = names.SF;
			this.SS = names.SS;
			this.HF = names.HF;
			this.HS = names.HS;
			this.BF = names.BF;
			this.BS = names.BS;
			this.EF = names.EF;
		}
	}
}