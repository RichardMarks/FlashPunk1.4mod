package net.flashpunk.ext 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	/**
	 * ...
	 * @author Richard Marks
	 */
	public class RenderText 
	{
		/**
		 * streamlined method to render text to a BitmapData surface without going through dealing with the Flash components directly.
		 * text uses the Text.font, Text.color and Text.size information for creation
		 * @param	text - string of text to render
		 * @param	target - BitmapData to render the text on
		 * @param	point - coordinate at which to render the text
		 * @param	camera - offset of the camera - if null FP.camera is used
		 */
		static public function toBitmap(text:String, target:BitmapData, point:Point, camera:Point = null):void
		{
			if (camera == null) { camera = FP.camera; }
			
			try
			{
				new Text(text).renderToBitmap(target, point, camera);
			}
			catch (err:Error)
			{
				
			}
		}
	}

}