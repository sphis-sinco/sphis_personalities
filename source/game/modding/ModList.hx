package game.modding;

import flixel.FlxG;
import game.modding.ModMetaData.ModMetadata;
import game.utils.MapUtil;
import haxe.Json;
import sys.FileSystem;

class ModList
{
	public static var MAXIMUM_MOD_VERSION:String = '1.0.0';
	public static var MINIMUM_MOD_VERSION:String = '0.0.0';

	public static var outdatedMods:Array<String> = [];

	public static var modList:Map<String, Bool> = [];

	public static var modMetadatas:Map<String, ModMetadata> = [];

	public static function setModEnabled(mod:String, enabled:Bool):Void
	{
		modList.set(mod, enabled);
		if (FlxG.save != null && FlxG.save.data.modList != null)
			FlxG.save.data.modList = modList;
	}

	public static function getModEnabled(mod:String):Bool
	{
		if (modList == null)
			return false;

		if (!modList.exists(mod))
			setModEnabled(mod, false);

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

		trace('activeMods: ' + activeMods);

		return activeMods;
	}

	public static function loadMods():Void
	{
		#if sys
		modList.clear();
		modMetadatas.clear();

		for (mod in FileSystem.readDirectory('mods/'))
		{
			if (FileSystem.exists('mods/' + mod + '/' + ModMetadata.modMetadataFile))
			{
				var nullError = false;
				var modMeta:ModMetadata;
				try
				{
					modMeta = ModMetadata.fromJsonStr(Json.parse('mods/' + mod + '/' + ModMetadata.modMetadataFile));
				}
				catch (e)
				{
					nullError = true;
					modMeta = null;
				}
				if (!nullError)
				{
					trace('Valid mod(' + Ansi.fg('', ORANGE) + mod + Ansi.reset('') + ')');
					modList.set(mod, false);
					modMetadatas.set(mod, modMeta);
				}
			}
		}
		#end

		loadModList();
	}

	public static function loadModList():Void
	{
		if (modList == null)
			modList = [];

		try
		{
			if (FlxG.save != null && FlxG.save.data.modList != null)
			{
				modList = FlxG.save.data.modList;

				if (modList == null)
					modList = [];

				if (modList != null)
					for (key => value in modList)
						trace('Mod(' + Ansi.fg('', ORANGE) + key + Ansi.reset('') + ') enabled: ' + value);
			}
			else
				modList.clear();
		}
		catch (e)
		{
			modList.clear();
		}

		for (mod in MapUtil.keysArray(modMetadatas))
			if (!modList.exists(mod))
			{
				trace('Re-added mod(' + Ansi.fg('', ORANGE) + mod + Ansi.reset('') + ')');
				modList.set(mod, false);
			}
	}
}
