package classes 
{
	/**
	 * ...
	 * @author 
	 */
	public class SaveTranslator 
	{
		
		public function SaveTranslator() 
		{
			
		}
		
		/**
		 * Get a boob row size index from the savefile boob size.
		 * @param	The boob size according to the savefile.
		 * @return	The index used in the viewer for that size.
		 */
		public function getRealBoobIndex(size:int):int
		{
			if (size < 1) return (1);
			if (size < 3) return (2);
			if (size < 5) return (3);
			if (size < 7) return (4);
			if (size < 9) return (5);
			if (size < 15) return (6);
			if (size < 27) return (7);
			if (size < 48) return (8);
			if (size < 80) return (9);
			return (10);
		}

		/**
		 * Get a cock size index from the savefile cock size.
		 * @param	The cock size according to the savefile.
		 * @return	The index used in the viewer for that size.
		 */
		public function getRealCockIndex(size:int):int
		{
			if (size < 1) return (0);
			if (size < 4) return (1);
			if (size < 7) return (2);
			if (size < 10) return (3);
			if (size < 14) return (4);
			if (size < 18) return (5);
			if (size < 21) return (6);
			if (size < 24) return (7);
			if (size < 27) return (8);
			return (9);
		}

		/**
		 * Get an ass size index from the savefile ass size.
		 * @param	The ass size according to the savefile.
		 * @return	The index used in the viewer for that size.
		 */
		public function getRealAssIndex(size:int):int
		{
			if (size < 4) return (0);
			if (size < 6) return (1);
			if (size < 8) return (2);
			if (size < 10) return (3);
			if (size < 13) return (4);
			if (size < 16) return (5);
			return (6);
		}

		/**
		 * Get a hair length index from the savefile hair length.
		 * @param	The hair length according to the savefile.
		 * @return	The index used in the viewer for that length.
		 */
		public function getRealHairIndex(size:int):int
		{
			if (size < 1) return (0);
			if (size < 6) return (1);
			if (size < 11) return (2);
			if (size < 16) return (3);
			return (4);
		}

		/**
		 * Get a hips size index from the savefile hips rating.
		 * @param	The hips rating according to the savefile.
		 * @return	The index used in the viewer for that rating.
		 */
		public function getRealHipsIndex(size:int):int
		{
			if (size < 6) return (0);
			if (size < 8) return (1);
			if (size < 10) return (2);
			if (size < 13) return (3);
			if (size < 16) return (4);
			if (size < 20) return (5);
			return (6);
		}
		
	}

}