package game;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;

class Mouse
{
	public static var state:String = MouseStates.IDLE;

	public static function setMouseState(value:String)
	{
		state = value;
		updateMouseGraphic();
	}

	public static function updateMouseGraphic()
	{
		var graphic = FlxGraphic.fromAssetKey(Paths.getImagePath('mouse/' + state));

		if (graphic == null)
		{
			FlxG.mouse.load(null);
			return;
		}

		FlxG.mouse.load(graphic.key);
	}

	public static var pressed(get, default):Bool;
	public static var justPressed(get, default):Bool;

	public static var released(get, default):Bool;
	public static var justReleased(get, default):Bool;

	static function get_pressed():Bool
		return FlxG.mouse.pressed;

	static function get_justPressed():Bool
		return FlxG.mouse.justPressed;

	static function get_released():Bool
		return FlxG.mouse.released;

	static function get_justReleased():Bool
		return FlxG.mouse.justReleased;

	public static function overlaps(obj:FlxBasic):Bool
		return FlxG.mouse.overlaps(obj);
}
