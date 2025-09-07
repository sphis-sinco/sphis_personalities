package game;

import crowplexus.iris.Iris;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import game.Controls.ControlsSave;
import game.desktop.DesktopMain;
import game.scripts.ScriptManager;
import haxe.macro.Compiler;

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
		#if !html5
		haxe.Log.trace = Iris.print;
		#end
		#end

		#if generateWebScript
		ScriptManager.generateWebScript();
		#if sys
		Sys.exit(0);
		#end
		#else
		FlxSprite.defaultAntialiasing = true;

		Controls.save = new ControlsSave(Paths.getGamePath('preferences/controls.json'));
		Controls.save.load(Controls.save.publicPath);

		Mouse.setMouseState(MouseStates.IDLE);

		ScriptManager.checkForUpdatedScripts();

		var startingState = Compiler.getDefine('StartingState');
		if (startingState != null)
			startingState.split('=')[0];
		trace(Std.string(startingState).toLowerCase());

		if (startingState != null)
		{
			if (startingState.length >= 1)
			{
				switch (Std.string(startingState).toLowerCase())
				{
					case 'blankstate':
						var blankStateID = Compiler.getDefine('BlankStateID');
						if (blankStateID != null)
						{
							blankStateID = blankStateID.split('=')[0];
							if (blankStateID == '1')
								blankStateID = null;
						}

						FlxG.switchState(() -> new BlankState(blankStateID));
					default:
						FlxG.switchState(() -> new DesktopMain());
				}
			}
		}
		else
			FlxG.switchState(() -> new game.desktop.DesktopMain());
		#end
	}
}
