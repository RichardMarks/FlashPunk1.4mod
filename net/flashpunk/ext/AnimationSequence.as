package net.flashpunk.ext
{
	/**
	 * ...
	 * @author Thomas King
	 */
	public class AnimationSequence
	{
		/**
		 * Constructor.
		 * @param	name		Animation name.
		 * @param	frames		Array of frame indices to animate.
		 * @param	frameRate	Animation speed.
		 * @param	loop		If the animation should loop.
		 */
		public function AnimationSequence(name:String, animations:Array, loop:Boolean = true) 
		{
			_name = name;
			_animations = animations;
			_loop = loop;
			_animCount = animations.length;
			_callbacks = new Array();
		}
		
		/**
		 * Plays the sequence.
		 * @param	reset		If the sequence should force-restart if it is already playing.
		 */
		public function play(reset:Boolean = false):void
		{
			_parent.playSeq(_name, reset);
		}
		
		public function addCallback(callback:Function, frame:int, save:Boolean = true):void
		{
			_callbacks.push(new AnimationCallback(callback, frame, save));
		}
		
		/**
		 * Name of the sequence.
		 */
		public function get name():String { return _name; }
		
		/**
		 * Array of animations in the sequence.
		 */
		public function get animations():Array { return _animations; }
		
		/**
		 * Amount of frames in the sequence.
		 */
		public function get animCount():uint { return _animCount; }
		
		/**
		 * If the sequence loops.
		 */
		public function get loop():Boolean { return _loop; }
		
		/**
		 * Function called when sequence is complete
		 */
		public function get callbacks():Array { return _callbacks; }
		
		/** @private */ internal var _parent:AdvancedAnimation;
		/** @private */ internal var _name:String;
		/** @private */ internal var _animations:Array;
		/** @private */ internal var _animCount:uint;
		/** @private */ internal var _loop:Boolean;
		/** @private */ internal var _callbacks:Array;
	}
}