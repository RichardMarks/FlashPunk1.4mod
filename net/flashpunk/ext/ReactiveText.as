package net.flashpunk.ext
{
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	
	/**
	 * ...
	 * @author Richard Marks
	 */
	public class ReactiveText extends Entity 
	{
		private var onClick:Function;
		private var myText:Text;
		private var myGfx:Graphiclist;
		
		public function ReactiveText(caption:String, clickHandler:Function = null, xPos:Number = 0, yPos:Number = 0, width:int = 0, height:int = 0, fgColor:uint = 0xFFFFFFFF) 
		{
			type = "ReactiveText";
			x = xPos;
			y = yPos;
			
			myText = new Text(caption);
			myText.color = fgColor;
			
			if (!width) { width = myText.width + 8; }
			if (!height) { height = myText.height + 8; }
			
			width = Math.max(width, myText.width);
			height = Math.max(height, myText.height);
			
			myText.x = int((width - myText.width) * 0.5);
			myText.y = int((height - myText.height) * 0.5);
			
			myGfx = new Graphiclist(myText);
			
			//myGfx = new Graphiclist(Image.createRect(width, height, bgColor), myText);
			myGfx.x -= width * 0.5;
			myGfx.y -= height * 0.5;
			
			graphic = myGfx;
			setHitbox(width, height);
			centerOrigin();
			
			onClick = clickHandler;
		}
		
		public function addGlow(color:uint):void
		{
			myText.field.filters = [new GlowFilter(color, 0.7, 4, 4, 8, BitmapFilterQuality.MEDIUM, false, false)];
			myText.clear();
			myText.updateBuffer();
		}
		
		public function disable():void 
		{
			if (!active) { return; }
			active = false;
			var darken:Image = Image.createRect(width, height, 0xFF797979);
			darken.alpha = 0.8;
			myGfx.add(darken);
		}
		
		public function enable():void 
		{
			if (active) { return; }
			active = true;
			myGfx.removeAt(1);
		}
		
		override public function update():void 
		{
			if (onClick == null)
			{
				return;
			}
			
			if (!Input.mousePressed)
			{
				return;
			}
			
			if (!collidePoint(x, y, FP.screen.mouseX, FP.screen.mouseY))
			{
				return;
			}
			
			onClick();
			
			super.update();
		}
		
	}

}