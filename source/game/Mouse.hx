package game;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import openfl.display.Bitmap;

class Mouse
{
	public static var previous_state:String = '';
	public static var state:String = MouseStates.IDLE;

	public static function setMouseState(value:String)
	{
		previous_state = '' + state;
		state = value;
		updateMouseGraphic();
	}

	public static function updateMouseGraphic()
	{
		if (previous_state == state)
			return;

		var graphic = FlxGraphic.fromAssetKey(Paths.getImagePath('mouse/' + state));
		trace('Updating Mouse Graphic to: ' + graphic.key);

		if (graphic == null)
		{
			FlxG.mouse.load(null);
			return;
		}

		FlxG.mouse.load(graphic.key);
	}
}
