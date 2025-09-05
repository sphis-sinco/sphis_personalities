package game.scripts;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;
import game.desktop.DesktopMain;
import game.scripts.events.AddedEvent;
import game.scripts.events.BaseEvent;
import game.scripts.events.BaseStateEvent;
import game.scripts.events.CreateEvent;
import game.scripts.events.UpdateEvent;
import lime.app.Application;
#if sys
import sys.FileSystem;
import sys.io.File;
#else
import lime.utils.Assets;
#end

class ScriptManager
{
	public static var SCRIPT_FOLDER:String = 'scripts';

	public static var SCRIPT_EXTS:Array<String> = ['hxc', 'hx', 'haxe', 'hscript'];

	public static var SCRIPTS:Array<Iris> = [];
	public static var SCRIPTS_ERRS:Map<String, Dynamic> = [];

	public static function call(method:String, ?args:Array<Dynamic>)
	{
		if (SCRIPTS.length < 1)
			return;

		for (script in SCRIPTS)
		{
			callSingular(script, method, args);
		}
	}

	public static function callSingular(script:Iris, method:String, ?args:Array<Dynamic>)
	{
		@:privateAccess {
			if (!script.interp.variables.exists(method))
			{
				final errMsg = 'missing method(' + method + ') for script(' + script.config.name + ')';

				if (!SCRIPTS_ERRS.exists('missing_method(' + method + ')_' + script.config.name))
				{
					SCRIPTS_ERRS.set('missing_method(' + method + ')_' + script.config.name, errMsg);
					trace(errMsg);
				}

				return;
			}

			var ny:Dynamic = script.interp.variables.get(method);
			try
			{
				if (ny != null && Reflect.isFunction(ny))
				{
					script.call(method, args);
				}
			}
			catch (e)
			{
				final errMsg = 'error calling method(' + method + ') for script(' + script.config.name + '): ' + e.message;

				if (!SCRIPTS_ERRS.exists('method(' + method + ')_error_' + script.config.name))
				{
					SCRIPTS_ERRS.set('method(' + method + ')_error_' + script.config.name, errMsg);
					trace(errMsg);
				}
			}
		}
	}

	public static function loadAllScripts()
	{
		for (script in SCRIPTS)
		{
			script.destroy();
			SCRIPTS.remove(script);
		}
		SCRIPTS = [];

		loadScriptsByPaths(getAllScriptPaths(SCRIPT_FOLDER));
	}

	public static function loadScriptByPath(path:String)
	{
		var newScript:Iris;

		var noExt:Int = 0;
		for (ext in SCRIPT_EXTS)
		{
			if (!StringTools.endsWith(path, '.' + ext))
				noExt++;
		}
		if (noExt >= SCRIPT_EXTS.length)
			return;

		try
		{
			newScript = new Iris(#if sys File.getContent(path) #else Assets.getText(path) #end, new IrisConfig(path, true, true, []));
		}
		catch (e)
		{
			newScript = null;
			trace('Error loading script(' + path + '): ' + e.message);
			Application.current.window.alert('Error loading script(' + path + '): ' + e.message + '\n\n' + e.details, 'Error loading script');
		}

		if (newScript != null)
		{
			initalizeScriptVariables(newScript);

			trace('Loaded script(' + path + ')');

			SCRIPTS.push(newScript);
			callSingular(newScript, 'onAdded', [new AddedEvent(newScript.name)]);
		}
	}

	public static function initalizeScriptVariables(script:Iris)
	{
		script.set('ScriptManager', ScriptManager, false);

		script.set('DesktopMain', DesktopMain, false);
		script.set('InitState', InitState, false);

		script.set('Paths', Paths, false);

		script.set('BaseEvent', BaseEvent, false);
		script.set('BaseStateEvent', BaseStateEvent, false);

		script.set('AddedEvent', AddedEvent, false);
		script.set('CreateEvent', CreateEvent, false);
		script.set('UpdateEvent', UpdateEvent, false);

		scriptImports(script);
	}

	static function scriptImports(script:Iris) {}

	public static function loadScriptsByPaths(paths:Array<String>)
	{
		for (path in paths)
			loadScriptByPath(path);
	}

	public static function getAllScriptPaths(script_folder:String):Array<String>
	{
		#if sys
		var typePaths:Array<String> = [
			Paths.getGamePath(SCRIPT_FOLDER + '/'),
			'game/' + SCRIPT_FOLDER + '/',
			Paths.getGamePath(''),
			'game/'
		];

		return Paths.getTypeArray('script', SCRIPT_FOLDER, SCRIPT_EXTS, typePaths);
		#else
		return [];
		#end
	}
}
