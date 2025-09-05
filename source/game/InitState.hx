package game;

import flixel.FlxG;
import flixel.FlxState;
import game.scripts.ScriptManager;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

		Mouse.setMouseState(MouseStates.IDLE);

		ScriptManager.loadAllScripts();

		FlxG.switchState(() -> new game.desktop.DesktopMain());
	}
}
