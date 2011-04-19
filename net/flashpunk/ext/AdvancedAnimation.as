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
			_updater = simpleUpdate;
		}
		
		private var frameChanged:Boolean;
		/** @private Updates the animation. */
		override public function update():void 
		{
			if (!_sequence) {
				super.update();
				return;
			}
			
			_updater();
		}
		
		private function simpleUpdate():void
		{
			updateSequence();
			playAnim(_sequence.animations[_sequenceIndex]);
			super.update();
		}
		
		private function advancedUpdate():void
		{
			if (complete || frameChanged) {
				checkCallbacks();
				_sequenceFrame++;
			}
			updateSequence();
			
			playAnim(_sequence.animations[_sequenceIndex]);
			
			var frameBefore:int = frame;
			super.update();
			frameChanged = frameBefore != frame;
		}
		
		private function updateSequence():void
		{
			// refactoring -Richard Marks
			
			// if the current animation has not finished
			if (!complete) { return; }
			
			_sequenceIndex++;
			if (_sequenceIndex == _sequence.animations.length) {
				if (_sequence.loop) {
					_sequenceIndex = _sequenceFrame = 0;
				}
				else {
					_sequenceIndex--;
				}
			}
		}
		
		private function checkCallbacks():void
		{
			var next:AnimationCallback = _sequence._callbacks[0];
			if (next && next.frame == _sequenceFrame) {
				_sequence.callbacks.shift();
				next.callback();
				if (next.save) {
					_sequence.callbacks.push(next);
				}
			}
		}
		
		private function playAnim(name:String):Anim
		{
			return super.play(name, false);
		}
		
		override public function play(name:String = "", reset:Boolean = false):Anim 
		{
			_sequence = null;
			return super.play(name, reset);
		}
		
		/**
		 * Add a Sequence.
		 * @param	name		Name of the sequence.
		 * @param	frames		Array of animation names to play through.
		 * @param	loop		If the sequence should loop.
		 * @return	A new Sequence object for the sequence.
		 */
		public function addSeq(name:String, animations:Array, loop:Boolean = true):AnimationSequence
		{
			if (_sequences[name]) throw new Error("Cannot have multiple animations with the same name");
			
			// changed to use hasAnim function from my branch - Richard Marks
			for each (var anims:String in animations)
			{
				//if (!_anims[anims]) throw new Error("Undefined animations in sequence.");
				if (!hasAnim(anims)) 
				{ 
					throw new Error("Undefined animations in sequence.");
				}
			}
			
			animations = addSequenceHACK(name, animations);
			
			(_sequences[name] = new AnimationSequence(name, animations, loop))._parent = this;
			return _sequences[name];
		}
		
		// for the love of god, we've got to find a better solution
		private function addSequenceHACK(name:String, animations:Array):Array
		{
			// this hack adds a second animation to the sequence if only one anim is given
			// the added animation is the last frame of the given animation
			// the added animation name is name_DIRTY_HACK_
			
			if (animations.length > 1) { return animations; }
			
			var anim:Anim = Anim(_anims[animations[0]]);
			add(name + "_DIRTY_HACK_", [anim.frames[anim.frames.length - 1]], anim.frameRate, false);
			animations.push(name + "_DIRTY_HACK_");
			return animations;
		}
		 
		public function addCallback(name:String, callback:Function, frame:int, save:Boolean = true):void
		{
			_sequences[name].addCallback(callback, frame, save);
			_updater = advancedUpdate;
		}
		
		/**
		 * Plays an Sequence.
		 * @param	name		Name of the sequence to play.
		 * @param	reset		If the sequence should force-restart if it is already playing.
		 * @return	Sequence object representing the played sequence.
		 */
		public function playSeq(name:String = "", reset:Boolean = false):AnimationSequence
		{
			if (!reset && _sequence && _sequence._name == name) return _sequence;
			_sequence = _sequences[name];
			if (!_sequence)
			{
				return null;
			}
			_sequenceIndex = _sequenceFrame = 0;
			playAnim(_sequence.animations[0]);
			return _sequence;
		}
		
		// added by Richard Marks
		/**
		 * The currently playing sequence.
		 */
		public function get currentSequence():String { return _sequence ? _sequence._name : ""; }
		
		// made protected just in case we want to extend this -Richard Marks
		/** @private */ protected var _sequences:Object = { };
		/** @private */ protected var _sequence:AnimationSequence;
		/** @private */ protected var _sequenceIndex:uint;
		/** @private */ protected var _sequenceFrame:uint;
		/** @private */ protected var _updater:Function;
	}

}