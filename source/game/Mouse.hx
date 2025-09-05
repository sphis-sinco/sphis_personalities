package game;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;

class Mouse
{
	public static var state(default, set):String = MouseStates.IDLE;

	static function set_state(value:String):String
	{
		return value;

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

		FlxG.mouse.load(graphic, 1);
	}
}
