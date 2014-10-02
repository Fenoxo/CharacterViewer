package classes.events 
{
	import flash.events.Event;
	/**
	 * Dispatched by Characters to order the addition of a note.
	 * @author Sbaf
	 */
	public final class NoteEvent extends Event
	{
		public static const NEW_NOTE:String = "newNote";
		
		private var note:String;
		private var toAdd:Boolean;
		
		/**
		 * Create a new NoteEvent.
		 * @param	The text of the note.
		 * @param	Wether the note should be added to (true), or replace the previous text (false).
		 * @param	If the event should bubble (true), or not (false).
		 * @param	If the event should be cancellable (true), or not (false).
		 */
		public function NoteEvent(noteText:String = "", isToAdd:Boolean = false, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super("newNote", bubbles, cancelable);
			note = noteText;
			toAdd = isToAdd;
		}
		
		/**
		 * Returns a clone of the NoteEvent.
		 * @return New NoteEvent.
		 */
		public override function clone():Event
		{
			return new NoteEvent(note, toAdd, bubbles, cancelable);
		}
		
		/**
		 * Returns the text of the note.
		 */
		public function get noteText():String
		{
			return (note);
		}
		
		/**
		 * Returns if the note is to be added or set.
		 */
		public function get isToAdd():Boolean
		{
			return (toAdd);
		}
	}
}