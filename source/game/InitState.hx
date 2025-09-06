package game;

import flixel.FlxG;
import flixel.FlxState;
import game.Controls.ControlsSave;
import game.scripts.ScriptManager;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

		Controls.save = new ControlsSave(Paths.getGamePath('preferences/controls.json'));
		Controls.save.load(Controls.save.publicPath);

		Mouse.setMouseState(MouseStates.IDLE);

		ScriptManager.loadAllScripts();

		FlxG.switchState(() -> new game.desktop.DesktopMain());
	}
}
