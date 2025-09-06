package game;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import game.Controls.ControlsSave;
import game.scripts.ScriptManager;

class InitState extends FlxState
{
	public static var initalized:Bool = false;

	override function create()
	{
		super.create();

		FlxSprite.defaultAntialiasing = true;

		Controls.save = new ControlsSave(Paths.getGamePath('preferences/controls.json'));
		Controls.save.load(Controls.save.publicPath);

		Mouse.setMouseState(MouseStates.IDLE);

		ScriptManager.loadAllScripts();

		if (!initalized)
		{
			initalized = true;
			FlxG.switchState(() -> new game.desktop.DesktopMain());
		}
		else
		{
			FlxG.resetState();
		}
	}
}
