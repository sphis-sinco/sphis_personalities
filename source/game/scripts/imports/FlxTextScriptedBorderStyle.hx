package game.scripts.imports;

import flixel.text.FlxText.FlxTextBorderStyle;

class FlxTextScriptedBorderStyle
{
	public static var NONE = FlxTextBorderStyle.NONE;

	/**
	 * A simple shadow to the lower-right
	 */
	public static var SHADOW = FlxTextBorderStyle.SHADOW;

	/**
	 * A shadow that allows custom placement
	 * **Note:** Ignores borderSize
	 */
	public static function SHADOW_XY(offsetX:Float, offsetY:Float)
	{
		return FlxTextBorderStyle.SHADOW_XY(offsetX, offsetY);
	}

	/**
	 * Outline on all 8 sides
	 */
	public static var OUTLINE = FlxTextBorderStyle.OUTLINE;

	/**
	 * Outline, optimized using only 4 draw calls
	 * **Note:** Might not work for narrow and/or 1-pixel fonts
	 */
	public static var OUTLINE_FAST = FlxTextBorderStyle.OUTLINE_FAST;
}
