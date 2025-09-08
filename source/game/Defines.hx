package game;

import haxe.macro.Compiler;
import haxe.macro.Expr;

class Defines
{
	public static var map:Map<String, Dynamic> = [];

	public static function get(key:String)
	{
		if (map.exists(key))
			return map.get(key);
		else
			return null;
	}

	public static function set(key:String, value:Dynamic)
	{
		return map.set(key, value);
	}

	public static function getDefines()
	{
		var define:Dynamic = null;
		try
		{
			define = Compiler.getDefine('StartingState');
			if (define != null)
				define = define.split('=')[0];
			set('StartingState', define);

			define = Compiler.getDefine('BlankStateID');
			if (define != null)
				define = define.split('=')[0];
			set('BlankStateID', define);

			set('scripts_ignoreMissingMethods', Compiler.getDefine('scripts_ignoreMissingMethods') == '1');
			set('scripts_ignoreMethodErrors', Compiler.getDefine('scripts_ignoreMethodsErrors') == '1');
			set('scripts_disableScripts', Compiler.getDefine('scripts_disableScripts') == '1');
			set('scripts_loadedScriptMSG', Compiler.getDefine('scripts_loadedScriptMSG') == '1');

			set('controls_loadExtraTraces', Compiler.getDefine('controls_loadExtraTraces') == '1');

			set('typeArray_foundfilesfunc_traces', Compiler.getDefine('typeArray_foundfilesfunc_traces') == '1');

			set('experiment_polymodSupport', Compiler.getDefine('experiment_polymodSupport') == '1');
			set('polymodSupport', Compiler.getDefine('polymodSupport') == '1');
		}
		catch (_) {}

		for (key => value in map)
		{
			trace('Define(' + Ansi.fg('', WHITE) + key + Ansi.reset('') + '): ' + value);
		}
	}
}
