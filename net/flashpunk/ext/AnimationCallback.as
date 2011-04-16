package net.flashpunk.ext 
{
	/**
	 * ...
	 * @author Thomas King
	 */
	public class AnimationCallback 
	{
		public function AnimationCallback(callback:Function, frame:int, save:Boolean) 
		{
			_callback = callback;
			_frame = frame;
			_save = save;
		}
		
		public function get callback():Function { return _callback; }
		
		public function get frame():int { return _frame; }
		
		public function get save():Boolean { return _save; }
		
		/** private*/ private var _callback:Function;
		/** private*/ private var _frame:int;
		/** private*/ private var _save:Boolean;
	}

}