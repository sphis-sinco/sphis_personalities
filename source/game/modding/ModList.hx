package game.modding;

import flixel.FlxG;
#if polymod
import polymod.Polymod.ModMetadata;
#end

class ModList
{
	public static var modList:Map<String, Bool> = [];

	#if polymod
	public static var modMetadatas:Map<String, ModMetadata> = [];
	#else
	public static var modMetadatas:Map<String, Dynamic> = [];
	#end

	public static function setModEnabled(mod:String, enabled:Bool):Void
	{
		modList.set(mod, enabled);
		if (FlxG.save != null)
			FlxG.save.data.modList = modList;
	}

	public static function getModEnabled(mod:String):Bool
	{
		if (modList == null)
			return false;

		if (!modList.exists(mod))
			setModEnabled(mod, true);

		return modList.get(mod);
	}

	public static function getActiveMods(modsToCheck:Array<String>):Array<String>
	{
		var activeMods:Array<String> = [];

		for (modName in modsToCheck)
		{
			if (getModEnabled(modName))
				activeMods.push(modName);
		}

		return activeMods;
	}

	public static function load():Void
	{
		try
		{
			if (FlxG.save != null)
			{
				modList = FlxG.save.data.modList;

				if (modList == null)
					modList = [];

				if (modList != null)
					for (key => value in modList)
					{
						trace('Mod(' + Ansi.fg('', WHITE) + key + Ansi.reset('') + ') enabled: ' + value);
					}
			}
			else
			{
				modList = [];
			}
		}
		catch (e)
		{
			modList = [];
		}
	}
}
