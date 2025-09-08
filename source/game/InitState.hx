package game;

import crowplexus.iris.Iris;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import game.Controls.ControlsSave;
import game.desktop.DesktopMain;
import game.desktop.DesktopPlay;
import game.desktop.play.LevelModule;
import game.desktop.play.LevelSpriteGroup;
import game.scripts.ScriptManager;
import game.scripts.WebScripts;
import game.scripts.events.AddedEvent;
import game.scripts.events.BaseEvent;
import game.scripts.events.BaseStateEvent;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;
import game.scripts.imports.FlxScriptedAxes;
import game.scripts.imports.FlxScriptedColor;
import haxe.macro.Compiler;
#if hscript
import flixel.system.debug.console.ConsoleUtil;
#end

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

		#if hscript
		ConsoleUtil.registerObject('InitState', InitState);
		ConsoleUtil.registerObject('Controls', Controls);
		ConsoleUtil.registerObject('Mouse', Mouse);
		ConsoleUtil.registerObject('MouseStates', MouseStates);
		ConsoleUtil.registerObject('Paths', Paths);
		ConsoleUtil.registerObject('State', State);
		ConsoleUtil.registerObject('Ansi', Ansi);
		ConsoleUtil.registerObject('BlankState', BlankState);

		ConsoleUtil.registerObject('DesktopMain', DesktopMain);
		ConsoleUtil.registerObject('DesktopPlay', DesktopPlay);

		// ConsoleUtil.registerObject('LevelData', LevelData);
		ConsoleUtil.registerObject('LevelModule', LevelModule);
		ConsoleUtil.registerObject('LevelSpriteGroup', LevelSpriteGroup);

		ConsoleUtil.registerObject('ScriptManager', ScriptManager);
		ConsoleUtil.registerObject('WebScripts', WebScripts);

		ConsoleUtil.registerObject('AddedEvent', AddedEvent);
		ConsoleUtil.registerObject('BaseEvent', BaseEvent);
		ConsoleUtil.registerObject('BaseStateEvent', BaseStateEvent);
		ConsoleUtil.registerObject('CreateEvent', CreateEvent);
		ConsoleUtil.registerObject('UpdateEvent', UpdateEvent);

		ConsoleUtil.registerObject('FlxScriptedAxes', FlxScriptedAxes);
		ConsoleUtil.registerObject('FlxScriptedColor', FlxScriptedColor);
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
			startingState = startingState.split('=')[0];
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
