package net.flashpunk.ext
{
	import net.flashpunk.graphics.Anim;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class AdvancedAnimation extends Spritemap
	{
		/**
		 * Constructor.
		 * @param	source			Source image.
		 * @param	frameWidth		Frame width.
		 * @param	frameHeight		Frame height.
		 * @param	callback		Optional callback function for animation end.
		 */
		public function AdvancedAnimation(source:*, frameWidth:uint = 0, frameHeight:uint = 0, callback:Function = null) 
		{
			super(source, frameWidth, frameHeight, callback);
		}
		
		/** @private Updates the animation. */
		override public function update():void 
		{
			if (!_seq) {
				super.update();
				return;
			}
			if (complete) {
				_seqIndex++;
				if (_seqIndex == _seq.animations.length) {
					if (_seq.loop) {
						_seqIndex = 0;
					}
					else _seqIndex--;
					// fixed bug where the sequence callback is ignored -Richard Marks
					if (_seq.callback != null)
					{
						_seq.callback();
					}
				}
			}
			playAnim(_seq.animations[_seqIndex]);
			super.update();
		}
		
		private function playAnim(name:String):Anim
		{
			return super.play(name);
		}
		
		override public function play(name:String = "", reset:Boolean = false):Anim 
		{
			_seq = null;
			return super.play(name, reset);
		}
		
		/**
		 * Add a Sequence.
		 * @param	name		Name of the sequence.
		 * @param	frames		Array of animation names to play through.
		 * @param	loop		If the sequence should loop.
		 * @return	A new Sequence object for the sequence.
		 */
		public function addSeq(name:String, animations:Array, loop:Boolean = true, callback:Function = null):AnimationSequence
		{
			if (_seqs[name]) throw new Error("Cannot have multiple animations with the same name");
			// changed to use hasAnim function from my branch - Richard Marks
			for each (var anims:String in animations)
			{
				//if (!_anims[anims]) throw new Error("Undefined animations in sequence.");
				if (!hasAnim(anims)) 
				{ 
					throw new Error("Undefined animations in sequence.");
				}
			}
			(_seqs[name] = new AnimationSequence(name, animations, loop, (callback != null? callback : this.callback)))._parent = this;
			return _seqs[name];
		}
		
		/**
		 * Plays an Sequence.
		 * @param	name		Name of the sequence to play.
		 * @param	reset		If the sequence should force-restart if it is already playing.
		 * @return	Sequence object representing the played sequence.
		 */
		public function playSeq(name:String = "", reset:Boolean = false):AnimationSequence
		{
			if (!reset && _seq && _seq._name == name) return _seq;
			_seq = _seqs[name];
			if (!_seq)
			{
				return null;
			}
			// bugfix - reset sequence index
			_seqIndex = 0;
			playAnim(_seq.animations[0]);
			return _seq;
		}
		
		// added by Richard Marks
		/**
		 * The currently playing sequence.
		 */
		public function get currentSequence():String { return _seq ? _seq._name : ""; }
		
		// made protected just in case we want to extend this -Richard Marks
		/** @private */ protected var _seqs:Object = { };
		/** @private */ protected var _seq:AnimationSequence;
		/** @private */ protected var _seqIndex:uint;
	}

}