package game;

import crowplexus.iris.Iris;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import game.Controls.ControlsSave;
import game.scripts.ScriptManager;

class InitState extends FlxState
{
	public static var oldTrace:Dynamic;

	override function create()
	{
		super.create();

		oldTrace = haxe.Log.trace;
		#if trimmedTrace
		haxe.Log.trace = function(v, ?infos)
		{
			#if sys
			final fileName = infos.fileName;
			final methodName = (infos.methodName == null) ? null : infos.methodName;

			var ln = '[' + fileName.split('/')[fileName.split('/')
				.length - 1] + ((methodName != null) ? ':' + methodName : '') + ':' + infos.lineNumber + '] ';

			ln += v;
			Sys.println(ln);
			#else
			oldTrace(v, infos);
			#end
		};
		#else
		haxe.Log.trace = Iris.print;
		#end

		#if generateWebScript
		ScriptManager.generateWebScript();
		throw 'Done';
		#else
		FlxSprite.defaultAntialiasing = true;

		Controls.save = new ControlsSave(Paths.getGamePath('preferences/controls.json'));
		Controls.save.load(Controls.save.publicPath);

		Mouse.setMouseState(MouseStates.IDLE);

		ScriptManager.checkForUpdatedScripts();

		FlxG.switchState(() -> new game.desktop.DesktopMain());
		#end
	}
}
