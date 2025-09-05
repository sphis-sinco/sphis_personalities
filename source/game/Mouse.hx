package game;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;

class Mouse
{
	public static var state:String = MouseStates.IDLE;

	public static function set_state(value:String)
	{
		state = value;
		updateMouseGraphic();
	}

	public static function updateMouseGraphic()
	{
		trace('Updating Mouse Graphic to: ' + Paths.getImagePath('mouse/' + state));
		var graphic = FlxGraphic.fromAssetKey(Paths.getImagePath('mouse/' + state));

		if (graphic == null)
		{
			FlxG.mouse.load(null);
			return;
		}

		FlxG.mouse.load(graphic.key);
	}
}
